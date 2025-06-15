# Data Warehouse with Medallion Architecture

This project implements a scalable data warehouse using the **medallion architecture** (Bronze-Silver-Gold layers) in SQL Server, featuring automated data pipelines and star schema analytics.

## Architecture Overview
- **Bronze Layer**: Raw ingestion of source data via stored procedures (landing zone with minimal transformation)
- **Silver Layer**: Cleaned, validated data with business logic applied (stored procedures for transformations)
- **Gold Layer**: Analysis-ready star schema for reporting (views with optimized dimensions/facts)


## Key Features
- **Idempotent Stored Procedures** for reliable incremental loading
- **Star Schema** in Gold layer for BI tool consumption
- **Data Validation** at Silver layer
- **Parameterized Scripts** for environment flexibility

## Setup
1. Execute bronze/silver stored procedures in dependency order
2. Create gold views after silver transformations


