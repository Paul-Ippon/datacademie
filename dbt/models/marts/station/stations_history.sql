{{
  config(
    materialized='incremental',
    incremental_strategy='merge',
    cluster_by=['station_id', 'update_hour'],
    merge_exclude_columns=['station_id','station_code','update_hour','latitude','longitude'],
    unique_key=['station_id', 'update_hour']
  )
}}

with stations_informations as (
    select * from {{ ref('dim_stations_informations') }}
)

, station_status as (
    select * from {{ ref('fact_stations_status') }}
)

, station_aggregation as (
    select
        s.update_hour
        , i.station_id
        , i.station_code
        , i.name
        , i.latitude
        , i.longitude
        , i.capacity
        , i.rental_methods
        , s.is_installed
        , s.is_renting
        , s.is_returning
        , s.num_bikes_available
        , s.num_bikes_available_mechanical
        , s.num_bikes_available_ebike
        , s.num_docks_available
        , s.last_updated_station_status
    from
        stations_informations as i
    inner join
        station_status as s
            on i.station_id = s.station_id
)

select * from station_aggregation