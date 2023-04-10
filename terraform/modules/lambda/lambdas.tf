variable "dynamodb_read_only_policy_arn" {}
variable "dynamodb_crud_policy_arn" {}
variable "app_name" {}
variable "ENV" {}

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

resource "aws_iam_role" "weight_tracker_api_lambda_crud" {
  name               = "weight-tracker-api-lambda-crud"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "weight_tracker_api_lambda_read_only" {
  name               = "weight-tracker-api-lambda-read-only"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "weight_tracker_api_lambda_crud_AWSLambdaBasicExecutionRole_attachment" {
  role       = aws_iam_role.weight_tracker_api_lambda_crud.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

resource "aws_iam_role_policy_attachment" "weight_tracker_api_lambda_read_only_AWSLambdaBasicExecutionRole_attachment" {
  role       = aws_iam_role.weight_tracker_api_lambda_read_only.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

resource "aws_iam_role_policy_attachment" "weight_tracker_api_lambda_crud_dynamodb_role_attachment" {
  role       = aws_iam_role.weight_tracker_api_lambda_crud.name
  policy_arn = var.dynamodb_crud_policy_arn
}

resource "aws_iam_role_policy_attachment" "weight_tracker_api_lambda_read_only_dynamodb_role_attachment" {
  role       = aws_iam_role.weight_tracker_api_lambda_read_only.name
  policy_arn = var.dynamodb_read_only_policy_arn
}


# LAMBDA: Weight Measurements: Delete Measurement

data "archive_file" "delete_measurement_zip" {
  type        = "zip"
  source_file = "./lambda/delete_measurement/index.mjs"
  output_path = "./temp/delete_measurement.zip"
}

resource "aws_lambda_function" "delete_measurement_lambda" {
  filename      = data.archive_file.delete_measurement_zip.output_path
  function_name = "weight_tracker_api_delete_measurement"
  role          = aws_iam_role.weight_tracker_api_lambda_crud.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.delete_measurement_zip.output_base64sha256

  runtime = "nodejs18.x"

  tags = {
    Name        = "weight_tracker_api_delete_measurement"
    Environment = var.ENV
    App         = var.app_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.weight_tracker_api_lambda_crud_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.weight_tracker_api_lambda_crud_dynamodb_role_attachment,
  ]
}

# LAMBDA: Weight Measurements: Insert Measurement

data "archive_file" "insert_measurement_zip" {
  type        = "zip"
  source_file = "./lambda/insert_measurement/index.mjs"
  output_path = "./temp/insert_measurement.zip"
}

resource "aws_lambda_function" "insert_measurement_lambda" {
  filename      = data.archive_file.insert_measurement_zip.output_path
  function_name = "weight_tracker_api_insert_measurement"
  role          = aws_iam_role.weight_tracker_api_lambda_crud.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.insert_measurement_zip.output_base64sha256

  runtime = "nodejs18.x"

  tags = {
    Name        = "weight_tracker_api_insert_measurement"
    Environment = var.ENV
    App         = var.app_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.weight_tracker_api_lambda_crud_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.weight_tracker_api_lambda_crud_dynamodb_role_attachment,
  ]
}

# LAMBDA: Weight Measurements: Retrieve Measurements

data "archive_file" "retrieve_measurements_zip" {
  type        = "zip"
  source_file = "./lambda/retrieve_measurements/index.mjs"
  output_path = "./temp/retrieve_measurements.zip"
}

resource "aws_lambda_function" "retrieve_measurements_lambda" {
  filename      = data.archive_file.retrieve_measurements_zip.output_path
  function_name = "weight_tracker_api_retrieve_measurements"
  role          = aws_iam_role.weight_tracker_api_lambda_read_only.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.retrieve_measurements_zip.output_base64sha256

  runtime = "nodejs18.x"

  tags = {
    Name        = "weight_tracker_api_retrieve_measurements"
    Environment = var.ENV
    App         = var.app_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.weight_tracker_api_lambda_read_only_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.weight_tracker_api_lambda_read_only_dynamodb_role_attachment,
  ]
}

