resource "aws_security_group" "allow-ssh" {
  vpc_id = aws_vpc.may_tf.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outgoing All Traffic"
    from_port   = 0
    protocol    = "-1"
    self        = "false"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Incoming SSH Data"
    from_port   = 22
    protocol    = "tcp"
    self        = "false"
    to_port     = 22
  }
}

resource "aws_security_group" "allow-web" {
  vpc_id = aws_vpc.may_tf.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outgoing Web Traffic"
    from_port   = 0
    protocol    = "-1"
    self        = "false"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Incoming HTTP Traffic Data"
    from_port   = 80
    protocol    = "tcp"
    self        = "false"
    to_port     = 80
  }

}
