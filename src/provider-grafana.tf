module "grafana" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "2.0.0"

  component = var.grafana_component_name

  context = module.this.context
}

module "grafana_api_key" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "2.0.0"

  component = var.grafana_api_key_component_name

  context = module.this.context
}

data "aws_ssm_parameter" "grafana_api_key" {
  name = module.grafana_api_key.outputs.ssm_path_grafana_api_key
}

provider "grafana" {
  url  = format("https://%s/", module.grafana.outputs.workspace_endpoint)
  auth = data.aws_ssm_parameter.grafana_api_key.value
}
