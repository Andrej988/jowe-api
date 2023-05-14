data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "jowe_api_gateway_sns" {
  name               = var.ENV == "dev" ? "${var.app_name}-api-gateway-sns-dev" : "${var.app_name}-api-gateway-sns"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "jowe_api_gateway_sns_delete_user_data_topic_publish_role_attachment" {
  role       = aws_iam_role.jowe_api_gateway_sns.name
  policy_arn = var.sns_and_sqs_policies["sns_delete_user_data_topic_publish"]
}
