#-----------------------------------------------------------------
# Compute Environment
#-----------------------------------------------------------------

resource "aws_batch_compute_environment" "batch_env" {
  compute_environment_name = "${var.project}-${var.environment}-shot-batch"
  compute_resources {

    max_vcpus          = var.shot-batch-vcpu
    security_group_ids = [aws_security_group.batch_sg.id]
    subnets            = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]
    type               = "FARGATE"
  }
  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  depends_on = [
    aws_iam_role_policy_attachment.aws_batch_service_role_attachment
  ]
}


#-----------------------------------------------------------------
# Queue for Shot Batch
#-----------------------------------------------------------------

resource "aws_batch_job_queue" "shot_batch_queue" {
  name                 = "${var.project}-${var.environment}-shot-batch-queue"
  state                = "ENABLED"
  priority             = "1"
  compute_environments = [aws_batch_compute_environment.batch_env.arn]
}


#-----------------------------------------------------------------
# Job Definition for Shot Batch
#-----------------------------------------------------------------

resource "aws_batch_job_definition" "shot_batch_definition" {
  name = "${var.project}-${var.environment}-shot-batch-definition"
  type = "container"

  platform_capabilities = [
    "FARGATE",
  ]

  container_properties = jsonencode({
    image = "${var.shot-batch-image}"

    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    environment = [
      {
        ENV1 = ""
      },
      {
        ENV2 = ""
      }
    ]

    resourceRequirements = [
      {
        type  = "VCPU"
        value = "0.25"
      },
      {
        type  = "MEMORY"
        value = "512"
      }
    ]

    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-group" : "${aws_cloudwatch_log_group.cloudwatch_log_group.name}",
        "awslogs-region" : "us-east-1",
        "awslogs-stream-prefix" : "ecs"
      }
    }

    executionRoleArn = aws_iam_role.aws_batch_service_execution_role.arn
  })
}


#-----------------------------------------------------------------
# Job Definition for Scheduling Batch
#-----------------------------------------------------------------

resource "aws_batch_job_definition" "scheduling_batch_definition" {
  name = "${var.project}-${var.environment}-scheduling-batch-definition"
  type = "container"

  platform_capabilities = [
    "FARGATE",
  ]

  container_properties = jsonencode({
    image = "${var.shot-batch-image}"

    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    environment = [
      {
        ENV1 = ""
      },
      {
        ENV2 = ""
      }
    ]

    resourceRequirements = [
      {
        type  = "VCPU"
        value = "0.25"
      },
      {
        type  = "MEMORY"
        value = "512"
      }
    ]

    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-group" : "${aws_cloudwatch_log_group.cloudwatch_log_group-scheduling.name}",
        "awslogs-region" : "us-east-1",
        "awslogs-stream-prefix" : "ecs"
      }
    }

    executionRoleArn = aws_iam_role.aws_batch_service_execution_role.arn
  })
}