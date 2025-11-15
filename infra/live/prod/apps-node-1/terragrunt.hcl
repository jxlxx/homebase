include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/linode_node"
}

locals {
  repo_url     = "REPLACE_WITH_YOUR_REPO_URL"
  instance_tag = "apps-node-1"
}

inputs = {
  label         = "apps-node-1"
  region        = "us-southeast"
  type          = "g6-standard-2"
  image         = "linode/ubuntu24.04"
  ssh_keys      = ["REPLACE_WITH_SSH_PUBKEY"]
  root_password = get_env("LINODE_ROOT_PASS", "")
  backups       = true
  tags          = ["homebase", local.instance_tag, "prod"]
  user_data     = templatefile("${get_repo_root()}/infra/cloud-init/apps-node.yaml", {
    repo_url = local.repo_url
  })
}
