
region = "eu-west-1"

project = "kensho"
env     = "prod"

domain_names          = ["static.getkensho.com", "app.getkensho.com"]
create_us_east_1_cert = true
create_regional_cert  = false

s3_bucket_name = "prod-kensho-static-files-207933152498"
s3_domain_name = "static.getkensho.com"

alb_domain_name = "app.getkensho.com"

create_waf = false