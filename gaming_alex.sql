CREATE DATABASE gaming_alex;
USE gaming_alex;
SHOW TABLES;

-- codigo de cada tabla segun entidad
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    nick TEXT NOT NULL,
    login TEXT NOT NULL,
    password TEXT NOT NULL,
    birthdate DATE
);

CREATE TABLE games (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    rules TEXT
);

CREATE TABLE avatars (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    game_id BIGINT NOT NULL,
    appearance TEXT,
    level INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (game_id) REFERENCES games(id)
);

CREATE TABLE matches (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    game_id BIGINT NOT NULL,
    name TEXT NOT NULL,
    password TEXT,
    created_at DATE,
    status TEXT,
    creator_avatar_id BIGINT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES games(id),
    FOREIGN KEY (creator_avatar_id) REFERENCES avatars(id)
);

CREATE TABLE match_participants (
    match_id BIGINT NOT NULL,
    avatar_id BIGINT NOT NULL,
    PRIMARY KEY (match_id, avatar_id),
    FOREIGN KEY (match_id) REFERENCES matches(id),
    FOREIGN KEY (avatar_id) REFERENCES avatars(id)
);

CREATE TABLE confrontations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    match_id BIGINT NOT NULL,
    avatar1_id BIGINT NOT NULL,
    avatar2_id BIGINT NOT NULL,
    result TEXT,
    FOREIGN KEY (match_id) REFERENCES matches(id),
    FOREIGN KEY (avatar1_id) REFERENCES avatars(id),
    FOREIGN KEY (avatar2_id) REFERENCES avatars(id)
);