use serde::{Deserialize, Serialize};
use tower_sessions::Session;

pub const SESSION_USER_KEY: &str = "user";

#[derive(Serialize, Deserialize, Clone)]
pub struct SessionUser {
    pub id: i64,
    pub username: String,
}

pub async fn current_user(session: &Session) -> Option<SessionUser> {
    session.get(SESSION_USER_KEY).await.ok().flatten()
}
