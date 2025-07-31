/*
- Bucket
    - Name
    - Region
    - Tags
- Versioning
- Block public access
- Encryption
- Random
*/

provider "aws" {
  region = var.bucket_region
}

resource "random_string" "random_suffix" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = true
}
locals {
  bucket_name_with_suffix = "${var.bucket_name}-${random_string.random_suffix.result}"
}

resource "aws_s3_bucket" "tfstate" {
  bucket        = local.bucket_name_with_suffix
  force_destroy = true
  tags = merge(
    var.bucket_tags,
    {
      Name = var.bucket_name
    }
  )
}

resource "aws_s3_bucket_versioning" "tfstate-versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate-pab" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate-encryption" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
