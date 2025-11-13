resource "aws_iam_role" "ec2_role" {
  name = "EC2RoleToFetchSSMParams"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2RoleToFetchSSMParams"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "bastion" {
  ami           = var.ami_id #local.ami_id
  instance_type = "m7i-flex.large"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id = local.public_subnet_id

  # need more for terraform
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("bastion.sh")
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
 #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  #"arn:aws:iam::898080060887:role/EC2RoleToFetchSSMParams"   #"TerraformAdmin"
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-bastion"
    }
  )
}
