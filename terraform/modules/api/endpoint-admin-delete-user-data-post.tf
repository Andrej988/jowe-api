resource "aws_api_gateway_method" "delete_user_data_method_post" {
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  resource_id   = aws_api_gateway_resource.delete_user_data.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.jowe_api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }

  depends_on = [
    aws_api_gateway_resource.delete_user_data
  ]
}

resource "aws_api_gateway_integration" "delete_user_data_integration_post" {
  rest_api_id             = aws_api_gateway_rest_api.jowe_api.id
  resource_id             = aws_api_gateway_resource.delete_user_data.id
  http_method             = aws_api_gateway_method.delete_user_data_method_post.http_method
  integration_http_method = aws_api_gateway_method.delete_user_data_method_post.http_method
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.AWS_REGION}:sns:action/Publish"
  credentials             = aws_iam_role.jowe_api_gateway_role.arn

  request_parameters = {
    "integration.request.querystring.TopicArn" = "'${var.sns_and_sqs_arns["sns_delete_user_data_topic"]}'"
    "integration.request.querystring.Message"  = "context.authorizer.claims.sub"
  }

  cache_key_parameters = [
    "integration.request.querystring.TopicArn"
  ]

  depends_on = [
    aws_api_gateway_method.delete_user_data_method_post
  ]
}

resource "aws_api_gateway_method_response" "delete_user_data_method_post_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.delete_user_data.id
  http_method = aws_api_gateway_method.delete_user_data_method_post.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_integration.delete_user_data_integration_post
  ]
}

resource "aws_api_gateway_method_response" "delete_user_data_method_post_500" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.delete_user_data.id
  http_method = aws_api_gateway_method.delete_user_data_method_post.http_method
  status_code = 500

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models = {
    "application/json" = aws_api_gateway_model.common_error_response.name
  }

  depends_on = [
    aws_api_gateway_integration.delete_user_data_integration_post,
    aws_api_gateway_model.common_error_response
  ]
}

resource "aws_api_gateway_integration_response" "delete_user_data_integration_res_post_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.delete_user_data.id
  http_method = aws_api_gateway_method.delete_user_data_method_post.http_method
  status_code = aws_api_gateway_method_response.delete_user_data_method_post_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = local.cors_access_control_allow_origin_value,
  }

  selection_pattern = ""

  response_templates = {
    "application/json" = "{}"
  }

  depends_on = [
    aws_api_gateway_method_response.delete_user_data_method_post_200
  ]
}

resource "aws_api_gateway_integration_response" "delete_user_data_integration_res_post_500" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.delete_user_data.id
  http_method = aws_api_gateway_method.delete_user_data_method_post.http_method
  status_code = aws_api_gateway_method_response.delete_user_data_method_post_500.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = local.cors_access_control_allow_origin_value
  }

  selection_pattern = ".*\"statusCode\":500.*"

  response_templates = {
    "application/json" = file("./mapping/common/ErrorResponseMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method_response.delete_user_data_method_post_500
  ]
}

