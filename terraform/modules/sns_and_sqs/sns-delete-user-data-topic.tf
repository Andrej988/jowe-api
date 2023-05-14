resource "aws_sns_topic" "delete_user_data" {
  name              = var.ENV == "dev" ? "${var.app_name}-delete-user-data-topic-dev" : "${var.app_name}-delete-user-data-topic"
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Name        = "sns-topic-${var.app_name}-delete-user-data"
    Environment = var.ENV
    App         = var.app_name
  }

  lifecycle {
    prevent_destroy = true
  }
}
