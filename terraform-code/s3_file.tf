resource "aws_s3_object" "object" {
  depends_on = [ aws_s3_bucket.bucket,aws_sns_topic.sns_alert_topic, aws_s3_bucket.bucket,aws_s3_bucket_notification.bucket_notification]

  bucket = aws_s3_bucket.bucket.id
  key    = "file.txt"
  source = "../file.txt"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../file.txt")
}