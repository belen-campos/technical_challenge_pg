SELECT 
    CAST(id AS bigint) AS id,
    created_at,
    name,
    email,
    city,
    state,
    zip,
    to_date(birth_date, 'YYYY-MM-DD') as birth_date,
    source
FROM {{ source('raw', 'raw_users') }}