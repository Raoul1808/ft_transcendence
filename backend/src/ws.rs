use std::sync::Arc;

use axum::{
    extract::{
        State, WebSocketUpgrade,
        ws::{Message, WebSocket},
    },
    response::IntoResponse,
};
use futures_util::{SinkExt, StreamExt};
use serde::Deserialize;
use tokio::sync::broadcast;
//use bytes::Bytes;

use crate::{AppState, RoomState, db};

pub async fn websocket_handler(
    ws: WebSocketUpgrade,
    State(state): State<Arc<AppState>>,
) -> impl IntoResponse {
    tracing::info!("websocket connection");
    ws.on_upgrade(|socket| handle_socket(socket, state))
}

#[derive(Deserialize)]
#[serde(tag = "type")]
enum ClientText {
    #[serde(rename = "result")]
    GameResult { score: [i32; 2] },
}

async fn handle_socket(socket: WebSocket, state: Arc<AppState>) {
    let (mut sender, mut receiver) = socket.split();
    let mut username = String::new();
    let mut channel = String::new();
    let mut tx = None;
	let mut slot: usize = 0;
	
    while let Some(Ok(msg)) = receiver.next().await {
        if let Message::Text(name) = msg {
            #[derive(Deserialize)]
            struct Connect {
                username: String,
                channel: String,
            }

            let connect: Connect = match serde_json::from_str(&name) {
                Ok(connect) => connect,
                Err(err) => {
                    tracing::error!("websocket identification failed: {name} {err}");
                    let _ = sender.send(Message::from("connection failed")).await;
                    break;
                }
            };
			let mut is_full = false;
            {
                let mut rooms = state.rooms.lock().unwrap();
                channel = connect.channel.clone();

                let room = rooms.entry(connect.channel).or_insert_with(RoomState::new);
                tx = Some(room.tx.clone());

				let mut users = room.users.lock().unwrap();
				if users.len() >= 2{
					is_full = true;
				}
				else if !users.contains(&connect.username) {
					users.insert(connect.username.to_owned());
					username = connect.username.clone();
					slot = users.len() - 1;
				}

                /*if !room.users.lock().unwrap().contains(&connect.username) {
                    room.users
                        .lock()
                        .unwrap()
                        .insert(connect.username.to_owned());
                    username = connect.username.clone();
                }*/
            }

			if is_full {
				let _ = sender.send(Message::from(r#"{"type":"error","reason":"lobby_full"}"#)).await;
				return ;
			}
            if tx.is_some() && !username.is_empty() {
                break;
            } else {
                let _ = sender
					.send(Message::from(r#"{"type":"error","reason":"username_taken"}"#,))
					.await;
                return;
            }
        }
    }

    let Some(tx) = tx else{
		return;
	};
    let mut rx = tx.subscribe();

	if let Err(e) = db::register_player(&state.db, &username).await {
		tracing::error!("cannot register player {username}: {e}");
	}

	let _ = sender
			.send(Message::from(format!(r#"{{"type" : "joined","slot":{slot}}}"#)))
			.await;
	if slot == 1 {
		let _ = tx.send(Message::from(r#"{{"type" : "ready"}"#));
	}

    tracing::info!("user {username} has arrived (slot {slot})");

    let mut recv_messages = {
        let username = username.clone();
        tokio::spawn(async move {
            tracing::info!("trying message recv");
            while let Ok(msg) = rx.recv().await {
                tracing::info!("user {username} received a message");
                if let Err(e) = sender.send(msg).await {
                    tracing::error!("error sending message: {e}");
                    break;
                }
            }
            tracing::info!("out of recv");
        })
    };

    let mut send_messages = {
        let tx = tx.clone();
        let state = state.clone();
        let channel = channel.clone();
        let username = username.clone();
        tokio::spawn(async move {
            tracing::info!("trying message send");
            while let Some(Ok(msg)) = receiver.next().await {
				match msg {
					Message::Binary(bytes) => {
						tracing::debug!("user {username} sent {} bytes", bytes.len());
						let _ = tx.send(Message::Binary(bytes));
					}
					Message::Text(text) => {
						handle_text(&state, &channel, &username, slot, &tx, text.as_str())
							.await;
					}
					Message::Close(_) => break,
					_ => {}
                //tracing::info!("user {username} sent {} bytes", bytes.len());
                //let _ = tx.send(bytes);
            }
		}
            tracing::info!("out of message send");
        })
	};

    tokio::select! {
        _ = (&mut send_messages) => recv_messages.abort(),
        _ = (&mut recv_messages) => send_messages.abort(),
    };

    let mut rooms = state.rooms.lock().unwrap();
    rooms
        .get_mut(&channel)
        .unwrap()
        .users
        .lock()
        .unwrap()
        .remove(&username);

    if rooms
        .get_mut(&channel)
        .unwrap()
        .users
        .lock()
        .unwrap()
        .is_empty()
    {
        rooms.remove(&channel);
    }

    tracing::info!("user {username} left");
}


async fn handle_text(
    state: &Arc<AppState>,
    channel: &str,
    username: &str,
    slot: usize,
    tx: &broadcast::Sender<Message>,
    raw: &str,
) {
    let Ok(ClientText::GameResult { score }) = serde_json::from_str(raw) else {
        return;
    };
    if score.iter().any(|s| *s < 0) {
        return;
    }

    enum Outcome {
        Wait,
        Mismatch,
        Save(String, String),
    }

    let outcome = {
        let mut rooms = state.rooms.lock().unwrap();
        let Some(room) = rooms.get_mut(channel) else {
            return;
        };
        if room.saved {
            return;
        }
        room.results.insert(slot, (username.to_owned(), score));
        if room.results.len() < 2 {
            Outcome::Wait
        } else if room.results.values().all(|(_, s)| *s == score) {
            room.saved = true;
            Outcome::Save(room.results[&0].0.clone(), room.results[&1].0.clone())
        } else {
            room.results.clear();
            Outcome::Mismatch
        }
    };

    match outcome {
        Outcome::Wait => {}
        Outcome::Mismatch => {
            let _ = tx.send(Message::from(
                r#"{"type":"error","reason":"result_mismatch"}"#,
            ));
        }
        Outcome::Save(p1, p2) => {
            match db::save_match(&state.db, &p1, &p2, score[0], score[1]).await {
                Ok(id) => {
                    tracing::info!("match {id} saved: {p1} {} - {} {p2}", score[0], score[1]);
                    let _ = tx.send(Message::from(format!(
                        r#"{{"type":"saved","match_id":{id}}}"#
                    )));
                }
                Err(e) => {
                    tracing::error!("save_match failed: {e}");
                    // allow another try
                    if let Some(room) = state.rooms.lock().unwrap().get_mut(channel) {
                        room.saved = false;
                        room.results.clear();
                    }
                    let _ = tx.send(Message::from(r#"{"type":"error","reason":"db_error"}"#));
                }
            }
        }
    }
}
