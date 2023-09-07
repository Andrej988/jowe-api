resource "aws_iam_role_policy_attachment" "jowe_api_lambda_dynamodb_crud_role_attachment_weight_measurements" {
  role       = aws_iam_role.jowe_api_lambda_crud.name
  policy_arn = var.dynamodb_tables["weight_measurements"]["policies"]["read_write"]
}

resource "aws_iam_role_policy_attachment" "jowe_api_lambda_dynamodb_read_only_role_attachment_weight_measurements" {
  role       = aws_iam_role.jowe_api_lambda_read_only.name
  policy_arn = var.dynamodb_tables["weight_measurements"]["policies"]["read_only"]
}

resource "aws_iam_role_policy_attachment" "jowe_api_lambda_sqs_processing_weight_measurements_delete_user_data_role_attachment" {
  role       = aws_iam_role.jowe_api_lambda_crud.name
  policy_arn = var.sns_and_sqs["sqs_weight_measurements_delete_user_data_queue"]["policy_arn"]
}
