SELECT 
     ps.id,
     ps.created_at,
     ps.title,
     ps.ean,
     ps.vendor,
     CAST(ps.price AS numeric) AS price,
     ps.updated_at,
     pc.category_id,
     pc.category_name,
     {{ prefix_columns('pc', 'category', ['description', 'typical_usage']) }}
FROM {{ ref('products_snapshot') }} ps
JOIN {{ ref('products_categories') }} pc ON ps.category = pc.category_name
WHERE ps.dbt_valid_to IS NULL AND ps.dbt_is_deleted = 'False'