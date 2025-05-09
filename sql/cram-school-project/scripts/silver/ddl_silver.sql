/*
=====================================================
DDL Script: Create Silver Tables
=====================================================
Script Purpose:
  This script creates tables in the 'silver' schema, 
  dropping tables if they already exist.
=====================================================
*/

CREATE SCHEMA IF NOT EXISTS silver;


-- Drop and create students table
DROP TABLE IF EXISTS silver.students;
CREATE TABLE silver.students (
    student_id         INT PRIMARY KEY,
    first_name         VARCHAR(50),
    last_name          VARCHAR(50),
    birth_date         DATE,
    email              VARCHAR(100),
    phone_number       VARCHAR(20),
    registration_date  DATE,
    gender             VARCHAR(10),
    education_level    VARCHAR(50),
    status             VARCHAR(20),
    full_name          VARCHAR(100),
    age                INT
);

-- Drop and create teachers table
DROP TABLE IF EXISTS silver.teachers;
CREATE TABLE silver.teachers (
    teacher_id         INT PRIMARY KEY,
    first_name         VARCHAR(50),
    last_name          VARCHAR(50),
    email              VARCHAR(100),
    specialty          VARCHAR(100),
    hire_date          DATE,
    degree             VARCHAR(50),
    years_experience   INT,
    status             VARCHAR(20),
    full_name          VARCHAR(100)
);

-- Drop and create courses table
DROP TABLE IF EXISTS silver.courses;
CREATE TABLE silver.courses (
    course_id     INT PRIMARY KEY,
    course_name   VARCHAR(100),
    subject       VARCHAR(50),
    teacher_id    INT,
    start_date    DATE,
    end_date      DATE,
    level         VARCHAR(50),
    status        VARCHAR(20),
    price         DECIMAL(10,2),
    duration_days INT,
    FOREIGN KEY (teacher_id) REFERENCES silver.teachers(teacher_id)
);

-- Drop and create payments table
DROP TABLE IF EXISTS silver.payments;
CREATE TABLE silver.payments (
    payment_id     INT PRIMARY KEY,
    student_id     INT,
    amount         DECIMAL(10,2),
    payment_date   DATE,
    payment_method VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES silver.students(student_id)
);

-- Drop and create enrollments table
DROP TABLE IF EXISTS silver.enrollments;
CREATE TABLE silver.enrollments (
    enrollment_id      INT PRIMARY KEY,
    student_id         INT,
    course_id          INT,
    enrolled_on        DATE,
    completion_status  VARCHAR(20),
    payment_id         INT UNIQUE,
    enrollment_year    INT,
    FOREIGN KEY (student_id) REFERENCES silver.students(student_id),
    FOREIGN KEY (course_id) REFERENCES silver.courses(course_id),
    FOREIGN KEY (payment_id) REFERENCES silver.payments(payment_id)
);

-- Drop and create assessments table
DROP TABLE IF EXISTS silver.assessments;
CREATE TABLE silver.assessments (
    assessment_id     INT PRIMARY KEY,
    course_id         INT,
    assessment_name   VARCHAR(50),
    assessment_date   DATE,
    assessment_year   INT,
    FOREIGN KEY (course_id) REFERENCES silver.courses(course_id)
);

-- Drop and create grades table
DROP TABLE IF EXISTS silver.grades;
CREATE TABLE silver.grades (
    grade_id       INT PRIMARY KEY,
    student_id     INT,
    assessment_id  INT,
    score          DECIMAL(5,2),
    passed         BOOLEAN,
    grade_category VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES silver.students(student_id),
    FOREIGN KEY (assessment_id) REFERENCES silver.assessments(assessment_id)
);
