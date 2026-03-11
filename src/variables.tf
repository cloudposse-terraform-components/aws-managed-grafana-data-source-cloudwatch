variable "region" {
  type        = string
  description = "AWS Region"
}

variable "cloudwatch_region" {
  type        = string
  description = "AWS Region where CloudWatch logs are stored. Defaults to the component's region if not specified."
  default     = ""
}

variable "default_log_groups" {
  type        = list(string)
  description = "List of default log groups to make available in Grafana"
  default     = []
}

variable "assume_role_arn" {
  type        = string
  description = "IAM Role ARN to assume for cross-account CloudWatch access. If empty, uses the Grafana workspace's IAM role."
  default     = ""
}

variable "datasource_name" {
  type        = string
  description = "Name for the CloudWatch data source in Grafana. Defaults to the component ID if not specified."
  default     = ""
}

variable "grafana_component_name" {
  type        = string
  description = "The name of the component used to provision an Amazon Managed Grafana workspace"
  default     = "managed-grafana/workspace"
}

variable "grafana_api_key_component_name" {
  type        = string
  description = "The name of the component used to provision an Amazon Managed Grafana API key"
  default     = "managed-grafana/api-key"
}
