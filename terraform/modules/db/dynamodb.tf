variable "app_name" {}
variable "ENV" {}
variable "dynamodb_measurements_table_name" {}

resource "aws_dynamodb_table" "weight_tracker_measurements" {
  name           = var.dynamodb_measurements_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"
  range_key      = "MeasurementId"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "MeasurementId"
    type = "S"
  }

  # Terraform doesn't care about the non-indexed attributes at creation time
  /*attribute {
    name = "Date"
    type = "S"
  }

  attribute {
    name = "Notes"
    type = "S"
  }

  attribute {
    name = "Weight"
    type = "N"
  }

  attribute {
    name = "BodyFat"
    type = "N"
  }

  attribute {
    name = "BoneMass"
    type = "N"
  }
  
  attribute {
    name = "MuscleMass"
    type = "N"
  }

  attribute {
    name = "Water"
    type = "N"
  }

  attribute {
    name = "EnergyExpenditure"
    type = "N"
  }

  attribute {
    name = "Timestamp"
    type = "N"
  }*/

  #ttl {
  #  attribute_name = "TimeToExist"
  #  enabled        = false
  #}

  tags = {
    Name        = "dynamodb-table-weight-tracker-measurements"
    Environment = var.ENV
    App         = var.app_name
  }
}

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
  name        = "dynamo_db_crud_policy"
  path        = "/"
  description = "IAM policy for logging crud dynamo db access"
  policy      = data.aws_iam_policy_document.dynamo_db_weight_tracker_measurements_crud_policy.json
}

resource "aws_iam_policy" "dynamo_db_read_only_policy" {
  name        = "dynamo_db_read_only_policy"
  path        = "/"
  description = "IAM policy for logging read only dynamo db access"
  policy      = data.aws_iam_policy_document.dynamo_db_read_only_policy_doc.json
}

output "dynamo_db_weight_tracker_crud_policy" {
  description = "ARN of CRUD policy for dynamodb tables"
  value = aws_iam_policy.dynamo_db_crud_policy.arn
}

output "dynamo_db_weight_tracker_read_only_policy" {
  description = "ARN of Read-Only policy for dynamodb tables"
  value = aws_iam_policy.dynamo_db_read_only_policy.arn
}
