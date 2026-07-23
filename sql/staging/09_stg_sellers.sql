DROP TABLE IF EXISTS staging.stg_sellers;

CREATE TABLE staging.stg_sellers AS
SELECT
    seller_id,
    seller_zip_code_prefix,
    TRIM(seller_city) AS seller_city,
    UPPER(seller_state) AS seller_state
FROM raw.sellers;