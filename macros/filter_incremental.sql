{% macro filter_incremental(column_stg, column_dw) %}
{% if is_incremental() %}
  -- Solo traer registros nuevos (creados después del último insert en bronze)
  WHERE {{ column_stg }} > (SELECT MAX({{ column_dw }}) FROM {{ this }})
{% endif %}
{% endmacro %}