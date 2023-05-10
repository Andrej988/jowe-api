resource "aws_dynamodb_table" "jowe_weight_targets" {
  name         = var.ENV == "dev" ? "${var.app_name}-weight-targets-dev" : "${var.app_name}-weight-targets"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"
  range_key    = "RecordId"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "RecordId"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-${var.app_name}-weight-targets"
    Environment = var.ENV
    App         = var.app_name
  }
}
