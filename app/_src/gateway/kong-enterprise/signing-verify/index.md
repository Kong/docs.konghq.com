---
title: Verify signatures for Signed Kong Images
badge: enterprise
---

Starting with {{site.ee_product_name}} 3.5.0.2, Docker container images are now signed using `cosign` with signatures published to a Docker Hub repository.

This guide provides steps to verify signatures for signed {{site.ee_product_name}} Docker container images in 2 different ways. The first is the minimal example, used to verify an image without leveraging any annotations. The second is the complete example, leveraging optional annotations for increased trust.

For the minimal example, you only need: Docker details, Github repo name, and Github workflow filename.
For the complete example, you will need the same details from above, as well as any of the optional annotations you wish to verify:

| Shorthand | Description | Example Value |
|---|---|---|
| `<repo>` | Github repository | `kong-ee` |
| `<workflow filename>` | Github workflow filename | `release.yml` |
| `<workflow name>` | Github workflow name | `Package & Release` |

Because Kong uses Github Actions to build and release, Kong also uses Github's OIDC identity to sign images; thus many of these details are Github-related.

## Examples

For both examples, you will need to:

1. Ensure `cosign` is installed

2. Collect the necessary image details

3. Set the `COSIGN_REPOSITORY` environment variable

   ```sh
   export COSIGN_REPOSITORY=kong/notary
   ```

{:.important .no-icon}
> Github owner is case-sensitive (`Kong/kong-ee` vs `kong/kong-ee`).

### Minimal Example

Run the `cosign verify ...` command:

```sh
cosign verify \
   <image>:<tag>@sha256:<digest> \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/<repo>/.github/workflows/<workflow filename>'
```

```sh
cosign verify \
   'kong/kong-gateway:3.5.0.2-ubuntu@sha256:208c23d88fa9f563a907dbb29c629c10c6183637898b34cbbafef779ff0965f2' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/kong-ee/.github/workflows/release.yml'
```

### Complete Example

```sh
cosign verify \
   <image>:<tag>@sha256:<digest> \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/<repo>/.github/workflows/<workflow filename>' \
   -a repo='Kong/<repo>' \
   -a workflow='<workflow name>'
```

```sh
cosign verify \
   'kong/kong-gateway:3.5.0.2-ubuntu@sha256:208c23d88fa9f563a907dbb29c629c10c6183637898b34cbbafef779ff0965f2' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/kong-ee/.github/workflows/release.yml' \
   -a repo='Kong/kong-ee' \
   -a workflow='Package & Release'
```
