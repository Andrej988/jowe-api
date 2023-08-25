
resource "aws_cloudwatch_event_rule" "user_data_deletion_schedule" {
  name                = var.ENV == "dev" ? "${var.APP_NAME}-cloudwatch-user-data-deletion-schedule-dev" : "${var.APP_NAME}-cloudwatch-user-data-deletion-schedule"
  description         = "Scheduler for user data deletion"
  schedule_expression = var.USER_DATA_DELETION_CRON

  tags = {
    Name        = "${var.APP_NAME}-cloudwatch-user-data-deletion-schedule"
    Environment = var.ENV
    App         = var.APP_NAME
  }
}

resource "aws_cloudwatch_event_target" "user_data_deletion_schedule_weight_measurements" {
  rule = aws_cloudwatch_event_rule.user_data_deletion_schedule.name
  arn  = aws_lambda_function.weight_measurements_delete_user_data_lambda.arn

  depends_on = [
    aws_cloudwatch_event_rule.user_data_deletion_schedule,
    aws_lambda_function.weight_measurements_delete_user_data_lambda
  ]
}

resource "aws_cloudwatch_event_target" "user_data_deletion_schedule_weight_targets" {
  rule = aws_cloudwatch_event_rule.user_data_deletion_schedule.name
  arn  = aws_lambda_function.weight_targets_delete_user_data_lambda.arn

  depends_on = [
    aws_cloudwatch_event_rule.user_data_deletion_schedule,
    aws_lambda_function.weight_targets_delete_user_data_lambda
  ]
}
