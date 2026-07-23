# Decision Log

This document records important engineering decisions made during the implementation of the pipeline.

---

## 2026-07-22 10:00

**Decision**

Separated the pipeline into Raw, Staging, Data Quality, and Mart layers.

**Considered**

Building everything directly from the raw tables.

**Reason**

A layered architecture improves maintainability, debugging, and mirrors modern data warehouse design.

---

## 2026-07-22 11:00

**Decision**

Used PostgreSQL schemas (`raw`, `staging`, `marts`) instead of storing all tables in one schema.

**Considered**

Using a single database schema.

**Reason**

Logical separation makes the pipeline easier to understand and maintain.

---

## 2026-07-22 13:30

**Decision**

Implemented one staging table for every source table.

**Considered**

Transforming data directly inside the marts.

**Reason**

Keeping transformations in the staging layer simplifies downstream SQL and isolates data cleansing.

---

## 2026-07-22 15:00

**Decision**

Preserved duplicate review records.

**Considered**

Removing duplicates using `DISTINCT`.

**Reason**

Investigation showed that duplicate review IDs and multiple reviews per order represent valid business scenarios.

---

## 2026-07-22 16:15

**Decision**

Kept products with missing attributes.

**Considered**

Filtering incomplete product records.

**Reason**

The missing attributes do not prevent analytical reporting and removing the records would lose valid business transactions.

---

## 2026-07-23 09:00

**Decision**

Implemented an automated SQL-based data quality framework.

**Considered**

Performing manual validation only.

**Reason**

Automated quality checks make the pipeline reproducible and easier to extend.

---

## 2026-07-23 10:00

**Decision**

Separated quality tests into individual SQL files.

**Considered**

Writing all quality checks in one SQL script.

**Reason**

Adding future tests only requires creating another SQL file without changing Python code.

---

## 2026-07-23 11:00

**Decision**

Stored the sampling seed as an environment variable.

**Considered**

Hardcoding the seed inside SQL.

**Reason**

Using configuration keeps the SQL reusable and satisfies the assignment requirement that the seed appears only once.

---

## 2026-07-23 12:00

**Decision**

Built a fact table (`fct_orders`) and a dimension table (`dim_sellers`).

**Considered**

Querying directly from staging tables.

**Reason**

Star-schema style marts simplify analytical queries and improve readability.

---

## 2026-07-23 13:00

**Decision**

Implemented deterministic hash-based sampling.

**Considered**

Using `ORDER BY RANDOM()`.

**Reason**

Hash-based sampling is reproducible and guarantees that the same seed always generates the same sample.