#-----------------------------------------------------------------
# Service Role for Fargate
#-----------------------------------------------------------------

resource "aws_iam_role" "aws_batch_service_role" {
  name = "${var.project}-${var.environment}-batch-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "batch.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role_attachment" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

#-----------------------------------------------------------------
# Execution Role for Batch
#-----------------------------------------------------------------

resource "aws_iam_role" "aws_batch_service_execution_role" {
  name = "${var.project}-${var.environment}-batch-execution-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_batch_execution_role_attachment" {
  role       = aws_iam_role.aws_batch_service_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "test_policy" {
  name = "${var.project}-${var.environment}-batch-execution-inline-policy"
  role = aws_iam_role.aws_batch_service_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue",
          "kms:Decrypt"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

#-----------------------------------------------------------------
# Execution Role for Batch
#-----------------------------------------------------------------

resource "aws_iam_role" "eventbridge_execution_role" {
  name = "${var.project}-${var.environment}-evnetbridge-execution-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "events.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy" "eventbridge_inline" {
  name = "${var.project}-${var.environment}-eventbridge-inline-policy"
  role = aws_iam_role.eventbridge_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : [
          "batch:SubmitJob"
        ],
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}