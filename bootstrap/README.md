# Bootstrap Remote State (Hetzner Object Storage)

This module creates an S3-compatible bucket inside Hetzner Object Storage (or any other S3 endpoint you configure) for Terraform/Terragrunt state.

## Prerequisites

- Terraform >= 1.5
- Access/secret keys for your Hetzner Object Storage project (generate them in the Hetzner Cloud Console; Terraform cannot create them programmatically yet)
- The object storage project itself already provisioned

Export the credentials before running:

```bash
export TF_VAR_object_storage_access_key="<hetzner-access-key>"
export TF_VAR_object_storage_secret_key="<hetzner-secret-key>"
```

Alternatively, place them inside `terraform.tfvars` (do **not** commit secrets).

## One-time bootstrap

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and set:
   - `bucket_name`: unique state bucket name
   - `object_storage_endpoint`: e.g., `https://fsn1.your-object-storage-endpoint`
   - `object_storage_region`: any string (Hetzner ignores it, but the AWS backend requires a value, e.g., `eu-central`)
2. Initialize and apply:

   ```bash
   cd bootstrap
   terraform init
   terraform apply
   ```

3. Record the bucket name, region string, and endpoint (outputs print them). Terragrunt uses these values in `infra/live/terragrunt.hcl`.

## Wiring Terragrunt

Set these environment variables whenever you run Terragrunt:

```bash
export OBJECT_STORAGE_ACCESS_KEY="<hetzner-access-key>"
export OBJECT_STORAGE_SECRET_KEY="<hetzner-secret-key>"
```

Update `infra/live/terragrunt.hcl` to match the outputs (bucket name, region string, endpoint URL). All stacks then use the S3 backend configured there.
