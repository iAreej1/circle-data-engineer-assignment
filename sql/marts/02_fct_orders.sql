DROP TABLE IF EXISTS marts.fct_orders;

CREATE TABLE marts.fct_orders AS

WITH sample_orders AS (

    SELECT *
    FROM staging.stg_orders
    WHERE MOD(ABS(HASHTEXT(order_id || '{sample_seed}')),100) < 80

),

item_summary AS (

    SELECT
        oi.order_id,

        COUNT(*) AS item_count,

        SUM(oi.price)::NUMERIC AS order_value,

        SUM(oi.freight_value)::NUMERIC AS freight_value

    FROM staging.stg_order_items oi

    INNER JOIN sample_orders so
        ON oi.order_id = so.order_id

    GROUP BY oi.order_id

),

payment_summary AS (

    SELECT
        op.order_id,

        SUM(op.payment_value)::NUMERIC AS payment_value

    FROM staging.stg_order_payments op

    INNER JOIN sample_orders so
        ON op.order_id = so.order_id

    GROUP BY op.order_id

)

SELECT

    so.order_id,

    so.customer_id,

    so.order_status,

    so.order_purchase_timestamp,

    so.order_delivered_customer_date,

    so.order_estimated_delivery_date,

    COALESCE(i.item_count, 0) AS item_count,

    ROUND(COALESCE(i.order_value, 0::NUMERIC), 2) AS order_value,

    ROUND(COALESCE(i.freight_value, 0::NUMERIC), 2) AS freight_value,

    ROUND(COALESCE(p.payment_value, 0::NUMERIC), 2) AS payment_value,

    (
        so.order_delivered_customer_date::DATE
        -
        so.order_purchase_timestamp::DATE
    ) AS delivery_days,

    CASE
        WHEN so.order_delivered_customer_date IS NULL THEN NULL
        WHEN so.order_delivered_customer_date > so.order_estimated_delivery_date THEN TRUE
        ELSE FALSE
    END AS late_delivery_flag

FROM sample_orders so

LEFT JOIN item_summary i
    ON so.order_id = i.order_id

LEFT JOIN payment_summary p
    ON so.order_id = p.order_id;