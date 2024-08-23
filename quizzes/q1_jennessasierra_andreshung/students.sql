DROP TABLE IF EXISTS students;

CREATE TABLE students (
    id serial PRIMARY KEY,
    firstName text NOT NULL,
    surname text NOT NULL,
    dateOfBirth date NOT NULL
);