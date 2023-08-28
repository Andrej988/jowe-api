resource "aws_dynamodb_table" "jowe_meal_recipes" {
  name         = var.ENV == "dev" ? "${var.APP_NAME}-meal-recipes-dev" : "${var.APP_NAME}-meal-recipes"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"
  range_key    = "RecipeId"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "RecipeId"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-${var.APP_NAME}-meal-recipes"
    Environment = var.ENV
    App         = var.APP_NAME
  }

  lifecycle {
    prevent_destroy = true
  }
}
