provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "latest-ubuntu" {
most_recent = true
owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_security_group" "default" {
  name = "default"
}

resource "aws_instance" "swarm-manager" {
  ami = "${data.aws_ami.latest-ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "maciekw@maciekw-ThinkPad-T460"
  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]
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
  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]
  tags = {
    Name  = "swarm-node-1"
    app = "swarm-cluster"
    role = "node"
  }
}
