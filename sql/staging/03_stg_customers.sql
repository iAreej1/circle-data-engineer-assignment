DROP TABLE IF EXISTS staging.stg_customers;

CREATE TABLE staging.stg_customers AS

SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM raw.customers;