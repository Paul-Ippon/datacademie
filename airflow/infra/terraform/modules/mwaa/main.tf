resource "aws_security_group" "mwaa" {
  name        = "${var.mwaa_environment_name}-sg"
  description = "Security Group for Amazon MWAA Environment ${var.mwaa_environment_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.mwaa_environment_name}-sg"
  })
}


resource "aws_mwaa_environment" "mwaa_environment" {
  name = var.mwaa_environment_name

  environment_class = local.mwaa_environment_class
  airflow_version   = local.mwaa_airflow_version

  execution_role_arn = aws_iam_role.mwaa_iam_role.arn

  source_bucket_arn = aws_s3_bucket.mwaa.arn

  requirements_s3_path           = aws_s3_object.requirements.id
  requirements_s3_object_version = aws_s3_object.requirements.version_id

  dag_s3_path = "dags"

  min_workers = var.mwaa_min_workers
  max_workers = var.mwaa_max_workers
  schedulers  = var.mwaa_number_schedulers

  webserver_access_mode = local.webserver_access_mode

  weekly_maintenance_window_start = ""

  airflow_configuration_options = {
    "core.lazy_load_plugins" = false
    "secrets.backend"        = "airflow.providers.amazon.aws.secrets.secrets_manager.SecretsManagerBackend"
    "secrets.backend_kwargs" = "{\"connections_prefix\" : \"airflow/connections\", \"variables_prefix\" : \"airflow/variables\", \"full_url_mode\": false}"
  }

  network_configuration {
    security_group_ids = [aws_security_group.mwaa.id]
    subnet_ids         = var.private_subnet_ids
  }

  logging_configuration {
    dag_processing_logs {
      enabled   = true
      log_level = "INFO"
    }

    scheduler_logs {
      enabled   = true
      log_level = "INFO"
    }

    task_logs {
      enabled   = true
      log_level = "INFO"
    }

    webserver_logs {
      enabled   = true
      log_level = "INFO"
    }

    worker_logs {
      enabled   = true
      log_level = "INFO"
    }
  }

  tags = merge(var.tags, {
    Name = "MWAA ${var.mwaa_environment_name}"
  })
}