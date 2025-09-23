output "bucket_arn" {
  value = aws_s3_bucket.mybucket.arn
  description = "The ARN of the S3 bucket"
}

output "bucket_name" {
  value       = aws_s3_bucket.mybucket.bucket
  description = "The name of the S3 bucket"
}

output "bucket_website_endpoint" {
  value = "http://${aws_s3_bucket.mybucket.bucket}.s3-website.${var.aws_region}.amazonaws.com"
  description = "The endpoint URL for the static website"
}


