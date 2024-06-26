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

## Prerequisites

1. Ensure [cosign](https://docs.sigstore.dev/system_config/installation/) is installed

2. Ensure [`regctl`](https://github.com/regclient/regclient/blob/main/docs/install.md) is installed

3. Collect the necessary image details.

4. Github owner is case-sensitive (`Kong/kong-mesh` vs `kong/kong-mesh`)

### Example with kong/kuma-cp

{{site.mesh_product_name}} image signature can be verified using `cosign`:

{% navtabs %}
{% navtab cosign %}

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

{% endnavtab %}
{% endnavtabs %}
