/*
===========================================================
Question 3 – Revenue Integrity
===========================================================

Objective:
1. Calculate the correct delivered GMV for 2017 using the
   order-level fact table.
2. Demonstrate why a naive join between orders,
   order_items, and order_payments overstates revenue.
3. Show that multiple payment records exist and explain
   why they cause duplicate rows in the naive join.
===========================================================
*/


/*----------------------------------------------------------
1. Correct Delivered GMV (2017)
Source: marts.fct_orders
----------------------------------------------------------*/

SELECT

    COUNT(*) AS delivered_orders,

    ROUND(
        SUM(order_value),
        2
    ) AS delivered_gmv_2017

FROM marts.fct_orders

WHERE order_status = 'delivered'

AND order_purchase_timestamp >= DATE '2017-01-01'

AND order_purchase_timestamp < DATE '2018-01-01';



/*----------------------------------------------------------
2. Incorrect (Naive) GMV Calculation

Joining orders -> order_items -> order_payments
duplicates item rows whenever an order has multiple
payment records, causing revenue inflation.
----------------------------------------------------------*/

SELECT

    ROUND(
        SUM(oi.price)::NUMERIC,
        2
    ) AS naive_gmv_2017

FROM staging.stg_orders o

INNER JOIN staging.stg_order_items oi
    ON o.order_id = oi.order_id

INNER JOIN staging.stg_order_payments op
    ON o.order_id = op.order_id

WHERE o.order_status = 'delivered'

AND o.order_purchase_timestamp >= DATE '2017-01-01'

AND o.order_purchase_timestamp < DATE '2018-01-01'

AND MOD(
        ABS(HASHTEXT(o.order_id || '{sample_seed}')),
        100
    ) < 80;



/*----------------------------------------------------------
3. Orders with Multiple Payments

These orders are the reason the naive join inflates GMV,
because each payment duplicates the corresponding order
item rows.
----------------------------------------------------------*/

SELECT

    COUNT(*) AS orders_with_multiple_payments

FROM (

    SELECT

        order_id

    FROM staging.stg_order_payments

    GROUP BY order_id

    HAVING COUNT(*) > 1

) payment_orders;