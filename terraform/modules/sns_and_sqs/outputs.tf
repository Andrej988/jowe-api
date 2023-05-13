output "sns_and_sqs_arns" {
  description = "SQS and SNS queues/topics"
  value = {
    sns_delete_user_data_topic                     = aws_sns_topic.delete_user_data.arn
    sqs_weight_measurements_delete_user_data_queue = aws_sqs_queue.weight_measurements_delete_user_data_queue.arn
    sqs_weight_targets_delete_user_data_queue      = aws_sqs_queue.weight_targets_delete_user_data_queue.arn
  }
}

output "sns_and_sqs_policies" {
  description = "Policies for SNS and SQS"
  value = {
    sns_delete_user_data_topic_publish             = aws_iam_policy.sns_delete_user_data_topic_publish_policy.arn
    sqs_weight_measurements_delete_user_data_queue = aws_iam_policy.sqs_weight_measurements_delete_user_data_queue_process_policy.arn
    sqs_weight_targets_delete_user_data_queue      = aws_iam_policy.sqs_weight_targets_delete_user_data_queue_process_policy.arn
  }
}
