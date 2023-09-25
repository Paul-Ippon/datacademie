variable "network_prefix" {
  type        = string
  description = "A prefix to use when naming resources."
}

variable "tags" {
  type        = map(string)
  description = "List of tags."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnets' CIDR blocks."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnets' CIDR blocks."
}