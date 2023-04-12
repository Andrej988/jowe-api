output "dynamo_db_weight_tracker_crud_policy" {
  description = "ARN of CRUD policy for dynamodb tables"
  value = aws_iam_policy.dynamo_db_crud_policy.arn
}

output "dynamo_db_weight_tracker_read_only_policy" {
  description = "ARN of Read-Only policy for dynamodb tables"
  value = aws_iam_policy.dynamo_db_read_only_policy.arn
}
