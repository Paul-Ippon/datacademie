## Profile
resource "aws_iam_instance_profile" "airbyte" {
  name = "${var.project}-${var.name}-airbyte-profile"
  role = aws_iam_role.airbyte.name
}

## Role
resource "aws_iam_role" "airbyte" {
  name               = "${var.project}-${var.name}-airbyte-role"
  assume_role_policy = data.aws_iam_policy_document.airbyte_assume_role.json
}

## Assume policy
data "aws_iam_policy_document" "airbyte_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Attach policies
resource "aws_iam_role_policy_attachment" "airbyte_ecr" {
  role       = aws_iam_role.airbyte.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
