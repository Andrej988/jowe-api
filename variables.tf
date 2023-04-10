variable "ENV" {}
variable "AWS_REGION" {}

variable "app_name" {
  default = "weight-tracker"
}

variable "dynamodb_measurements_table_name" {
  default = "weight-tracker-measurements"
}
