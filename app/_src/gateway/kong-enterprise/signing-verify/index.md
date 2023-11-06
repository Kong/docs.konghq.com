---
title: Verify signatures for Signed Kong Images
badge: enterprise
---

As of {{site.ee_product_name}} version 3.5, Docker container images are now signed using `cosign` with signatures published to a Docker Hub repository.

This guide provides steps to verify signatures for signed {{site.ee_product_name}} Docker container images in 2 different ways. The first is the minimal example, used to verify an image without leveraging any annotations. The second is the complete example, leveraging optional annotations for increased trust.

For the minimal example, you only need: Docker details, Github repo name, and Github workflow filename.
For the complete example, you will need the same details from above, as well as any of the optional annotations you wish to verify:

| "token" | Description | Example Value |
|---|---|---|
| `<sha>` | Github commit sha | `3687f9f32a80a60869cc3c0b7584be9696973e7e` |
| `<repo>` | Github repository | `kong-ee` |
| `<workflow filename>` | Github workflow filename | `release.yml` |
| `<workflow name>` | Github workflow name | `Package & Release` |

Because Kong uses Github Actions to build and release, Kong also uses Github's OIDC identity to sign images; thus many of these details are Github-related.

## Examples

For both examples, you will need to:

1. Ensure `cosign` is installed

2. Collect the necessary image details

3. Set the `COSIGN_REPOSITORY` environment variable (`kong/notary` or `kong/notary-internal`)

   ```sh
   export COSIGN_REPOSITORY=kong/notary-internal
   ```

{:.important .no-icon}
> Github owner is case-sensitive (`Kong/kong-ee` vs `kong/kong-ee`).

### Minimal Example

Run the `cosign verify ...` command:

```sh
cosign verify \
   <image>:<tag>@sha256:<digest> \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/<repo>/.github/workflows/<workflow filename>*'
```

```sh
cosign verify \
   'kong/kong-gateway-dev:3687f9f32a80a60869cc3c0b7584be9696973e7e@sha256:65310a3947775cb3ac30f3c21504c2c8d28a688825b2256a40678bc2cbee1189' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/kong-ee/.github/workflows/release.yml*'
```

### Complete Example

```sh
cosign verify \
   <image>:<tag>@sha256:<digest> \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/<repo>/.github/workflows/<workflow filename>*' \
   -a repo="Kong/<repo>" \
   -a workflow="<workflow name>" \
   -a sha="<sha>"
```

```sh
cosign verify \
   'kong/kong-gateway-dev:3687f9f32a80a60869cc3c0b7584be9696973e7e@sha256:65310a3947775cb3ac30f3c21504c2c8d28a688825b2256a40678bc2cbee1189' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/kong-ee/.github/workflows/release.yml*' \
   -a repo="Kong/kong-ee" \
   -a workflow="Package & Release" \
   -a sha="3687f9f32a80a60869cc3c0b7584be9696973e7e"
```
