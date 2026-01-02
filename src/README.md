# Component: `managed-grafana/data-source/cloudwatch`

This component creates a CloudWatch data source in Amazon Managed Grafana. It enables querying CloudWatch logs and metrics from Grafana dashboards, with support for cross-account access via IAM role assumption.

## Usage

**Stack Level**: Regional (deployed to core-auto where Grafana workspace exists)

This component creates a CloudWatch data source in Grafana for querying AWS CloudWatch logs and metrics. It supports cross-account access via IAM role assumption, allowing a central Grafana workspace to query CloudWatch data from multiple AWS accounts.

### Prerequisites

- Amazon Managed Grafana workspace deployed via the `managed-grafana/workspace` component
- Grafana API key deployed via the `managed-grafana/api-key` component
- (Optional) IAM role in target account for cross-account access

### Example Configuration

```yaml
components:
  terraform:
    grafana/datasource/cloudwatch/defaults:
      metadata:
        component: managed-grafana/data-source/cloudwatch
        type: abstract
      vars:
        enabled: true
        grafana_component_name: grafana
        grafana_api_key_component_name: grafana/api-key

    grafana/datasource/cloudwatch/plat-dev:
      metadata:
        component: managed-grafana/data-source/cloudwatch
        inherits:
          - grafana/datasource/cloudwatch/defaults
      vars:
        name: plat-dev-cloudwatch
        datasource_name: plat-dev-cloudwatch
        assume_role_arn: !terraform.state iam-role/grafana-cloudwatch-access plat-use2-dev role.arn
        cloudwatch_account_id: '{{ index .vars.account_map.full_account_map "plat-dev" }}'
```

### Cross-Account Access

To query CloudWatch data from another AWS account:

1. Create an IAM role in the target account that:
   - Trusts the Grafana workspace's account (e.g., `core-auto`)
   - Has CloudWatch read permissions (logs and metrics)

2. Specify the role ARN in `assume_role_arn`

Example IAM role configuration (using `iam-role` component):

```yaml
components:
  terraform:
    iam-role/grafana-cloudwatch-access:
      metadata:
        component: iam-role
      vars:
        enabled: true
        name: grafana-cloudwatch-access
        principals:
          AWS:
            - 'arn:aws:iam::{{ index .vars.account_map.full_account_map "core-auto" }}:root'
        policy_statements:
          CloudWatchLogsReadAccess:
            effect: Allow
            actions:
              - logs:DescribeLogGroups
              - logs:DescribeLogStreams
              - logs:GetLogEvents
              - logs:GetQueryResults
              - logs:StartQuery
              - logs:StopQuery
            resources:
              - "*"
          CloudWatchMetricsReadAccess:
            effect: Allow
            actions:
              - cloudwatch:GetMetricData
              - cloudwatch:GetMetricStatistics
              - cloudwatch:ListMetrics
            resources:
              - "*"
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0, < 6.0.0 |
| grafana | >= 2.18.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0, < 6.0.0 |
| grafana | >= 2.18.0 |

## Resources

| Name | Type |
|------|------|
| grafana_data_source.cloudwatch | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS Region | `string` | n/a | yes |
| assume_role_arn | IAM Role ARN to assume for cross-account CloudWatch access | `string` | `""` | no |
| cloudwatch_account_id | AWS Account ID where CloudWatch logs are stored | `string` | `""` | no |
| cloudwatch_region | AWS Region where CloudWatch logs are stored | `string` | `""` | no |
| datasource_name | Name for the CloudWatch data source in Grafana | `string` | `""` | no |
| default_log_groups | List of default log groups to make available in Grafana | `list(string)` | `[]` | no |
| grafana_component_name | The name of the component used to provision an Amazon Managed Grafana workspace | `string` | `"managed-grafana/workspace"` | no |
| grafana_api_key_component_name | The name of the component used to provision an Amazon Managed Grafana API key | `string` | `"managed-grafana/api-key"` | no |

## Outputs

| Name | Description |
|------|-------------|
| uid | The UID of this CloudWatch data source |
| name | The name of this CloudWatch data source |
| id | The full ID of this CloudWatch data source (orgId:uid) |

## References

- [Amazon CloudWatch](https://docs.aws.amazon.com/cloudwatch/)
- [Amazon Managed Grafana](https://docs.aws.amazon.com/grafana/)
- [Grafana CloudWatch Data Source](https://grafana.com/docs/grafana/latest/datasources/cloudwatch/)
- [cloudposse-terraform-components](https://github.com/orgs/cloudposse-terraform-components/repositories)
