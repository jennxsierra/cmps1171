-- Andres Hung & Jennessa Sierra

-- 1
-- GROUP BY and AGGREGATE function
-- show the number of employees who work or participate in each department

SELECT department, COUNT(department)
FROM employee_department
GROUP BY department;

-- 2
-- GROUP BY with HAVING clause
-- show the departments who have more than 2 employees working in it

SELECT department, COUNT(department)
FROM employee_department
GROUP BY department
HAVING COUNT(department) > 2;

-- 3
-- JOIN
-- show the employee details and their department details

SELECT E.first_name, E.last_name, D.department
FROM employee E
INNER JOIN employee_department ED
ON E.employee_number = ED.employee
INNER JOIN department D
ON ED.department = D.department_code;

-- 4
-- JOIN, GROUP BY, HAVING
-- find employees that have more than one email address

SELECT E.employee_number, E.first_name, E.last_name
FROM employee E
JOIN email EM ON E.employee_number = EM.employee
GROUP BY E.employee_number, E.first_name, E.last_name
HAVING COUNT(DISTINCT EM.email) > 1;