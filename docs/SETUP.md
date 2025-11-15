# Setup Guide

This document explains how to bootstrap Hetzner Object Storage for Terraform state, deploy Hetzner Cloud infrastructure with Terragrunt, and run the Docker services.

## 1. Prerequisites

- Terraform/OpenTofu >= 1.5
- Terragrunt >= 0.55
- Docker + Docker Compose plugin (for local verification or manual runs)
- Hetzner Cloud account with:
  - A **Hetzner Cloud API token** for provisioning servers (`HCLOUD_TOKEN`)
  - An **API token for Hetzner DNS** (create one in the DNS Console; set as `HETZNER_DNS_API_TOKEN`)
  - A **Hetzner Object Storage project** with access + secret keys (Hetzner Console → Object Storage → Access Keys)
- SSH key uploaded to Hetzner Cloud so the server module can reference it by name

Export the credentials before using Terragrunt:

```bash
export HCLOUD_TOKEN="<hcloud-token>"
export HETZNER_DNS_API_TOKEN="<hetzner-dns-token>"
export OBJECT_STORAGE_ACCESS_KEY="<object-storage-access-key>"
export OBJECT_STORAGE_SECRET_KEY="<object-storage-secret-key>"
```

## 2. Bootstrap remote state

The `bootstrap/` directory creates an S3 bucket on Hetzner Object Storage (or any compatible endpoint you configure).

1. Copy `bootstrap/terraform.tfvars.example` to `bootstrap/terraform.tfvars` and set:
   - `bucket_name` — unique bucket name (Hetzner enforces global uniqueness per project)
   - `object_storage_endpoint` — e.g., `https://fsn1.your-object-endpoint`
   - `object_storage_region` — any string (Hetzner ignores it; `eu-central` works fine)
2. Export the access key + secret key (or define them in `terraform.tfvars` but don’t commit secrets).
3. Run Terraform locally (backend defaults to local state):

   ```bash
   cd bootstrap
   terraform init
   terraform apply
   ```

4. Collect the outputs (`bucket_name`, `object_storage_endpoint`, `object_storage_region`).
5. Update `infra/live/root.hcl` with those values.

Terragrunt uses the same object-storage credentials from the environment variables when configuring the S3 backend.

## 3. Provision infrastructure with Terragrunt

All live stacks reside under `infra/live`.

1. **Apps node** – creates a Hetzner Cloud server that runs all Docker workloads via cloud-init. Before applying, edit `infra/live/prod/apps-node-1/terragrunt.hcl` to set `repo_url` (SSH or HTTPS clone URL) and `repo_branch` (e.g., `main`, `develop`) so the machine checks out the correct branch:

   ```bash
   cd infra/live/prod/apps-node-1
   terragrunt init
   terragrunt apply
   ```

   Parameters such as location, server type, SSH key name, repo URL, and branch are set inside the Terragrunt file. Update them as needed before applying. For private repositories, you can either embed a short-lived personal access token in the HTTPS URL or configure an SSH deploy key and switch `repo_url` to the SSH form (`git@...`) after adding the key to cloud-init (see notes below).

2. **DNS** – provisions the `jxlxx.org` zone using Hetzner DNS and creates A records for every service (including Authelia at `auth.jxlxx.org`):

   ```bash
   cd ../dns
   terragrunt init
   terragrunt apply
   ```

3. Repeat the pattern for other environments by adding folders under `infra/live` and adjusting Terragrunt inputs.

## 4. Manage services on the server

cloud-init installs Docker, clones this repository into `/srv/homebase`, and runs `services/deploy-all.sh`. To tweak secrets or redeploy:

```bash
ssh root@<apps-node-ip>
cd /srv/homebase/services
cp traefik/.env.example traefik/.env    # repeat for each service and edit secrets
./deploy-all.sh
```

`deploy-all.sh` ensures the shared `proxy` network exists and then runs `docker compose up -d` for Traefik, Authelia, Home, Gitea, Matrix, HedgeDoc, and Excalidraw. Manage any stack individually with `docker compose -f services/<stack>/docker-compose.yml up -d`.

- **Matrix Synapse** uses a templated config: edit `services/matrix/.env` (copied from `.env.example`) with your secrets and domain, and `services/deploy-all.sh` automatically renders `services/matrix/config/homeserver.yaml` from `homeserver.yaml.example` on each deploy. You can still customize the rendered file afterwards (it’s ignored by Git) if you need additional tweaks.

**Private repository tips**

- Use an SSH deploy key dedicated to this repo, store the private half securely, and extend `infra/cloud-init/apps-node.yaml` to drop it into `/root/.ssh` when rendering user data (avoid committing the key; reference it via environment variables when templating).
- Alternatively, supply an HTTPS URL that embeds a Git provider access token (e.g., `https://<token>@github.com/org/homebase.git`) and rotate the token frequently.
- `repo_branch` in Terragrunt controls which branch cloud-init checks out (`git fetch && git checkout <branch>`), so you can spin up preview environments from feature branches without rewriting the template.

## 5. Authentication management

- Authelia config lives in `services/auth/config/configuration.yml`.
- Users are in `services/auth/config/users_database.yml`. Generate password hashes with `docker run authelia/authelia:4.38 authelia hash-password 'MySecurePass'` and add new entries.
- Replace the example session/storage secrets with long random strings (env variables via `.env` also work).
- Traefik references the middleware `authelia-auth@file` defined in `services/traefik/traefik_dynamic.yml`. Every service router includes that middleware, so everything requires login.

## 6. Updating domains or certificates

- Change hostnames in service Traefik labels, Authelia config, and `.env` files as needed.
- Update `infra/live/prod/dns/terragrunt.hcl` for new records, then re-run Terragrunt in that directory.
- Traefik automatically manages Let’s Encrypt certificates and stores them inside `services/traefik/letsencrypt/acme.json` on the server.

## 7. Destroying resources

To remove infrastructure:

```bash
cd infra/live/prod/dns
terragrunt destroy

cd ../apps-node-1
terragrunt destroy
```

Destroy the remote state bucket by running `terraform destroy` in `bootstrap/` only after all Terragrunt states have been deleted.
