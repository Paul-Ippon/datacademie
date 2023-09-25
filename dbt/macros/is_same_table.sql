{% macro is_same_table(table_name_A, table_name_B, columns_to_compare) %}
    (
        select
            '{{ table_name_A }}' AS in_table
            , {{ columns_to_compare }}
        from {{ ref(table_name_A) }}
        except
        select
            '{{ table_name_A }}' AS in_table
            , {{ columns_to_compare }} 
        from 
            {{ ref(table_name_B) }}
    )

    union 

    (
        select
            '{{ table_name_B }}' AS in_table
            , {{ columns_to_compare }}
        from {{ ref(table_name_B) }}
        except
        select
            '{{ table_name_B }}' AS in_table
            , {{ columns_to_compare }} 
        from 
            {{ ref(table_name_A) }}
    )
{% endmacro %}