use std::sync::Arc;

use axum::{
    Json, Router,
    extract::Request,
    middleware::{Next, from_fn},
    response::{IntoResponse, Response},
    routing::{get, post},
};
use serde::Serialize;

use crate::AppState;

pub mod auth;
mod game;

#[derive(Serialize)]
struct Message {
    message: String,
}

async fn jsonize(request: Request, next: Next) -> Response {
    let response = next.run(request).await;
    if let Some(err) = response.extensions().get::<Arc<crate::Error>>() {
        (
            err.status_code(),
            Json(Message {
                message: err.to_string(),
            }),
        )
            .into_response()
    } else {
        response
    }
}

pub fn build_router() -> Router<Arc<AppState>> {
    Router::new()
        .route("/matches", get(game::matches))
        .route("/register", post(auth::register))
        .route("/login", post(auth::login))
        .route("/logout", post(auth::logout))
        .route("/me", get(auth::me))
        .layer(from_fn(jsonize))
}
