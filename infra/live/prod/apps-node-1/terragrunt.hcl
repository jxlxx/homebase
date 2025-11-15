include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/hetzner_server"
}

locals {
  repo_url = "REPLACE_WITH_YOUR_REPO_URL"
}

inputs = {
  name         = "apps-node-1"
  location     = "fsn1"
  server_type  = "cx21"
  image        = "ubuntu-24.04"
  ssh_keys     = ["REPLACE_WITH_HCLOUD_SSH_KEY_NAME"]
  backups      = true
  enable_ipv6  = true
  labels = {
    project = "homebase"
    env     = "prod"
    role    = "apps"
  }
  user_data = templatefile("${get_repo_root()}/infra/cloud-init/apps-node.yaml", {
    repo_url = local.repo_url
  })
}
