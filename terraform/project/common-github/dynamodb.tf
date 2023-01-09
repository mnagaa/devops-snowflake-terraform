resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "${var.project}-terraform-state-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST" // On-demandモード

  attribute {
    name = "LockID"
    type = "S"
  }
}
