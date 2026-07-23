# Insight Memo

## Circle Data Engineering Assessment

### Executive Summary

This analysis was performed on a reproducible sample of the Olist e-commerce dataset using the pipeline's deterministic sampling approach. Three business questions were investigated: seller health, delivery reliability, and revenue integrity. The results identify opportunities to improve seller performance, strengthen delivery operations, and ensure financial reporting accuracy.

---

# 1. Seller Health

Sellers were segmented into three groups using lifetime GMV, total orders, and average customer review score.

| Segment         | Sellers |    Avg GMV | Avg Orders | Avg Review |
| --------------- | ------: | ---------: | ---------: | ---------: |
| High Performing |       4 | 111,203.66 |     639.50 |       4.24 |
| Growing         |      73 |  38,034.97 |     276.08 |       4.19 |
| Stalling        |   2,887 |   2,661.57 |      19.90 |       3.97 |

### Key Findings

* High-performing sellers represent a very small portion of the seller base but generate significantly higher revenue and maintain strong customer satisfaction.
* Growing sellers demonstrate healthy sales volume and review scores and appear to be good candidates for additional investment and seller support programs.
* Most sellers fall into the Stalling segment, indicating relatively low sales activity and fewer completed orders.

### Recommendation

Focus commercial initiatives on helping Growing sellers become High Performing while introducing targeted support or retention programs for Stalling sellers.

---

# 2. Delivery Reliability

Delivery reliability was analyzed by product category using the percentage of late deliveries and average customer review score.

Categories with the highest late delivery rates included:

| Category                    | Late Delivery % | Avg Review |
| --------------------------- | --------------: | ---------: |
| Audio                       |          13.48% |       3.75 |
| Home Comfort                |          11.49% |       3.85 |
| Christmas Supplies          |          11.32% |       4.18 |
| Construction Tools (Lights) |          10.26% |       3.87 |
| Electronics                 |           9.88% |       4.04 |

### Key Findings

* Several product categories experience noticeably higher late-delivery rates than the overall portfolio.
* Categories with higher delivery delays generally also receive lower customer review scores, suggesting delivery performance contributes to customer satisfaction.
* High-volume categories such as Electronics, Health & Beauty, Bed & Bath, and Telephony combine large order volumes with meaningful late-delivery percentages, making them priority improvement areas.

### Recommendation

Prioritize operational improvements in categories with both high sales volume and elevated late-delivery rates. Even modest improvements in these categories could positively impact customer satisfaction at scale.

---

# 3. Revenue Integrity

Delivered Gross Merchandise Value (GMV) for 2017 was calculated using the order-level fact table.

| Metric                |        Value |
| --------------------- | -----------: |
| Delivered Orders      |       34,868 |
| Correct Delivered GMV | 4,798,827.08 |
| Naive GMV             | 5,044,044.76 |
| Difference            |   245,217.68 |
| Overstatement         |        5.11% |

### Why the Naive Join is Incorrect

A direct join between **orders**, **order_items**, and **order_payments** creates duplicate rows whenever an order has multiple payment records.

The analysis identified **2,961 orders with multiple payments**. Because every payment record is joined to every order item for the same order, item prices are counted multiple times, resulting in an inflated GMV calculation.

Using the order-level fact table avoids this duplication and provides a single, reliable revenue value for each order.

### Recommendation

Business reporting should use curated analytical models rather than calculating revenue directly from raw transactional tables. Centralizing revenue calculations within the fact table ensures consistency across dashboards and prevents reporting errors caused by join multiplication.

---

# Conclusion

The pipeline successfully transforms raw transactional data into analytics-ready fact and dimension tables suitable for business reporting.

The analysis identified three key opportunities:

* Expand and support high-potential sellers.
* Improve delivery performance in high-impact product categories.
* Standardize revenue reporting using curated analytical models to eliminate double-counting and ensure financial accuracy.
