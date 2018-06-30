variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}

variable "count" {
  description = "number of VMs"
  default = 1
}

