resource "aws_ecr_repository" "golang-test" {
  name         = "golang-test"
  force_delete = true

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = {
    Name    = "golang-test"
    Project = var.project
    Env     = var.environment
  }
}