{% test not_future_date(model, column_name) %}

{% set today_date = "'" ~ var("today") ~ "'" if var("today") is not none else "now()" %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }} > {{ today_date ~ '::date' }}

{% endtest %}
