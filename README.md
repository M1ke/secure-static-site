# Deploy a Secure Static Site with AWS & Terraform

[Read the full article](https://m1ke.me/2018/12/deploy-a-secure-static-site-with-aws-terraform/)

**tl;dr**

1. Run `./setup`
2. Set the `domain_website`, `route53_zone_id` and `aws_region` variables in `main.tf`
3. Run `terraform apply` and type "yes" when prompted
4. Run `./deploy` to deploy the example website at `web/` to your new S3 bucket
5. Visit the domain you entered

Read the article linked above for more comprehensive information as well as troubleshooting tips.

Pull requests welcome to improve chance of errors or add more helpful troubleshooting guides!
