resource "aws_sns_topic" "delete_user_data" {
  name              = var.ENV == "dev" ? "${var.APP_NAME}-delete-user-data-topic-dev" : "${var.APP_NAME}-delete-user-data-topic"
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Name        = "sns-topic-${var.APP_NAME}-delete-user-data"
    Environment = var.ENV
    App         = var.APP_NAME
  }

  lifecycle {
    prevent_destroy = true
  }
}
