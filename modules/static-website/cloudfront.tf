resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = "${aws_s3_bucket.website.bucket_domain_name}"
    origin_id = "S3-${var.domain_website}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path}"
    }
  }

  enabled = true
  is_ipv6_enabled = true

  logging_config {
    include_cookies = false
    bucket = "${aws_s3_bucket.logs.bucket_domain_name}"
    prefix = "cloudfront/"
  }

  aliases = [
    "${var.domain_website}"]
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = [
      "HEAD",
      "GET",
      "OPTIONS"]
    cached_methods = [
      "HEAD",
      "GET"]
    target_origin_id = "S3-${var.domain_website}"

    forwarded_values {
      query_string = false
      headers = []

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = "${var.lambda_arn}"
      include_body = false
    }

    viewer_protocol_policy = "redirect-to-https"
    default_ttl = "${var.ttl}"
    max_ttl = "${var.ttl}"
    min_ttl = "${var.ttl}"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    minimum_protocol_version = "TLSv1.1_2016"
    acm_certificate_arn = "${var.acm_arn}"
    ssl_support_method = "sni-only"
  }

  custom_error_response {
    error_code = 403
    error_caching_min_ttl = 300
    response_page_path = "/404.html"
    response_code = 404
  }

  custom_error_response {
    error_code = 404
    error_caching_min_ttl = 300
    response_page_path = "/404.html"
    response_code = 404
  }

  tags {
  }
}

resource "aws_cloudfront_origin_access_identity" "website" {
  comment = "static content for ${var.domain_website}"
}

resource "aws_cloudfront_distribution" "www-redirect" {
  origin {
    domain_name = "${aws_s3_bucket.www-redirect.bucket_domain_name}"
    origin_id = "S3-www.${var.domain_website}"
  }

  enabled = true
  is_ipv6_enabled = true

  aliases = [
    "www.${var.domain_website}"]
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = [
      "HEAD",
      "GET"]
    cached_methods = [
      "HEAD",
      "GET"]
    target_origin_id = "S3-www.${var.domain_website}"

    forwarded_values {
      query_string = false
      headers = []

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    default_ttl = 0
    max_ttl = 0
    min_ttl = 0
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    minimum_protocol_version = "TLSv1.1_2016"
    acm_certificate_arn = "${var.acm_arn}"
    ssl_support_method = "sni-only"
  }

  tags {
  }
}
