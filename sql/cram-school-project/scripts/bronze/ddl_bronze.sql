/*
=====================================================
DDL Script: Create Bronze Tables
=====================================================
Script Purpose:
  This script creates tables in the 'bronze' schema, 
  dropping tables if they already exist.
=====================================================
*/


-- Drop and create students table
DROP TABLE IF EXISTS bronze.students;
CREATE TABLE bronze.students (
    student_id         INT PRIMARY KEY,
    first_name         VARCHAR(50),
    last_name          VARCHAR(50),
    birth_date         DATE,
    email              VARCHAR(100),
    phone_number       VARCHAR(20),
    registration_date  DATE,
    gender             VARCHAR(10),
    education_level    VARCHAR(50),
    status             VARCHAR(20)
);

-- Drop and create teachers table
DROP TABLE IF EXISTS bronze.teachers;
CREATE TABLE bronze.teachers (
    teacher_id         INT PRIMARY KEY,
    first_name         VARCHAR(50),
    last_name          VARCHAR(50),
    email              VARCHAR(100),
    specialty          VARCHAR(100),
    hire_date          DATE,
    degree             VARCHAR(50),
    years_experience   INT,
    status             VARCHAR(20)
);

-- Drop and create courses table
DROP TABLE IF EXISTS bronze.courses;
CREATE TABLE bronze.courses (
    course_id     INT PRIMARY KEY,
    course_name   VARCHAR(100),
    subject       VARCHAR(50),
    teacher_id    INT,
    start_date    DATE,
    end_date      DATE,
    level         VARCHAR(50),
    status        VARCHAR(20),
    price         DECIMAL(10,2),
    FOREIGN KEY (teacher_id) REFERENCES bronze.teachers(teacher_id)
);

-- Drop and create payments table
DROP TABLE IF EXISTS bronze.payments;
CREATE TABLE bronze.payments (
    payment_id     INT PRIMARY KEY,
    student_id     INT,
    amount         DECIMAL(10,2),
    payment_date   DATE,
    payment_method VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES bronze.students(student_id)
);

-- Drop and create enrollments table
DROP TABLE IF EXISTS bronze.enrollments;
CREATE TABLE bronze.enrollments (
    enrollment_id      INT PRIMARY KEY,
    student_id         INT,
    course_id          INT,
    enrolled_on        DATE,
    completion_status  VARCHAR(20),
    payment_id         INT UNIQUE,
    FOREIGN KEY (student_id) REFERENCES bronze.students(student_id),
    FOREIGN KEY (course_id) REFERENCES bronze.courses(course_id),
    FOREIGN KEY (payment_id) REFERENCES bronze.payments(payment_id)
);

-- Drop and create assessments table
DROP TABLE IF EXISTS bronze.assessments;
CREATE TABLE bronze.assessments (
    assessment_id     INT PRIMARY KEY,
    course_id         INT,
    assessment_name   VARCHAR(50),
    assessment_date   DATE,
    FOREIGN KEY (course_id) REFERENCES bronze.courses(course_id)
);

-- Drop and create grades table
DROP TABLE IF EXISTS bronze.grades;
CREATE TABLE bronze.grades (
    grade_id       INT PRIMARY KEY,
    student_id     INT,
    assessment_id  INT,
    score          DECIMAL(5,2),
    passed         BOOLEAN,
    FOREIGN KEY (student_id) REFERENCES bronze.students(student_id),
    FOREIGN KEY (assessment_id) REFERENCES bronze.assessments(assessment_id)
);
