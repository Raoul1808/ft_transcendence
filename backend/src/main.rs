use std::{
    collections::{HashMap, HashSet},
    io,
    sync::{Arc, Mutex},
};

use axum::{
    Json, Router,
    extract::{Path, State, ws::Message},
    http::{Method, StatusCode},
    response::{Html, IntoResponse},
    routing::get,
};
//use bytes::Bytes;
use sqlx::PgPool;
use tokio::sync::broadcast;
use tower_http::{cors::CorsLayer, services::ServeDir};
use tracing::info;
use tracing_subscriber::{EnvFilter, layer::SubscriberExt, util::SubscriberInitExt};

mod db;
mod ws;

async fn index() -> impl IntoResponse {
    Html(include_str!("../static/wstest.html"))
}

async fn echo(Path(str): Path<String>) -> impl IntoResponse {
    Html(str)
}

async fn matches(
    State(state): State<Arc<AppState>>,
) -> Result<Json<Vec<db::MatchRow>>, StatusCode> {
    db::list_matches(&state.db).await.map(Json).map_err(|e| {
        tracing::error!("list_matches: {e}");
        StatusCode::INTERNAL_SERVER_ERROR
    })
}

pub struct AppState {
    pub rooms: Mutex<HashMap<String, RoomState>>,
	pub db: PgPool,
}

pub struct RoomState {
    pub users: Mutex<HashSet<String>>,
	pub results: HashMap<usize, (String, [i32; 2])>,
	pub saved: bool,
    pub tx: broadcast::Sender<Message>,
}

impl RoomState {
    #[allow(clippy::new_without_default)]
    pub fn new() -> Self {
        Self {
            users: Mutex::new(HashSet::new()),
			results: HashMap::new(),
			saved: false,
            tx: broadcast::channel(64).0,
        }
    }
}

// entrypoint
#[tokio::main]
async fn main() -> io::Result<()> {
    tracing_subscriber::registry()
        .with(
            EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| format!("{}=info", env!("CARGO_CRATE_NAME")).into()),
        )
        .with(tracing_subscriber::fmt::layer())
        .init();
	let pool = db::init_db().await;
	db::run_migrations(&pool).await;

    let state = Arc::new(AppState {
        rooms: Mutex::new(HashMap::new()),
		db: pool,
    });

    let cors = CorsLayer::new()
        .allow_origin(tower_http::cors::Any)
        .allow_methods(vec![Method::GET]);

    let app = Router::new()
        .route("/", get(index))
		.route("/matches", get(matches))
        .route("/{str}", get(echo))
        .route("/ws", get(ws::websocket_handler))
        .nest_service("/public", ServeDir::new("static"))
        .with_state(state)
        .layer(cors)
        .layer(tower_http::trace::TraceLayer::new_for_http());

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await?;

    info!("server listening on {}", listener.local_addr().unwrap());
    axum::serve(listener, app)
        .with_graceful_shutdown(shutdown_signal())
        .await
}

async fn shutdown_signal() {
    tracing::debug!("installing ctrl+c handler");
    let ctrl_c = async {
        tokio::signal::ctrl_c()
            .await
            .expect("failed to install Ctrl+C handler");
    };

    tracing::debug!("installing terminate signal handler");
    #[cfg(unix)]
    let terminate = async {
        tokio::signal::unix::signal(tokio::signal::unix::SignalKind::terminate())
            .expect("failed to install signal handler")
            .recv()
            .await;
    };

    #[cfg(not(unix))]
    let terminate = std::future::pending::<()>();

    tracing::debug!("polling termination signal");
    tokio::select! {
        _ = ctrl_c => {},
        _ = terminate => {},
    };
    tracing::info!("received stop signal");
}
