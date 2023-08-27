data "aws_iam_policy_document" "sqs_weight_targets_delete_user_data_queue_process_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]

    resources = [aws_sqs_queue.weight_targets_delete_user_data_queue.arn]
  }

  depends_on = [
    aws_sqs_queue.weight_targets_delete_user_data_queue
  ]
}

resource "aws_iam_policy" "sqs_weight_targets_delete_user_data_queue_process_policy" {
  name        = var.ENV == "dev" ? "${var.APP_NAME}-sqs-weight-targets-delete-user-data-queue-policy-dev" : "${var.APP_NAME}-sqs-weight-targets-delete-user-data-queue-policy"
  path        = "/"
  description = "IAM policy for crud SQS queue weight targets delete user data processing"
  policy      = data.aws_iam_policy_document.sqs_weight_targets_delete_user_data_queue_process_policy.json

  depends_on = [
    data.aws_iam_policy_document.sqs_weight_targets_delete_user_data_queue_process_policy
  ]
}
