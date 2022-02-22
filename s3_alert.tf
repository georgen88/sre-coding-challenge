resource "aws_sns_topic" "sns_alert_topic" {
  depends_on = [aws_s3_bucket.bucket]

  name = "s3-event-notification-topic-${var.usage}"

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:s3-event-notification-topic-${var.usage}",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.bucket.arn}"}
        }
    }]
}
POLICY
}

resource "aws_sns_topic_subscription" "email-target" {
  depends_on = [aws_sns_topic.sns_alert_topic]

  topic_arn              = aws_sns_topic.sns_alert_topic.arn
  protocol               = "email"
  endpoint               = "jorge.t.nava@gmail.com"
  endpoint_auto_confirms = "true"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "bucket-challenge-${var.usage}"
#   acl    = "private"
#   tags = local.tags
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  depends_on = [aws_sns_topic.sns_alert_topic, aws_s3_bucket.bucket]
  bucket     = aws_s3_bucket.bucket.id
  topic {
    topic_arn     = aws_sns_topic.sns_alert_topic.arn
    events        = ["s3:ObjectCreated:*"]
    # filter_suffix = "*.*"
  }
}