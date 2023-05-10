output "api_lambdas_names" {
  description = "Lambdas used for API - Names"
  value = {
    weight_measurements_insert   = aws_lambda_function.weight_measurements_insert_lambda.function_name
    weight_measurements_delete   = aws_lambda_function.weight_measurements_delete_lambda.function_name
    weight_measurements_retrieve = aws_lambda_function.weight_measurements_retrieve_lambda.function_name
    weight_targets_insert        = aws_lambda_function.weight_targets_insert_lambda.function_name
    weight_targets_delete        = aws_lambda_function.weight_targets_delete_lambda.function_name
    weight_targets_retrieve      = aws_lambda_function.weight_targets_retrieve_lambda.function_name
  }
}

output "api_lambdas_arns" {
  description = "Lambdas used for API - ARNs"
  value = {
    weight_measurements_insert   = aws_lambda_function.weight_measurements_insert_lambda.invoke_arn
    weight_measurements_delete   = aws_lambda_function.weight_measurements_delete_lambda.invoke_arn
    weight_measurements_retrieve = aws_lambda_function.weight_measurements_retrieve_lambda.invoke_arn
    weight_targets_insert        = aws_lambda_function.weight_targets_insert_lambda.invoke_arn
    weight_targets_delete        = aws_lambda_function.weight_targets_delete_lambda.invoke_arn
    weight_targets_retrieve      = aws_lambda_function.weight_targets_retrieve_lambda.invoke_arn
  }
}

