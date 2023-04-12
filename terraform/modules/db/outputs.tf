output "dynamodb_policies" {
  description = "Policies for dynamodb tables"
  value = {
    measurements_crud      = aws_iam_policy.dynamodb_measurements_crud_policy.arn
    measurements_read_only = aws_iam_policy.dynamodb_measurements_read_only_policy.arn
    profiles_crud          = aws_iam_policy.dynamodb_profiles_crud_policy.arn
    profiles_read_only     = aws_iam_policy.dynamodb_profiles_read_only_policy.arn
  }
}
