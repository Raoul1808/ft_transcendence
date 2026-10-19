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

use crate::{AppState, RoomState};

pub async fn websocket_handler(
    ws: WebSocketUpgrade,
    State(state): State<Arc<AppState>>,
) -> impl IntoResponse {
    tracing::info!("websocket connection");
    ws.on_upgrade(|socket| handle_socket(socket, state))
}

async fn handle_socket(socket: WebSocket, state: Arc<AppState>) {
    let (mut sender, mut receiver) = socket.split();
    let mut username = String::new();
    let mut channel = String::new();
    let mut tx = None;

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

            {
                let mut rooms = state.rooms.lock().unwrap();
                channel = connect.channel.clone();

                    let room = rooms.entry(connect.channel).or_insert_with(|| RoomState::new());
                tx = Some(room.tx.clone());

                if !room.users.lock().unwrap().contains(&connect.username) {
                    room.users
                        .lock()
                        .unwrap()
                        .insert(connect.username.to_owned());
                    username = connect.username.clone();
                }
            }

            if tx.is_some() && !username.is_empty() {
                break;
            } else {
                let _ = sender.send(Message::from("username already taken")).await;
                return;
            }
        }
    }

    let tx = tx.unwrap();
    let mut rx = tx.subscribe();

    tracing::info!("user {username} has arrived");

    let mut recv_messages = {
        let username = username.clone();
        tokio::spawn(async move {
            tracing::info!("trying message recv");
            while let Ok(bytes) = rx.recv().await {
                tracing::info!("user {username} received {} bytes", bytes.len());
                if let Err(e) = sender.send(Message::Binary(bytes)).await {
                    tracing::error!("error sending message: {e}");
                    break;
                }
            }
            tracing::info!("out of recv");
        })
    };

    let mut send_messages = {
        let tx = tx.clone();
        let username = username.clone();
        tokio::spawn(async move {
            tracing::info!("trying message send");
            while let Some(Ok(Message::Binary(bytes))) = receiver.next().await {
                tracing::info!("user {username} sent {} bytes", bytes.len());
                let _ = tx.send(bytes);
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
