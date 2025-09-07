{% set today_date = "'" ~ var("today") ~ "'" if var("today") is not none else "now()" %}

WITH orders AS (
    SELECT
        o.created_at,
        o.user_id,
        o.product_id,
        o.quantity,
        o.unit_price
    FROM {{ ref('silver_orders') }} o
), purchases AS (
    SELECT
        user_id,
        min(created_at) AS first_purchase_date,
        max(created_at) AS last_purchase_date
    FROM orders
    GROUP BY user_id
), metrics_last_year AS (
    SELECT
        user_id,
        COUNT(*) AS total_orders,
        SUM(quantity * unit_price) AS total_amount_spent,
        COUNT(distinct product_id) AS distinct_products
    FROM orders
    WHERE {{ diff_dates('years', 'created_at', today_date ~ '::date') }} <= 12
    GROUP BY user_id
)
SELECT
    u.id AS user_id,
    p.first_purchase_date,
    p.last_purchase_date,
    m.total_orders,
    m.total_amount_spent,
    m.distinct_products
FROM {{ ref('silver_users') }} u
LEFT JOIN purchases p ON u.id = p.user_id
LEFT JOIN metrics_last_year m on u.id = m.user_id
