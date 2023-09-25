locals {
  project_name = "datacademie-airflow"

  /* Buckets local var */

  raw_data_bucket_name        = "${local.project_name}-raw-data-bucket"
  processed_data_bucket_name  = "${local.project_name}-processed-data-bucket"

  tags = {
    Owner      = "datacademie-airflow"
    Project    = local.project_name
    Managed-By = "terraform"
  }
}