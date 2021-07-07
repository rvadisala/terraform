variable "WEB_PUBLIC_KEY" {
  description = "Public Key for webservers"
  default     = "webkey.pub"
}

variable "WEB_PRIVATE_KEY" {
  description = "Private Key for webservers"
  default     = "webkey"
}


variable "instance_ips" {
  description = "The IPs to use for our instances"
  default     = ["10.0.101.49", "10.0.101.50"]
}

