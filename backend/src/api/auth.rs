use std::sync::Arc;

use axum::{
    Json,
    extract::State,
    http::StatusCode,
    response::{IntoResponse, Response},
};
use serde::Deserialize;
use tower_sessions::Session;

use crate::{
    AppState,
    auth::{SESSION_USER_KEY, SessionUser, current_user, hash_password, verify_password},
    db,
};

#[derive(Deserialize)]
pub struct Credentials {
    username: String,
    password: String,
}

pub async fn register(
    State(state): State<Arc<AppState>>,
    Json(creds): Json<Credentials>,
) -> Result<Response, crate::Error> {
    let username = creds.username.trim().to_string();
    if username.is_empty() || username.chars().count() > 32 {
        return Err(crate::Error::InvalidUsernameLength);
    }
    let len = creds.password.chars().count();
    if !(8..=128).contains(&len) {
        return Err(crate::Error::InvalidPasswordLength);
    }

    let password = creds.password;
    let hash = tokio::task::spawn_blocking(move || hash_password(&password)).await??;

    let res = match db::create_account(&state.db, &username, &hash).await? {
        Some(id) => (StatusCode::CREATED, Json(SessionUser { id, username })).into_response(),
        None => (StatusCode::CONFLICT, "username already taken").into_response(),
    };
    Ok(res)
}

pub async fn login(
    State(state): State<Arc<AppState>>,
    session: Session,
    Json(creds): Json<Credentials>,
) -> Result<Response, crate::Error> {
    let account = db::find_account(&state.db, creds.username.trim()).await?;

    let Some((id, username, Some(stored_hash))) = account else {
        return Err(crate::Error::Unauthorized);
    };

    let password = creds.password;
    let ok = tokio::task::spawn_blocking(move || verify_password(&password, &stored_hash))
        .await
        .unwrap_or(false);
    if !ok {
        return Err(crate::Error::Unauthorized);
    }

    session.cycle_id().await?;
    let user = SessionUser { id, username };
    session.insert(SESSION_USER_KEY, user.clone()).await?;
    Ok(Json(user).into_response())
}

pub async fn logout(session: Session) -> Result<StatusCode, crate::Error> {
    session.flush().await?;
    Ok(StatusCode::NO_CONTENT)
}

pub async fn me(session: Session) -> Result<Response, crate::Error> {
    match current_user(&session).await {
        Some(user) => Ok(Json(user).into_response()),
        None => Err(crate::Error::Unauthorized),
    }
}
