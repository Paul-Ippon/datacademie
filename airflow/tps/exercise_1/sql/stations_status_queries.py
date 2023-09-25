

copy_s3_data_to_sta_table = """
    COPY INTO STATIONS_STATUS_STA
      FROM {{ params.s3_uri }} credentials=(AWS_KEY_ID='{{ params.aws_key_id }}' AWS_SECRET_KEY='{{ params.aws_secret_key }}')
      FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1);
"""

create_table_stations_status = """
    CREATE TABLE IF NOT EXISTS STATIONS_STATUS (
      station_id INT,
      is_installed INT,
      is_renting INT,
      is_returning INT,
      last_reported INT,
      num_bikes_available INT,
      num_docks_available INT,
      ebike_available INT,
      mechanical_available INT,
      lastUpdatedOther INT,
      ttl INT
    );
"""

create_table_stations_status_history = """
    CREATE TABLE IF NOT EXISTS STATIONS_STATUS_HISTORY (
        station_id INT,
        is_installed INT,
        is_renting INT,
        is_returning INT,
        last_reported INT,
        num_bikes_available INT,
        num_docks_available INT,
        ebike_available INT,
        mechanical_available INT,
        lastUpdatedOther INT,
        ttl INT,
        effective_from TIMESTAMP_NTZ(9) DEFAULT current_timestamp(),
        effective_to TIMESTAMP_NTZ(9),
        PRIMARY KEY (station_id, lastUpdatedOther)
    );
"""

create_table_stations_status_sta = """
    CREATE OR REPLACE TABLE STATIONS_STATUS_STA (
      station_id INT,
      is_installed INT,
      is_renting INT,
      is_returning INT,
      last_reported INT,
      num_bikes_available INT,
      num_docks_available INT,
      ebike_available INT,
      mechanical_available INT,
      lastUpdatedOther INT,
      ttl INT
    );
"""

drop_sta_table = "DROP TABLE STATIONS_STATUS_STA;"

stations_status_cdc_step = """
    MERGE INTO STATIONS_STATUS_HISTORY t
    USING (
        SELECT
            station_id,
            is_installed,
            is_renting,
            is_returning,
            last_reported,
            num_bikes_available,
            num_docks_available,
            ebike_available,
            mechanical_available,
            lastUpdatedOther,
            ttl
        FROM STATIONS_STATUS_STA
        WHERE station_id IS NOT NULL
        AND last_reported IS NOT NULL
    ) s
    ON (t.station_id = s.station_id AND t.last_reported = s.last_reported)
    WHEN NOT MATCHED THEN
        INSERT (
            station_id,
            is_installed,
            is_renting,
            is_returning,
            last_reported,
            num_bikes_available,
            num_docks_available,
            ebike_available,
            mechanical_available,
            lastUpdatedOther,
            ttl
        ) VALUES (
            s.station_id,
            s.is_installed,
            s.is_renting,
            s.is_returning,
            s.last_reported,
            s.num_bikes_available,
            s.num_docks_available,
            s.ebike_available,
            s.mechanical_available,
            s.lastUpdatedOther,
            s.ttl
        )
    WHEN MATCHED THEN
        UPDATE SET effective_to = current_timestamp();
"""

stations_status_merge_final_table_step = """
    MERGE INTO STATIONS_STATUS t
    USING (
        SELECT
            station_id,
            is_installed,
            is_renting,
            is_returning,
            last_reported,
            num_bikes_available,
            num_docks_available,
            ebike_available,
            mechanical_available,
            lastUpdatedOther,
            ttl
        FROM STATIONS_STATUS_STA
        WHERE station_id IS NOT NULL
        AND last_reported IS NOT NULL
    ) s
    ON (t.station_id = s.station_id AND t.last_reported = s.last_reported)
    WHEN NOT MATCHED THEN
        INSERT (
            station_id,
            is_installed,
            is_renting,
            is_returning,
            last_reported,
            num_bikes_available,
            num_docks_available,
            ebike_available,
            mechanical_available,
            lastUpdatedOther,
            ttl
        ) VALUES (
            s.station_id,
            s.is_installed,
            s.is_renting,
            s.is_returning,
            s.last_reported,
            s.num_bikes_available,
            s.num_docks_available,
            s.ebike_available,
            s.mechanical_available,
            s.lastUpdatedOther,
            s.ttl
        )
    WHEN MATCHED THEN
        UPDATE SET
            t.is_installed = s.is_installed,
            t.is_renting = s.is_renting,
            t.is_returning = s.is_returning,
            t.lastUpdatedOther = s.lastUpdatedOther,
            t.num_bikes_available = s.num_bikes_available,
            t.num_docks_available = s.num_docks_available,
            t.ebike_available = s.ebike_available,
            t.mechanical_available = s.mechanical_available,
            t.ttl = s.ttl;
"""
