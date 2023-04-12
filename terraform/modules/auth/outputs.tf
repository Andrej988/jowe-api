output "cognito_user_pool_arn" {
  description = "ARN of Cognito User Pool"
  value = aws_cognito_user_pool.user_pool.arn
}
