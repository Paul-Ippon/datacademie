variable "user" {
  type = string
}

variable "snowflake_user" {
  type = string
}

variable "snowflake_password" {
  type = string

  sensitive   = true
}