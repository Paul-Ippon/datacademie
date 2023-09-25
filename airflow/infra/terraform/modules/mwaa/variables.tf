variable "mwaa_environment_name" {
  type        = string
  description = "Name of the mwaa environment"
}

variable "tags" {
  type        = map(string)
  description = "List of tags."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the MWAA going to be deploy"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets' IDs."
}

variable "mwaa_max_workers" {
  type        = number
  description = "Maximum number of MWAA workers."
  default     = 2
}

variable "mwaa_min_workers" {
  type        = number
  description = "Minimum number of MWAA workers."
  default     = 1
}

variable "mwaa_number_schedulers" {
  type        = number
  description = "Minimum number of MWAA scheduler."
  default     = 2
}