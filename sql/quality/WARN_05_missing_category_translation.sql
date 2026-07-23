SELECT COUNT(DISTINCT p.product_category_name) AS failed_records
FROM staging.stg_products p
LEFT JOIN staging.stg_product_category_translation t
ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL;