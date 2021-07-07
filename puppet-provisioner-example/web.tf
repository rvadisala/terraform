# SSH issues used "-o IdentitiesOnly=yes"

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main_vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Name        = "Aws Main VPC"
    Owner       = "NetEnrich"
    Terraform   = "true"
    Environment = "Production"
  }

}

resource "aws_key_pair" "webkey" {
  key_name   = "webkey2"
  public_key = file(var.WEB_PUBLIC_KEY)

}

data "template_file" "index" {
 count    = length(var.instance_ips)
  template = file("index.html.tpl")
  vars = {
  hostname = "web-${format("%03d", count.index + 1)}"
 }
}

resource "aws_instance" "web_inst" {
 # ami           = "ami-026f33d38b6410e30"   # Centos 7
  ami           = "ami-0c45b2c735e7cbd50"    # Centos 8
  instance_type = "t2.micro"
  key_name      = aws_key_pair.webkey.key_name
  monitoring    = false
  subnet_id     = module.vpc.public_subnets[0]
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp2"
  }
  # user_data              = file("web_bootstrap.sh")
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  security_groups        = [aws_security_group.web_host_sg.id]
  private_ip             = var.instance_ips[count.index]
  count                  = length(var.instance_ips)

  connection {
    user        = "centos"
    private_key = file(var.WEB_PRIVATE_KEY)
    host        = coalesce(self.public_ip)
    type        = "ssh"
  }

  provisioner "file" {
    content     = element(data.template_file.index.*.rendered, count.index)
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    script = "bootstrap_puppet.sh"
  }

  provisioner "file" {
    source      = "web-nginx.conf"
    destination = "/tmp/web-nginx.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/index.html /usr/share/nginx/html/index.html",
      "sudo mv /tmp/web-nginx.conf /etc/nginx/conf.d/web-nginx.conf"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl restart nginx"
    ]
  }

  tags = {
    Name = "web-${format("%03d", count.index + 1)}"
  }

}

resource "aws_security_group" "web_host_sg" {

  vpc_id = module.vpc.vpc_id
  name   = "web_host_sg"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing traffic for webserver"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing traffic for SSH"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }


  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "ALL"
    to_port     = 0
  }

  tags = { Name = "web_host_sg" }
}

resource "aws_elb" "web_elb" {
  name                        = "web-elb"
  internal                    = false
  connection_draining         = true
  connection_draining_timeout = 300
  cross_zone_load_balancing   = true
  health_check {
    healthy_threshold   = 5
    interval            = 30
    target              = "HTTP:80/index.html"
    timeout             = 5
    unhealthy_threshold = 2
  }
  idle_timeout = 60
  instances    = aws_instance.web_inst.*.id
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  security_groups = [aws_security_group.web_host_sg.id]
  subnets         = module.vpc.public_subnets
}
