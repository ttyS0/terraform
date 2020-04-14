data "aws_ami" "ubuntu1804" {

  most_recent = true

  owners = [
    "099720109477"
  ]

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
    ]
  }
}

resource "aws_spot_instance_request" "cuda" {
  ami = data.aws_ami.ubuntu1804.id
  instance_type = "g4dn.xlarge"
  spot_price = "0.20"
  spot_type = "one-time"
  wait_for_fulfillment = true

  key_name = aws_key_pair.home.key_name

  vpc_security_group_ids = [
    aws_security_group.allow-ssh.id
  ]

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.cuda-role.name

  root_block_device {
    volume_size = "10"
  }

  user_data = file("transcode_setup.sh")

}

resource "aws_key_pair" "home" {
  key_name = "home"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDumCrRqbtcApi4chDkQriLIp2Apeev57LMmROsBn4fNwbmWdwe3mWzqIGQIHzfyZMvUs6pJa9MZe5Yy11sDp0GSNZ+EAt6EZsjB36MproGUuTFYdhxoVLPBa+843MsH4VKeW1onMGCBypboXHdEvogorDU3+7j7gP0JPESKujaitA9k+vC35uvVyxKpIcQvR5s6BBI2W7nc1OfrquhZy6TuhmMhYOVKYpGhuF/xtlNGCUQ8oRw5xGV6QcVCWC+3Mm0v7uU8z38C/VpEYMebi2KLvzepfZ9kdrreEsyRPhHwwRzpn8pU4a98R3KoI6uxLl0DuyaldBHqcB0a52Y7Opz sean@nazgul.ttys0.net"
}

resource "aws_security_group" "allow-ssh" {
  name = "allow_ssh"
  description = "Allow SSH from my home IP"
  vpc_id = aws_default_vpc.vpc.id

  ingress {
    description = "SSH"
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "${local.pubip}/32"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

data "aws_iam_policy_document" "transcode-bucket" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.skj-archive.arn
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:PutObjectVersionACL",
      "s3:DeleteObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      "${aws_s3_bucket.skj-archive.arn}/transcode/*"
    ]
  }
}

data "aws_iam_policy_document" "cuda-node" {
  statement {
    effect = "Allow"

    principals {
      identifiers = [
        "ec2.amazonaws.com"]
      type = "Service"
    }

    actions = [
      "sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cuda-role" {
  name = "cuda_role"

  assume_role_policy = data.aws_iam_policy_document.cuda-node.json
}

resource "aws_iam_role_policy_attachment" "cuda-role" {
  role = aws_iam_role.cuda-role.name
  policy_arn = aws_iam_policy.cuda-policy.arn
}

resource "aws_iam_policy" "cuda-policy" {
  name = "cuda-policy"
  description = "EC2 Access for CUDA instances"

  policy = data.aws_iam_policy_document.transcode-bucket.json
}

resource "aws_iam_instance_profile" "cuda-role" {
  name = "cuda-role"
  role = aws_iam_role.cuda-role.name
}

output "cuda-pubip" {
  value = aws_spot_instance_request.cuda.public_ip
}
