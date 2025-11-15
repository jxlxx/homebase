# Bootstrap Remote State (Hetzner Object Storage)

This module creates an S3-compatible bucket inside Hetzner Object Storage (or any other S3 endpoint you configure) for Terraform/Terragrunt state.

## Prerequisites

- Terraform >= 1.5
- Access/secret keys for your Hetzner Object Storage project (generate them in the Hetzner Cloud Console; Terraform cannot create them programmatically yet)
- An Object Storage project already provisioned

Export the credentials before running (or provide them via `terraform.tfvars`, but never commit secrets):

```bash
export TF_VAR_object_storage_access_key="<hetzner-access-key>"
export TF_VAR_object_storage_secret_key="<hetzner-secret-key>"
```

## One-time bootstrap

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and set:
   - `bucket_name`: unique state bucket name
   - `object_storage_endpoint`: e.g., `https://fsn1.your-object-storage-endpoint`
   - `object_storage_region`: any valid AWS region string (Hetzner ignores it; `eu-central-1` works)
2. Initialize and apply with the local backend:

   ```bash
   cd bootstrap
   terraform init
   terraform apply
   ```

3. Record the outputs (`bucket_name`, `object_storage_endpoint`, `object_storage_region`). Terragrunt uses those values in `infra/live/root.hcl`.

## Migrate bootstrap to the remote backend

After the bucket exists, reconfigure this directory to store its own state in that bucket. First export the credentials (same as Terragrunt uses):

```bash
export OBJECT_STORAGE_ACCESS_KEY="<hetzner-access-key>"
export OBJECT_STORAGE_SECRET_KEY="<hetzner-secret-key>"
export BOOTSTRAP_BUCKET="<bucket_name>"
export BOOTSTRAP_ENDPOINT="<https://fsn1...>"
```

The backend file (`backend-remote.tf`) already locks in the common settings (region, skip checks, path-style URLs). Run `terraform init` with the remaining parameters:

```bash
terraform init -reconfigure \
  -backend-config="bucket=${BOOTSTRAP_BUCKET}" \
  -backend-config="key=bootstrap/terraform.tfstate" \
  -backend-config="endpoint=${BOOTSTRAP_ENDPOINT}" \
  -backend-config="access_key=${OBJECT_STORAGE_ACCESS_KEY}" \
  -backend-config="secret_key=${OBJECT_STORAGE_SECRET_KEY}"
```

Terraform will migrate the existing local state into the bucket. Future `terraform apply` runs inside `bootstrap/` automatically use that remote backend.

## Wiring Terragrunt

Set these environment variables whenever you run Terragrunt (they match the bucket you created above):

```bash
export OBJECT_STORAGE_ACCESS_KEY="<hetzner-access-key>"
export OBJECT_STORAGE_SECRET_KEY="<hetzner-secret-key>"
```

Update `infra/live/root.hcl` with the bucket name, region string, and endpoint. All Terragrunt stacks will then use the shared S3 backend for remote state.
