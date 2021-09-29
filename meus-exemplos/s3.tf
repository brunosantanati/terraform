resource "aws_s3_bucket" "openbanking-bucket" {
  bucket = "openbanking-bucket"
  acl    = "private"

  tags = {
    Name = "openbanking-bucket"
  }
}

resource "aws_s3_bucket_object" "openbanking-folders" {
  count  = "${length(var.s3_folders)}"
  bucket = "openbanking-bucket"
  acl    = "private"
  key    = "${var.s3_folders[count.index]}/"
  #source = "/dev/null" # Linux
  source = "nul" # Windows
  depends_on = [
    aws_s3_bucket.openbanking-bucket
  ]

  tags = {
    Name = "openbanking-folders"
  }
}

resource "aws_s3_bucket_notification" "openbanking-bucket-notification" {
  bucket = aws_s3_bucket.openbanking-bucket.id

  queue {
    queue_arn     = aws_sqs_queue.openbanking-queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "folder1/"
  }
}