output "uid" {
  # The output "id" includes orgId (orgId:uid). We only want uid
  value       = local.enabled ? split(":", grafana_data_source.cloudwatch[0].id)[1] : null
  description = "The UID of this CloudWatch data source"
}

output "name" {
  value       = local.enabled ? grafana_data_source.cloudwatch[0].name : null
  description = "The name of this CloudWatch data source"
}

output "id" {
  value       = local.enabled ? grafana_data_source.cloudwatch[0].id : null
  description = "The full ID of this CloudWatch data source (orgId:uid)"
}
