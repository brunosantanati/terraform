variable "s3_folders" {
  type        = list
  description = "The list of S3 folders to create"
  default     = ["folder1", "folder2", "folder3"]
}

variable "kms_alias" {
  default = "openbanking-key-2"
}

variable "kms_description" {
  default = "Open Banking Key"
}