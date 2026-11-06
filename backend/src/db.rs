use serde::Serialize;
use sqlx::{
    FromRow, PgConnection, PgPool,
    postgres::{PgConnectOptions, PgPoolOptions},
};

fn env(name: &str) -> String {
    std::env::var(name).unwrap_or_else(|_| panic!("{name} not set"))
}

pub async fn init_db() -> PgPool {
    let pass_file = std::env::var("DB_PASSWORD_FILE")
        .unwrap_or_else(|_| "/run/secrets/postgres_pass".to_string());
    let password = std::fs::read_to_string(&pass_file)
        .unwrap_or_else(|e| panic!("cannot read {pass_file}: {e}"));

    let options = PgConnectOptions::new()
        .host(&env("DB_HOST"))
        .username(&env("DB_USER"))
        .database(&env("DB_NAME"))
        .password(password.trim());

    PgPoolOptions::new()
        .max_connections(5)
        .connect_with(options)
        .await
        .expect("cannot connect to postgres")
}

pub async fn run_migrations(pool: &PgPool) {
    sqlx::migrate!("./migrations")
        .run(pool)
        .await
        .expect("cannot run migrations");
}

async fn upsert_player(conn: &mut PgConnection, username: &str) -> Result<i64, sqlx::Error> {
    let (id,): (i64,) = sqlx::query_as(
        "INSERT INTO players (username) VALUES ($1)
         ON CONFLICT (username) DO UPDATE SET username = EXCLUDED.username
         RETURNING id",
    )
    .bind(username)
    .fetch_one(conn)
    .await?;
    Ok(id)
}

pub async fn register_player(pool: &PgPool, username: &str) -> Result<i64, sqlx::Error> {
	let mut conn = pool.acquire().await?;
	upsert_player(&mut conn, username).await
}

pub async fn save_match(
    pool: &PgPool,
    player1: &str,
    player2: &str,
    score1: i32,
    score2: i32,
) -> Result<i64, sqlx::Error> {
    let mut tx = pool.begin().await?;

	eprintln!("test on est avant l'inserte");

    let id1 = upsert_player(&mut tx, player1).await?;
    let id2 = upsert_player(&mut tx, player2).await?;

    let (match_id,): (i64,) = sqlx::query_as(
        "INSERT INTO matches (player1_id, player2_id, score1, score2)
         VALUES ($1, $2, $3, $4)
         RETURNING id",
    )
    .bind(id1)
    .bind(id2)
    .bind(score1)
    .bind(score2)
    .fetch_one(&mut *tx)
    .await?;

    tx.commit().await?;
    Ok(match_id)
}

#[derive(FromRow, Serialize)]
pub struct MatchRow {
    pub id: i64,
    pub player1: String,
    pub player2: String,
    pub score1: i32,
    pub score2: i32,
    pub played_at: String,
}

pub async fn list_matches(pool: &PgPool) -> Result<Vec<MatchRow>, sqlx::Error> {
    sqlx::query_as(
        "SELECT m.id, p1.username AS player1, p2.username AS player2,
                m.score1, m.score2, m.played_at::text AS played_at
         FROM matches m
         JOIN players p1 ON p1.id = m.player1_id
         JOIN players p2 ON p2.id = m.player2_id
         ORDER BY m.id DESC
         LIMIT 50",
    )
    .fetch_all(pool)
    .await
}
