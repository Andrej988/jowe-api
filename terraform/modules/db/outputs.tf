output "dynamodb_policies" {
  description = "Policies for dynamodb tables"
  value = {
    weight_measurements_crud      = aws_iam_policy.dynamodb_measurements_crud_policy.arn
    weight_measurements_read_only = aws_iam_policy.dynamodb_measurements_read_only_policy.arn
    weight_targets_crud           = aws_iam_policy.dynamodb_weight_target_crud_policy.arn
    weight_targets_read_only      = aws_iam_policy.dynamodb_weight_target_read_only_policy.arn
  }
}

output "dynamodb_tables" {
  description = "Dynamodb tables"
  value = {
    weight_measurements = aws_dynamodb_table.jowe_measurements.name
    weight_targets      = aws_dynamodb_table.jowe_weight_targets.name
  }
}
