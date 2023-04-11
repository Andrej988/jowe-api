variable "app_name" {}
variable "ENV" {}

resource "aws_cognito_user_pool" "user_pool" {
  name = "weight-tracker-auth"
  #name = var.ENV == "dev" ? "weight-tracker-auth-dev" : "weight-tracker-auth"

  #Self-Registration (set false to enable self registration)
  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  alias_attributes = [ "email", "preferred_username" ]
  username_configuration {
    case_sensitive = false
  }
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_numbers = true
    require_symbols = true
    require_uppercase = true
    temporary_password_validity_days = 7
  }

  mfa_configuration = "OPTIONAL"
  software_token_mfa_configuration {
    enabled = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Account Confirmation"
    email_message = "Your confirmation code is {####}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "gender"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 10
    }
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      schema
    ]
  }

  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }

  tags = {
    Name        = "weight_tracker_user_pool"
    Environment = var.ENV
    App         = var.app_name
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "weight-tracker-web"

  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false
  prevent_user_existence_errors = "ENABLED"

  access_token_validity = 60
  id_token_validity = 60
  refresh_token_validity = 30
  token_validity_units {
    access_token = "minutes"
    id_token = "minutes"
    refresh_token = "days"
  }

  explicit_auth_flows = [
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}
