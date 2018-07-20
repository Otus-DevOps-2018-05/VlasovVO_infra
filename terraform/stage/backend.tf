terraform {
  backend "gcs" {
    bucket = "storage-bucket-vvo1"
    prefix = "terraform/stage"
  }
}
