#-----------------------------------------------------------------
# Security Group for Batch
#-----------------------------------------------------------------

resource "aws_security_group" "batch_sg" {
  name        = "${var.project}-${var.environment}-batch-sg"
  description = "security group for batch"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-alb-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "batch_outbound_rule" {
  security_group_id = aws_security_group.batch_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

#-----------------------------------------------------------------
# Security Group for VPC Endpoint
#-----------------------------------------------------------------


resource "aws_security_group" "vpcendpoint_sg" {
  name        = "${var.project}-${var.environment}-vpcendpoint-sg"
  description = "security group for VPCEndpoint"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-vpcendpoint-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "vpcendpoint_outbound_rule" {
  security_group_id = aws_security_group.vpcendpoint_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "vpcendpoint_inbound_rule1" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.vpcendpoint_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}