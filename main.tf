#create s3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
  tags = {

    Project     = "S3Site"
    Environment = "Dev"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-020cba7c55df1f615"
  instance_type = "t3.micro"

  tags = {
    Name        = "WebServer"
    Project     = "S3Site"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "oc" {
  bucket = aws_s3_bucket.mybucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "pb" {
  bucket = aws_s3_bucket.mybucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.oc,
    aws_s3_bucket_public_access_block.pb
  ]
  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}


resource "aws_s3_object" "index" {
  bucket = "${aws_s3_bucket.mybucket.id}"
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = "${aws_s3_bucket.mybucket.id}"
  key    = "error.html"
  source = "error.html"
    acl = "public-read"
    content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket.mybucket ]
}
