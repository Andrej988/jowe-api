variable "AWS_ACCESS_KEY_ID" {
  type = string
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
  sensitive = true
}

variable "AWS_REGION" {
  type = string
}

variable "AWS_CERTIFICATE_ARN" {
  type = string
}

variable "DOMAIN_NAME" {
  type = string
}

variable "ENV" {
  type = string
}

variable "app_name" {
  type = string
  default = "weight-tracker"
}

variable "TF_LOG" {
  type = string
  default = "DEBUG"
}
