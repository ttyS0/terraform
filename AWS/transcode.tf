variable "nvenc_node_number" {
  default = 0
}

variable "sw_node_number" {
  default = 0
}


data "aws_ami" "ubuntu-amd64" {

  most_recent = true

  owners = [
    "099720109477"
  ]

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    ]
  }
}

data "aws_ami" "ubuntu-arm64" {

  most_recent = true

  owners = [
    "099720109477"
  ]

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"
    ]
  }
}

resource "aws_launch_configuration" "sw" {
  image_id = data.aws_ami.ubuntu-arm64.id
  instance_type = "c6g.8xlarge"
  spot_price = "0.60"

  iam_instance_profile = aws_iam_instance_profile.transcoding-role.name
  security_groups = [
    aws_security_group.allow-ssh.id
  ]

  key_name = aws_key_pair.home.key_name
  associate_public_ip_address = true

  user_data = file("scripts/sw-setup.sh")

  root_block_device {
    volume_size = "100"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "sw" {
  max_size = 5
  min_size = 0
  desired_capacity = var.sw_node_number
  availability_zones = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d"]

  name = "sw"
  launch_configuration = aws_launch_configuration.sw.name

}

resource "aws_launch_configuration" "nvenc" {
  image_id = data.aws_ami.ubuntu-amd64.id
  instance_type = "g4dn.xlarge"
  spot_price = "0.25"

  iam_instance_profile = aws_iam_instance_profile.transcoding-role.name
  security_groups = [
    aws_security_group.allow-ssh.id
  ]

  key_name = aws_key_pair.home.key_name
  associate_public_ip_address = true

  user_data = file("scripts/nvenc-setup.sh")

  root_block_device {
    volume_size = "20"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nvenc" {
  max_size = 5
  min_size = 0
  desired_capacity = var.nvenc_node_number

  name = "nvenc"
  launch_configuration = aws_launch_configuration.nvenc.name
  availability_zones = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d"]

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
      aws_s3_bucket.skj-archive.arn,
      aws_s3_bucket.skj-logs.arn
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
      "${aws_s3_bucket.skj-archive.arn}/transcode/*",
      "${aws_s3_bucket.skj-logs.arn}/transcode/*"
    ]
  }
}

data "aws_iam_policy_document" "transcoding-node" {
  statement {
    effect = "Allow"

    principals {
      identifiers = [
        "ec2.amazonaws.com"]
      type = "Service"
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "transcoding-role" {
  name = "transcoding-role"

  assume_role_policy = data.aws_iam_policy_document.transcoding-node.json
}

resource "aws_iam_role_policy_attachment" "transcoding-role" {
  role = aws_iam_role.transcoding-role.name
  policy_arn = aws_iam_policy.transcoding-policy.arn
}

resource "aws_iam_policy" "transcoding-policy" {
  name = "transcoding-policy"
  description = "EC2 Access for NVENC instances"

  policy = data.aws_iam_policy_document.transcode-bucket.json
}

resource "aws_iam_instance_profile" "transcoding-role" {
  name = "transcoding-role"
  role = aws_iam_role.transcoding-role.name
}


