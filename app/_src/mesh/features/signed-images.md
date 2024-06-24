---
title: Verify Signatures for Signed Kong Mesh Images
badge: enterprise
---

Starting with {{site.mesh_product_name}} 2.7.4, Docker container images are now signed using `cosign` with signatures published to a Docker Hub repository.

This guide provides steps to verify signatures for signed {{site.mesh_product_name}} Docker container images using:

* An example, used to verify an image leveraging optional annotations for increased trust

For the example, you need Docker image details, a GitHub repo name, a GitHub workflow filename as well as any of the optional annotations you wish to verify:

| Shorthand | Description | Example Value |
|---|---|---|
| `<repo>` | Github repository | `kong-mesh` |
| `<workflow filename>` | Github workflow filename | `kuma-_build_publish.yaml` |
| `<workflow name>` | Github workflow name | `build-test-distribute` |

Because Kong uses Github Actions to build and release, Kong also uses Github's OIDC identity to sign images, which is why many of these details are Github-related.

## Examples

### Prerequisites

For the example, you need to:

1. Ensure `cosign` is installed.

2. Collect the necessary image details.

3. Set the `COSIGN_REPOSITORY` environment variable:

   ```sh
   export COSIGN_REPOSITORY=kong/notary
   ```

{:.important .no-icon}
> Github owner is case-sensitive (`Kong/kong-mesh` vs `kong/kong-mesh`).

### Example

Run the `cosign verify ...` command:

```sh
cosign verify \
   'kong/kuma-cp:2.7.4@sha256:87c441496c55569946384642d35fefa7f243809ed67a25cedef7f6ee043f9beb' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/kong-mesh/.github/workflows/kuma-_build_publish.yaml' \
   -a repo='Kong/kong-mesh' \
   -a workflow='build-test-distribute'
```
