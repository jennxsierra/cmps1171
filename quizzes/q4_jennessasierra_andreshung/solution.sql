-- 1. CREATE DATABASE AND TABLES
DROP DATABASE IF EXISTS quiz4;
CREATE DATABASE quiz4;

DROP ROLE IF EXISTS quiz4;
CREATE ROLE quiz4 WITH LOGIN PASSWORD '#quiz4#';

-- GRANT ALL PRIVILEGES ON PUBLIC SCHEMA TO quiz4;

DROP TABLE IF EXISTS book;
CREATE TABLE book (
    id serial PRIMARY KEY,
    title text NOT NULL,
    isbn text NOT NULL,    
    pages integer NOT NULL,  -- how many pages in the book
    pub_date date NOT NULL DEFAULT NOW()  -- automatically inserted by PostgreSQL
);

DROP TABLE IF EXISTS author;
CREATE TABLE author (
    id serial PRIMARY KEY,
    fname text NOT NULL,
    lname text NOT NULL
);

-- Add your insert statements here
INSERT INTO book (title, isbn, pages)
VALUES
    ('Harry Potter and the Sorcerer''s Stone', '9780590353427', 309),
    ('The Shining', '9780385121675', 447),
    ('1984', '9780451524935', 328),
    ('The Hobbit', '9780345534835', 310),
    ('To Kill a Mockingbird', '9780060935467', 323);

INSERT INTO author (fname, lname)
VALUES
    ('J.K.', 'Rowling'),
    ('Stephen', 'King'),
    ('George', 'Orwell'),
    ('J.R.R.', 'Tolkien'),
    ('Harper', 'Lee');

SELECT *
FROM book;

SELECT *
FROM author;


-- 2. STORED PROCEDURE TO INSERT BOOK
CREATE OR REPLACE PROCEDURE insert_book(p_title text, p_isbn text, p_pages integer)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_title IS NULL OR p_title = '' THEN
        RAISE EXCEPTION 'Title cannot be empty';
    END IF;
    IF p_isbn IS NULL OR p_isbn = '' THEN
        RAISE EXCEPTION 'ISBN cannot be empty';
    END IF;
    IF p_pages IS NULL OR p_pages <= 0 THEN
        RAISE EXCEPTION 'Pages must be greater than 0';
    END IF;

    INSERT INTO book (title, isbn, pages) VALUES (p_title, p_isbn, p_pages);
END;
$$;

-- Call statement for stored procedure
CALL insert_book('New Book', '1234567890', 200);


-- 3. FUNCTION TO INSERT AUTHOR AND RETURN ID
CREATE OR REPLACE FUNCTION insert_author(p_fname text, p_lname text)
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    r_author_id integer;
BEGIN
    IF p_fname IS NULL OR p_fname = '' THEN
        RAISE EXCEPTION 'First name cannot be empty';
    END IF;
    IF p_lname IS NULL OR p_lname = '' THEN
        RAISE EXCEPTION 'Last name cannot be empty';
    END IF;

    INSERT INTO author (fname, lname) VALUES (p_fname, p_lname)
    RETURNING id INTO r_author_id;

    RETURN r_author_id;
END;
$$;

SELECT  *
FROM insert_author('John', 'Doe');

SELECT *
FROM author;


-- 4. TABLE TO LOG AUTHOR CHANGES
CREATE TABLE author_logs (
    id_old integer,
    fname_old text,
    lname_old text
);

SELECT *
FROM author_logs;


-- 5. TRIGGER TO LOG AUTHOR CHANGES
-- Trigger function
CREATE OR REPLACE FUNCTION author_logs_trg_func()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO author_logs (id_old, fname_old, lname_old)
    VALUES (OLD.id, OLD.fname, OLD.lname);

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        RETURN NEW;
    END IF;
END;
$$;

DROP TRIGGER IF EXISTS author_logs_trg
ON author;

-- Trigger
CREATE TRIGGER author_logs_trg 
BEFORE DELETE OR UPDATE 
ON author 
FOR EACH ROW 
EXECUTE PROCEDURE author_logs_trg_func();

-- Test trigger
UPDATE author SET fname = 'Jane' WHERE fname = 'John';

SELECT *
FROM author;

SELECT *
FROM author_logs;

DELETE FROM author WHERE fname = 'Jane';

SELECT *
FROM author;

SELECT *
FROM author_logs;