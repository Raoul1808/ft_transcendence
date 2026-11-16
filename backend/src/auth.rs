use std::sync::Arc;

use argon2::{
    Argon2, PasswordHash, PasswordHasher, PasswordVerifier,
    password_hash::{SaltString, rand_core::OsRng},
};
use axum::{
    Json,
    extract::State,
    http::StatusCode,
    response::{IntoResponse, Response},
};
use serde::{Deserialize, Serialize};
use tower_sessions::Session;

use crate::{AppState, db};

const SESSION_USER_KEY: &str = "user";

#[derive(Serialize, Deserialize, Clone)]
pub struct SessionUser {
    pub id: i64,
    pub username: String,
}

#[derive(Deserialize)]
pub struct Credentials {
    username: String,
    password: String,
}

fn hash_password(password: &str) -> Result<String, argon2::password_hash::Error> {
    let salt = SaltString::generate(&mut OsRng);
    Ok(Argon2::default()
        .hash_password(password.as_bytes(), &salt)?
        .to_string())
}

fn verify_password(password: &str, stored_hash: &str) -> bool {
    match PasswordHash::new(stored_hash) {
        Ok(parsed) => Argon2::default()
            .verify_password(password.as_bytes(), &parsed)
            .is_ok(),
        Err(_) => false,
    }
}

pub async fn current_user(session: &Session) -> Option<SessionUser> {
    session.get(SESSION_USER_KEY).await.ok().flatten()
}

pub async fn register(
    State(state): State<Arc<AppState>>,
    Json(creds): Json<Credentials>,
) -> Response {
    let username = creds.username.trim().to_string();
    if username.is_empty() || username.chars().count() > 32 {
        return (
            StatusCode::BAD_REQUEST,
            "username must be 1 to 32 characters",
        )
            .into_response();
    }
    let len = creds.password.chars().count();
    if !(8..=128).contains(&len) {
        return (
            StatusCode::BAD_REQUEST,
            "password must be 8 to 128 characters",
        )
            .into_response();
    }

    let password = creds.password;
    let hash = match tokio::task::spawn_blocking(move || hash_password(&password)).await {
        Ok(Ok(h)) => h,
        _ => return StatusCode::INTERNAL_SERVER_ERROR.into_response(),
    };

    match db::create_account(&state.db, &username, &hash).await {
        Ok(Some(id)) => (StatusCode::CREATED, Json(SessionUser { id, username })).into_response(),
        Ok(None) => (StatusCode::CONFLICT, "username already taken").into_response(),
        Err(e) => {
            tracing::error!("register failed: {e}");
            StatusCode::INTERNAL_SERVER_ERROR.into_response()
        }
    }
}

pub async fn login(
    State(state): State<Arc<AppState>>,
    session: Session,
    Json(creds): Json<Credentials>,
) -> Response {
    let account = match db::find_account(&state.db, creds.username.trim()).await {
        Ok(a) => a,
        Err(e) => {
            tracing::error!("login lookup failed: {e}");
            return StatusCode::INTERNAL_SERVER_ERROR.into_response();
        }
    };

    let Some((id, username, Some(stored_hash))) = account else {
        return StatusCode::UNAUTHORIZED.into_response();
    };

    let password = creds.password;
    let ok = tokio::task::spawn_blocking(move || verify_password(&password, &stored_hash))
        .await
        .unwrap_or(false);
    if !ok {
        return StatusCode::UNAUTHORIZED.into_response();
    }

    if let Err(e) = session.cycle_id().await {
        tracing::error!("cycle_id failed: {e}");
        return StatusCode::INTERNAL_SERVER_ERROR.into_response();
    }
    let user = SessionUser { id, username };
    if let Err(e) = session.insert(SESSION_USER_KEY, user.clone()).await {
        tracing::error!("session insert failed: {e}");
        return StatusCode::INTERNAL_SERVER_ERROR.into_response();
    }
    Json(user).into_response()
}

pub async fn logout(session: Session) -> StatusCode {
    match session.flush().await {
        Ok(()) => StatusCode::NO_CONTENT,
        Err(e) => {
            tracing::error!("logout failed: {e}");
            StatusCode::INTERNAL_SERVER_ERROR
        }
    }
}

pub async fn me(session: Session) -> Response {
    match current_user(&session).await {
        Some(user) => Json(user).into_response(),
        None => StatusCode::UNAUTHORIZED.into_response(),
    }
}
