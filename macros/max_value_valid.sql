{% test max_value_valid(model, column_name, max_value) %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }} > {{ max_value }}

{% endtest %}