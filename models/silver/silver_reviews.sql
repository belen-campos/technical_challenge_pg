SELECT 
    id,
    created_at,
    reviewer,
    product_id,
    rating,
    body
FROM {{ ref('bronze_reviews') }}