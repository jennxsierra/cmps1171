-- Part A

-- Question 1
DROP DATABASE IF EXISTS music;
CREATE DATABASE music;

DROP ROLE IF EXISTS music;
CREATE ROLE music
WITH LOGIN PASSWORD '#music#';

-- Question 2
DROP TABLE IF EXISTS album CASCADE;
CREATE TABLE album (
    id SERIAL PRIMARY KEY, 
    title TEXT NOT NULL);

-- Question 3
DROP TABLE IF EXISTS track;
CREATE TABLE track (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    len INTEGER NOT NULL
);

-- Question 4
ALTER TABLE track
ADD COLUMN album_id INTEGER REFERENCES album(id) ON DELETE CASCADE;

-- Question 5
INSERT INTO album (title)
VALUES
('The Wall'),
('The Dark Side of the Moon'),
('The Final Cut');

INSERT INTO track (title, len, album_id)
VALUES
('Another Brick in the Wall', 3, 1),
('The Great Gig in the Sky', 3, 2),
('How I Wish You Were Here', 4, 2),
('Comfortably Numb', 5, 1),
('The Final Cut', 3, 3);

-- Question 6
SELECT A.title AS album_title, T.title AS track_title, T.len
FROM album AS A
INNER JOIN track AS T
ON A.id = T.album_id;