/*
Question 2

Delivery Reliability

Objective:
Identify product categories where late deliveries
are most common and measure their impact on
customer review scores.
*/

SELECT

    product_category,

    SUM(total_orders) AS total_orders,

    SUM(late_orders) AS late_orders,

    ROUND(
        SUM(late_orders)::NUMERIC
        /
        NULLIF(SUM(total_orders),0)
        * 100,
        2
    ) AS late_delivery_percentage,

    ROUND(
        AVG(avg_review_score),
        2
    ) AS average_review_score

FROM marts.dim_products

WHERE product_category <> 'Unknown'
GROUP BY product_category

HAVING SUM(total_orders) >= 100

ORDER BY

    late_delivery_percentage DESC,
    total_orders DESC;