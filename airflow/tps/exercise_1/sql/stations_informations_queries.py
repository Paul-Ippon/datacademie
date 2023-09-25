

copy_s3_data_to_sta_table = """
    COPY INTO STATIONS_INFORMATIONS_STA
      FROM {{ params.s3_uri }} credentials=(AWS_KEY_ID='{{ params.aws_key_id }}' AWS_SECRET_KEY='{{ params.aws_secret_key }}')
      FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1);
"""

create_table_stations_informations = """
    CREATE TABLE IF NOT EXISTS STATIONS_INFORMATIONS (
      station_id INT,
      stationCode VARCHAR(255),
      name VARCHAR(255),
      capacity INT,
      rental_methods VARCHAR(512),
      lat FLOAT,
      lon FLOAT,
      lastupdatedother INT,
      ttl INT
    );
"""

create_table_stations_informations_history = """
    CREATE TABLE IF NOT EXISTS STATIONS_INFORMATIONS_HISTORY (
        station_id INT,
        stationCode VARCHAR(255),
        name VARCHAR(255),
        capacity INT,
        rental_methods VARCHAR(512),
        lat FLOAT,
        lon FLOAT,
        lastupdatedother INT,
        ttl INT,
        effective_from TIMESTAMP_NTZ(9) DEFAULT current_timestamp(),
        effective_to TIMESTAMP_NTZ(9),
        PRIMARY KEY (station_id, lastUpdatedOther)
    );
"""

create_table_stations_informations_sta = """
    CREATE OR REPLACE TABLE STATIONS_INFORMATIONS_STA (
      station_id INT,
      stationCode VARCHAR(255),
      name VARCHAR(255),
      capacity INT,
      rental_methods VARCHAR(512),
      lat FLOAT,
      lon FLOAT,
      lastupdatedother INT,
      ttl INT
    );
"""

drop_sta_table = "DROP TABLE STATIONS_INFORMATIONS_STA;"

stations_informations_cdc_step = """
    MERGE INTO STATIONS_INFORMATIONS_HISTORY t
    USING (
        SELECT
            station_id,
            stationCode,
            name,
            capacity,
            rental_methods,
            lat,
            lon,
            lastupdatedother,
            ttl
        FROM STATIONS_INFORMATIONS_STA
        WHERE station_id IS NOT NULL
        AND lastUpdatedOther IS NOT NULL
    ) s
    ON (t.station_id = s.station_id AND t.lastUpdatedOther = s.lastUpdatedOther)
    WHEN NOT MATCHED THEN
        INSERT (
            station_id,
            stationCode,
            name,
            capacity,
            rental_methods,
            lat,
            lon,
            lastupdatedother,
            ttl
        ) VALUES (
            s.station_id,
            s.stationCode,
            s.name,
            s.capacity,
            s.rental_methods,
            s.lat,
            s.lon,
            s.lastupdatedother,
            s.ttl
        )
    WHEN MATCHED THEN
        UPDATE SET effective_to = current_timestamp();
"""

stations_informations_merge_final_table_step = """
    MERGE INTO STATIONS_INFORMATIONS t
    USING (
        SELECT
            station_id,
            stationCode,
            name,
            capacity,
            rental_methods,
            lat,
            lon,
            lastupdatedother,
            ttl
        FROM STATIONS_INFORMATIONS_STA
        WHERE station_id IS NOT NULL
        AND lastUpdatedOther IS NOT NULL
    ) s
    ON (t.station_id = s.station_id AND t.lastUpdatedOther = s.lastUpdatedOther)
    WHEN NOT MATCHED THEN
        INSERT (
            station_id,
            stationCode,
            name,
            capacity,
            rental_methods,
            lat,
            lon,
            lastupdatedother,
            ttl
        ) VALUES (
            s.station_id,
            s.stationCode,
            s.name,
            s.capacity,
            s.rental_methods,
            s.lat,
            s.lon,
            s.lastupdatedother,
            s.ttl
        )
    WHEN MATCHED THEN
        UPDATE SET
            t.name = s.name,
            t.stationCode = s.stationCode,
            t.capacity = s.capacity,
            t.rental_methods = s.rental_methods,
            t.lat = s.lat,
            t.lon = s.lon,
            t.ttl = s.ttl;
"""
