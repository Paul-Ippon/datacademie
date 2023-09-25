
module "network" {
  source = "./modules/networks"

  network_prefix  = local.network_prefix

  vpc_cidr = local.vpc_cidr

  public_subnet_cidrs = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs

  tags = local.tags
}

module "mwaa" {
  source = "./modules/mwaa"

  mwaa_environment_name = local.mwaa_environment_name

  vpc_id              = module.network.vpc_id
  private_subnet_ids  = module.network.private_subnets_ids

  mwaa_min_workers        = local.mwaa_min_workers
  mwaa_max_workers        = local.mwaa_max_workers

  mwaa_number_schedulers  = local.mwaa_number_schedulers

  tags = local.tags
}

module "s3" {
  source = "./modules/s3"

  raw_data_bucket_name       = local.raw_data_bucket_name
  processed_data_bucket_name = local.processed_data_bucket_name

  tags = local.tags
}

module "cicd" {
  source = "./modules/cicd"

  datacademie_bucket = "${local.mwaa_environment_name}-bucket"

  tags = local.tags
}