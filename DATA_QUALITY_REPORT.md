# Data Quality Report

## Overview

Data profiling was performed on the staged data after ingestion. The objective was to identify genuine data quality issues while distinguishing them from valid business behavior.

All findings below are based on the sampled data used by the analytical marts.

---

## Finding 1 — Products with Missing Attributes

**Affected rows:** 610

**Issue**

Some products are missing descriptive attributes such as weight or dimensions.

**Decision**

Kept the records.

**Reason**

These products are still referenced by valid orders and removing them would reduce analytical completeness.

---

## Finding 2 — Missing Product Category Translations

**Affected rows:** 2 categories

- pc_gamer
- portateis_cozinha_e_preparadores_de_alimentos

**Issue**

Two Portuguese product categories do not exist in the translation table.

**Decision**

Kept the original category names.

**Reason**

Dropping these products would lose valid business transactions.

---

## Finding 3 — Multiple Reviews per Order

**Affected rows:** 547 orders

**Issue**

Some orders contain more than one review.

**Decision**

Kept all reviews.

**Reason**

Investigation showed these are legitimate business records rather than duplicates.

---

## Finding 4 — Duplicate Review IDs

**Affected rows:** 789 review IDs

**Issue**

Some review IDs appear multiple times.

**Decision**

Did not remove duplicate review IDs.

**Reason**

The same review can legitimately be associated with multiple orders. Applying DISTINCT would incorrectly remove valid data.

---

## Finding 5 — Multiple Geolocations per ZIP Code

**Affected rows:** Multiple ZIP codes

**Issue**

Many ZIP codes contain multiple latitude and longitude coordinates.

**Decision**

Kept all records.

**Reason**

A ZIP code can legitimately cover multiple physical locations. This reflects real geographic variation rather than duplicate data.

---

# Summary

| Finding | Decision |
|----------|----------|
| Missing product attributes | Keep |
| Missing category translations | Keep |
| Multiple reviews per order | Keep |
| Duplicate review IDs | Keep |
| Multiple geolocations per ZIP | Keep |

No critical data quality issues affecting referential integrity or primary keys were found after staging.