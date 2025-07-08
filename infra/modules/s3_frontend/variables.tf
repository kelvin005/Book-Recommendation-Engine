variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to host frontend"
}

variable "local_dir" {
  type        = string
  description = "Path to frontend source files"
  default     = "../../frontend"
}

    
