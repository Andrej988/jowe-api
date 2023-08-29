data "aws_iam_policy_document" "dynamodb_jowe_list_values_crud_policy" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem"
    ]

    resources = [aws_dynamodb_table.jowe_list_values.arn]
  }

  depends_on = [
    aws_dynamodb_table.jowe_list_values
  ]
}

data "aws_iam_policy_document" "dynamodb_jowe_list_values_read_only_policy" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query"
    ]

    resources = [aws_dynamodb_table.jowe_list_values.arn]
  }

  depends_on = [
    aws_dynamodb_table.jowe_list_values
  ]
}

resource "aws_iam_policy" "dynamodb_list_values_crud_policy" {
  name        = var.ENV == "dev" ? "${var.APP_NAME}-dynamodb-list_values-crud-policy-dev" : "${var.APP_NAME}-dynamodb-list_values-crud-policy"
  path        = "/"
  description = "IAM policy for crud dynamo db list_values table access"
  policy      = data.aws_iam_policy_document.dynamodb_jowe_list_values_crud_policy.json

  depends_on = [
    data.aws_iam_policy_document.dynamodb_jowe_list_values_crud_policy
  ]
}

resource "aws_iam_policy" "dynamodb_list_values_read_only_policy" {
  name        = var.ENV == "dev" ? "${var.APP_NAME}-dynamodb-list_values-read-only-policy-dev" : "${var.APP_NAME}-dynamodb-list_values-read-only-policy"
  path        = "/"
  description = "IAM policy for read only dynamo db list values table access"
  policy      = data.aws_iam_policy_document.dynamodb_jowe_list_values_read_only_policy.json

  depends_on = [
    data.aws_iam_policy_document.dynamodb_jowe_list_values_read_only_policy
  ]
}
