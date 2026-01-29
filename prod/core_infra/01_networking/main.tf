
locals {}



data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ec2_managed_prefix_list" "cloudfront_ipv4" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

module "vpc" {
  source   = "../../../modules/vpc-multi-tier-network"
  env      = var.env
  project  = var.project
  vpc_cidr = "10.0.0.0/16"
}

module "acm" {
  source                             = "../../../modules/acm"
  env                                = var.env
  project                            = var.project
  region                             = var.region
  alb_certificate_domain_name        = var.alb_certificate_domain_name
  cloudfront_certificate_domain_name = var.cloudfront_certificate_domain_name
  providers = {
    aws.us_east_1 = aws.us_east_1
  }
  tags = var.tags
}

module "alb" {
  source            = "../../../modules/alb"
  env               = var.env
  project           = var.project
  internal          = false
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = [module.vpc.public_subnet_a_id, module.vpc.public_subnet_b_id]
  certificate_arn   = module.acm.alb_certificate_arn
  health_check_path = "/"
  tags              = var.tags
  ingress_rules = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      prefix_list_ids = [
        data.aws_ec2_managed_prefix_list.cloudfront_ipv4.id
      ]
      description = "HTTP from CloudFront IPv4"
    },
    {
      from_port = 3000
      to_port   = 3000
      protocol  = "tcp"
      cidr_blocks = [
        module.vpc.vpc_cidr
      ]
      description = "Allow internal vpc traffic"
    }
  ]
}

module "waf_cloudfront" {
  source     = "../../../modules/waf"
  env        = var.env
  project    = var.project
  scope      = "CLOUDFRONT"
  create_waf = true

  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

module "cloudfront" {
  source          = "../../../modules/cloudfront"
  env             = var.env
  project         = var.project
  alb_domain_name = module.alb.alb_dns_name
  web_acl_id      = var.create_waf ? module.waf_cloudfront.web_acl_arn : null
  tags            = var.tags
}

module "cloudtrail" {
  source                 = "../../../modules/cloudtrail"
  environment            = var.env
  project_name           = var.project
  region                 = var.region
  cloudtrail_bucket_name = "${var.env}-${var.project}-cloudtrail"

}
