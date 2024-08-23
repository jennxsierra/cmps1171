DROP TABLE IF EXISTS hr_employee;
CREATE TABLE hr_employee (
	emp_id int NOT NULL,
	annual_salary numeric NOT NULL,
	hourly_rate numeric GENERATED ALWAYS AS (annual_salary / 2080) STORED
);

BEGIN TRANSACTION;
	
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES 
	(3, 70000),
	(4, 70000),
	(5, 70000),
	(6, 70000),
	(7, 70000),
	(8, 70000);
	
	SELECT * FROM hr_employee;
	
	--COMMIT;
	--ROLLBACK;
	
-- Savepoints:

BEGIN TRANSACTION;
	
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES (1, 40000);
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES (2, 50000);
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES (3, 65000);
	SAVEPOINT emp_3;
	
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES (4, 70000);
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES (5, 85000);
	UPDATE hr_employee SET annual_salary = 41000 WHERE emp_id = 2;
	SAVEPOINT emp_5;
	
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES (6, 90000);
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES (7, 95000);
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES (8, 96000);
	DELETE FROM hr_employee WHERE emp_id = 2;
	SAVEPOINT emp_8;
	
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES (9, 97000);
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES (10, 97500);
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES (11, 97700);
	INSERT INTO hr_employee(emp_id, annual_salary)
	VALUES (12, 97800);
	
	ROLLBACK TO SAVEPOINT emp_3;
	RELEASE SAVEPOINT emp_8;
	
	SELECT * FROM hr_employee;
	
	--COMMIT;
	--ROLLBACK;
	
-- Show all active/abandon processes
SELECT STATE, datname, pid, *
FROM pg_stat_activity;

-- Display pid of current window
SELECT pg_backend_pid();

-- Kill pid
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'week8'		-- Name of database catalog
AND pid <> pg_backend_pid() -- Do not kill my own connection
AND STATE = 'idle'			-- The value of state column is idle
AND pid = 7199;				-- Use the pid column value