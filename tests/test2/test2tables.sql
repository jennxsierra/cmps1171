-- Andres Hung & Jennessa Sierra

DROP DATABASE IF EXISTS test2;
CREATE DATABASE test2;

DROP ROLE IF EXISTS test2;
CREATE ROLE test2 WITH LOGIN PASSWORD 'test2';

\c test2 postgres
GRANT ALL PRIVILEGES ON SCHEMA public TO test2;
\c test2 test2

-- TABLES

CREATE TABLE "department" (
  "department_code" varchar PRIMARY KEY,
  "department" varchar NOT NULL
);

CREATE TABLE "employee" (
  "employee_number" varchar PRIMARY KEY,
  "first_name" varchar NOT NULL,
  "last_name" varchar NOT NULL
);

CREATE TABLE "employee_department" (
  "employee" varchar,
  "department" varchar,
  PRIMARY KEY ("employee", "department")
);
ALTER TABLE "employee_department" ADD FOREIGN KEY ("employee") REFERENCES "employee" ("employee_number");
ALTER TABLE "employee_department" ADD FOREIGN KEY ("department") REFERENCES "department" ("department_code");

CREATE TABLE "email" (
  "employee" varchar,
  "email" varchar NOT NULL,
  PRIMARY KEY ("employee", "email")
);
ALTER TABLE "email" ADD FOREIGN KEY ("employee") REFERENCES "employee" ("employee_number");

CREATE TABLE "phone" (
  "employee" varchar,
  "phone" varchar NOT NULL,
  PRIMARY KEY ("employee", "phone")
);
ALTER TABLE "phone" ADD FOREIGN KEY ("employee") REFERENCES "employee" ("employee_number");