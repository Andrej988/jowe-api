variable "TERRAFORM_CLOUD_ORGANIZATION" {}
variable "TERRAFORM_CLOUD_WORKSPACE" {}
variable "ENV" {}
variable "AWS_REGION" {}
variable "DOMAIN_NAME" {}
variable "CERTIFICATE_ARN" {}

variable "app_name" {
  default = "weight-tracker"
}

variable "TF_LOG" {
  default = "DEBUG"
}
