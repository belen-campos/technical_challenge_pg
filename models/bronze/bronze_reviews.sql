SELECT 
    CAST(id AS bigint) AS id,
    created_at,
    reviewer,
    CAST(product_id AS bigint) AS product_id,
    CAST(rating AS integer) AS rating,
    body
FROM {{ source('raw', 'raw_reviews') }}