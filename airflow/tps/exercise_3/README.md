# Exercise 3

Now that you have your dags, you will improve your code to make it more organized.

## Managing Dependencies with Datasets

Modify your dags so that your analytics dag depends on your data extraction dag.

You must use the concept of "dataset": https://airflow.apache.org/docs/apache-airflow/2.4.3/concepts/datasets.html

## Code Improvement (Optional)

Modify your dags to make them more generic.

Here are some optimization ideas for your dags:
- Make your sql queries generic so that they are reusable;
- Modify your Airflow tasks (Operator) by replacing all the hard-coded parameters with variables;
- Create task groups to group similar tasks (for sql queries, for example).
- You can create a python file "my_dag_variables.py" to store all the variables.

Documentation:
- https://docs.astronomer.io/learn/task-groups