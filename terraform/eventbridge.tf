resource "aws_cloudwatch_event_rule" "scheduling-batch-rule" {
  name                = "${var.project}-${var.environment}-scheduling-batch-rule"
  schedule_expression = var.scheduling-batch-interval
}

resource "aws_cloudwatch_event_target" "target_batch" {
  arn      = aws_batch_job_queue.shot_batch_queue.arn
  rule     = aws_cloudwatch_event_rule.scheduling-batch-rule.name
  role_arn = aws_iam_role.eventbridge_execution_role.arn
  batch_target {
    job_definition = aws_batch_job_definition.scheduling_batch_definition.name
    job_name       = "scheduling-execution-batch"
  }
}