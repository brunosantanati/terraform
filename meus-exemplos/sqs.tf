resource "aws_sqs_queue" "openbanking-queue-dlq" {
  name                      = "openbanking-queue-dlq"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  kms_master_key_id                 = "alias/${var.kms_alias}"
  kms_data_key_reuse_period_seconds = 300

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
    aws_sqs_queue.openbanking-queue-dlq,
    aws_kms_key.openbanking-key-2
  ]
  kms_master_key_id                 = "alias/${var.kms_alias}"
  kms_data_key_reuse_period_seconds = 300

  tags = {
    Environment = "production"
  }

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:openbanking-queue",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.openbanking-bucket.arn}" }
      }
    }
  ]
}
POLICY
}

/*
EXEMPLO DE POLITICA DE ACESSO QUE USEI EM UM PROJETO

{
  "Version": "2012-10-17",
  "Id": "example-ID",
  "Statement": [
    {
      "Sid": "example-statement-ID",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "SQS:*",
      "Resource": "arn:aws:sqs:sa-east-1:348197166762:nome-fila-aqui",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "account-aqui"
        },
        "ArnLike": {
          "aws:SourceArn": "arn:aws:s3:*:*:nome-bucket-aqui"
        }
      }
    }
  ]
}
*/