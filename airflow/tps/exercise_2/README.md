# Exercise 2

You will write a data analysis dag generating a Snowflake table containing statistics on stations.

## Construction of the dag

For this exercise, you are completely free to choose the query.

You must therefore:
1) Create the sql code that will allow you to create the table;
2) Create the sql code responsible for inserting data into your table from the "source" data;
3) Create the dag that executes the creation of the table and after the insertion of data in two separate tasks;
4) As for the "schedule", you can define it based on the schedule of the first exercise for now.

Documentation:
- https://airflow.apache.org/docs/apache-airflow-providers-snowflake/stable/operators/snowflake.html