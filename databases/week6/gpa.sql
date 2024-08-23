-- Demonstrate subqueries
DROP TABLE IF EXISTS students CASCADE;
CREATE TABLE students (
    id serial PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    gender text NOT NULL CHECK (gender IN ('male', 'female')) -- constraint
);

INSERT INTO students(first_name, last_name, gender)
VALUES
('Joe', 'Smith', 'male'),
('Jane', 'Sosa', 'female'),
('Jill', 'Sanchez', 'female');

DROP TABLE IF EXISTS grade;
CREATE TABLE grade (
    id serial PRIMARY KEY,
    student_id integer REFERENCES students(id),
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

-- Find students who have a gpa greater than the average gpa
SELECT COUNT(gpa) 
FROM (
    SELECT S.first_name, S.last_name, G.gpa
    FROM students AS S
    INNER JOIN grade AS G
    ON S.id = G.student_id
    WHERE G.gpa > (
        SELECT AVG(gpa) 
        FROM grade
    )
) AS subquery;