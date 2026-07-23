DROP TABLE IF EXISTS staging.stg_order_items;

CREATE TABLE staging.stg_order_items AS

SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
FROM raw.order_items;