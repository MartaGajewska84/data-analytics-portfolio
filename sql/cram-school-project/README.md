# 🎓 Cram School Data Warehouse (Star Schema)

This project implements a **star schema-based data warehouse** for a cram school. It organizes raw data into Bronze, Silver, and Gold layers and provides a foundation for analytics, reporting, and business intelligence — including key performance indicators (KPIs) on student performance, engagement, and revenue.

---

## 🏗️ Project Structure

The project consists of the following SQL files, organized by their role in the data pipeline:

- `init_database.sql` – Creates database schemas and initializes the environment.
- `ddl_bronze.sql` – Defines raw staging tables (Bronze layer).
- `ddl_silver.sql` – Defines cleaned and transformed tables (Silver layer).
- `ddl_gold.sql` – Defines dimension and fact views in star schema format (Gold layer).
- `load_bronze_layer.sql` – Loads raw data into Bronze tables.
- `load_silver_layer.sql` – Performs transformations from Bronze to Silver.
- `kpi_views.sql` – Contains business KPI views for analytics and dashboards.

---

## ⭐ Data Warehouse Architecture

### 🔹 Bronze Layer
- Raw ingestion from CSV files or external sources.
- Minimal transformation — 1:1 with source.

### 🔸 Silver Layer
- Cleaned and standardized data (type casting, deduplication, enrichment).
- Joins across multiple bronze tables.

### 🥇 Gold Layer
- Star schema with:
  - `dim_students`
  - `dim_teachers`
  - `dim_courses`
  - `dim_assessments`
  - `fact_enrollments`
  - `fact_grades`
  - `fact_payments`
- Additional `kpi_` views to support business reporting and dashboards.

---

## 📊 KPIs Available

- **Average Courses per Student**
- **Completion Rate (overall and by course)**
- **Grade Performance (score, pass rate by course)**
- **Revenue (total and by course)**

## ✅ Requirements

To run this project, you need:

- **PostgreSQL** version 13 or higher  
- The `psql` **command-line client**   
- *(Optional)* A PostgreSQL GUI (e.g., **pgAdmin**) for easier inspection  
