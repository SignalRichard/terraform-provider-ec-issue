terraform {
  required_version = "= 1.6.3"

  required_providers {
    ec = {
      source = "elastic/ec"
      version = "0.9.0"
    }
  }

  backend "local" {
    # This should be changed to any other backend configuration, see: https://developer.hashicorp.com/terraform/language/settings/backends/configuration
  }
}

provider "ec" {
  # Configuration options
}


locals {
  ec_region = "azure-eastus"
  stack_version = "8.11.1"
}

# Retrieve the latest stack pack version
data "ec_stack" "latest" {
  version_regex = local.stack_version
  region        = local.ec_region
}

# Create an Elastic Cloud deployment
resource "ec_deployment" "expected_error" {
  # Optional name.
  name = "expected_error"

  region                 = local.ec_region
  version                = local.stack_version 
  deployment_template_id = "azure-general-purpose"

  elasticsearch = {
    hot = {
      node_type_data = "true"
      node_type_ingest = "true"
      node_type_master = "true"
      node_type_ml = "false"
      autoscaling = {}
    }
  }

  kibana = {}

  enterprise_search = {}

  integrations_server = {}
}

# Create an Elastic Cloud deployment
resource "ec_deployment" "unexpected_error" {
  # Optional name.
  name = "unexpected_error"

  region                 = local.ec_region
  version                = data.ec_stack.latest.version
  deployment_template_id = "azure-general-purpose"

  elasticsearch = {
    hot = {
      node_type_data = "true"
      node_type_ingest = "true"
      node_type_master = "true"
      node_type_ml = "false"
      autoscaling = {}
    }
  }

  kibana = {}

  enterprise_search = {}

  integrations_server = {}
}
