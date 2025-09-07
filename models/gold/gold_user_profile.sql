{% set today_date = "'" ~ var("today") ~ "'" if var("today") is not none else "now()" %}

WITH orders AS (
    SELECT
        o.created_at,
        o.user_id,
        o.product_id,
        o.quantity,
        o.unit_price,
        p.category_name,
        {{ diff_dates('years', 'o.created_at', today_date ~ '::date') }} <= 12 AS is_last_year
    FROM {{ ref('silver_orders') }} o
    LEFT JOIN {{ ref('silver_products') }} p on o.product_id = p.id
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
    WHERE is_last_year
    GROUP BY user_id
), user_categories AS (
    SELECT 
        user_id, 
        category_name, 
        SUM(quantity), 
        row_number() OVER (PARTITION BY user_id ORDER BY sum(quantity) DESC) AS rnk
    FROM orders 
    WHERE is_last_year
    GROUP BY user_id, category_name
)
SELECT
    u.id AS user_id,
    p.first_purchase_date,
    p.last_purchase_date,
    m.total_orders,
    m.total_amount_spent,
    m.distinct_products,
    c.category_name as category_preference
FROM {{ ref('silver_users') }} u
LEFT JOIN purchases p ON u.id = p.user_id
LEFT JOIN metrics_last_year m on u.id = m.user_id
LEFT JOIN user_categories c on u.id = c.user_id AND rnk = 1
