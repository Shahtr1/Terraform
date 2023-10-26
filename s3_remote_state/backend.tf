terraform {
  backend "s3" {
    bucket         = "shahrukhmasterterraform"
    key            = "s3_backend.tfstate"
    dynamodb_table = "s3-state-lock"
    region         = "ap-south-1"
    access_key     = "**"
    secret_key     = "**"
  }
}
