data "aws_iam_policy_document" "dynamodb_jowe_weight_target_crud_policy" {
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

    resources = [aws_dynamodb_table.jowe_weight_targets.arn]
  }

  depends_on = [
    aws_dynamodb_table.jowe_weight_targets
  ]
}

data "aws_iam_policy_document" "dynamodb_jowe_weight_target_read_only_policy" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query"
    ]

    resources = [aws_dynamodb_table.jowe_weight_targets.arn]
  }

  depends_on = [
    aws_dynamodb_table.jowe_weight_targets
  ]
}

resource "aws_iam_policy" "dynamodb_weight_target_crud_policy" {
  name        = var.ENV == "dev" ? "${var.app_name}-dynamodb-weight-target-crud-policy-dev" : "${var.app_name}-dynamodb-weight-target-crud-policy"
  path        = "/"
  description = "IAM policy for crud dynamo db weight target table access"
  policy      = data.aws_iam_policy_document.dynamodb_jowe_weight_target_crud_policy.json

  depends_on = [
    data.aws_iam_policy_document.dynamodb_jowe_weight_target_crud_policy
  ]
}

resource "aws_iam_policy" "dynamodb_weight_target_read_only_policy" {
  name        = var.ENV == "dev" ? "${var.app_name}-dynamodb-weight-target-read-only-policy-dev" : "${var.app_name}-dynamodb-weight-target-read-only-policy"
  path        = "/"
  description = "IAM policy for read only dynamo db weight target table access"
  policy      = data.aws_iam_policy_document.dynamodb_jowe_weight_target_read_only_policy.json

  depends_on = [
    data.aws_iam_policy_document.dynamodb_jowe_weight_target_read_only_policy
  ]
}
