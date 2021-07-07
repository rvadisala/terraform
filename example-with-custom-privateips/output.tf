output "lb_dnsname" {
  description = "Web Loadbalancer DNS Name"
  value       = aws_elb.web_elb.dns_name
}