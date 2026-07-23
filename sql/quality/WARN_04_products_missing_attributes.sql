SELECT COUNT(*) AS failed_records
FROM staging.stg_products
WHERE product_category_name IS NULL
  AND product_name_lenght IS NULL
  AND product_description_lenght IS NULL
  AND product_photos_qty IS NULL;