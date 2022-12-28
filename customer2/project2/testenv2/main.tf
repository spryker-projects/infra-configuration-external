resource "aws_s3_bucket" "testenv2-bucket" {
  bucket = "testenv2-bucket"

  tags = {
    Name        = "My bucket"
    Customer    = "customer2"
    Environment = "testenv2"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.testenv2-bucket.id
  acl    = "private"
}
