---
title: Verify Signatures for Signed Kong Mesh Images
badge: enterprise
---

Starting with {{site.mesh_product_name}} 2.7.0, Docker container images are now signed using `cosign` with signatures published to a Docker Hub repository.

This guide provides steps to verify signatures for signed {{site.mesh_product_name}} Docker container images in two different ways:
* A minimal example, used to verify an image without leveraging any annotations
* A complete example, leveraging optional annotations for increased trust

For the minimal example, you only need Docker image details, a GitHub repo name, and a GitHub workflow filename.

For the complete example, you need the same details as the minimal example, as well as any of the optional annotations you wish to verify:

| Shorthand | Description | Example Value |
|---|---|---|
| `<repo>` | Github repository | `kong-mesh` |
| `<workflow filename>` | Github workflow filename | `kuma-_build_publish.yaml` |
| `<workflow name>` | Github workflow name | `build-test-distribute` |

Because Kong uses Github Actions to build and release, Kong also uses Github's OIDC identity to sign images, which is why many of these details are Github-related.

## Examples
### Prerequisites
For both examples, you need to:

1. Ensure `cosign` is installed.

2. Collect the necessary image details.

3. Set the `COSIGN_REPOSITORY` environment variable:

   ```sh
   export COSIGN_REPOSITORY=kong/notary-internal
   ```

{:.important .no-icon}
> Github owner is case-sensitive (`Kong/kong-mesh` vs `kong/kong-mesh`).
### Minimal example

Run the `cosign verify ...` command:

```sh
cosign verify \
   kong/<image>:<tag>@sha256:<digest> \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/<repo>/.github/workflows/<workflow filename>'
```

Here's the same example using sample values instead of placeholders:
```sh
cosign verify \
   'kong/kuma-cp:2.7.0-preview.v579166351@sha256:4382a3879994a08df804e0007431907d014f9d4899efb4fb5cedf292f14e6a4a' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/kong-mesh/.github/workflows/kuma-_build_publish.yaml'
```

### Complete example

```sh
cosign verify \
   <image>:<tag>@sha256:<digest> \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/<repo>/.github/workflows/<workflow filename>' \
   -a repo='Kong/<repo>' \
   -a workflow='<workflow name>'
```

Here's the same example using sample values instead of placeholders:
```sh
cosign verify \
   'kong/kuma-cp:2.7.0-preview.v579166351@sha256:4382a3879994a08df804e0007431907d014f9d4899efb4fb5cedf292f14e6a4a' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/kong-mesh/.github/workflows/kuma-_build_publish.yaml' \
   -a repo='Kong/kong-mesh' \
   -a workflow='build-test-distribute'
```