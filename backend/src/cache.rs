use std::time::Duration;

use tower_sessions_redis_store::fred::prelude::*;

pub const MATCHES_KEY: &str = "cache:matches";

pub async fn connect() -> Pool {
    let url = std::env::var("REDIS_URL").unwrap_or_else(|_| "redis://127.0.0.1:6379".to_string());
    let config = Config::from_url(&url).unwrap_or_else(|e| panic!("bad REDIS_URL: {e}"));
    let perf = PerformanceConfig {
        default_command_timeout: Duration::from_secs(2),
        ..Default::default()
    };
    let pool = Pool::new(
        config,
        Some(perf),
        None,
        Some(ReconnectPolicy::default()),
        6,
    )
    .expect("cannot create redis pool");
    let _connection_task = pool.connect();
    pool.wait_for_connect()
        .await
        .expect("cannot connect to redis");
    pool
}

pub async fn get(pool: &Pool, key: &str) -> Option<String> {
    match tokio::time::timeout(
        Duration::from_millis(300),
        pool.get::<Option<String>, _>(key),
    )
    .await
    {
        Ok(Ok(value)) => value,
        Ok(Err(e)) => {
            tracing::warn!("redis get failed: {e}");
            None
        }
        Err(_) => {
            tracing::warn!("redis get timed out");
            None
        }
    }
    //pool.get(key).await.unwrap_or(None)
}

pub async fn set(pool: &Pool, key: &str, value: &str) {
    let fut = pool.set::<(), _, _>(key, value, Some(Expiration::EX(30)), None, false);
    match tokio::time::timeout(Duration::from_millis(300), fut).await {
        Ok(Ok(())) => {}
        Ok(Err(e)) => tracing::warn!("redis set failed: {e}"),
        Err(_) => tracing::warn!("redis set timed out"),
    }
    /*let res: Result<(), _> = pool
        .set(key, value, Some(Expiration::EX(30)), None, false)
        .await;
    //timeout
    if let Err(e) = res {
        println!("redis set err: {e}");
    }*/
}

pub async fn invalidate(pool: &Pool, key: &str) {
    match tokio::time::timeout(Duration::from_millis(300), pool.del::<(), _>(key)).await {
        Ok(Ok(())) => {}
        Ok(Err(e)) => tracing::warn!("redis del failed: {e}"),
        Err(_) => tracing::warn!("redis del timed out"),
    }
    //let _: Result<(), _> = pool.del(key).await;
}
