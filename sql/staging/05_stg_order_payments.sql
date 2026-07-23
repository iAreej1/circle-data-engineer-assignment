DROP TABLE IF EXISTS staging.stg_order_payments;

CREATE TABLE staging.stg_order_payments AS

SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM raw.order_payments;