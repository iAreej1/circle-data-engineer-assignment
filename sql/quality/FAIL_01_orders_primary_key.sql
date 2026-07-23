SELECT COUNT(*) AS failed_records
FROM (
    SELECT order_id
    FROM staging.stg_orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) t;