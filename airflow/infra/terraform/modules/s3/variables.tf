variable "tags" {
  type        = map(string)
  description = "List of tags."
}


variable "raw_data_bucket_name" {
  type        = string
  description = "Name of raw data bucket."
}

variable "processed_data_bucket_name" {
  type        = string
  description = "Name of processed data bucket."
}