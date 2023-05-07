data "aws_iam_policy_document" "dynamodb_jowe_measurements_crud_policy" {
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

    resources = [aws_dynamodb_table.jowe_measurements.arn]
  }
}

data "aws_iam_policy_document" "dynamodb_read_only_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query"
    ]

    resources = [aws_dynamodb_table.jowe_measurements.arn]
  }
}

resource "aws_iam_policy" "dynamodb_measurements_crud_policy" {
  name        = var.ENV == "dev" ? "${var.app_name}-dynamodb-measurements-crud-policy-dev" : "${var.app_name}-dynamodb-measurements-crud-policy"
  path        = "/"
  description = "IAM policy for logging crud dynamo db access"
  policy      = data.aws_iam_policy_document.dynamodb_jowe_measurements_crud_policy.json
}

resource "aws_iam_policy" "dynamodb_measurements_read_only_policy" {
  name        = var.ENV == "dev" ? "${var.app_name}-dynamodb-measurements-read-only-policy-dev" : "${var.app_name}-dynamodb-measurements-read-only-policy"
  path        = "/"
  description = "IAM policy for logging read only dynamo db access"
  policy      = data.aws_iam_policy_document.dynamodb_read_only_policy_doc.json
}
