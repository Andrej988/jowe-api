resource "aws_sqs_queue" "weight_measurements_delete_user_data_queue" {
  name                      = var.ENV == "dev" ? "${var.app_name}-weight-measurements-delete-user-data-dev" : "${var.app_name}-weight-measurements-delete-user-data"
  delay_seconds             = 5
  max_message_size          = 2048
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 20
  sqs_managed_sse_enabled = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.weight_measurements_delete_user_data_dead_letter_queue.arn
    maxReceiveCount     = 4
  })

  tags = {
    Name        = "sqs-queue-${var.app_name}-weight-measurements-delete-user-data"
    Environment = var.ENV
    App         = var.app_name
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [
    aws_sqs_queue.weight_measurements_delete_user_data_dead_letter_queue
  ]
}

resource "aws_sqs_queue" "weight_measurements_delete_user_data_dead_letter_queue" {
  name = var.ENV == "dev" ? "${var.app_name}-weight-measurements-delete-user-data-dead-letter-dev" : "${var.app_name}-weight-measurements-delete-user-data-dead-letter"
  sqs_managed_sse_enabled = true

  tags = {
    Name        = "sqs-queue-${var.app_name}-weight-measurements-delete-user-data-dead-letter"
    Environment = var.ENV
    App         = var.app_name
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_sqs_queue_policy" "delete_user_data_weight_measurements_subscription" {
  queue_url = aws_sqs_queue.weight_measurements_delete_user_data_queue.id
  policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": [
        "sqs:SendMessage"
      ],
      "Resource": [
        "${aws_sqs_queue.weight_measurements_delete_user_data_queue.arn}"
      ],
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.delete_user_data.arn}"
        }
      }
    }
  ]
}
EOF

  depends_on = [
    aws_sqs_queue.weight_measurements_delete_user_data_queue,
    aws_sns_topic.delete_user_data
  ]
}
