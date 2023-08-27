data "aws_iam_policy_document" "dynamodb_jowe_meal_recipes_crud_policy" {
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

    resources = [aws_dynamodb_table.jowe_meal_recipes.arn]
  }

  depends_on = [
    aws_dynamodb_table.jowe_meal_recipes
  ]
}

data "aws_iam_policy_document" "dynamodb_jowe_meal_recipes_read_only_policy" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query"
    ]

    resources = [aws_dynamodb_table.jowe_meal_recipes.arn]
  }

  depends_on = [
    aws_dynamodb_table.jowe_meal_recipes
  ]
}

resource "aws_iam_policy" "dynamodb_meal_recipes_crud_policy" {
  name        = var.ENV == "dev" ? "${var.APP_NAME}-dynamodb-meal_recipes-crud-policy-dev" : "${var.APP_NAME}-dynamodb-meal_recipes-crud-policy"
  path        = "/"
  description = "IAM policy for crud dynamo db meal recipes table access"
  policy      = data.aws_iam_policy_document.dynamodb_jowe_meal_recipes_crud_policy.json

  depends_on = [
    data.aws_iam_policy_document.dynamodb_jowe_meal_recipes_crud_policy
  ]
}

resource "aws_iam_policy" "dynamodb_meal_recipes_read_only_policy" {
  name        = var.ENV == "dev" ? "${var.APP_NAME}-dynamodb-meal_recipes-read-only-policy-dev" : "${var.APP_NAME}-dynamodb-meal_recipes-read-only-policy"
  path        = "/"
  description = "IAM policy for read only dynamo db meal recipes table access"
  policy      = data.aws_iam_policy_document.dynamodb_jowe_meal_recipes_read_only_policy.json

  depends_on = [
    data.aws_iam_policy_document.dynamodb_jowe_meal_recipes_read_only_policy
  ]
}
