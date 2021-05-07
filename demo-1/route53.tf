resource "aws_route53_zone" "aashritha" {
  name = "aashritha.com"
}

resource "aws_route53_record" "www-record" {
  zone_id = aws_route53_zone.aashritha.zone_id
  name    = "www.aashritha.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.web_inst.public_ip]
}

resource "aws_route53_record" "web-records" {
  zone_id = aws_route53_zone.aashritha.zone_id
  name    = "web"
  type    = "CNAME"
  ttl     = "5"
  records = ["www.aashritha.com"]
}

output "NameServers_for_ROUTE53" {
  value = aws_route53_zone.aashritha.name_servers
}
