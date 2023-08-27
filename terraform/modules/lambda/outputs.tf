output "api_lambdas" {
  description = "Lambdas used for API"
  value = {
    meal_recipes_insert = {
      function_name = aws_lambda_function.meal_recipes_insert_lambda.function_name
      invoke_arn    = aws_lambda_function.meal_recipes_insert_lambda.invoke_arn
    }
    meal_recipes_edit = {
      function_name = aws_lambda_function.meal_recipes_edit_lambda.function_name
      invoke_arn    = aws_lambda_function.meal_recipes_edit_lambda.invoke_arn
    }
    meal_recipes_delete = {
      function_name = aws_lambda_function.meal_recipes_delete_lambda.function_name
      invoke_arn    = aws_lambda_function.meal_recipes_delete_lambda.invoke_arn
    }
    meal_recipes_delete_user_data = {
      function_name = aws_lambda_function.meal_recipes_delete_user_data_lambda.function_name
      invoke_arn    = aws_lambda_function.meal_recipes_delete_user_data_lambda.invoke_arn
    }
    meal_recipes_retrieve = {
      function_name = aws_lambda_function.meal_recipes_retrieve_lambda.function_name
      invoke_arn    = aws_lambda_function.meal_recipes_retrieve_lambda.invoke_arn
    }

    weight_measurements_insert = {
      function_name = aws_lambda_function.weight_measurements_insert_lambda.function_name
      invoke_arn    = aws_lambda_function.weight_measurements_insert_lambda.invoke_arn
    }
    weight_measurements_edit = {
      function_name = aws_lambda_function.weight_measurements_edit_lambda.function_name
      invoke_arn    = aws_lambda_function.weight_measurements_edit_lambda.invoke_arn
    }
    weight_measurements_delete = {
      function_name = aws_lambda_function.weight_measurements_delete_lambda.function_name
      invoke_arn    = aws_lambda_function.weight_measurements_delete_lambda.invoke_arn
    }
    weight_measurements_delete_user_data = {
      function_name = aws_lambda_function.weight_measurements_delete_user_data_lambda.function_name
      invoke_arn    = aws_lambda_function.weight_measurements_delete_user_data_lambda.invoke_arn
    }
    weight_measurements_retrieve = {
      function_name = aws_lambda_function.weight_measurements_retrieve_lambda.function_name
      invoke_arn    = aws_lambda_function.weight_measurements_retrieve_lambda.invoke_arn
    }

    weight_targets_insert = {
      function_name = aws_lambda_function.weight_targets_insert_lambda.function_name
      invoke_arn    = aws_lambda_function.weight_targets_insert_lambda.invoke_arn
    }
    weight_targets_delete = {
      function_name = aws_lambda_function.weight_targets_delete_lambda.function_name
      invoke_arn    = aws_lambda_function.weight_targets_delete_lambda.invoke_arn
    }
    weight_targets_delete_user_data = {
      function_name = aws_lambda_function.weight_targets_delete_user_data_lambda.function_name
      invoke_arn    = aws_lambda_function.weight_targets_delete_user_data_lambda.invoke_arn
    }
    weight_targets_retrieve = {
      function_name = aws_lambda_function.weight_targets_retrieve_lambda.function_name
      invoke_arn    = aws_lambda_function.weight_targets_retrieve_lambda.invoke_arn
    }
  }
}
