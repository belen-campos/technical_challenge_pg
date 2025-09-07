{% set today_date = "'" ~ var("today") ~ "'" if var("today") is not none else "now()" %}

WITH orders AS (
    SELECT DISTINCT user_id
    FROM {{ ref('bronze_orders') }}
    WHERE {{ diff_dates('mons', 'created_at', today_date ~ '::date') }} <= {{ var("months_active_threshold") }}
)
SELECT 
    u.id,
    u.created_at,
    u.name,
    u.email,
    u.city,
    u.state,
    u.zip,
    u.birth_date,
    u.source,
    extract(YEAR FROM u.birth_date) AS birth_year,
    {{ diff_dates('years', 'u.birth_date', today_date ~ '::date') }} AS age,
    o.user_id IS NOT NULL AS is_active
FROM {{ ref('bronze_users') }} u
LEFT JOIN orders o on u.id = o.user_id