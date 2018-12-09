resource "aws_s3_bucket" "website" {
  bucket = "${var.domain_website}-static-site"
  acl = "private" // Public access will be via CloudFront

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id = "non-current-version-expiration"
    enabled = true

    noncurrent_version_expiration {
      days = 90
    }
  }

  tags {
    Name = "${var.bucket_website_name}"
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = "${aws_s3_bucket.website.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "bucket_policy_site",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_cloudfront_origin_access_identity.website.iam_arn}"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.website.arn}/*"
        }
    ]
}
EOF
}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.domain_website}-site-logs"
  acl = "private"

  lifecycle_rule {
    id = "all-logs-90-day-expiration"
    enabled = true

    expiration {
      days = 90
    }
  }

  tags {
    Name = "${var.bucket_logs_name}"
  }
}

resource "aws_s3_bucket" "www-redirect" {
  bucket = "www.${var.domain_website}"
  website {
    redirect_all_requests_to = "https://${var.domain_website}"
  }

  tags {
    Name= "${var.bucket_website_name} www redirect"
  }
}
/*

resource "aws_s3_bucket_policy" "www-redirect" {
  bucket = "${aws_s3_bucket.www-redirect.bucket}"
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "AIDAJEWIPXAYR5K2CAEZK"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.www-redirect.bucket}*/
/*"
        }
    ]
}
EOF
}
*/

output "bucket_name" {
  value = "${aws_s3_bucket.website.bucket}"
}
