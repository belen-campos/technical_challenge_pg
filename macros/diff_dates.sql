{% macro diff_dates(part, col_start, col_end) %}
    extract({{ part }} from age({{ col_end }}, {{ col_start }}))
{% endmacro %}
