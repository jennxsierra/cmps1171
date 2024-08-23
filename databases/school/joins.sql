-- An INNER JOIN returs a row if the row matches in all tables
SELECT
    S.student_id,
    S.first_name,
    S.last_name,
    G.student_id,
    G.grade
FROM
    students AS S
    INNER JOIN grades AS G ON S.student_id = G.student_id;

-- A LEFT OUTER JOIN determines what is in the first table but not the second
SELECT
    S.student_id,
    S.first_name,
    S.last_name,
    G.student_id,
    G.grade
FROM
    students AS S
    LEFT OUTER JOIN grades AS G ON S.student_id = G.student_id
WHERE
    G.student_id IS NULL;

-- A RIGHT OUTER JOIN determines what is in the second table but not the first
SELECT
    S.student_id,
    S.first_name,
    S.last_name,
    G.student_id,
    G.grade
FROM
    students AS S
    RIGHT OUTER JOIN grades AS G ON S.student_id = G.student_id
WHERE
    S.student_id IS NULL;

-- A FULL OUTER JOIN determines what is in either table but not both
SELECT
    S.student_id,
    S.first_name,
    S.last_name,
    G.student_id,
    G.grade
FROM
    students AS S
    FULL OUTER JOIN grades AS G ON S.student_id = G.student_id
WHERE
    S.student_id IS NULL
    OR G.student_id IS NULL;