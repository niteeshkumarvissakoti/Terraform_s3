output "website_endpoint_url" {
  description = "The url of the S3 bucket website is"
  #value       = aws_s3_bucket.mybucket.website_endpoint
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}