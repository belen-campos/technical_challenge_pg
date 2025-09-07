-- Rating promedio por producto, por dia
SELECT 
    DATE(r.created_at) AS date_id,
    r.product_id AS product_id,
    p.title,
    p.category_id,
    p.category_name,
    ROUND(AVG(rating),4) AS avg_rating
FROM {{ ref('silver_reviews') }} r
JOIN {{ ref('silver_products') }} p ON r.product_id = p.id
GROUP BY 1,2,3,4,5