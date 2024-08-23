-- Part B

-- Question 2
SELECT name, COUNT(name)
FROM course
GROUP BY name
HAVING COUNT(name) = 1;

-- Question 3
SELECT L.first_name, L.last_name, COUNT(C.name) AS number_of_courses
FROM lecturer AS L
INNER JOIN course AS C
ON L.id = C.lecturer_id
GROUP BY L.first_name, L.last_name;

-- Question 4
SELECT L.first_name, L.last_name, C1.name, C2.name, C3.name
FROM lecturer AS L
INNER JOIN course as C1
ON L.id = C1.lecturer_id
INNER JOIN course as C2
ON L.id = C2.lecturer_id
INNER JOIN course as C3
ON L.id = C3.lecturer_id
WHERE C1.name = 'Principles of Progamming 1'
AND C2.name = 'Principles of Progamming 2'
AND C3.name = 'Web Development';