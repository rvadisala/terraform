variable "AWS_REGION" {
  default = "ap-south-1"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "webkey.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "webkey"
}


variable "AMI" {
  type = map(string)
  default = {
    ap-south-1 = "ami-0ffc7af9c06de0077"
    us-east-2  = "ami-00f8e2c955f7ffa9b"
  }
}

variable "INSTANCE_USER" {
  default = "rvadisala"
}

variable "VOLUME_NAME" {
  default = "/dev/xvdb"
}
