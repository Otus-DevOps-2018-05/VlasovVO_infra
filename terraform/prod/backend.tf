terraform {
  backend "gcs" {
    bucket = "storage-bucket-vvo2"
    prefix = "terraform/prod"
  }
}
