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

resource "aws_iam_role" "jowe_api_gateway_role" {
  name               = var.ENV == "dev" ? "${var.app_name}-api-gateway-sns-dev" : "${var.app_name}-api-gateway-sns"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  depends_on = [
    data.aws_iam_policy_document.assume_role
  ]
}

resource "aws_iam_role_policy" "api_gateway_cloudwatch_policy" {
  name = var.ENV == "dev" ? "${var.app_name}-api-gateway-cloudwatch-policy-dev" : "${var.app_name}-api-gateway-cloudwatch-policy"
  role = aws_iam_role.jowe_api_gateway_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })

  depends_on = [
    aws_iam_role.jowe_api_gateway_role
  ]
}


resource "aws_iam_role_policy_attachment" "jowe_api_gateway_sns_delete_user_data_topic_publish_role_attachment" {
  role       = aws_iam_role.jowe_api_gateway_role.name
  policy_arn = var.sns_and_sqs_policies["sns_delete_user_data_topic_publish"]

  depends_on = [
    aws_iam_role.jowe_api_gateway_role
  ]
}

resource "aws_api_gateway_account" "jowe_api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.iam_for_api_gateway.arn
  depends_on = [
    aws_iam_role.jowe_api_gateway_role
  ]
}
