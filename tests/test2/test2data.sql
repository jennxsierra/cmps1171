-- Andres Hung & Jennessa Sierra

-- INSERT DATA

INSERT INTO department (department_code, department)
VALUES
  ('EXEC', 'Executive'),
  ('SALS', 'Sales'),
  ('ADMN', 'Administration'),
  ('FINA', 'Finance'),
  ('HUMR', 'Human Resources'),
  ('RDEV', 'Research and Development');

INSERT INTO employee (employee_number, first_name, last_name)
VALUES
  ('WILSONM', 'Marcia', 'Wilson'),
  ('WILSONH', 'Henry', 'Wilson'),
  ('CROMWELLW', 'William', 'Cromwell'),
  ('BOLEYNA', 'Annita', 'Boleyn'),
  ('RANGERJ', 'John', 'Ranger'),
  ('GATESS', 'Sally', 'Gates');

INSERT INTO employee_department (employee, department)
VALUES
  ('WILSONM', 'EXEC'),
  ('WILSONH', 'FINA'),
  ('CROMWELLW', 'SALS'),
  ('CROMWELLW', 'ADMN'),
  ('BOLEYNA', 'SALS'),
  ('RANGERJ', 'SALS'),
  ('RANGERJ', 'HUMR'),
  ('RANGERJ', 'RDEV'),
  ('GATESS', 'RDEV');

INSERT INTO email (employee, email)
VALUES
  ('WILSONM', 'Marcia.Wilson@MDC.com'),
  ('WILSONH', 'Henry.Wilson@MDC.com'),
  ('CROMWELLW', 'William.Cromwell@MDC.com'),
  ('BOLEYNA', 'Annita.Wilson@MDC.com'),
  ('BOLEYNA', 'Annita.Wilson@yahoo.com'),
  ('BOLEYNA', 'Annita.Wilson@gmail.com'),
  ('RANGERJ', 'John.Ranger@MDC.com'),
  ('GATESS', 'Sally.Gates@MDC.com'),
  ('GATESS', 'Sally.Wilson@protonmail.com');

INSERT INTO phone (employee, phone)
VALUES
  ('WILSONM', '723-543-1201'),
  ('WILSONH', '723-543-1202'),
  ('CROMWELLW', '723-543-1211'),
  ('BOLEYNA', '723-543-1212'),
  ('RANGERJ', '723-543-2000'),
  ('RANGERJ', '501-666-7777'),
  ('GATESS', '723-543-2020');

-- SHOW ALL TABLES

SELECT *
FROM department;

SELECT *
FROM employee;

SELECT *
FROM employee_department;

SELECT *
FROM email;

SELECT *
FROM phone;