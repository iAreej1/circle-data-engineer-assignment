DROP TABLE IF EXISTS marts.dim_products;

CREATE TABLE marts.dim_products AS

SELECT

    oi.product_id,

    COALESCE(
        pct.product_category_name_english,
        p.product_category_name
    ) AS product_category,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    COUNT(*) AS total_quantity_sold,

    ROUND(SUM(oi.price)::NUMERIC, 2) AS total_revenue,

    SUM(
        CASE
            WHEN fo.late_delivery_flag = TRUE THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(AVG(orv.review_score)::NUMERIC, 2) AS avg_review_score

FROM staging.stg_order_items oi

INNER JOIN marts.fct_orders fo
    ON oi.order_id = fo.order_id

LEFT JOIN staging.stg_products p
    ON oi.product_id = p.product_id

LEFT JOIN staging.stg_product_category_translation pct
    ON p.product_category_name = pct.product_category_name

LEFT JOIN staging.stg_order_reviews orv
    ON oi.order_id = orv.order_id

GROUP BY

    oi.product_id,

    COALESCE(
        pct.product_category_name_english,
        p.product_category_name
    );