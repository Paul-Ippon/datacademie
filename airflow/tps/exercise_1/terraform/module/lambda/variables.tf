variable "source_file" {
  type = string
}

variable "source_file_type" {
  type = string
  default = "zip"
}

variable "function_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
  default = "python3.9"
}

variable "lambda_policies_arn" {
  type = list(string)
}

variable "timeout" {
  type = number
  default = 10
}