SELECT COUNT(*) AS failed_records
FROM staging.stg_order_items oi
LEFT JOIN staging.stg_orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;