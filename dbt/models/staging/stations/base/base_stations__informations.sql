select
	json_data as data
from
    {{ source('datacademie','raw_stations_informations') }}
