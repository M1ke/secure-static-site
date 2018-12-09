resource "aws_acm_certificate" "domain" {
  domain_name = "${var.domain_website}"
  validation_method = "DNS"

  tags {
    Name = "${var.cert_name}"
  }

  subject_alternative_names = [
    "www.${var.domain_website}"]
}

resource "aws_route53_record" "domain-acm-validation" {
  name = "${aws_acm_certificate.domain.domain_validation_options.0.resource_record_name}"
  type = "${aws_acm_certificate.domain.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.route53_zone_id}"
  records = [
    "${aws_acm_certificate.domain.domain_validation_options.0.resource_record_value}"]
  ttl = 300
}

resource "aws_route53_record" "domain-acm-validation-www" {
  name = "${aws_acm_certificate.domain.domain_validation_options.1.resource_record_name}"
  type = "${aws_acm_certificate.domain.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.route53_zone_id}"
  records = [
    "${aws_acm_certificate.domain.domain_validation_options.1.resource_record_value}"]
  ttl = 300
}

resource "aws_acm_certificate_validation" "domain" {
  certificate_arn = "${aws_acm_certificate.domain.arn}"
  validation_record_fqdns = [
    "${aws_route53_record.domain-acm-validation.fqdn}",
    "${aws_route53_record.domain-acm-validation-www.fqdn}"]
}
