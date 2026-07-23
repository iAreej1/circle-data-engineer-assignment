SELECT COUNT(*) AS failed_records
FROM staging.stg_order_payments
WHERE payment_value < 0;