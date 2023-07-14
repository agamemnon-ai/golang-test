#-----------------------------------------------------------------
# Log Group for shot-batch
#-----------------------------------------------------------------

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/aws/ecs/${var.project}-${var.environment}-shot-batch"
  retention_in_days = 1
}


#-----------------------------------------------------------------
# Log Group for scheduling-batch
#-----------------------------------------------------------------

resource "aws_cloudwatch_log_group" "cloudwatch_log_group-scheduling" {
  name              = "/aws/ecs/${var.project}-${var.environment}-scheduling-execution-batch"
  retention_in_days = 1
}