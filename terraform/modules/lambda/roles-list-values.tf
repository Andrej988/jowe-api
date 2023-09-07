resource "aws_iam_role_policy_attachment" "jowe_api_lambda_dynamodb_crud_role_attachment_list_values" {
  role       = aws_iam_role.jowe_api_lambda_crud.name
  policy_arn = var.dynamodb_tables["list_values"]["policies"]["read_write"]
}

resource "aws_iam_role_policy_attachment" "jowe_api_lambda_dynamodb_read_only_role_attachment_list_values" {
  role       = aws_iam_role.jowe_api_lambda_read_only.name
  policy_arn = var.dynamodb_tables["list_values"]["policies"]["read_only"]
}
