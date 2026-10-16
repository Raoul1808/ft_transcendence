use std::io;

use axum::{
    Router,
    extract::Path,
    response::{Html, IntoResponse},
    routing::get,
};
use tracing::info;
use tracing_subscriber::{EnvFilter, layer::SubscriberExt, util::SubscriberInitExt};

async fn index() -> impl IntoResponse {
    Html("<h1>hell word</h1>")
}

async fn echo(Path(str): Path<String>) -> impl IntoResponse {
    Html(str)
}

#[tokio::main]
async fn main() -> io::Result<()> {
    tracing_subscriber::registry()
        .with(
            EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| format!("{}=info", env!("CARGO_CRATE_NAME")).into()),
        )
        .with(tracing_subscriber::fmt::layer())
        .init();

    let app = Router::new()
        .route("/", get(index))
        .route("/{str}", get(echo))
        .layer(tower_http::trace::TraceLayer::new_for_http());

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await?;

    info!("server listening on {}", listener.local_addr().unwrap());
    axum::serve(listener, app).await
}
