-- A sample table to demonstrate joins
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name text,
    last_name text
);

INSERT INTO
    students (student_id, first_name, last_name)
VALUES
    (20221, 'Joe', 'Smith'),
    (20222, 'Jane', 'Sosa'),
    (20223, 'Jill', 'Sanchez');

DROP TABLE IF EXISTS grades;

CREATE TABLE grades (student_id integer PRIMARY KEY, grade text);

INSERT INTO
    grades
VALUES
    (20221, 'A'),
    (20222, 'B+'),
    (20223, 'D+');