provider "aws" {
  region = var.region
}
module "vpc" {
  source = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
  azs = var.azs
}

module "s3" {
  source = "../modules/s3"
  bucket_name = var.bucket_name

}

module "ec2" {
  source = "../modules/ec2"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
}