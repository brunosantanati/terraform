provider "aws" {
  region  = "us-east-1"
}

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