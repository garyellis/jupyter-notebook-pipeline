include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/garyellis/terraform-aws-jupyter-notebook"
}

inputs = {
  name = "gellis-notebook"
  key_name = "garyellis"
  subnet_id = "subnet-01e011432e9d97433"
  vpc_id = "vpc-090fb2bb569edbd85"
  tags = {environment_stage = "jupyter-notebook"}

  # proxy configuration
  http_proxy  = "http://squid-proxy.shared-services.ews.works:3128"
  https_proxy = "http://squid-proxy.shared-services.ews.works:3128"
  no_proxy    = "localhost,127.0.0.1,::1,169.254.169.254,169.254.170.2,ews.works"


  # iam permissions
  kms_cmk_arns     = []
  s3_read_buckets  = []
  s3_write_buckets = []
}
