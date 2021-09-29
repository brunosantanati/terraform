terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "brunolabs"

    workspaces {
      name = "aws-infra-brunolabs"
    }
  }
}