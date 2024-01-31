variable "projectName" {
  
}
variable "AMI" {
    default =  "ami-053b0d53c279acc90"
    // AMI not as per my account
}

variable "CPU" {
  default = "t2.micro"
}

variable "keyName" {
  
}
variable "clientSG_Id" {
  
}
variable "maxSize" {
  default = 6
}
variable "minSize" {
  default = 2
}
variable "desiredCap" {
  default = 3
}
variable "asgHealthCheckType" {
  default = "ELB"
}
variable "PRI_SUB_3_A_ID" {

}
variable "PRI_SUB_4_B_ID" {

}
variable "TG_ARN" {
    
}
