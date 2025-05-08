-- =============================================================
-- 📦 load_bronze_layer.sql
-- 
-- Description:
-- This script loads raw data from CSV files into the Bronze layer
-- of the cram_school database. It populates the following tables:
--   - bronze.students
--   - bronze.teachers
--   - bronze.courses
--   - bronze.payments
--   - bronze.enrollments
--   - bronze.assessments
--   - bronze.grades
--
-- Requirements:
--   - All CSV files must be accessible by the PostgreSQL server
--   - CSV files must contain headers and be encoded in UTF-8
--   - Paths must be updated if file locations change
--
-- Notes:
--   - Assumes the database schema and foreign key constraints 
--     have already been created.
--   - Run this script using a privileged PostgreSQL user (e.g., postgres)
--     from a local psql terminal for best results.
--   - Replace <path_to> with your local or server path
--     example: '/absolute/path/to/your/data/students.csv'
-- =============================================================

-- Load data into bronze.students
COPY bronze.students (
    student_id, first_name, last_name, birth_date,
    email, phone_number, registration_date,
    gender, education_level, status
)
FROM '<path_to>/students.csv'
DELIMITER ','
CSV HEADER;

-- Load data into bronze.teachers
COPY bronze.teachers (
    teacher_id, first_name, last_name, email,
    specialty, hire_date, degree,
    years_experience, status
)
FROM '<path_to>/teachers.csv'
DELIMITER ','
CSV HEADER;

-- Load data into bronze.courses
COPY bronze.courses (
    course_id, course_name, subject, teacher_id,
    start_date, end_date, level, status, price
)
FROM '<path_to>/courses.csv'
DELIMITER ','
CSV HEADER;

-- Load data into bronze.payments
COPY bronze.payments (
    payment_id, student_id, amount, payment_date, payment_method
)
FROM '<path_to>/payments.csv'
DELIMITER ','
CSV HEADER;

-- Load data into bronze.enrollments
COPY bronze.enrollments (
    enrollment_id, student_id, course_id, enrolled_on,
    completion_status, payment_id
)
FROM '<path_to>/enrollments.csv'
DELIMITER ','
CSV HEADER;

-- Load data into bronze.assessments
COPY bronze.assessments (
    assessment_id, course_id, assessment_name, assessment_date
)
FROM '<path_to>/assessments.csv'
DELIMITER ','
CSV HEADER;

-- Load data into bronze.grades
COPY bronze.grades (
    grade_id, student_id, assessment_id, score, passed
)
FROM '<path_to>/grades.csv'
DELIMITER ','
CSV HEADER;



