provider "aws"{
    region = "us-east-2"
    profile = "default"
    shared_credentials_file = "~/.aws/credentials"
}

resource "aws_instance" "prod"{
    instance_type = "t2.micro"
    ami = "ami-08b6f2a5c291246a0"
}