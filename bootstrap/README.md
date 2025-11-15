# Bootstrap Remote State

This directory creates the Linode Object Storage bucket and access keys used for Terraform/Terragrunt remote state.

## Prerequisites

- Terraform >= 1.5
- Linode API token exported before running: `export LINODE_TOKEN="..."`

## One-time bootstrap

1. Copy `terraform.tfvars.example` to `terraform.tfvars` (or set variables via CLI) and fill in the bucket label/cluster you prefer.
2. Run Terraform locally (the default backend is local; see `backend-local.tf`).

```bash
cd bootstrap
terraform init
terraform apply
```

This creates:

- An Object Storage bucket for state files
- A dedicated access key/secret for the Terraform backend

> The secret access key is returned **once**. Store it securely (e.g., password manager) and do not commit it to Git.

## Wiring Terragrunt

After the bucket exists, update `infra/live/terragrunt.hcl` with the bucket name, cluster/region, and S3 endpoint that terraform output.

Export the Object Storage credentials before running Terragrunt:

```bash
export LINODE_OBJ_ACCESS_KEY="$(terraform -chdir=bootstrap output -raw access_key_id)"
export LINODE_OBJ_SECRET_KEY="$(terraform -chdir=bootstrap output -raw secret_access_key)"
```

(Or store them in a secure secrets manager.)

Terragrunt uses those environment variables when configuring the `remote_state` block.
