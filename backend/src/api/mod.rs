use std::sync::Arc;

use axum::{
    Router,
    routing::{get, post},
};

use crate::AppState;

pub mod auth;
mod game;

pub fn build_router() -> Router<Arc<AppState>> {
    Router::new()
        .route("/matches", get(game::matches))
        .route("/register", post(auth::register))
        .route("/login", post(auth::login))
        .route("/logout", post(auth::logout))
        .route("/me", get(auth::me))
}
