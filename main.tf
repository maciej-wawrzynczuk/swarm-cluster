provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "latest-ubuntu" {
most_recent = true
owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_security_group" "default" {
  name = "default"
}

#TODO: restrict cidr
resource "aws_security_group" "swarm-node" {
  name = "swarm-node"
  description = "Docker swarm communication"

  ingress {
    from_port = 2376
    to_port = 2376
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 2377
    to_port = 2377
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 7946
    to_port = 7946
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port = 4789
    to_port = 4789
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "swarm-manager" {
  ami = "${data.aws_ami.latest-ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "maciekw@maciekw-ThinkPad-T460"
  vpc_security_group_ids = ["${data.aws_security_group.default.id}",
                            "${aws_security_group.swarm-node.id}"]
  tags = {
    Name  = "swarm-manager"
    app = "swarm-cluster"
    role = "manager"
  }
}

resource "aws_instance" "swarm-node-1" {
  ami = "${data.aws_ami.latest-ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "maciekw@maciekw-ThinkPad-T460"
  vpc_security_group_ids = ["${data.aws_security_group.default.id}",
                            "${aws_security_group.swarm-node.id}"]
  tags = {
    Name  = "swarm-node-1"
    app = "swarm-cluster"
    role = "node"
  }
}
