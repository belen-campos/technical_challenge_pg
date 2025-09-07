{{ config(
    materialized='incremental',
    unique_key='id'
) }}

SELECT 
    o.id,
    o.created_at,
    o.user_id,
    o.product_id,
    o.quantity,
    o.unit_price,
    {{ prefix_columns('u', 'user', ['name', 'city', 'source']) }}
FROM {{ ref('bronze_orders') }} o
JOIN {{ ref('bronze_users') }} u ON o.user_id = u.id
{{ filter_incremental('o.created_at', 'created_at') }}