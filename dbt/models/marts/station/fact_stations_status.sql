{{
  config(
    materialized='incremental',
    incremental_strategy='merge',
    cluster_by=['update_hour','station_id'],
    merge_exclude_columns=['station_id','station_code','update_hour'],
    unique_key=['update_hour','station_id']
  )
}}

select
    date_trunc('hour',last_updated_refresh)::timestamp  as update_hour
    , station_id::number(38,0)                          as station_id
    , station_code::number(38,0)                        as station_code
    , is_installed::number(38,0)                        as is_installed
    , is_renting::number(38,0)                          as is_renting
    , is_returning::number(38,0)                        as is_returning
    , num_bikes_available::number(38,0)                 as num_bikes_available
    , num_bikes_available_mechanical::number(38,0)      as num_bikes_available_mechanical
    , num_bikes_available_ebike::number(38,0)           as num_bikes_available_ebike
    , num_docks_available::number(38,0)                 as num_docks_available
    , last_updated_station_status::timestamp            as last_updated_station_status
    , last_updated_refresh::timestamp                   as last_updated_refresh
from
    {{ ref('stg_stations__status') }}
