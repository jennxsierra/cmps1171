-- [CMPS1171-1] Introduction to Databases Project 2
-- Andres Hung & Jennessa Sierra
-- 2024/03/23

/* QUERIES */

-- 3. For each student, show parents' names, emails, and phones
SELECT
    S.first_name AS student_fname, 
    S.last_name AS student_lname, 
    P.first_name AS parent_fname, 
    P.last_name AS parent_lname, 
    P.contact_email AS parent_email,
    P.contact_phone AS parent_phone
FROM students AS S
INNER JOIN parent_student AS PS
USING (student_id)
INNER JOIN parents AS P
USING (parent_id);

-- 4. For each student, show their building name and classroom name
SELECT 
    S.first_name AS student_fname,
    S.last_name AS student_lname,
    B.name AS building_name,
    C.name AS classroom_name
FROM students AS S
INNER JOIN classrooms AS C
ON S.classroom = C.classroom_id
INNER JOIN buildings AS B
ON C.building = B.building_id;

-- 5. For each parent, show their children's names
SELECT
    P.first_name AS parent_fname,
    P.last_name AS parent_lname,
    S.first_name AS student_fname,
    S.last_name AS student_lname
FROM parents AS P
INNER JOIN parent_student AS PS
USING (parent_id)
INNER JOIN students AS S
USING (student_id);

-- 6. For each teacher, show their email and phone number
SELECT first_name, last_name, contact_email, contact_phone
FROM teachers;

-- 7. Queries for number of students in each classroom
SELECT COUNT(*) AS students_toucan
FROM students
WHERE classroom = 1;

SELECT COUNT(*) AS students_tapir
FROM students
WHERE classroom = 2;

SELECT COUNT(*) AS students_mahogany
FROM students
WHERE classroom = 3;

SELECT COUNT(*) AS students_black_orchid
FROM students
WHERE classroom = 4;