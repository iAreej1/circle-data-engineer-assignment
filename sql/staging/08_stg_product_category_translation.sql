DROP TABLE IF EXISTS staging.stg_product_category_translation;

CREATE TABLE staging.stg_product_category_translation AS

SELECT
    TRIM(product_category_name) AS product_category_name,
    TRIM(product_category_name_english) AS product_category_name_english

FROM raw.product_category_name_translation;