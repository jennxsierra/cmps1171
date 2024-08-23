-- A demonstration table
DROP TABLE IF EXISTS lecturer CASCADE;
CREATE TABLE lecturer (
    id serial PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    gender text NOT NULL
);

-- A demonstration table
DROP TABLE IF EXISTS course;
CREATE TABLE course (
    id serial PRIMARY KEY,
    name text NOT NULL,
    lecturer_id integer REFERENCES lecturer(id) ON DELETE CASCADE
);

INSERT INTO lecturer (first_name, last_name, gender)
VALUES
('Jane', 'Smith', 'female'),
('Jill', 'Sosa', 'female'),
('Josh', 'Sullivan', 'male'),
('Joseph', 'Suggs', 'male');

INSERT INTO course (name, lecturer_id)
VALUES
('Introduction to Databases', 1),
('Principles of Progamming 1', 1),
('Principles of Progamming 2', 1),
('Web Development', 2),
('Principles of Progamming 1', 2),
('Principles of Progamming 2', 2),
('Introduction to Databases', 3),
('Principles of Progamming 1', 3),
('Algorithms', 4),
('Fundamentals of Computing', 1),
('Fundamentals of Computing', 2),
('Fundamentals of Computing', 3),
('Fundamentals of Computing', 4);

-- Lecturers and their courses
SELECT L.first_name, L.last_name, C.name 
FROM lecturer AS L 
INNER JOIN course AS C  
ON L.id = C.lecturer_id
ORDER BY C.name;

SELECT L.first_name, L.last_name, C.name 
FROM lecturer AS L 
INNER JOIN course AS C  
ON L.id = C.lecturer_id;

-- Lecturers who teach Introduction to Databases
SELECT L.first_name, L.last_name, C.name 
FROM lecturer AS L 
INNER JOIN course AS C  
ON L.id = C.lecturer_id
WHERE C.name = 'Introduction to Databases';


-- Lecturers who teach Introduction to Databases and Fundamentals of Computing
SELECT L.first_name, L.last_name
FROM lecturer AS L 
INNER JOIN course AS C  
ON L.id = C.lecturer_id
WHERE C.name = 'Introduction to Databases'
AND C.name = 'Fundamentals of Computing';


SELECT L.first_name, L.last_name, C1.name, C2.name
FROM lecturer AS L 
INNER JOIN course AS C1  
ON L.id = C1.lecturer_id
INNER JOIN course AS C2
ON L.id = C2.lecturer_id
WHERE C1.name = 'Introduction to Databases'
AND C2.name = 'Fundamentals of Computing';