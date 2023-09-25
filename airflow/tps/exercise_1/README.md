# Exercise 1

For this first exercise, you will need to extract data from the velibmetropole API and push it into Snowflake.

The goal is to have an ETL (Extract Transform Load) approach, not an ELT (Extract Load Transform) approach like you may have done in previous sessions (Airbyte + DBT).

# Setup

Deploy the AWS infrastructure using the terraform provided in the "terraform" folder.

It consists of:
- 3 lambdas (one for extraction and two for transformation)
- An AWS user for access to the S3 bucket for Snowflake
- Secrets for Airflow (Snowflake, AWS)

When you run "terraform apply", three values will be requested:
- "snowflake_password": your Snowflake password
- "snowflake_user": your Snowflake username
- "user": your personal user identifier (first letter of the first name followed by the last name, for example: jgros)

# Steps

Each of these steps must be performed within the same dag.

Here is an example of a DAG creation:

```
DAG(
    dag_id="jgros.exercice_1",
    start_date=pendulum.datetime(2023, 3, 5, tz="UTC"),
    schedule_interval="@hourly",
    catchup=False,
    max_active_runs=1,
)
```

This should be run every hour.

You must create your DAG in the GitLab project: https://gitlab.ippon.fr/datacademie-group/datacademie-airflow

To avoid conflicts, you must respect this file tree structure:
- dag/user/exercice_X/user_exercice_X_dag.py
- dag/user/exercice_X/user_exercice_X_variables.py (for upcoming exercises)
- For any additional resources added, you must place them (files and folders) in the folder "dag/user/exercice_X/".

Documentation:
- https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dags.html

To push any modifications to Airflow, you must create a branch from the main branch.

When you merge your branch into the "main" branch, it will trigger a synchronization with the S3 bucket containing all of your dags and update Airflow accordingly.

## Data Extraction

API used: https://www.velib-metropole.fr/donnees-open-data-gbfs-du-service-velib-metropole

You must extract data from the following URLs:
- https://velib-metropole-opendata.smoove.pro/opendata/Velib_Metropole/station_status.json
- https://velib-metropole-opendata.smoove.pro/opendata/Velib_Metropole/station_information.json

The lambdas must write to the bucket: datacademie-airflow-raw-data-bucket

You can use the following documentation (LambdaInvokeFunctionOperator operator): https://airflow.apache.org/docs/apache-airflow-providers-amazon/stable/operators/lambda.html

To simplify your task, you must use the "payload" parameter of the Airflow operator to define the various inputs of the extraction lambda:
- s3_key
- bucket_name
- api_endpoint

Here's an example of a payload (replace the values of the different fields with your own):

```
payload=json.dumps({
    "bucket_name": "datacademie-airflow-raw-data-bucket",
    "s3_key": "jgros/velibmetropole/status/data.json",
    "api_endpoint": "https://velib-metropole-opendata.smoove.pro/opendata/Velib_Metropole/station_status.json"
})
```

Note: You must write your files in a path with your username as a "prefix".
Examples:
- datacademie-airflow-raw-data/jgros/velibmetropole/status/data.json
- datacademie-airflow-raw-data/jgros/velibmetropole/informations/data.json

## Data transformation

The lambdas responsible for data transformation have already been created using the Terraform script that you executed in the "Setup" section.

The data should be pushed to the datacademie-airflow-processed-data-bucket bucket.

Below is an example of a payload (replace the values of the different fields with your own):

```
payload=json.dumps({
    "source": {
        "bucket": "datacademie-airflow-raw-data-bucket",
        "key": "jgros/velibmetropole/status/data.json"
    },
    "destination": {
        "bucket":  "datacademie-airflow-processed-data-bucket",
        "key": "jgros/velibmetropole/status/data.csv"
    }
})
```

Note: You must write your files in a path with your username as a "prefix".
Examples:
- datacademie-airflow-processed-data/jgros/velibmetropole/status/data.csv
- datacademie-airflow-processed-data/jgros/velibmetropole/informations/data.csv

## Writing to Snowflake

You must now load the previously transformed data into your Snowflake database.

You can use the sample python files in the "sql" folder: these consist of the SQL queries you will need. You can directly integrate them into the folder where your dag is located and use them in your file describing your dag.

Here is an example Airflow task for executing a Snowflake query:

```
from jgros.exercice_1.sql import stations_status_queries
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator

create_table_stations_status = SnowflakeOperator(
    task_id="create_table_stations_status",
    snowflake_conn_id="snowflake/jgros"
    sql=stations_status_queries.create_table_stations_status
)
```

To load data into Snowflake, you need to (using the Snowflake operator in Airflow):

1) Create the "STAGING" table: it will be used to load your CSV data into Snowflake
2) Create the "HISTORY" table: it will be used to keep a record of all changes to your data in Snowflake
3) Create the "FINAL" table: it will be used to store only the latest state of the data.
4) Load S3 data into Snowflake
5) Update the "HISTORY" table
6) Update the final table
7) Delete the "STAGING" table
8) You must perform these 7 operations (Airflow tasks) for each of the data sets (stations_status / stations_information)

You can parallelize some tasks using the following syntax:

```
start >> [task_1, task_2, task_3] >> end
```

To inject the values of the SQL query parameters, you must use the **"params"** parameter of the **"SnowflakeOperator"** operator:

```
params={
    's3_uri': 's3://datacademie-airflow-processed-data-bucket/jgros/velibmetropole/status/data.csv',
    'aws_key_id': snowflake_load_conn.login,
    'aws_secret_key': snowflake_load_conn.password
}
```

To retrieve the aws_key_id/aws_secret_key credentials that are stored in an AWS Secrets Manager secret, you can use the following code:

```
from airflow.models import Connection
snowflake_load_conn = Connection.get_connection_from_secrets("aws/jgros_snowflake_load")
```


In this example, tasks "task_1", "task_2", and "task_3" are executed in parallel.

Documentation:
- https://airflow.apache.org/docs/apache-airflow-providers-snowflake/stable/operators/snowflake.html