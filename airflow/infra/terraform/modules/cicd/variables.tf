variable "tags" {
  type        = map(string)
  description = "List of tags."
}


variable "datacademie_bucket" {
  type        = string
  description = "Name of airflow bucket."
}