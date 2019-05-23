variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default = "europe-west1"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable machine_type {
  description = "Machine type"
  default     = "g1-small"
}

variable disk_image {
  description = "Disk image"
}
