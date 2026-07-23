/*
Question 1
Seller Health

Segmentation Logic

High Performing:
- GMV >= 50,000
- Orders >= 300
- Review >= 4.2

Growing:
- GMV >= 10,000
- Orders >= 100
- Review >= 4.0

Stalling:
- Everyone else
*/

SELECT

    CASE

        WHEN lifetime_gmv >= 50000
             AND total_orders >= 300
             AND avg_review_score >= 4.2
            THEN 'High Performing'

        WHEN lifetime_gmv >= 10000
             AND total_orders >= 100
             AND avg_review_score >= 4.0
            THEN 'Growing'

        ELSE 'Stalling'

    END AS seller_segment,

    COUNT(*) AS seller_count,

    ROUND(AVG(lifetime_gmv),2) AS avg_gmv,

    ROUND(AVG(total_orders),2) AS avg_orders,

    ROUND(AVG(avg_review_score),2) AS avg_review_score,

    MODE() WITHIN GROUP (
        ORDER BY primary_category
    ) AS dominant_category

FROM marts.dim_sellers

GROUP BY seller_segment

ORDER BY avg_gmv DESC;