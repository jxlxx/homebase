include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/hetzner_server"
}

locals {
  repo_url    = "https://github.com/jxlxx/homebase.git"
  repo_branch = "main"
}

inputs = {
  name         = "apps-node-1"
  location     = "fsn1"
  server_type  = "cx23"
  image        = "ubuntu-24.04"
  ssh_keys     = ["admin@jxlxx.org"]
  backups      = true
  enable_ipv6  = true
  labels = {
    project = "homebase"
    env     = "prod"
    role    = "apps"
  }
  user_data = templatefile("${get_repo_root()}/infra/cloud-init/apps-node.yaml", {
    repo_url    = local.repo_url
    repo_branch = local.repo_branch
  })
}
