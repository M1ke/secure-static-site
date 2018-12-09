# User chosen as required
variable "route53_zone_id" {}
variable "domain_website" {}

# Can be set if desired
variable "cert_name" {
  default = "Static website certificate"
}

output "acm_arn" {
  value = "${aws_acm_certificate.domain.arn}"
}
