resource "aws_route53_record" "website-A-record" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.domain_website}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.website.domain_name}"
    zone_id = "${aws_cloudfront_distribution.website.hosted_zone_id}"
    evaluate_target_health = false
  }
}
