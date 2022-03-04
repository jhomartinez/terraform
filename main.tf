provider "aws"{
    region = "us-east-2"
    profile = "default"
    shared_credentials_file = "~/.aws/credentials"
}

resource "aws_instance" "prod"{
    instance_type = "t2.micro"
    ami = "ami-08b6f2a5c291246a0"
    tags = {
        Name = "test-ec2"
    }
    key_name = aws_key_pair.user_ssh.key_name
    user_data = file("./scripts/init.sh")
    security_groups = []
}

data "aws_vpc" "default" {
    id = "vpc-8cae28e7"
}

resource "aws_security_group" "http_https" {
    name = "http_https"
    description = "Allows http and https trafics only"
    vpc_id = data.aws_vpc.default.id
    ingress {
        description = "Https from the internet"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [data.aws_vpc.default.cidr_block, "0.0.0.0/0"]
    }
    ingress {
        description = "Http from the internet"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [data.aws_vpc.default.cidr_block, "0.0.0.0/0"]
    }
}

resource "aws_network_interface_sg_attachment" "sg_attachment"{
    security_group_id = aws_security_group.http_https.id
    network_interface_id = aws_instance.prod.primary_network_interface_id
}

resource "aws_key_pair" "user_ssh" {
    key_name = "ssh_instance_key"
    public_key = file("~/.ssh/id_rsa.pub")
}
