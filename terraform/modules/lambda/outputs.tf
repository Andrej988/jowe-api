output "api_lambdas_names" {
  description = "Lambdas used for API - Names"
  value = {
    insert_measurement    = aws_lambda_function.insert_measurement_lambda.function_name
    delete_measurement    = aws_lambda_function.delete_measurement_lambda.function_name
    retrieve_measurements = aws_lambda_function.retrieve_measurements_lambda.function_name
  }
}

output "api_lambdas_arns" {
  description = "Lambdas used for API - ARNs"
  value = {
    insert_measurement    = aws_lambda_function.insert_measurement_lambda.invoke_arn
    delete_measurement    = aws_lambda_function.delete_measurement_lambda.invoke_arn
    retrieve_measurements = aws_lambda_function.retrieve_measurements_lambda.invoke_arn
  }
}

