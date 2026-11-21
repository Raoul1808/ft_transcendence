use std::sync::Arc;

use axum::{
    extract::State,
    http::{StatusCode, header},
    response::IntoResponse,
};

use crate::{AppState, cache, db};

pub async fn matches(State(state): State<Arc<AppState>>) -> Result<impl IntoResponse, StatusCode> {
    if let Some(json) = cache::get(&state.redis, cache::MATCHES_KEY).await {
        tracing::debug!("matches: cache hit");
        return Ok(([(header::CONTENT_TYPE, "application/json")], json));
    }

    let rows = db::list_matches(&state.db).await.map_err(|e| {
        tracing::error!("list_matches: {e}");
        StatusCode::INTERNAL_SERVER_ERROR
    })?;
    let json = serde_json::to_string(&rows).map_err(|e| {
        tracing::error!("serialize matches: {e}");
        StatusCode::INTERNAL_SERVER_ERROR
    })?;

    cache::set(&state.redis, cache::MATCHES_KEY, &json).await;
    Ok(([(header::CONTENT_TYPE, "application/json")], json))
}
