---
title: Verify signatures for signed Kong Mesh images
badge: enterprise
---

Starting with {{site.mesh_product_name}} 2.7.4, Docker container images are now signed using `cosign` with signatures published to a Docker Hub repository.

This guide provides steps to verify signatures for signed {{site.mesh_product_name}} Docker container images with an example used to verify an image leveraging optional annotations for increased trust.

Because Kong uses GitHub Actions to build and release, Kong also uses GitHub's OIDC identity to sign images, which is why many of these details are GitHub-related.

## Prerequisites

* [`Cosign`](https://docs.sigstore.dev/system_config/installation/) is installed

* [`regctl`](https://github.com/regclient/regclient/blob/main/docs/install.md) is installed

* Collect the necessary image details.

* The GitHub owner is case-sensitive (`Kong/kong-mesh` vs `kong/kong-mesh`)

### Example with kong/kuma-cp

The {{site.mesh_product_name}} image signature can be verified using `cosign`:

1. Set the `COSIGN_REPOSITORY` environment variable:

   ```sh
   export COSIGN_REPOSITORY=kong/notary
   ```

2. Parse the image manifest using `regctl`

   ```sh
   IMAGE_DIGEST=$(regctl manifest digest kong/kuma-cp:{{page.version}})
   ```

3. Run the `cosign verify ...` command:

   ```sh
   cosign verify \
      kong/kuma-cp:{{page.version}}@${IMAGE_DIGEST} \
      --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
      --certificate-identity-regexp='https://github.com/Kong/kong-mesh/.github/workflows/kuma-_build_publish.yaml' \
      -a repo='Kong/kong-mesh' \
      -a workflow='build-test-distribute'
   ```
