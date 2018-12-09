# User chosen as required
variable "route53_zone_id" {}
variable "domain_website" {}

# Can be anything the user wants
variable "bucket_website_name" {
  default = "Static website hosting bucket"
}
variable "bucket_logs_name" {
  default = "Static website logs bucket"
}
# Set this to 0 to disable caching or
# higher to increase cache time
variable "ttl" {
  default = 300
}

# Ideally provided by another service but must
# be valid ARNs in us-east-1
variable "acm_arn" {}
variable "lambda_arn" {}
