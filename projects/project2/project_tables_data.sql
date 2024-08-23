-- [CMPS1171-1] Introduction to Databases Project 2
-- Andres Hung & Jennessa Sierra
-- 2024/03/22

/* USAGE */

-- 1. Comment everything after DATABASE SETUP section.
-- 2. Run file as the postgres superuser in the postgres database.
-- 3. Manually log into project database as project user.
-- 4. Uncomment the rest of sections and comment the DATABASE SETUP section.
-- 5. Run file again to create the tables and populate with data.

/* DATABASE SETUP */

DROP DATABASE IF EXISTS project;
CREATE DATABASE project;

DROP ROLE IF EXISTS project;
CREATE ROLE project WITH LOGIN PASSWORD '#swordfish#';

-- psql@15+ only - grant privileges to project user as postgres superuser
\c project postgres
GRANT ALL PRIVILEGES ON SCHEMA public TO project;
\c project project

/* CREATE TABLES */

-- drop existing tables
DROP TABLE IF EXISTS addresses CASCADE;
DROP TABLE IF EXISTS districts CASCADE;
DROP TABLE IF EXISTS parent_student CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS parents CASCADE;
DROP TABLE IF EXISTS classrooms CASCADE;
DROP TABLE IF EXISTS buildings CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;

-- BUILDINGS and CLASSROOMS

CREATE TABLE buildings (
    building_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    classroom_capacity INT NOT NULL
);

CREATE TABLE classrooms (
    classroom_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    has_projector BOOL NOT NULL,
    building INT NOT NULL,
    FOREIGN KEY (building) REFERENCES buildings (building_id)
);

-- TEACHERS, PARENTS and STUDENTS

CREATE TABLE districts (
    name TEXT PRIMARY KEY
);

CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    address TEXT NOT NULL,
    district TEXT,
    FOREIGN KEY (district) REFERENCES districts (name)
);

CREATE TABLE teachers (
    teacher_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    gender CHAR(1) NOT NULL CHECK (gender IN ('m', 'f', 'o')),
    salary NUMERIC(8, 2) NOT NULL,
    contact_phone TEXT NOT NULL,
    contact_email TEXT NOT NULL,
    address INT, -- assume one main address
    FOREIGN KEY (address) REFERENCES addresses (address_id)
);

-- parents table also include guardians
-- only one parent of student is needed for record, but can add more than one record
CREATE TABLE parents (
    parent_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    gender CHAR(1) NOT NULL CHECK (gender IN ('m', 'f', 'o')),
    profession TEXT NOT NULL,
    contact_phone TEXT NOT NULL,
    contact_email TEXT NOT NULL,
    address INT, -- assume one main address
    FOREIGN KEY (address) REFERENCES addresses (address_id)
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1) NOT NULL CHECK (gender IN ('m', 'f', 'o')),
    graduated DATE, -- NULL value indicates student has not graduated yet
    address INT,
    classroom INT NOT NULL, -- a preschool student only belongs to one classroom
    FOREIGN KEY (address) REFERENCES addresses (address_id),
    FOREIGN KEY (classroom) REFERENCES classrooms (classroom_id)
);

-- linking table to indicate many-to-many relationship between students and parents
CREATE TABLE parent_student (
    parent_id INT NOT NULL,
    student_id INT NOT NULL,
    PRIMARY KEY (parent_id, student_id),
    FOREIGN KEY (parent_id) REFERENCES parents (parent_id),
    FOREIGN KEY (student_id) REFERENCES students (student_id)
);

/* INSERT DATA */

INSERT INTO buildings (name, classroom_capacity)
VALUES
    ('George Price', 30),
    ('Dean Barrow', 35);

INSERT INTO classrooms (name, has_projector, building)
VALUES
    ('Toucan', true, 1),
    ('Tapir', false, 1),
    ('Mahogany', true, 2),
    ('Black Orchid', false, 2);

INSERT INTO districts
VALUES
    ('Corozal'),
    ('Orange Walk'),
    ('Belize'),
    ('Cayo'),
    ('Stann Creek'),
    ('Dangriga');

INSERT INTO addresses (address, district)
VALUES
    -- some teachers travel for work
    ('78 Duality Blvd', 'Belize'),
    ('45 Cardinal Ave', 'Cayo'),
    ('12 Lion Ave', 'Belize'),
    ('19 Dragon Ln', 'Orange Walk'),
    ('65 Trio St', 'Cayo'),
    ('32 Forest Dr', 'Cayo'),
    ('15 Flowers St', 'Cayo'),
    ('29 Macal St', 'Cayo'),
    ('24 Macaw Ave', 'Cayo'),
    ('46 College Blvd', 'Cayo'),
    -- parent and students have same address
    ('26 Canada Hill St', 'Cayo'),
    ('45 Orange St', 'Cayo'),
    ('17 Hibiscus St', 'Cayo'),
    ('49 Unity Blvd', 'Cayo'),
    ('13 Toucan Ave', 'Cayo'),
    ('11 Power Ln', 'Cayo'),
    ('15 Trinity Blvd', 'Cayo'),
    ('19 Constitution Dr', 'Cayo');

INSERT INTO teachers (first_name, last_name, gender, salary, contact_phone, contact_email, address)
VALUES
    ('Kieran', 'Ryan', 'm', 2500.00, '555-2468', 'kryan@gmail.com', 1),
    ('David', 'Garcia', 'm', 2200.00, '555-1357', 'dgarcia@outlook.com', 2),
    ('Vernelle', 'Sylvester', 'f', 2200.00, '555-9630', 'vsylvester@gmail.com', 3),
    ('Amilcar', 'Umana', 'm', 2250.00, '555-7421', 'aumana@gmail.com', 4),
    ('Manuel', 'Medina', 'm', 2300.00, '555-8532', 'mmedina@yahoo.com', 5),
    ('Stephen', 'Sangster', 'm', 2000.00, '555-6974', 'ssangster@protonmail.com', 6),
    ('Josue', 'Ake', 'm', 2100.00, '555-3815', 'jake@icloud.com', 7),
    ('Apolonio', 'Aguilar', 'm', 2400.00, '555-2697', 'aaguilar@hotmail.com', 8),
    ('Steven', 'Lewis', 'm', 2350.00, '555-1548', 'slewis@gmail.com', 9),
    ('Giovanni', 'Pinelo', 'f', 2400.00, '555-9637', 'gpinelo@gmail.com', 10);

INSERT INTO parents (first_name, last_name, gender, profession, contact_phone, contact_email, address)
VALUES
    ('Jorge', 'Vasquez', 'm', 'Electrician', '555-1234', 'gamer123@gmail.com', 11),
    ('Alissa', 'Guerrero', 'f', 'Musician', '555-5678', 'aly$$aGee@gmail.com', 12),
    ('Thomas', 'Flowers', 'm', 'Construction Worker', '555-9012', 'thomasflowers@gmail.com', 13),
    ('Karen', 'Castillo', 'f', 'Secretary', '555-3456', 'karencastle@yahoo.com', 14),
    ('Frank', 'Brown', 'm', 'Accountant', '555-7890', 'bfrank@gmail.com', 15),
    ('Lisa', 'Reyes', 'f', 'Chemist', '555-2345', 'lisareyesbmp@gmail.com', 16),
    ('Josue', 'Garcia', 'm', 'Artist', '555-6789', 'garciabest444@gmail.com', 17),
    ('Janet', 'Garcia', 'f', 'Writer', '555-0123', 'janety@hotmail.com', 17),
    ('Albert', 'Neal', 'm', 'Retail Clerk', '555-4567', 'nealiobert@gmail.com', 18),
    ('Ruth', 'Neal', 'f', 'Consultant', '555-8901', 'ruthusher@gmail.com', 18);

INSERT INTO students (first_name, last_name, date_of_birth, gender, graduated, address, classroom)
VALUES
    ('Miguel', 'Vasquez', '2019-05-15', 'm', '2023-08-01', 11, 1),
    ('Maria', 'Guerrero', '2018-11-20', 'f', '2022-08-01', 12, 2),
    ('Michael', 'Flowers', '2021-03-10', 'm', NULL, 13, 3),
    ('Sandra', 'Castillo', '2020-09-25', 'f', NULL, 14, 4),
    ('David', 'Brown', '2022-07-01', 'm', NULL, 15, 1),
    ('Martha', 'Reyes', '2020-12-12', 'f', NULL, 16, 2),
    ('Daniel', 'Garcia', '2020-02-28', 'm', NULL, 17, 3),
    ('Olivia', 'Neal', '2021-06-18', 'f', NULL, 18, 4),
    ('Matthew', 'Neal', '2021-10-05', 'm', NULL, 18, 1),
    ('Sophia', 'Neal', '2021-08-22', 'f', NULL, 18, 2);

INSERT INTO parent_student (parent_id, student_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 7),
    (9, 8), (9, 9), (9, 10),
    (10, 8), (10, 9), (10, 10);

/* DISPLAY ALL TABLES */

SELECT *
FROM buildings;

SELECT *
FROM classrooms;

SELECT *
FROM districts;

SELECT *
FROM addresses;

SELECT *
FROM teachers;

SELECT *
FROM parents;

SELECT *
FROM students;

SELECT *
FROM parent_student;