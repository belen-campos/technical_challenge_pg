{{ config(
    materialized='incremental',
    unique_key='id'
) }}

SELECT 
    CAST(id AS bigint) AS id,
    created_at,
    CAST(user_id AS bigint) AS user_id,
    CAST(product_id AS bigint) AS product_id,
    CAST(quantity AS integer) AS quantity,
    CAST(unit_price AS numeric) AS  unit_price
FROM {{ source('raw', 'raw_orders') }}
{{ filter_incremental('created_at', 'created_at') }}