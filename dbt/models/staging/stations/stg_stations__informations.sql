with stations_informations as (
    select * from {{ ref('base_stations__informations') }}
)

, flatten_stations as (
    select
        d.value:station_id                      as station_id
        , d.value:stationCode                   as station_code
        , d.value:name                          as name
        , d.value:capacity                      as capacity
        , d.value:rental_methods                as rental_methods
        , d.value:lat                           as latitude
        , d.value:lon                           as longitude
        , si.data:lastUpdatedOther::timestamp   as last_updated_refresh
    from
        stations_informations as si
    , table( flatten(input => si.data:data:stations)) as d
)

select * from flatten_stations