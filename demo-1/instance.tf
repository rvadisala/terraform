# AWS KEY PAIR Declaration
resource "aws_key_pair" "webkey" {
  key_name   = "webkey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)

}

#AWS Resource Declaration
resource "aws_instance" "web_inst" {
  ami              = var.AMI[var.AWS_REGION]
  instance_type    = "t2.micro"
  key_name         = aws_key_pair.webkey.key_name
  subnet_id        = aws_subnet.public_subnet_1.id
  security_groups  = [aws_security_group.allow-ssh.id, aws_security_group.allow-web.id]
  user_data_base64 = data.template_cloudinit_config.config.rendered

  tags = {
    "Name"  = "Web Instance Apache"
    "Owner" = "Netenrich AWS TEAM"
  }

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /bin/bash /tmp/script.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = var.INSTANCE_USER
    private_key = file(var.PATH_TO_PRIVATE_KEY)
    host        = coalesce(self.public_ip, self.private_ip)
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name  = "/dev/sdb"
  volume_id    = aws_ebs_volume.vol1.id
  instance_id  = aws_instance.web_inst.id
  skip_destroy = "true"
  force_detach = "true"
}

resource "aws_ebs_volume" "vol1" {
  availability_zone = "ap-south-1a"
  encrypted         = false
  size              = 8
  type              = "gp2"

}

output "Public_IP" {
  value = [aws_instance.web_inst.public_ip, aws_instance.web_inst.public_dns, aws_instance.web_inst.private_ip, aws_key_pair.webkey.key_name]
}
