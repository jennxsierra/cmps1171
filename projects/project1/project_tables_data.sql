-- [CMPS1171-1] Introduction to Databases Project 1
-- Andres Hung & Jennessa Sierra
-- 2024/02/23

/* USAGE */

-- 1. Comment everything after DATABASE SETUP section.
-- 2. Run file as the postgres superuser in the postgres database.
-- 3. Manually log into music database as music user.
-- 4. Uncomment the rest of sections and comment the DATABASE SETUP section.
-- 5. Run file again to create the tables and populate with data.

/* DATABASE SETUP */

DROP DATABASE IF EXISTS music;
CREATE DATABASE music;

DROP ROLE IF EXISTS music;
CREATE ROLE music WITH LOGIN PASSWORD '$swordfish$';

-- psql@16 only - grant privileges to music user as postgres superuser
\c music
GRANT ALL PRIVILEGES ON SCHEMA public TO music;
\c music music

/* CREATE TABLES */

-- clear existing tables
DROP TABLE IF EXISTS performances CASCADE;
DROP TABLE IF EXISTS districts CASCADE;
DROP TABLE IF EXISTS shows CASCADE;
DROP TABLE IF EXISTS venues;
DROP TABLE IF EXISTS artists;

-- used in both artist and venue addresses
CREATE TABLE
    districts (
        district_id SERIAL PRIMARY KEY,
        name TEXT NOT NULL
    );

CREATE TABLE
    artists (
        artist_id SERIAL PRIMARY KEY,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        gender CHAR(1) NOT NULL CHECK (gender in ('m', 'f', 'o')),
        date_of_birth DATE NOT NULL,
        genre TEXT NOT NULL, -- assume one genre
        address TEXT NOT NULL, -- assume one address
        district INT,
        phone TEXT NOT NULL, -- assume one phone number
        email TEXT, -- assume one email address
        FOREIGN KEY (district) REFERENCES districts (district_id)
    );

CREATE TABLE
    venues (
        venue_id SERIAL PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        district INT,
        capacity INT NOT NULL,
        private BOOL NOT NULL,
        contact_phone TEXT NOT NULL,
        FOREIGN KEY (district) REFERENCES districts (district_id)
    );

CREATE TABLE
    shows (
        show_id SERIAL PRIMARY KEY,
        name TEXT NOT NULL,
        venue INT,
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        price NUMERIC(9, 2) NOT NULL,
        description TEXT NOT NULL,
        tickets INT NOT NULL,
        vip_tickets INT,
        FOREIGN KEY (venue) REFERENCES venues (venue_id)
    );

-- linking table to indicate many-to-many relationship between artists and shows tables
CREATE TABLE
    performances (
        performance_id SERIAL PRIMARY KEY,
        show_id INT,
        artist_id INT,
        FOREIGN KEY (show_id) REFERENCES shows (show_id),
        FOREIGN KEY (artist_id) REFERENCES artists (artist_id)
    );

/* INSERT DATA INTO TABLES */

INSERT INTO districts (name)
VALUES
    ('Corozal'),
    ('Orange Walk'),
    ('Belize'),
    ('Cayo'),
    ('Stann Creek'),
    ('Toledo');

INSERT INTO artists (first_name, last_name, gender, date_of_birth, genre, address, district, phone, email)
VALUES
    ('John', 'Smith', 'm', '2000-01-01', 'Country', '14 Apple Street', 4, '633-1902', 'johnsmith@gmail.com'),
    ('Jane', 'Smith', 'f', '2001-02-10', 'Pop', '34 Mango Street', 1, '633-7787', 'janesmith@gmail.com'),
    ('Mark', 'Johnson', 'm', '1995-05-15', 'Rock', '56 Mahogany Street', 3, '633-4567', 'markjohnson@gmail.com'),
    ('Emily', 'Davis', 'f', '1998-09-20', 'Jazz', '78 Haulover Creek Street', 2, '633-9876', 'emilydavis@gmail.com'),
    ('Michael', 'Wilson', 'o', '1990-12-03', 'Hip Hop', '90 Blue Hole Street', 5, '633-2345', 'michaelwilson@gmail.com'),
    ('Sarah', 'Anderson', 'f', '1993-07-08', 'R&B', '12 Mariposa Avenue', 6, '633-8765', 'sarahanderson@gmail.com'),
    ('David', 'Taylor', 'm', '1988-03-25', 'Classical', '45 Hummingbird Drive', 1, '633-5432', 'davidtaylor@gmail.com'),
    ('Olivia', 'Thomas', 'f', '1997-11-12', 'Pop', '67 Mountaine View Boulevard', 4, '633-7654', 'oliviathomas@gmail.com'),
    ('Daniel', 'Brown', 'm', '1992-06-18', 'Rock', '89 Rose Garden Street', 2, '633-3210', 'danielbrown@gmail.com'),
    ('Sophia', 'Clark', 'f', '1994-04-05', 'Country', '23 Cardinal Avenue', 2, '633-6789', 'sophiaclark@gmail.com');
    


INSERT INTO venues (name, address, district, capacity, private, contact_phone)
VALUES
    ('Bliss Institute of Arts', 'Seaside Avenue', 3, 1000, false, '822-0989'),
    ('Belize City Civic Center', 'Central American Boulevard', 3, 5000, false, '822-1234'),
    ('San Ignacio Resort Hotel', 'Buena Vista Street', 4, 500, true, '822-5678'),
    ('Placencia Community Center', 'Main Street', 5, 200, false, '822-4321'),
    ('Ambergris Stadium', 'Barrier Reef Drive', 6, 1000, false, '822-8765'),
    ('Dangriga Cultural Center', 'St. Vincent Street', 5, 300, false, '822-2345'),
    ('Orange Walk Town Hall', 'Queen Victoria Avenue', 2, 400, false, '822-7890'),
    ('Stann Creek Sports Complex', 'Front Street', 5, 800, true, '822-5432'),
    ('Benque Viejo Del Carmen Community Center', 'San Jose Street', 4, 250, false, '822-9876'),
    ('Corozal Civic Center', '7th Avenue', 1, 600, false, '822-3210');
    

-- some shows don't offer VIP tickets, indicated by NULL values
INSERT INTO shows (name, venue, start_date, end_date, price, description, tickets, vip_tickets)
VALUES
    ('Love Day Fest', 5, '2024-02-14', '2024-02-14', 15000.00, 'Celebrate Valentine''s Day with love!', 150, 15),
    ('Spring Fling', 3, '2024-03-30', '2024-03-31', 75000.00, 'Celebrate the arrival of spring with this lively event.', 750, 75),
    ('Easter Beach Party', 9, '2024-04-16', '2024-04-16', 35000.00, 'Enjoy a fun-filled day at the beach this Easter.', 350, 35),
    ('Summer Crash', 1, '2024-06-01', '2024-06-03', 50000.00, 'Experience the ultimate summer fun at this event.', 500, 50),
    ('Carnival', 10, '2024-09-10', '2024-09-12', 60000.00, 'Join the festivities and excitement of a carnival.', 600, NULL),
    ('Fall Fest', 4, '2024-09-25', '2024-09-30', 25000.00, 'Celebrate the beauty of fall at this festival.', 250, 25),
    ('Independence Day Celebration', 7, '2024-09-21', '2024-09-21', 30000.00, 'Celebrate Independence Day with patriotic spirit.', 300, NULL),
    ('Halloween Bazaar', 8, '2024-10-31', '2024-10-31', 20000.00, 'Experience a spooky and fun-filled Halloween event.', 200, 20),
    ('Garifuna Settlement Day', 8, '2024-11-19', '2024-11-19', 40000.00, 'Celebrate the Garifuna culture and heritage on this special day.', 400, 40),
    ('Winter Wonderland', 2, '2024-12-23', '2024-12-25', 100000.00, 'Experience the magic of winter at this holiday event.', 1000, 100),
    ('New Years Bash', 2, '2024-12-30', '2025-01-01', 70000.00, 'Start the new year with a party!', 900, NULL);


INSERT INTO performances (show_id, artist_id)
VALUES
    (1, 1),
    (1, 2),
    (2, 3),
    (3, 4),
    (3, 5),
    (3, 6),
    (4, 7),
    (4, 8),
    (5, 9),
    (5, 10),
    (6, 1),
    (7, 2),
    (7, 3),
    (7, 4),
    (8, 5),
    (8, 6),
    (8, 7),
    (9, 8),
    (10, 9),
    (11, 10);