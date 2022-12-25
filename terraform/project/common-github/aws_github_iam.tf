# GitHub Actions Readonly

resource "aws_iam_role" "github-actions-ro-role" {
  name = "${var.project}-github-actions-ro-role"
  assume_role_policy = templatefile(
    "./policy/iam_actions_ro_assume_role_policy.json",
    {
      account_id  = var.account_id
      github_org  = local.github_org
      github_repo = local.github_repo
    }
  )
}

resource "aws_iam_policy" "github-actions-ro-policy" {
  name   = "${var.project}-github-actions-ro-policy"
  policy = templatefile("./policy/iam_actions_ro_policy.json", {})
}

resource "aws_iam_role_policy_attachment" "github-actions-ro-role-policy-attachment" {
  role       = aws_iam_role.github-actions-ro-role.name
  policy_arn = aws_iam_policy.github-actions-ro-policy.arn
}

output "github_actions_role_ro_arn" {
  value = aws_iam_role.github-actions-ro-role.arn
}

# GitHub Actions ReadWrite

resource "aws_iam_role" "github-actions-rw-role" {
  name = "${var.project}-github-actions-rw-role"
  assume_role_policy = templatefile(
    "./policy/iam_actions_rw_assume_role_policy.json",
    {
      account_id  = var.account_id
      github_org  = local.github_org
      github_repo = local.github_repo
    }
  )
}

resource "aws_iam_policy" "github-actions-rw-policy" {
  name   = "${var.project}-github-actions-rw-policy"
  policy = templatefile("./policy/iam_actions_rw_policy.json", {})
}

// based on PowerUserAccess, add iam create policy and deny to delete important resources, eg. RDS, DynamoDB, VPC...
resource "aws_iam_role_policy_attachment" "github-actions-rw-role-policy-attachment" {
  role       = aws_iam_role.github-actions-rw-role.name
  policy_arn = aws_iam_policy.github-actions-rw-policy.arn
}

output "github_actions_role_rw_arn" {
  value = aws_iam_role.github-actions-rw-role.arn
}

# GitHub Actions ReadWrite for ECR

resource "aws_iam_role" "github-actions-ecr-rw-role" {
  name = "${var.project}-github-actions-ecr-rw-role"
  assume_role_policy = templatefile(
    "./policy/iam_actions_ecr_rw_assume_role_policy.json",
    {
      account_id  = var.account_id
      github_org  = local.github_org
      github_repo = local.github_repo
    }
  )
}

resource "aws_iam_policy" "github-actions-ecr-rw-policy" {
  name   = "${var.project}-github-actions-ecr-rw-policy"
  policy = templatefile("./policy/iam_actions_ecr_rw_policy.json", {})
}

resource "aws_iam_role_policy_attachment" "github-actions-ecr-rw-role-policy-attachment" {
  role       = aws_iam_role.github-actions-ecr-rw-role.name
  policy_arn = aws_iam_policy.github-actions-ecr-rw-policy.arn
}

output "github_actions_role_ecr_rw_arn" {
  value = aws_iam_role.github-actions-ecr-rw-role.arn
}
