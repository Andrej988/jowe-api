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

  depends_on = [
    aws_cognito_user_pool.user_pool
  ]
}
