variable "s3_folders" {
  type        = list
  description = "The list of S3 folders to create"
  default     = ["folder1", "folder2", "folder3"]
}