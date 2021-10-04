data "aws_caller_identity" "current" {}

resource "aws_kms_key" "openbanking-key-2" {
  description         = var.kms_description

  policy = <<POLICY
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
            "Action": [
                "kms:GenerateDataKey",
                "kms:Decrypt"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform-aws",
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/userTest",
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/bruno"
                ]
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_kms_alias" "openbanking-key-alias" {
  target_key_id = aws_kms_key.openbanking-key-2.id
  name          = "alias/${var.kms_alias}"
}