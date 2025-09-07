{% macro prefix_columns(alias, prefix, columns) %}
{% for column in columns %}
    {{ alias }}.{{ column }} as {{ prefix }}_{{ column }} {% if not loop.last %}, {% endif %}
{% endfor %}
{% endmacro %}
