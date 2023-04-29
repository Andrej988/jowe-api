data "aws_iam_policy_document" "dynamodb_jowe_profiles_crud_policy" {
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

    resources = [aws_dynamodb_table.jowe_profiles.arn]
  }
}

data "aws_iam_policy_document" "dynamodb_jowe_profiles_read_only_policy" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query"
    ]

    resources = [aws_dynamodb_table.jowe_profiles.arn]
  }
}

resource "aws_iam_policy" "dynamodb_profiles_crud_policy" {
  name        = var.ENV == "dev" ? "${var.app_name}-dynamodb-profiles-crud-policy-dev" : "${var.app_name}-dynamodb-profiles-crud-policy"
  path        = "/"
  description = "IAM policy for crud dynamo db profiles table access"
  policy      = data.aws_iam_policy_document.dynamodb_jowe_measurements_crud_policy.json
}

resource "aws_iam_policy" "dynamodb_profiles_read_only_policy" {
  name        = var.ENV == "dev" ? "${var.app_name}-dynamodb-profiles-read-only-policy-dev" : "${var.app_name}-dynamodb-profiles-read-only-policy"
  path        = "/"
  description = "IAM policy for read only dynamo db profiles table access"
  policy      = data.aws_iam_policy_document.dynamodb_read_only_policy_doc.json
}
