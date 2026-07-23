# Circle Data Engineering Assessment

## Overview

This project implements an end-to-end data engineering pipeline for the Olist e-commerce dataset as part of the Circle Data Engineering Assessment.

The pipeline follows a modern layered data warehouse architecture:

**Raw → Staging → Data Quality → Marts**

The solution is fully containerized using Docker and PostgreSQL. It ingests CSV files, performs data validation, applies transformations, executes automated data quality checks, and builds analytical fact and dimension tables for reporting.

---

# Architecture

```
CSV Files
    │
    ▼
+-------------+
| Raw Layer   |
+-------------+
       │
       ▼
+----------------+
| Staging Layer  |
+----------------+
       │
       ▼
+-----------------------+
| Data Quality Checks   |
+-----------------------+
       │
       ▼
+-------------+
| Mart Layer  |
+-------------+
```

---

# Project Structure

```
.
├── data/
│   └── *.csv
│
├── pipeline/
│   ├── database.py
│   ├── ingest.py
│   ├── main.py
│   ├── sql_runner.py
│   └── quality/
│       ├── __init__.py
│       └── tests.py
│
├── sql/
│   ├── raw/
│   ├── staging/
│   ├── quality/
│   └── marts/
│
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
├── README.md
├── DATA_QUALITY_REPORT.md
├── DECISIONS.md
└── INSIGHT_MEMO.md
```

---

# Pipeline Layers

## 1. Raw Layer

The raw layer loads the original CSV files into PostgreSQL without applying business transformations.

Purpose:

- Preserve source data
- Maintain reproducibility
- Enable reprocessing

Loaded tables include:

- customers
- geolocation
- orders
- order_items
- order_payments
- order_reviews
- products
- sellers
- product_category_name_translation

---

## 2. Staging Layer

The staging layer standardizes the raw data before it is used for analytics.

Typical transformations include:

- Removing unnecessary whitespace
- Standardizing data types
- Basic data cleansing
- Preparing consistent schemas

One staging table is created for every raw table.

---

## 3. Data Quality Framework

An automated quality framework executes SQL-based validation tests after the staging layer is built.

The framework:

- Automatically discovers all SQL tests in `sql/quality`
- Executes each test
- Reports PASS, FAIL, or WARNING
- Stops the pipeline if a critical test fails

Current quality checks include:

- Orders primary key validation
- Order Items foreign key validation
- Negative payment detection
- Missing product attributes (warning)
- Missing product category translations (warning)

---

## 4. Mart Layer

The mart layer builds analytics-ready tables.

Current marts include:

### Fact Tables

- `marts.fct_orders`

Contains one record per sampled order with:

- Order information
- Customer
- Payment amount
- Freight value
- Item count
- Delivery duration
- Late delivery flag

### Dimension Tables

- `marts.dim_sellers`

Contains seller-level business metrics including:

- Lifetime GMV
- Number of orders
- Average review score
- Best-selling product category

---

# Sampling Strategy

To ensure reproducible results while reducing processing volume, analytical marts are built using a deterministic sample.

The sampling logic uses a configurable seed supplied through Docker environment variables.

Every reported metric is calculated from this reproducible sample.

---

# Running the Project

## Prerequisites

- Docker Desktop
- Docker Compose

---

## Build and Run

```bash
docker compose up --build
```

The pipeline automatically:

1. Creates database schemas
2. Loads all raw CSV files
3. Builds staging tables
4. Executes data quality tests
5. Builds analytical marts

---

# Technologies

- Python 3
- PostgreSQL
- Docker
- Docker Compose
- Pandas
- SQL

---

# Data Quality

A detailed description of all identified data quality issues can be found in:

```
DATA_QUALITY_REPORT.md
```

---

# Design Decisions

Engineering decisions and trade-offs are documented in:

```
DECISIONS.md
```

---

# Business Insights

The analytical findings generated from the marts are documented in:

```
INSIGHT_MEMO.md
```

---

# Author

Prepared as part of the Circle Data Engineering Assessment.