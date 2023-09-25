{% macro is_in_production() %}
    {% if target.name.lower() == 'prod' %}
        {{ return(True) }}
    {% else %}
        {{ return(False) }}
    {% endif %}
{%endmacro%}