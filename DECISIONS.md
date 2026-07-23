# Decision Log

This document records the key engineering decisions made during the implementation of the data pipeline. Each decision includes the alternatives considered and the reasoning behind the final approach.

---

## 2026-07-22 10:00

### Decision

Implemented deterministic hash-based sampling using a configurable seed.

### Alternatives Considered

* `ORDER BY RANDOM()`
* `LIMIT N`
* Random sampling using PostgreSQL's `RANDOM()`

### Reason

The assessment requires all reported metrics to be reproducible from the same sample. Hash-based sampling guarantees that the same seed always produces the same set of orders, making every pipeline run deterministic.

---

## 2026-07-22 11:00

### Decision

Stored the sampling seed as an environment variable and injected it into SQL at runtime.

### Alternatives Considered

* Hardcoding the seed inside every SQL file.

### Reason

Keeping the seed in configuration ensures it appears only once, makes the SQL reusable, and satisfies the assessment requirement.

---

## 2026-07-22 13:00

### Decision

Designed `fct_orders` as an order-level fact table (one row per order).

### Alternatives Considered

* Building the fact table at the order-item level.

### Reason

Most business metrics such as GMV, delivery performance, and order counts are naturally measured per order. An order-level fact table also avoids accidental double counting during reporting.

---

## 2026-07-22 15:00

### Decision

Calculated GMV from aggregated order values instead of joining raw transactional tables during analysis.

### Alternatives Considered

* Computing revenue directly from joins between orders, order items, and payments.

### Reason

Orders can contain multiple payment records. Joining raw tables duplicates item rows and inflates revenue. Centralizing revenue in the fact table produces consistent business metrics.

---

## 2026-07-22 16:30

### Decision

Assigned each seller a single primary category based on the category with the highest number of items sold.

### Alternatives Considered

* Highest revenue category.
* Most recent category sold.
* Returning multiple categories per seller.

### Reason

Using the most frequently sold category provides a stable business classification while keeping the seller dimension simple for reporting.

---

## 2026-07-23 09:00

### Decision

Preserved products with missing attributes instead of removing them.

### Alternatives Considered

* Excluding incomplete product records from the pipeline.

### Reason

Although some product attributes are missing, the transactions themselves are valid. Removing those records would understate revenue and sales metrics.

---

## 2026-07-23 10:30

### Decision

Used `COALESCE()` to fall back to the original product category whenever an English translation was unavailable.

### Alternatives Considered

* Excluding products with missing translations.
* Leaving the translated category as NULL.

### Reason

Keeping every product available for analysis was more valuable than losing records because of missing reference data.

---

## 2026-07-23 11:30

### Decision

Measured delivery reliability using **late delivery rate** rather than only counting late deliveries.

### Alternatives Considered

* Reporting only the number of late orders.

### Reason

A percentage provides a fair comparison across categories with very different sales volumes.

---

## 2026-07-23 12:30

### Decision

Defined seller segments using three business measures: lifetime GMV, total orders, and average review score.

### Alternatives Considered

* Segmenting sellers using only GMV.
* Segmenting sellers using only order count.

### Reason

Combining financial performance, sales activity, and customer satisfaction provides a more balanced view of seller health than any single metric alone.

---

## 2026-07-23 14:00

### Decision

Reported data quality issues instead of automatically correcting or removing affected records.

### Alternatives Considered

* Automatically filtering invalid or incomplete records during ingestion.

### Reason

The objective of the assessment was to identify and document data quality issues while preserving the original business data. Reporting the issues keeps the pipeline transparent and allows business users to decide how they should be handled.

## 2026-07-23 16:30

**Decision**

Explicitly treated non-delivered orders and delivered orders with missing delivery dates as not late when building `late_delivery_flag`.

**Considered**

Allowing the flag to remain NULL when the delivery date was missing.

**Reason**

The late-delivery metric is only meaningful for completed deliveries. Explicitly assigning FALSE avoids ambiguous NULL values in downstream reporting and simplifies analytical queries.