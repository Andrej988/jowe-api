data "aws_iam_policy_document" "sns_delete_user_data_topic_publish_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sns:Publish"
    ]

    resources = [aws_sns_topic.delete_user_data.arn]
  }

  depends_on = [
    aws_sns_topic.delete_user_data
  ]
}

resource "aws_iam_policy" "sns_delete_user_data_topic_publish_policy" {
  name        = var.ENV == "dev" ? "${var.app_name}-sns-delete-user-data-topic-publish-policy-dev" : "${var.app_name}-sns-delete-user-data-topic-publish-policy"
  path        = "/"
  description = "IAM policy for publishing to SNS delete user data topic"
  policy      = data.aws_iam_policy_document.sns_delete_user_data_topic_publish_policy.json

  depends_on = [
    data.aws_iam_policy_document.sns_delete_user_data_topic_publish_policy
  ]
}
