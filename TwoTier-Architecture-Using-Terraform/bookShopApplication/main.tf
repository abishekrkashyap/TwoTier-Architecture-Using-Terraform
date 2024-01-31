# Creating VPC
module "VPC" {
  source = "../modules/VPC"
  Region           = var.applicationRegion
  projectName      = var.projectName
  VPC_CIDR         = var.vpc_CIDR
  PUB_SUB_1_A_CIDR = var.pub_Sub_1_A_CIDR
  PUB_SUB_2_B_CIDR = var.pub_Sub_2_B_CIDR
  PRI_SUB_3_A_CIDR = var.pri_Sub_3_A_CIDR
  PRI_SUB_4_B_CIDR = var.pri_Sub_4_B_CIDR
  PRI_SUB_5_A_CIDR = var.pri_Sub_5_A_CIDR
  PRI_SUB_6_B_CIDR = var.pri_Sub_6_B_CIDR
}

# Creating NAT-Gateway
module "NAT-Gateway" {
  source = "../modules/NAT-GATEWAY"
  PUB_SUB_1_A_ID = module.VPC.PUBLIC_SUB_1_A_ID
  IGW_ID         = module.VPC.IGW_ID
  PUB_SUB_2_B_ID = module.VPC.PUBLIC_SUB_2_B_ID
  VPC_ID         = module.VPC.VPC-Id
  PRI_SUB_3_A_ID = module.VPC.PRIVATE_SUB_3_A_ID
  PRI_SUB_4_B_ID = module.VPC.PRIVATE_SUB_4_B_ID
  PRI_SUB_5_A_ID = module.VPC.PRIVATE_SUB_5_A_ID
  PRI_SUB_6_B_ID = module.VPC.PRIVATE_SUB_6_B_ID
}

# Creating Security Group
module "SecurityGroup" {
  source = "../modules/SG"
  vpcID = module.VPC.VPC-Id
}

# Creating Key for the Instance
module "Key" {
  source = "../modules/KEY"
}

# launching JUMP server or Bastion host 
module "JumpServer" {
  source = "../modules/EC2"
  jumpSG_Id      = module.SecurityGroup.Jump-SG-ID
  PUB_SUB_1_A_ID = module.VPC.PUBLIC_SUB_1_A_ID
  KEY_NAME       = module.Key.keyName
}

# Creating Application Load Balancer
module "ApplicationLoadBanlancer" {
  source = "../modules/ALB"
  projectName    = module.VPC.Project-Name
  ALB_SG_ID      = module.SecurityGroup.ALB-SG-ID
  PUB_SUB_1_A_ID = module.VPC.PUBLIC_SUB_1_A_ID
  PUB_SUB_2_B_ID = module.VPC.PUBLIC_SUB_2_B_ID
  VPC_ID         = module.VPC.VPC-Id  
}

# Creating Auto Scaling Group
module "AutoScalingGroup" {
  source = "../modules/ASG"
  projectName    = module.VPC.Project-Name
  keyName        = module.Key.keyName
  clientSG_Id    = module.SecurityGroup.Client-SG-ID
  PRI_SUB_3_A_ID = module.VPC.PRIVATE_SUB_3_A_ID
  PRI_SUB_4_B_ID = module.VPC.PRIVATE_SUB_4_B_ID
  TG_ARN         = module.ApplicationLoadBanlancer.targetGroup-ARN 
}

# Creating RDS Instance
module "RDS" {
  source = "../modules/RDS"
  dataBase_SG_Id   = module.SecurityGroup.Database-SG-ID
  dataBaseUserName = var.DBUserName
  dataBasePassword = var.DBPassword
  PRI_SUB_5_A_ID   = module.VPC.PRIVATE_SUB_5_A_ID
  PRI_SUB_6_B_ID   = module.VPC.PRIVATE_SUB_6_B_ID  
}

# Creating Cloud Front distribution
module "cloudFront" {
  source = "../modules/CLOUDFRONT"
  ALBDomainName         = module.ApplicationLoadBanlancer.albDNSName
  additionalDomainName  = var.AdditionalDomainName
  certificateDomainName = var.CertificateDomainName
  projectName           = module.VPC.Project-Name
}

# Add Records in Route 53hosted Zone
module "route53" {
  source = "../modules/ROUTE-53"
  cloudFront_DomainName    = module.cloudFront.cloudFront-DomainName
  cloudFront_HostedZone-Id = module.cloudFront.cloudFront_HOSTED_ZONE_ID
}