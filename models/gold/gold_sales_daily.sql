-- Ventas por día (total_sales, total_orders)
SELECT 
    DATE(created_at) AS date_id,
    SUM(quantity) AS total_sales_items,
    ROUND(SUM(quantity * unit_price),4) AS total_sales,
    COUNT(*) AS total_orders
FROM {{ ref('silver_orders') }}
GROUP BY 1