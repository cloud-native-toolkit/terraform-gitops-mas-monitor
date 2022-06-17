module "iot" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-mas-iot"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  kubeseal_cert = module.gitops.sealed_secrets_cert

  instanceid = module.mas_kafka.instanceid
  workspace_id = "demo"
  entitlement_key = module.cp_catalogs.entitlement_key
  jdbc_scope = module.masjdbc.scope
 
}
