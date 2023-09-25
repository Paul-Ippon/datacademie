{{
  config(
    materialized='incremental',
    incremental_strategy='merge',
    cluster_by=['station_id'],
    merge_exclude_columns=['station_id','station_code','latitude', 'longitude'],
    unique_key=['station_id']
  )
}}

select
    station_id::number(38,0)            as station_id
    , station_code::number(38,0)        as station_code
    , name::string                      as name
    , capacity::number(38,0)            as capacity
    , rental_methods::variant           as rental_methods
    , latitude::float                   as latitude
    , longitude::float                  as longitude
    , last_updated_refresh::timestamp   as last_updated_refresh
from
    {{ ref('stg_stations__informations') }}
