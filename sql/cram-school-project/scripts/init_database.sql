-- Create the cram_school database 

CREATE DATABASE cram_school;
   
-- NOTE: After running this, switch to the cram_school database before executing the rest.

-- =====================================================
-- PostgreSQL DDL Script: Create Bronze, Silver and Gold Layer 
-- =====================================================

CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

