locals {
  ports = {
    http  = 80
    https = 443
    ssh   = 22
    docdb = 27017
  }

  vpc_cidr                = "10.0.0.0/16"
  vpc_azs                 = slice(data.aws_availability_zones.available.names, 0, 3)
  vpc_flow_s3_bucket_name = "vpc-flow-logs-${random_pet.this.id}"
}

#-------------------------------------------------------------------------------
# VPC

data "aws_availability_zones" "available" {}

#tfsec:ignore:aws-ec2-no-public-ingress-acl
#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1"

  name = module.this.name

  cidr                       = local.vpc_cidr
  azs                        = local.vpc_azs
  manage_default_network_acl = true
  intra_subnets              = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets             = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  private_subnets            = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]

  intra_subnet_tags = {
    Visibility = "intra"
  }
  public_subnet_tags = {
    Visibility = "public"
  }
  private_subnet_tags = {
    Visibility = "private"
  }

  enable_dns_support     = true
  enable_dns_hostnames   = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_flow_log           = true
  flow_log_file_format      = "parquet"
  flow_log_destination_type = "s3"
  flow_log_destination_arn  = module.vpc_flow_s3_bucket.s3_bucket_arn
  vpc_flow_log_tags         = module.this.tags
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.1"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    cloudwatch = {
      service = "monitoring"
    },
    cloudwatch-events = {
      service = "events"
    },
    cloudwatch-logs = {
      service = "logs"
    },
    ecs = {
      service = "ecs"
    },
    ecs-agent = {
      service = "ecs-agent"
    },
    ecs-telemetry = {
      service = "ecs-telemetry"
    },
    elastic-load-balancing = {
      service = "elasticloadbalancing"
    },
    kms = {
      service = "kms"
    },
    s3 = {
      service = "s3"
    },
  }
}

#-------------------------------------------------------------------------------
# VPC Flow S3 Bucket

#TODO: Enable bucket logging and send logs to bucket on security account.
#tfsec:ignore:aws-s3-enable-versioning
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-bucket-encryption
#tfsec:ignore:aws-s3-encryption-customer-key
module "vpc_flow_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.14"

  bucket        = local.vpc_flow_s3_bucket_name
  policy        = data.aws_iam_policy_document.vpc_flow_log_s3.json
  force_destroy = true

  lifecycle_rule = [
    {
      id      = "transition-old-logs"
      enabled = true

      transition = [
        {
          days          = 30
          storage_class = "ONEZONE_IA"
        },
        {
          days          = 60
          storage_class = "GLACIER"
        }
      ]
    }
  ]
}

data "aws_iam_policy_document" "vpc_flow_log_s3" {
  statement {
    sid = "AWSLogDeliveryWrite"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = ["arn:aws:s3:::${local.vpc_flow_s3_bucket_name}/AWSLogs/*"]
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = ["arn:aws:s3:::${local.vpc_flow_s3_bucket_name}"]
  }
}
