locals {
  tags  = {
    Environment = var.environment
    Owner       = var.owner
    Management  = var.management
    CreatedBy   = var.createdby
  }
}