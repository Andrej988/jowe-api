variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
variable "AWS_REGION" {}
variable "AWS_CERTIFICATE_ARN" {}
variable "DOMAIN_NAME" {}
variable "ENV" {}

variable "app_name" {
  default = "weight-tracker"
}

variable "TF_LOG" {
  default = "DEBUG"
}
