variable "bucket_name" {
  description = "The name of the S3 bucket to store Terraform state files."
  type        = string
  default     = "my-terraform-state-bucket"

}

variable "bucket_region" {
  description = "The AWS region where the S3 bucket will be created."
  type        = string
  default     = "us-east-1"
}

variable "bucket_tags" {
  description = "A map of tags to assign to the S3 bucket."
  type        = map(string)
  default = {
    Environment = "Dev"
    ManagedBy   = "Brian"
  }
}