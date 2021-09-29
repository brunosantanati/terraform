resource "aws_sqs_queue" "openbanking-queue-dlq" {
  name                      = "openbanking-queue-dlq"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Environment = "production"
  }
}

resource "aws_sqs_queue" "openbanking-queue" {
  name                      = "openbanking-queue"
  delay_seconds             = 90
  max_message_size          = 1024
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.openbanking-queue-dlq.arn
    maxReceiveCount     = 4
  })
  depends_on = [
    aws_sqs_queue.openbanking-queue-dlq
  ]

  tags = {
    Environment = "production"
  }
}