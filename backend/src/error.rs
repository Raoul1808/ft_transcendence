use axum::{http::StatusCode, response::IntoResponse};
use thiserror::Error;

#[derive(Debug, Error)]
pub enum Error {
    #[error("resource not found")]
    NotFound,

    #[error("username must be between 1 and 32 characters")]
    InvalidUsernameLength,

    #[error("password must be between 8 and 128 characters")]
    InvalidPasswordLength,

    #[error("unauthorized")]
    Unauthorized,

    #[error("database error")]
    Sqlx(sqlx::Error),

    #[error("argon2 password hash error")]
    Argon2PasswordHash(#[from] argon2::password_hash::Error),

    #[error("tokio join error")]
    TokioJoin(#[from] tokio::task::JoinError),

    #[error("tower session error")]
    Session(#[from] tower_sessions::session::Error),
}

impl Error {
    fn status_code(&self) -> StatusCode {
        match self {
            Self::NotFound => StatusCode::NOT_FOUND,
            Self::InvalidUsernameLength | Self::InvalidPasswordLength => StatusCode::BAD_REQUEST,
            Self::Unauthorized => StatusCode::UNAUTHORIZED,
            _ => StatusCode::INTERNAL_SERVER_ERROR,
        }
    }
}

impl IntoResponse for Error {
    fn into_response(self) -> axum::response::Response {
        tracing::error!("{}", self.to_string());
        match &self {
            Self::Sqlx(e) => {
                tracing::error!("{e}");
            }
            Self::Argon2PasswordHash(e) => {
                tracing::error!("{e}");
            }
            Self::TokioJoin(e) => {
                tracing::error!("{e}");
            }
            Self::Session(e) => {
                tracing::error!("{e}");
            }
            _ => {}
        };
        (self.status_code(), self.to_string()).into_response()
    }
}

impl From<sqlx::Error> for Error {
    fn from(value: sqlx::Error) -> Self {
        match value {
            sqlx::Error::RowNotFound => Self::NotFound,
            _ => Self::Sqlx(value),
        }
    }
}
