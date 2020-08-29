variable "nvenc_node_number" {
  default = 0
}


data "aws_ami" "ubuntu" {

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

resource "aws_launch_configuration" "nvenc" {
  image_id = data.aws_ami.ubuntu.id
  instance_type = "g4dn.xlarge"
  spot_price = "0.25"

  iam_instance_profile = aws_iam_instance_profile.nvenc-role.name
  security_groups = [
    aws_security_group.allow-ssh.id
  ]

  key_name = aws_key_pair.home.key_name
  associate_public_ip_address = true

  user_data = file("transcode_setup.sh")

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
  vpc_zone_identifier = [
    aws_default_subnet.az1.id]

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

data "aws_iam_policy_document" "nvenc-node" {
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

resource "aws_iam_role" "nvenc-role" {
  name = "nvenc_role"

  assume_role_policy = data.aws_iam_policy_document.nvenc-node.json
}

resource "aws_iam_role_policy_attachment" "nvenc-role" {
  role = aws_iam_role.nvenc-role.name
  policy_arn = aws_iam_policy.nvenc-policy.arn
}

resource "aws_iam_policy" "nvenc-policy" {
  name = "nvenc-policy"
  description = "EC2 Access for NVENC instances"

  policy = data.aws_iam_policy_document.transcode-bucket.json
}

resource "aws_iam_instance_profile" "nvenc-role" {
  name = "nvenc-role"
  role = aws_iam_role.nvenc-role.name
}


