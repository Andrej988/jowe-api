data "aws_iam_policy_document" "dynamo_db_weight_tracker_measurements_crud_policy" {
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

    resources = [aws_dynamodb_table.weight_tracker_measurements.arn]
  }
}

data "aws_iam_policy_document" "dynamo_db_read_only_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query"
    ]

    resources = [aws_dynamodb_table.weight_tracker_measurements.arn]
  }
}

resource "aws_iam_policy" "dynamo_db_crud_policy" {
  name        = var.ENV == "dev" ? "weight-tracker-dynamo_db_crud_policy-measurements-dev" : "weight-tracker-dynamo_db_crud_policy-measurements"
  path        = "/"
  description = "IAM policy for logging crud dynamo db access"
  policy      = data.aws_iam_policy_document.dynamo_db_weight_tracker_measurements_crud_policy.json
}

resource "aws_iam_policy" "dynamo_db_read_only_policy" {
  name        = var.ENV == "dev" ? "weight-tracker-dynamo_db_read_only_policy-measurements-dev" : "weight-tracker-dynamo_db_read_only_policy-measurements"
  path        = "/"
  description = "IAM policy for logging read only dynamo db access"
  policy      = data.aws_iam_policy_document.dynamo_db_read_only_policy_doc.json
}
