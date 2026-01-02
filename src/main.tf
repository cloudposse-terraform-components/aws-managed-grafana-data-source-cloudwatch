locals {
  enabled = module.this.enabled

  # Default the CloudWatch region to the component's region if not specified
  cloudwatch_region = var.cloudwatch_region != "" ? var.cloudwatch_region : var.region

  # Default datasource name to a descriptive name if not specified
  datasource_name = var.datasource_name != "" ? var.datasource_name : module.this.id
}

resource "grafana_data_source" "cloudwatch" {
  count = local.enabled ? 1 : 0

  type = "cloudwatch"
  name = local.datasource_name
  uid  = module.this.id

  json_data_encoded = jsonencode(merge(
    {
      defaultRegion = local.cloudwatch_region
      authType      = var.assume_role_arn != "" ? "ec2_iam_role" : "default"
    },
    var.assume_role_arn != "" ? {
      assumeRoleArn = var.assume_role_arn
    } : {},
    length(var.default_log_groups) > 0 ? {
      defaultLogGroups = var.default_log_groups
    } : {}
  ))
}
