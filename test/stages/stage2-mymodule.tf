resource "time_sleep" "wait_20_mins_for_iot" {
  depends_on = [ module.iot ]

  // we need to do some throtteling due to rate limits being hit
  // the iot stack would most likely be done in a separate layer as well
  // and prevents needing a separate cluster just for iot prereq
  create_duration = "20m"
}

module "gitops_module" {
  source = "./module"
  depends_on = [ time_sleep.wait_20_mins_for_iot ]

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  kubeseal_cert = module.gitops.sealed_secrets_cert

  instanceid = module.iot.instname
  entitlement_key = module.cp_catalogs.entitlement_key

}

resource null_resource write_namespace {
  depends_on = [module.gitops_module]

  provisioner "local-exec" {
    command = "echo -n '${module.gitops_module.namespace}' > .namespace"
  }
}