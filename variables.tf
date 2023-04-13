variable "AWS_REGION" {}
variable "AWS_CERTIFICATE_ARN" {}
variable "DOMAIN_NAME" {}
variable "ENV" {}
variable "TERRAFORM_CLOUD_ORGANIZATION" {}
variable "TERRAFORM_CLOUD_WORKSPACE" {}

variable "app_name" {
  default = "weight-tracker"
}

variable "TF_LOG" {
  default = "DEBUG"
}
