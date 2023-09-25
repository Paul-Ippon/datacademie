with station_status as (
    select * from {{ ref('base_stations__status') }}
)

, flatten_stations as (
    select
        d.value:station_id                      as station_id
        , d.value:stationCode                   as station_code
        , d.value:is_installed                  as is_installed
        , d.value:is_renting                    as is_renting
        , d.value:is_returning                  as is_returning
        , d.value:numBikesAvailable             as numBikesAvailable
        , d.value:numDocksAvailable             as numDocksAvailable
        , d.value:num_bikes_available           as num_bikes_available
        , sum(f.value:mechanical)               as num_bikes_available_mechanical
        , sum(f.value:ebike)                    as num_bikes_available_ebike
        , d.value:num_docks_available           as num_docks_available
        , d.value:last_reported::timestamp      as last_updated_station_status
        , ss.data:lastUpdatedOther::timestamp   as last_updated_refresh
    from
        station_status as ss
    , table( flatten(input => ss.data:data:stations)) as d
    , table( flatten(input => d.value:num_bikes_available_types)) as f
    group by
        station_id
        , station_code
        , is_installed
        , is_renting
        , is_returning
        , numBikesAvailable
        , numDocksAvailable
        , num_bikes_available
        , num_docks_available
        , last_updated_station_status
        , last_updated_refresh
)

select * from flatten_stations