provider "aws"{
    region = "us-east-2"
    profile = "default"
    shared_credentials_file = "~/.aws/credentials"
}

resource "aws_instance" "prod"{
    instance_type = "t2.micro"
    ami = "ami-08b6f2a5c291246a0"
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