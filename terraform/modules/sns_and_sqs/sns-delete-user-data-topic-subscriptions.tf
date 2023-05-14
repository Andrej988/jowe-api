resource "aws_sns_topic_subscription" "delete_user_data_weight_measurements" {
  protocol  = "sqs"
  topic_arn = aws_sns_topic.delete_user_data.arn
  endpoint  = aws_sqs_queue.weight_measurements_delete_user_data_queue.arn

  depends_on = [
    aws_sns_topic.delete_user_data,
    aws_sqs_queue.weight_measurements_delete_user_data_queue
  ]
}

resource "aws_sns_topic_subscription" "delete_user_data_weight_targets" {
  protocol  = "sqs"
  topic_arn = aws_sns_topic.delete_user_data.arn
  endpoint  = aws_sqs_queue.weight_targets_delete_user_data_queue.arn

  depends_on = [
    aws_sns_topic.delete_user_data,
    aws_sqs_queue.weight_targets_delete_user_data_queue
  ]
}
