-- ================================================================
-- 🧼 Silver Layer Data Transformation Script
--
-- Description:
-- This script transforms and loads cleaned, standardized, and enriched
-- data from the Bronze layer into the Silver layer of the cram_school database.
--
-- Each INSERT includes operations such as:
-- - Trimming whitespace
-- - Standardizing text formats (e.g., lowercase, title case)
-- - Deriving new columns (e.g., full_name, age, year fields, categories)
-- - Ensuring data consistency for future reporting and ML pipelines
-- ================================================================


-- Insert cleaned and enriched student data
INSERT INTO silver.students (
    student_id, first_name, last_name, full_name,
    birth_date, age, email, phone_number,
    registration_date, gender, education_level, status
)
SELECT
    s.student_id,
    TRIM(s.first_name),
    TRIM(s.last_name),
    TRIM(s.first_name) || ' ' || TRIM(s.last_name) AS full_name,
    s.birth_date,
    DATE_PART('year', AGE(s.birth_date))::INT AS age,
    LOWER(TRIM(s.email)),
    TRIM(s.phone_number),
    s.registration_date,
    CASE
        WHEN LOWER(TRIM(s.gender)) = 'm' THEN 'male'
        WHEN LOWER(TRIM(s.gender)) = 'f' THEN 'female'
        ELSE 'other'
    END AS gender,
    TRIM(s.education_level),
    TRIM(s.status)
FROM bronze.students s;


-- Insert cleaned and standardized teacher data
INSERT INTO silver.teachers (
    teacher_id, first_name, last_name, full_name,
    email, specialty, hire_date, degree,
    years_experience, status
)
SELECT
    t.teacher_id,
    TRIM(t.first_name),
    TRIM(t.last_name),
    TRIM(t.first_name) || ' ' || TRIM(t.last_name) AS full_name,
    LOWER(TRIM(t.email)),
    INITCAP(TRIM(t.specialty)), 
    t.hire_date,
    INITCAP(TRIM(t.degree)),
    t.years_experience,
    LOWER(TRIM(t.status))
FROM bronze.teachers t;


-- Insert cleaned course data with derived duration in days
INSERT INTO silver.courses (
    course_id, course_name, subject, teacher_id,
    start_date, end_date, duration_days,
    level, status, price
)
SELECT
    c.course_id,
    INITCAP(TRIM(c.course_name)),
    INITCAP(TRIM(c.subject)),
    c.teacher_id,
    c.start_date,
    c.end_date,
    (c.end_date - c.start_date) AS duration_days, 
    INITCAP(TRIM(c.level)),
    LOWER(TRIM(c.status)),
    c.price
FROM bronze.courses c;


-- Insert cleaned payment data with standardized payment method
INSERT INTO silver.payments (
    payment_id, student_id, amount, payment_date, payment_method
)
SELECT
    p.payment_id,
    p.student_id,
    p.amount,
    p.payment_date,
    INITCAP(TRIM(p.payment_method)) 
FROM bronze.payments p;


-- Insert enrollment data with derived enrollment year
INSERT INTO silver.enrollments (
    enrollment_id, student_id, course_id,
    enrolled_on, enrollment_year,
    completion_status, payment_id
)
SELECT
    e.enrollment_id,
    e.student_id,
    e.course_id,
    e.enrolled_on,
    EXTRACT(YEAR FROM e.enrolled_on)::INT AS enrollment_year,
    LOWER(TRIM(e.completion_status)), 
    e.payment_id
FROM bronze.enrollments e;


-- Insert assessments with standardized names and extracted year
INSERT INTO silver.assessments (
    assessment_id, course_id,
    assessment_name, assessment_date,
    assessment_year
)
SELECT
    a.assessment_id,
    a.course_id,
    INITCAP(TRIM(a.assessment_name)),
    a.assessment_date,
    EXTRACT(YEAR FROM a.assessment_date)::INT AS assessment_year
FROM bronze.assessments a;


-- Insert grade data with derived grade categories
INSERT INTO silver.grades (
    grade_id, student_id, assessment_id,
    score, passed, grade_category
)
SELECT
    g.grade_id,
    g.student_id,
    g.assessment_id,
    g.score,
    g.passed,
    CASE
        WHEN g.score >= 90 THEN 'Excellent'
        WHEN g.score >= 75 THEN 'Good'
        WHEN g.score >= 60 THEN 'Pass'
        ELSE 'Fail'
    END AS grade_category
FROM bronze.grades g;

