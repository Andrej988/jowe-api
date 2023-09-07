data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "jowe_api_lambda_crud" {
  name               = var.ENV == "dev" ? "${var.APP_NAME}-api-lambda-crud-dev" : "${var.APP_NAME}-api-lambda-crud"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "jowe_api_lambda_read_only" {
  name               = var.ENV == "dev" ? "${var.APP_NAME}-api-lambda-read-only-dev" : "${var.APP_NAME}-api-lambda-read-only"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "jowe_api_lambda_crud_AWSLambdaBasicExecutionRole_attachment" {
  role       = aws_iam_role.jowe_api_lambda_crud.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

resource "aws_iam_role_policy_attachment" "jowe_api_lambda_read_only_AWSLambdaBasicExecutionRole_attachment" {
  role       = aws_iam_role.jowe_api_lambda_read_only.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}
