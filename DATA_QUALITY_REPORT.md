# Data Quality Report (Sample Data)

## Overview

Data quality profiling was performed on the staged dataset after ingestion. The objective was to identify genuine data quality issues, distinguish them from valid business scenarios, and document how each issue was handled.

All findings reported below are based on the deterministic sample used throughout the analytical marts.

---

## Finding 1 — Products with Missing Attributes

**Affected Rows:** 610

### Issue

Some products are missing descriptive attributes such as weight or physical dimensions.

### Decision

The records were retained.

### Reason

These products are referenced by valid customer orders. Removing them would reduce analytical completeness and understate business metrics such as revenue and order counts.

---

## Finding 2 — Missing Product Category Translations

**Affected Rows:** 2 product categories

* `pc_gamer`
* `portateis_cozinha_e_preparadores_de_alimentos`

### Issue

Two Portuguese product categories do not have matching English translations.

### Decision

When a translation was unavailable, the original Portuguese category name was retained using `COALESCE()`.

### Reason

This preserves all valid product records while ensuring every product remains available for downstream analysis.

---

## Finding 3 — Multiple Reviews per Order

**Affected Rows:** 547 orders

### Issue

Some orders contain more than one customer review.

### Decision

All review records were preserved.

### Reason

Investigation showed these represent valid business scenarios rather than duplicate data, so removing them would incorrectly discard legitimate customer feedback.

---

## Finding 4 — Duplicate Review IDs

**Affected Rows:** 789 review IDs

### Issue

Some review identifiers appear more than once.

### Decision

Duplicate review IDs were retained.

### Reason

The duplicated identifiers correspond to legitimate business records and are not the result of ingestion errors. Applying `DISTINCT` would incorrectly remove valid data.

---

## Finding 5 — Multiple Geolocation Records per ZIP Code

**Affected Rows:** 17,972 ZIP code prefixes

### Issue

Several ZIP code prefixes are associated with multiple latitude and longitude coordinates.

### Decision

All geolocation records were preserved.

### Reason

A single ZIP code can legitimately cover multiple geographic locations. These records represent real geographic variation rather than duplicate data.

---

# Summary

| Data Quality Finding                      |              Affected Rows | Decision                    |
| ----------------------------------------- | -------------------------: | --------------------------- |
| Products with missing attributes          |                        610 | Retained records            |
| Missing product category translations     |               2 categories | Used original category name |
| Multiple reviews per order                |                 547 orders | Retained all reviews        |
| Duplicate review IDs                      |             789 review IDs | Retained duplicate IDs      |
| Multiple geolocation records per ZIP code | Multiple ZIP code prefixes | Retained all geolocations   |

---

## Conclusion

The identified issues primarily involve missing reference data or valid business scenarios rather than corrupted records. Throughout the pipeline, valid transactional data was preserved while quality issues were documented and made transparent.

No violations of primary keys, foreign keys, or negative payment values were detected during the staged data quality checks.
