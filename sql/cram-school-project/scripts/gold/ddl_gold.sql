/*
    ========================================================================
    DDL script: Create Gold Views
    ========================================================================
    This SQL script defines the GOLD layer views in a dimensional star schema
    for an educational domain. The schema is built on top of SILVER (cleaned)
    data sources and organizes data into:

    - Dimension tables (dim_*) to describe key entities: students, teachers,
      courses, and assessments.
    - Fact tables (fact_*) to record measurable events such as enrollments,
      grades, and payments.

    Each dimension includes surrogate keys and each fact view joins to 
    dimensions to enable analytical queries.

*/

-- ============================================================================
-- DIMENSION: Students
-- Description: Contains descriptive attributes for each student along with
-- a surrogate key (student_key) for dimensional joins.
-- Source: silver.students
-- ============================================================================
CREATE OR REPLACE VIEW gold.dim_students AS
SELECT
    ROW_NUMBER() OVER (ORDER BY student_id) AS student_key,  -- surrogate key
    s.student_id,
    s.full_name,
    s.first_name,
    s.last_name,
    s.gender,
    s.age,
    s.education_level,
    s.status,
    s.registration_date
FROM silver.students s;

-- ============================================================================
-- DIMENSION: Teachers
-- Description: Stores teacher information and professional attributes with a
-- surrogate key (teacher_key) for use in the courses dimension.
-- Source: silver.teachers
-- ============================================================================
CREATE OR REPLACE VIEW gold.dim_teachers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY t.teacher_id) AS teacher_key,  -- surrogate key
    t.teacher_id,
    t.full_name,
    t.first_name,
    t.last_name,
    t.specialty,
    t.degree,
    t.years_experience,
    t.status,
    t.hire_date
FROM silver.teachers t;

-- ============================================================================
-- DIMENSION: Courses
-- Description: Contains course metadata including level, subject, price, and
-- associated teacher (via teacher_key). Used for analyzing course performance.
-- Source: silver.courses + gold.dim_teachers
-- ============================================================================
CREATE OR REPLACE VIEW gold.dim_courses AS
SELECT
    ROW_NUMBER() OVER (ORDER BY c.course_id) AS course_key,  -- surrogate key
    c.course_id,
    c.course_name,
    c.subject,
    c.level,
    c.status,
    c.start_date,
    c.end_date,
    c.duration_days,
    c.price,
    dt.teacher_key,
    dt.full_name AS teacher_name
FROM silver.courses c
JOIN gold.dim_teachers dt
    ON c.teacher_id = dt.teacher_id;

-- ============================================================================
-- DIMENSION: Assessments
-- Description: Stores assessment metadata including name, date, and related course.
-- Used to enrich fact_grades with assessment-level context.
-- Source: silver.assessments + gold.dim_courses
-- ============================================================================
CREATE OR REPLACE VIEW gold.dim_assessments AS
SELECT
    ROW_NUMBER() OVER (ORDER BY a.assessment_id) AS assessment_key,  -- surrogate key
    a.assessment_id,
    INITCAP(TRIM(a.assessment_name)) AS assessment_name,
    a.assessment_date,
    a.assessment_year,
    dc.course_key,
    dc.course_name
FROM silver.assessments a
JOIN gold.dim_courses dc
    ON a.course_id = dc.course_id;

-- ============================================================================
-- FACT: Enrollments
-- Description: Records enrollment events by students in courses, including
-- enrollment date, year, status, and payment linkage.
-- Joins to: dim_students, dim_courses
-- Source: silver.enrollments
-- ============================================================================
CREATE OR REPLACE VIEW gold.fact_enrollments AS
SELECT
    e.enrollment_id,
    ds.student_key,
    dc.course_key,
    e.enrolled_on,
    e.enrollment_year,
    e.completion_status,
    e.payment_id
FROM silver.enrollments e
JOIN gold.dim_students ds ON e.student_id = ds.student_id
JOIN gold.dim_courses dc ON e.course_id = dc.course_id;

-- ============================================================================
-- FACT: Grades
-- Description: Captures student performance on assessments, including scores
-- and pass/fail status. Linked to courses and students.
-- Joins to: dim_students, dim_courses, dim_assessments (indirectly)
-- Source: silver.grades + silver.assessments
-- ============================================================================
CREATE OR REPLACE VIEW gold.fact_grades AS
SELECT
    ROW_NUMBER() OVER (ORDER BY g.grade_id) AS grade_fact_id,  -- surrogate key
    g.grade_id,
    ds.student_key,
    dc.course_key,
    g.assessment_id,
    g.score,
    g.passed,
    g.grade_category
FROM silver.grades g
JOIN silver.assessments a
    ON g.assessment_id = a.assessment_id
JOIN gold.dim_courses dc
    ON a.course_id = dc.course_id
JOIN gold.dim_students ds
    ON g.student_id = ds.student_id;

-- ============================================================================
-- FACT: Payments
-- Description: Records payment transactions made by students, including amount,
-- method, and date. Linked to students for revenue analysis.
-- Joins to: dim_students
-- Source: silver.payments
-- ============================================================================
CREATE OR REPLACE VIEW gold.fact_payments AS
SELECT
    ROW_NUMBER() OVER (ORDER BY p.payment_id) AS payment_fact_id,  -- surrogate key
	p.payment_id,
    ds.student_key,
    p.amount,
    p.payment_date,
    p.payment_method
FROM silver.payments p
JOIN gold.dim_students ds
    ON p.student_id = ds.student_id;






