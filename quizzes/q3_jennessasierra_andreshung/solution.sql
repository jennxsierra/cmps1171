-- Andres Hung Jennessa Sierra CMPS1171 Quiz 3
-- 2024/02/26

-- DATA FROM library.sql

DROP TABLE IF EXISTS book_author CASCADE; -- drop linking table first

-- #1
DROP TABLE IF EXISTS book;
CREATE TABLE book (
    id serial PRIMARY KEY,
    title text NOT NULL,
    isbn text NOT NULL,    
    page_count integer NOT NULL,  -- how many pages in the book
    publication_date date NOT NULL DEFAULT NOW()  -- automatically inserted by PostgreSQL
);

DROP TABLE IF EXISTS author;
CREATE TABLE author (
    id serial PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL
);

INSERT INTO book (title, isbn, page_count, publication_date)
VALUES ('Introduction to Data Processing', '9780743273565', 180, '1925-04-10'),
       ('How to Program C++', '9780061120084', 281, '1960-07-11'),
       ('CompTIA A+ Certification', '9780451524935', 328, '1949-06-08'),
       ('Hardware Fundamentals', '9780141439518', 432, '1813-01-28'),
       ('The All-In-One Study Guide', '9780316769488', 277, '1951-07-16');

INSERT INTO author (first_name, last_name)
VALUES ('Sally', 'Richards'),
       ('Cheryl', 'Jones'),
       ('George', 'Johnson'),
       ('Jane', 'Anderson'),
       ('Jennifer', 'Smith');


-- #2
linking table
CREATE TABLE book_author (
    id serial PRIMARY KEY,
    book_id integer REFERENCES book (id),
    author_id integer REFERENCES author (id)
);

-- #3
INSERT INTO book_author (book_id, author_id)
VALUES 
    (1, 1),
    (1, 2),
    (2, 3),
    (2, 4),
    (3, 1),
    (3, 4),
    (4, 5),
    (4, 2),
    (5, 1),
    (5, 3);

-- #4
SELECT B.title, A.first_name, A.last_name
FROM book AS B
INNER JOIN book_author AS BA
ON B.id = BA.book_id
INNER JOIN author AS A
ON BA.author_id = A.id;

-- -- DATA FROM gpa.sql
DROP TABLE IF EXISTS student CASCADE;
CREATE TABLE student (
    id serial PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    gender text NOT NULL CHECK (gender IN ('male', 'female'))
);

INSERT INTO student(first_name, last_name, gender)
VALUES 
('Joe', 'Smith', 'male'),
('Jane', 'Sosa', 'female'),
('Jill', 'Sanchez', 'female');

DROP TABLE IF EXISTS grade;
CREATE TABLE grade (
    id serial PRIMARY KEY,
    student_id integer REFERENCES student(id),
    semester integer NOT NULL,
    gpa numeric(3, 2) NOT NULL
);

INSERT INTO grade(student_id, semester, gpa)
VALUES
(1, 1, 3.50),
(1, 2, 2.88),
(2, 1, 3.25),
(2, 2, 3.75),
(3, 1, 3.55),
(3, 2, 3.50);

-- #5
SELECT MAX(temp.count) AS max_gender
FROM (
    SELECT gender AS student_gender, COUNT(gender)
    FROM student
    GROUP BY gender
) AS temp;
