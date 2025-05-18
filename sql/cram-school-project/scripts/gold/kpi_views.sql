/*
    =============================================================================
    KPI VIEWS – GOLD LAYER
    =============================================================================
    This SQL script defines key performance indicator (KPI) views in the gold layer.
    These views are designed to support business intelligence dashboards, performance 
    tracking, and reporting use cases.

    The KPIs focus on four key areas:
    - Student Engagement (e.g., average number of courses per student)
    - Completion Rates (overall and by course)
    - Grade Performance (average scores and pass rates)
    - Revenue Tracking (total and course-level revenue)

*/

-- ============================================================================
-- KPI: Average Number of Courses per Student
-- Description: Measures student engagement by calculating the average number
-- of enrollments per student across the platform.
-- ============================================================================
CREATE OR REPLACE VIEW gold.kpi_avg_courses_per_student AS
SELECT
    ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT student_key), 2) AS avg_courses_per_student
FROM gold.fact_enrollments;

-- ============================================================================
-- KPI: Overall Completion Rate
-- Description: Calculates the percentage of completed enrollments out of all
-- course enrollments.
-- ============================================================================
CREATE OR REPLACE VIEW gold.kpi_completion_rate AS
SELECT
    ROUND(SUM(CASE WHEN completion_status = 'completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS completion_rate_percent
FROM gold.fact_enrollments;

-- ============================================================================
-- KPI: Completion Rate by Course
-- Description: Provides a breakdown of course completion rates for each course,
-- showing the number of enrollments, completions, and completion percentage.
-- ============================================================================
CREATE OR REPLACE VIEW gold.kpi_completion_rate_by_course AS
SELECT
    dc.course_name,
    COUNT(*) AS total_enrollments,
    SUM(CASE WHEN fe.completion_status = 'completed' THEN 1 ELSE 0 END) AS completions,
    ROUND(SUM(CASE WHEN fe.completion_status = 'completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS completion_rate_percent
FROM gold.fact_enrollments fe
JOIN gold.dim_courses dc ON fe.course_key = dc.course_key
GROUP BY dc.course_name;

-- ============================================================================
-- KPI: Grades by Course
-- Description: Summarizes assessment performance for each course by calculating
-- average score and pass rate based on the grade fact table.
-- ============================================================================
CREATE OR REPLACE VIEW gold.kpi_grades_by_course AS
SELECT
    dc.course_name,
    COUNT(*) AS total_assessments,
    ROUND(AVG(fg.score), 2) AS avg_score,
    ROUND(SUM(CASE WHEN fg.passed THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pass_rate_percent
FROM gold.fact_grades fg
JOIN gold.dim_courses dc ON fg.course_key = dc.course_key
GROUP BY dc.course_name;

-- ============================================================================
-- KPI: Total Revenue and Average Revenue per Student
-- Description: Measures overall revenue generated and the average revenue per
-- unique student who made a payment.
-- ============================================================================
CREATE OR REPLACE VIEW gold.kpi_total_revenue AS
SELECT
    SUM(amount) AS total_revenue,
    COUNT(DISTINCT student_key) AS unique_students,
    ROUND(SUM(amount) * 1.0 / COUNT(DISTINCT student_key), 2) AS avg_revenue_per_student
FROM gold.fact_payments;

-- ============================================================================
-- KPI: Revenue by Course
-- Description: Estimates revenue earned per course by joining payments with
-- enrollments and courses.
-- ============================================================================
CREATE OR REPLACE VIEW gold.kpi_revenue_by_course AS
SELECT
    dc.course_name,
    ROUND(SUM(fp.amount), 2) AS total_revenue
FROM gold.fact_payments fp
JOIN gold.fact_enrollments fe ON fp.student_key = fe.student_key
JOIN gold.dim_courses dc ON fe.course_key = dc.course_key
GROUP BY dc.course_name;

