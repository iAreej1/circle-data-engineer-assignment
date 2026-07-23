DROP TABLE IF EXISTS marts.dim_sellers;

CREATE TABLE marts.dim_sellers AS

WITH sample_orders AS (

    SELECT *
    FROM staging.stg_orders
    WHERE MOD(
        ABS(HASHTEXT(order_id || '{sample_seed}')),
        100
    ) < 80

),

seller_sales AS (

    SELECT

        oi.seller_id,

        SUM(oi.price)::NUMERIC AS lifetime_gmv,

        MIN(o.order_purchase_timestamp) AS first_sale,

        MAX(o.order_purchase_timestamp) AS last_sale

    FROM staging.stg_order_items oi

    INNER JOIN sample_orders o
        ON oi.order_id = o.order_id

    GROUP BY oi.seller_id

),

seller_reviews AS (

    SELECT

        oi.seller_id,

        AVG(r.review_score)::NUMERIC AS avg_review_score

    FROM staging.stg_order_items oi

    INNER JOIN sample_orders o
        ON oi.order_id = o.order_id

    INNER JOIN staging.stg_order_reviews r
        ON oi.order_id = r.order_id

    GROUP BY oi.seller_id

),

seller_categories AS (

    SELECT

        oi.seller_id,

        COALESCE(
            t.product_category_name_english,
            'Unknown'
        ) AS category_name,

        COUNT(*) AS total_items

    FROM staging.stg_order_items oi

    INNER JOIN sample_orders o
        ON oi.order_id = o.order_id

    INNER JOIN staging.stg_products p
        ON oi.product_id = p.product_id

    LEFT JOIN staging.stg_product_category_translation t
        ON p.product_category_name = t.product_category_name

    GROUP BY
        oi.seller_id,
        category_name

),

ranked_categories AS (

    SELECT

        seller_id,

        category_name,

        ROW_NUMBER() OVER (

            PARTITION BY seller_id
            ORDER BY total_items DESC, category_name

        ) AS rn

    FROM seller_categories

)

SELECT

    s.seller_id,

    ROUND(COALESCE(ss.lifetime_gmv,0),2) AS lifetime_gmv,

    (
        (
            EXTRACT(YEAR FROM AGE(ss.last_sale, ss.first_sale)) * 12
        )
        +
        EXTRACT(MONTH FROM AGE(ss.last_sale, ss.first_sale))
        + 1
    )::INT AS active_months,

    ROUND(COALESCE(sr.avg_review_score,0),2) AS avg_review_score,

    rc.category_name AS primary_category

FROM staging.stg_sellers s

LEFT JOIN seller_sales ss
    ON s.seller_id = ss.seller_id

LEFT JOIN seller_reviews sr
    ON s.seller_id = sr.seller_id

LEFT JOIN ranked_categories rc
    ON s.seller_id = rc.seller_id
    AND rc.rn = 1

WHERE ss.seller_id IS NOT NULL;