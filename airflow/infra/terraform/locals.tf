locals {
  /* Network local var */

  network_prefix  = "datacademie-airflow"

  vpc_cidr = "10.12.0.0/16"

  public_subnet_cidrs = [ "10.12.1.0/24", "10.12.2.0/24" ]
  private_subnet_cidrs = [ "10.12.3.0/24", "10.12.4.0/24" ]

  /* MWAA local var */

  mwaa_environment_name = "datacademie-airflow"

  mwaa_min_workers        = 1
  mwaa_max_workers        = 10

  mwaa_number_schedulers  = 2

  /* Buckets local var */

  raw_data_bucket_name        = "datacademie-airflow-raw-data-bucket"
  processed_data_bucket_name  = "datacademie-airflow-processed-data-bucket"

  tags = {
    Owner      = "jgros@ippon.fr"
    Project    = "datacademie-airflow"
    Managed-By = "terraform"
  }
}