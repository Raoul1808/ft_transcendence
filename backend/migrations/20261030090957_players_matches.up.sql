-- Add up migration script here

Create TABLE players (
	id			BIGSERIAL PRIMARY KEY,
	username	TEXT NOT NULL UNIQUE,
	password_hash	TEXT,
	created_at	TIMESTAMPTZ NOT NULL DEFAULT now()
);

Create TABLE matches (
	id			BIGSERIAL PRIMARY KEY,
	player1_id	BIGINT NOT NULL REFERENCES players(id),
	player2_id	BIGINT NOT NULL REFERENCES players(id),
	score1		INT NOT NULL,
	score2		INT NOT NULL,
	played_at	TIMESTAMPTZ NOT NULL DEFAULT now(),
	CHECK (player1_id <> player2_id)
);

CREATE INDEX matches_player1_idx ON matches (player1_id);
CREATE INDEX matches_player2_idx ON matches (player2_id);
