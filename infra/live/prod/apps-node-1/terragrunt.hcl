include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/hetzner_server"
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
  repo_url                = "https://github.com/jxlxx/homebase.git"
  repo_branch             = "main"
  letsencrypt_environment = "staging"
}
