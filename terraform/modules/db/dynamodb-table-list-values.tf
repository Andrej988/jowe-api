resource "aws_dynamodb_table" "jowe_list_values" {
  name         = var.ENV == "dev" ? "${var.APP_NAME}-list-values-dev" : "${var.APP_NAME}-list-values"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ListId"
  range_key    = "Value"

  attribute {
    name = "ListId"
    type = "S"
  }

  attribute {
    name = "Value"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-${var.APP_NAME}-list-values"
    Environment = var.ENV
    App         = var.APP_NAME
  }

  lifecycle {
    prevent_destroy = true
  }
}
