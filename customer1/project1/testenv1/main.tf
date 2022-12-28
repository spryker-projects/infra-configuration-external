resource "aws_s3_bucket" "testenv1-bucket" {
  bucket = "testenv1-bucket"

  tags = {
    Name        = "My bucket"
    Customer    = "customer1"
    Environment = "testenv1"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.testenv1-bucket.id
  acl    = "private"
}
