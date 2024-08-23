-- [CMPS1171-1] Introduction to Databases Final Project
-- Andres Hung & Jennessa Sierra
-- 2024/04/12

/* USAGE */

-- 1. Comment everything after DATABASE SETUP section.
-- 2. Run file as the postgres superuser in the postgres database.
-- 3. Manually log into project database as utopia user.
-- 4. Uncomment the rest of sections and comment the DATABASE SETUP section.
-- 5. Run file again to create the tables and populate with data.

/* DATABASE SETUP */

DROP DATABASE IF EXISTS utopia;
CREATE DATABASE utopia;

DROP ROLE IF EXISTS utopia;
CREATE ROLE utopia WITH LOGIN PASSWORD '#final#';

-- psql@15+ only - grant privileges to utopia user as postgres superuser
\c utopia postgres
GRANT ALL PRIVILEGES ON SCHEMA public TO utopia;
\c utopia utopia

/* CREATE TABLES */

-- drop existing tables
DROP TABLE IF EXISTS user_page_comments CASCADE;
DROP TABLE IF EXISTS user_block_lists CASCADE;
DROP TABLE IF EXISTS user_messages CASCADE;
DROP TABLE IF EXISTS user_conversations CASCADE;
DROP TABLE IF EXISTS user_relationship_preferences CASCADE;
DROP TABLE IF EXISTS relationship_types CASCADE;
DROP TABLE IF EXISTS user_photos CASCADE;
DROP TABLE IF EXISTS user_gender_preferences CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS genders CASCADE;

-- USERS, GENDERS, and GENDER PREFERENCES

CREATE TABLE genders (
    gender_id SERIAL PRIMARY KEY,
    gender TEXT NOT NULL
);

CREATE TABLE users (
    utopia_id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL,
    gender INT,
    biography TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (gender) REFERENCES genders (gender_id)
);

CREATE TABLE user_gender_preferences (
    utopia_id INT,
    gender_id INT,
    PRIMARY KEY (utopia_id, gender_id),
    FOREIGN KEY (utopia_id) REFERENCES users (utopia_id),
    FOREIGN KEY (gender_id) REFERENCES genders (gender_id)
);

-- USER PHOTOS

CREATE TABLE user_photos (
    photo_id SERIAL PRIMARY KEY,
    uploader_id INT,
    url TEXT NOT NULL,
    description TEXT NOT NULL,
    uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uploader_id) REFERENCES users (utopia_id)
);

-- RELATIONSHIPS AND RELATIONSHIP PREFERENCES

CREATE TABLE relationship_types (
    relationship_id SERIAL PRIMARY KEY,
    relationship TEXT NOT NULL
);

CREATE TABLE user_relationship_preferences (
    utopia_id INT,
    relationship_id INT,
    PRIMARY KEY (utopia_id, relationship_id),
    FOREIGN KEY (utopia_id) REFERENCES users (utopia_id),
    FOREIGN KEY (relationship_id) REFERENCES relationship_types (relationship_id)
);

-- CONVERSATIONS AND MESSAGES

CREATE TABLE user_conversations (
    conversation_id SERIAL PRIMARY KEY,
    -- assume only 2 users can be in a conversation according to the database specifications
    initiator INT, -- the user who initially started the conversation
    recipient INT, -- the participant user
    -- assume closed conversations cannot be reopened; a new conversation must be created
    active BOOL NOT NULL DEFAULT true, -- users can delete/close conversations; it remains in database but is no longer active
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    closed_at TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (initiator) REFERENCES users (utopia_id),
    FOREIGN KEY (recipient) REFERENCES users (utopia_id)
);

CREATE TABLE user_messages (
    message_id SERIAL PRIMARY KEY,
    conversation_id INT,
    contents TEXT NOT NULL,
    sender INT, -- receiver can be retrieved from sender, conversation_id and the user_conversatinos table
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    received_at TIMESTAMP NOT NULL, -- when the recipient has gotten the message on their app
    seen_at TIMESTAMP NOT NULL,
    FOREIGN KEY (sender) REFERENCES users (utopia_id),
    FOREIGN KEY (conversation_id) REFERENCES user_conversations (conversation_id)
);

-- USER BLOCK LISTS

CREATE TABLE user_block_lists (
    blocker INT,
    blockee INT,
    PRIMARY KEY (blocker, blockee),
    FOREIGN KEY (blocker) REFERENCES users (utopia_id),
    FOREIGN KEY (blockee) REFERENCES users (utopia_id)
);

-- USER COMMENTS

CREATE TABLE user_page_comments (
    comment_id SERIAL PRIMARY KEY,
    -- assume each user is only allowed one page on which comments are made, so utopia_id is used
    user_page INT,
    commenter INT,
    contents TEXT NOT NULL,
    anonymized BOOL NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_page) REFERENCES users (utopia_id),
    FOREIGN KEY (commenter) REFERENCES users (utopia_id)
);

/* INSERT DATA */

INSERT INTO genders (gender)
VALUES
    ('male'),
    ('female');

INSERT INTO users (username, email, fname, lname, gender, biography, created_at)
VALUES
    (
        'roylandsumx',
        'roylandsummer@gmail.com',
        'Royland',
        'Summer',
        1,
        'I am a happy-go-lucky nature-loving fellow looking for a date!',
        '2024-01-10 15:52:24.12041-06'
    ),
    (
        'cindyramos',
        'cindylovers@gmail.com',
        'Cindy',
        'Ramos',
        2,
        'I love hiking, adventures and spending my time traveling the world.',
        '2023-10-15 14:20:59.43523-06' -- the last -06 don't change, that's the timezone in BZ
    ),
    (
        'gamer99epic',
        'randallswerve@gmail.com',
        'Randall',
        'Swerve',
        1,
        'Eat, Sleep, Fortnite, Repeat',
        '2024-02-17 02:23:43.75342-06'
    ),
    (
        'jennmay',
        'jennymay@gmail.com',
        'Jennifer',
        'May',
        2,
        'Photography is my passion and I love capturing the beauty of the world.',
        '2023-11-01 09:12:54.10044-06'
    ),
    (
        'johnnycodes',
        'johnsmith@gmail.com',
        'John',
        'Smith',
        1,
        'Aspiring software engineer and content creator.',
        '2024-04-12 12:00:21.00973-06'
    ),
    (
        'migzmusic',
        'miguelsanchez@gmail.com',
        'Miguel',
        'Sanchez',
        1,
        'Music is my life and I love playing the guitar.',
        '2024-02-20 08:30:49.02370-06'

    ),
    (
        'coolcoder123',
        'coolcoder123@gmail.com',
        'James',
        'Johnson',
        1,
        'Just a teen who loves coding and video games. Always up for a challenge!',
        '2024-03-12 16:37:14.73850-06'
    ),
    (
        'musiclover98',
        'musiclover98@gmail.com',
        'Emily',
        'Williams',
        2,
        'Music is my life. I play the guitar and write my own songs. Dream big!',
        '2024-04-15 17:30:59.53214-06'
    ),
    (
        'skaterboy2005',
        'skaterboy2005@gmail.com',
        'Michael',
        'Brown',
        1,
        'Skateboarding is not just a sport, its a lifestyle. Live free, skate hard.',
        '2024-01-18 13:42:34.25478-06'
    ),
    (
        'bookwormgirl',
        'bookwormgirl@gmail.com',
        'Emma',
        'Jones',
        2,
        'Books are my escape from reality. Love fantasy and sci-fi genres.',
        '2023-12-20 19:17:54.36594-06'
    ),
    (
        'hoopdreams',
        'hoopdreams@gmail.com',
        'David',
        'Miller',
        1,
        'Basketball is my passion. Working hard to make the varsity team next year.',
        '2024-03-22 09:27:34.11542-06'
    ),
    (
        'artisticanna',
        'artisticanna@gmail.com',
        'Anna',
        'Davis',
        2,
        'Art is the way I express myself. Love painting and digital art.',
        '2024-02-24 11:45:23.95123-06'
    ),
    (
        'gamingguru',
        'gamingguru@gmail.com',
        'Robert',
        'Wilson',
        1,
        'Gaming is not just a hobby, its a way of life. Love RPGs and strategy games.',
        '2024-01-26 22:21:34.75369-06'
    ),
    (
        'dancindiva',
        'dancindiva@gmail.com',
        'Sophia',
        'Thomas',
        2,
        'Dance is my passion. Ballet, hip-hop, contemporary - I love it all!',
        '2023-11-28 17:30:59.11420-06'
    ),
    (
        'techgeek',
        'techgeek@gmail.com',
        'William',
        'Moore',
        1,
        'Tech enthusiast. Love building PCs and exploring new tech gadgets.',
        '2023-11-30 20:45:34.36594-06'
    )
    

INSERT INTO user_gender_preferences (utopia_id, gender_id)
VALUES
    (1, 2),
    (2, 1),
    (3, 2),
    (4, 1),
    (5, 2),
    (6, 2),
    (7, 1),
    (8, 1),
    (9, 2),
    (10, 2),
    (11, 1),
    (12, 2),
    (13, 1),
    (14, 2),
    (15, 1);

INSERT INTO user_photos (uploader_id, url, description, uploaded_at)
VALUES
    (
        1,
        'https://utopiadating.bz/photo/189427',
        'This was me at the September 21st Independence Day celebration in 2023!',
        '2024-01-11 10:12:54.10044-06'
    ),
    (
        2,
        'https://utopiadating.bz/photo/548935',
        'At the Florida beaches relaxing in the sun.',
        '2023-10-15 16:11:04.10234-06' -- make sure this is after user creation date
    ),
    (
        3,
        'https://utopiadating.bz/photo/98124',
        'Me and my friends at the Fortnite World Cup 2024!',
        '2024-02-18 02:23:43.75342-06'
    ),
    (
        4,
        'https://utopiadating.bz/photo/33415',
        'Me at the Grand Canyon, one of the most beautiful places I have visited!',
        '2023-11-04 19:16:43.12041-06'
    ),
    (
        5,
        'https://utopiadating.bz/photo/67339',
        'Coding till the break of dawn!',
        '2024-04-15 07:05:21.02450-06'
    ),
    (
        6,
        'https://utopiadating.bz/photo/88541',
        'Playing the guitar at a local concert!',
        '2024-02-27 18:33:37.01467-06'
    ),
    (
        7,
        'https://utopiadating.bz/photo/99721',
        'What video game should I play next?',
        '2024-04-14 16:37:14.73850-06'
    ),
    (
        8,
        'https://utopiadating.bz/photo/52117',
        'Picked up some new vinyls today!',
        '2024-04-18 12:17:21.13362-06'
    ),
    (
        9,
        'https://utopiadating.bz/photo/12345',
        'Skateboarding at the local skate park!',
        '2024-01-22 16:58:34.94716-06'
    ),
    (
        10,
        'https://utopiadating.bz/photo/67890',
        'Reading my favorite book series!',
        '2023-12-23 20:11:29.25478-06'
    ),
    (
        11,
        'https://utopiadating.bz/photo/23456',
        'Practicing my basketball shots!',
        '2024-03-27 10:19:43.15973-06'
    ),
    (
        12,
        'https://utopiadating.bz/photo/78901',
        'Painting a new masterpiece!',
        '2024-02-30 14:27:23.95123-06'
    ),
    (
        13,
        'https://utopiadating.bz/photo/34567',
        'Just won a game of Fortnite!',
        '2024-01-29 22:31:52.55472-06'
    ),
    (
        14,
        'https://utopiadating.bz/photo/89012',
        'Dancing the night away!',
        '2023-11-29 21:42:34.11542-06'
    ),
    (
        15,
        'https://utopiadating.bz/photo/45678',
        'Building my new PC!',
        '2024-12-01 11:03:19.81662-06'
    );

INSERT INTO relationship_types (relationship)
VALUES
    ('Romance'),
    ('Friendship'),

INSERT INTO user_relationship_preferences (utopia_id, relationship_id)
VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 2),
    (6, 2),
    (7, 1),
    (8, 1),
    (9, 2),
    (10, 2),
    (11, 1),
    (12, 1),
    (13, 1),
    (14, 2),
    (15, 1);

INSERT INTO user_conversations (initiator, recipient, active, created_at, closed_at)
VALUES
    (1, 2, true, '2024-01-12 09:31:54.87041-06', NULL), -- make sure the times make sense and give some examples of non-active ones with closed_at values
    (3, 4, false, '2024-02-27 13:07:14.59840-06', '2024-02-28 10:02:27.48625-06'),
    (5, 7, true, '2024-04-15 17:30:59.53214-06', NULL),
    (6, 8, true, '2024-04-28 08:30:49.02370-06', NULL),
    (13, 14, false, '2024-02-02 22:21:34.75369-06', '2024-02-03 17:30:59.11420-06'),
    (15, 1, false, '2024-02-12 12:00:21.00973-06', '2024-02-13 08:30:49.02370-06');


INSERT INTO user_messages (conversation_id, contents, sender, sent_at, received_at, seen_at)
VALUES
    (
        1,
        'hey gurl wats up',
        1,
        '2024-01-12 09:32:03.27141-06',
        '2024-01-12 09:32:05.72341-06',
        '2024-01-12 09:42:04.27051-06'
    ),
    (
        1,
        'Im working (traveling) hbu?',
        2,
        '2024-01-12 09:43:15.45141-06',
        '2024-01-12 09:50:30.34892-06',
        '2024-01-12 09:50:35.29084-06' -- make sure the timings make sense
    ),
    (
        2,
        'hey jenn, loved the pic of the grand canyon!',
        3,
        '2024-02-27 13:07:14.59840-06',
        '2024-02-27 13:07:14.87410-06',
        '2024-02-27 13:09:15.12340-06'
    ),
    (
        2,
        'thanks! it was an amazing experience',
        4,
        '2024-02-27 13:09:43.24863-06',
        '2024-02-27 13:09:43.36154-06',
        '2024-02-27 13:10:21.14563-06'
    ),
    (
        3,
        'hey, wanna play Fortnite?? im the BEST!!1!',
        5,
        '2024-04-15 17:30:59.53214-06',
        '2024-04-15 17:30:59.75321-06',
        '2024-04-15 17:31:11.12340-06'
    ),
    (
        3,
        'sure! I love Fortnite too!',
        7,
        '2024-04-15 17:32:43.24863-06',
        '2024-04-15 17:32:43.36154-06',
        '2024-04-15 17:33:21.14563-06'
    ),
    (
        4,
        'hey, wanna listen to me play guitar?',
        6,
        '2024-04-28 08:30:49.02370-06',
        '2024-04-28 08:30:49.75321-06',
        '2024-04-28 08:31:11.12340-06'
    ),
    (
        4,
        'sure! I love music :)',
        8,
        '2024-04-28 08:32:43.24863-06',
        '2024-04-28 08:32:43.36154-06',
        '2024-04-28 08:33:21.14563-06'
    ),
    (
        5,
        'hey, do you play viedo games?',
        13,
        '2024-02-02 22:21:34.75369-06',
        '2024-02-02 22:21:34.84975-06',
        '2024-02-02 22:22:17.19478-06'
    ),
    (
        5,
        'not really but it sounds fun!',
        14,
        '2024-02-02 22:22:43.24863-06',
        '2024-02-02 22:22:43.36154-06',
        '2024-02-02 22:23:21.14563-06'
    ),
    (
        6,
        'sup bro, you code?',
        15,
        '2024-02-12 12:00:21.00973-06',
        '2024-02-12 12:00:21.19754-06',
        '2024-02-12 12:01:28.39410-06'
    ),
    (
        6,
        'nah but i have a PC!',
        1,
        '2024-02-12 12:01:43.24863-06',
        '2024-02-12 12:01:43.36154-06',
        '2024-02-12 12:02:21.14563-06'
    );

INSERT INTO user_block_lists (blocker, blockee)
VALUES
    (2, 3),
    (4, 11),
    (12, 14);

INSERT INTO user_page_comments (user_page, commenter, contents, anonymized, created_at)
VALUES
    (
        3,
        13,
        'yo bro, wanna play fortnite sometime?',
        false,
        '2024-02-18 03:00:14.13445-06'
    ),
    (
        2,
        1,
        'hey cindy, love the beach pic!',
        false,
        '2023-10-15 16:29:34.85201-06'
    ),
    (
        5,
        7,
        'code on bro!',
        false,
        '2024-04-15 17:35:59.53214-06'
    ),
    (
        6,
        8,
        'love the guitar pic james!',
        false,
        '2024-02-27 18:35:37.01467-06'
    ),
    (
        9,
        10,
        'awesome skate pics mike :)',
        false,
        '2024-01-22 17:00:34.94716-06'
    ),
    (
        11,
        12,
        'varsity team here you come!',
        false,
        '2024-03-27 10:30:15.65420-06'
    ),
    (
        15,
        13,
        'epic PC build dude!',
        false,
        '2024-12-01 11:15:49.88542-06'
    );
    

/* DISPLAY ALL TABLES */

SELECT *
FROM genders;

SELECT *
FROM users;

SELECT *
FROM user_gender_preferences;

SELECT *
FROM user_photos;

SELECT *
FROM relationship_types;

SELECT *
FROM user_relationship_preferences;

SELECT *
FROM user_conversations;

SELECT *
FROM user_messages;

SELECT *
FROM user_block_lists;

SELECT *
FROM user_page_comments;