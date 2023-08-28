output "dynamodb_tables" {
  description = "Output data related to dynamodb tables"

  value = {
    weight_measurements = {
      name = aws_dynamodb_table.jowe_measurements.name
      policies = {
        read_write = aws_iam_policy.dynamodb_measurements_crud_policy.arn
        read_only  = aws_iam_policy.dynamodb_measurements_read_only_policy.arn
      }
    }
    weight_targets = {
      name = aws_dynamodb_table.jowe_weight_targets.name
      policies = {
        read_write = aws_iam_policy.dynamodb_weight_target_crud_policy.arn
        read_only  = aws_iam_policy.dynamodb_weight_target_read_only_policy.arn
      }

    }
    meal_recipes = {
      name = aws_dynamodb_table.jowe_meal_recipes.name
      policies = {
        read_write = aws_iam_policy.dynamodb_meal_recipes_crud_policy.arn
        read_only  = aws_iam_policy.dynamodb_meal_recipes_read_only_policy.arn
      }
    }
  }
}
