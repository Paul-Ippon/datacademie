{% docs station_id %}
Unique identifier for the station  
**Type** : number
{% enddocs %}

{% docs station_code %}
Station number  
**Type** : number
{% enddocs %}

{% docs last_updated_refresh %}
Timestamp of the last report returned by the API
**Type** : timestamp  
{% enddocs %}

----- Informations -----

{% docs name %}
Name of the stations  
**Type** : string  
**Source** : station_information API
{% enddocs %}

{% docs latitude %}
Latitude of the station (in WGS84 format)  
**Type** : float  
**Source** : station_information API
{% enddocs %}

{% docs longitude %}
Longitude of the station (in WGS84 format)  
**Type** : float  
**Source** : station_information API
{% enddocs %}

{% docs capacity %}
Number of docks in the station  
**Type** : number  
**Source** : station_information API
{% enddocs %}

{% docs rental_methods %}
| values     | Payment methods      |
|------------|----------------------|
| NULL       | No purchase possible |
| CREDITCARD | Credit card          |
| CASH       | Cash                 |

Payment methods available to buy temporary passes (if null then no purchase possible in this station)  
**Type** : variant  
**Source** : station_information API
{% enddocs %}

----- Status -----

{% docs is_installed %}
Binary variable indicating whether the station is. The station has already been deployed (1) or is still being deployed (0)  
**Type** : number  
**Source** : stations_status API
{% enddocs %}

{% docs is_renting %}
Binary variable indicating whether the station can rent bikes (is_renting=1 if the station status is Operative)  
**Type** : number  
**Source** : stations_status API
{% enddocs %}

{% docs is_returning %}
Binary variable indicating whether the station can receive bikes (is_renting=1 if the station status is Operative)  
**Type** : number  
**Source** : stations_status API
{% enddocs %}

{% docs num_bikes_available %}
Number of bikes available in the station  
**Type** : number  
**Source** : stations_status API
{% enddocs %}

{% docs num_docks_available %}
Number of docks available in the station  
**Type** : number  
**Source** : stations_status API
{% enddocs %}

{% docs num_bikes_available_types %}
Number of bicycles available with distinctions between mechanical and electric Vélib'  
**Type** : variant  
**Source** : stations_status API
{% enddocs %}

{% docs last_updated_station_status %}
Timestamp of the last report returned by the station  
**Type** : timestamp  
**Source** : stations_status API
{% enddocs %}

