data "aws_iam_policy_document" "dynamodb_health_tracker_profiles_crud_policy" {
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

    resources = [aws_dynamodb_table.health_tracker_profiles.arn]
  }
}

data "aws_iam_policy_document" "dynamodb_health_tracker_profiles_read_only_policy" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query"
    ]

    resources = [aws_dynamodb_table.health_tracker_profiles.arn]
  }
}

resource "aws_iam_policy" "dynamodb_profiles_crud_policy" {
  name        = var.ENV == "dev" ? "health-tracker-dynamodb-profiles-crud-policy-dev" : "health-tracker-dynamodb-profiles-crud-policy"
  path        = "/"
  description = "IAM policy for crud dynamo db profiles table access"
  policy      = data.aws_iam_policy_document.dynamodb_health_tracker_measurements_crud_policy.json
}

resource "aws_iam_policy" "dynamodb_profiles_read_only_policy" {
  name        = var.ENV == "dev" ? "health-tracker-dynamodb-profiles-read-only-policy-dev" : "health-tracker-dynamodb-profiles-read-only-policy"
  path        = "/"
  description = "IAM policy for read only dynamo db profiles table access"
  policy      = data.aws_iam_policy_document.dynamodb_read_only_policy_doc.json
}
