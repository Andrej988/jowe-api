output "api_lambdas" {
  description = "Lambdas used for API"
  value = {
    insert_measurement = aws_lambda_function.insert_measurement_lambda.invoke_arn
    delete_measurement = aws_lambda_function.delete_measurement_lambda.invoke_arn
    retrieve_measurements = aws_lambda_function.retrieve_measurements_lambda.invoke_arn
  }
}

