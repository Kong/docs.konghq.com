---
title: Verify Build Provenance for Signed Kong Mesh Images
badge: enterprise
---

Starting with 2.8.0, {{site.mesh_product_name}} produces build provenance for docker container images, which can be verified using `cosign` / `slsa-verifier` with attestations published to a Docker Hub repository.

This guide provides steps to verify build provenance for signed {{site.mesh_product_name}} Docker container images using:

* An example, to verify an image provenance leveraging any optional annotations for increased trust

For the example, you will need a Docker manifest digest, a GitHub repo name, as well as any of the optional annotations you wish to verify:

{:.important .no-icon}
> The Docker manifest digest is required for build provenance verification. The manifest digest can be different from the platform specific image digest for a specific distribution.

| Shorthand | Description | Example Value |
|---|---|---|
| `<repo>` | GitHub repository | `kong-mesh` |
| `<workflow name>` | GitHub workflow name | `build-test-distribute` |
| `<workflow trigger>` | Github workflow trigger name | `push` |
| `<version>` | Artifact version to download | `{{page.version}}` |

Because Kong uses GitHub Actions to build and release, Kong also uses GitHub's OIDC identity to generate build provenance for container images, which is why many of these details are GitHub-related.

## Prerequisites

1. Ensure [cosign](https://docs.sigstore.dev/system_config/installation/) / [slsa-verifier](https://github.com/slsa-framework/slsa-verifier?tab=readme-ov-file#installation) is installed

2. Ensure [`regctl`](https://github.com/regclient/regclient/blob/main/docs/install.md) is installed

3. Collect the necessary image details.

4. The GitHub owner is case-sensitive (`Kong/kong-mesh` vs `kong/kong-mesh`).

## Example with kong/kuma-cp

{{site.mesh_product_name}} image provenance can be verified using `cosign` or `slsa-verifier`:

{% navtabs %}
{% navtab cosign %}

1. Set the `COSIGN_REPOSITORY` environment variable:

   ```sh
   export COSIGN_REPOSITORY=kong/notary
   ```

2. Parse the image manifest using `regctl`

   ```sh
   export IMAGE_DIGEST=$(regctl manifest digest kong/kuma-cp:{{page.version}})
   ```

3. Run the `cosign verify-attestation ...` command:

   ```sh
   cosign verify-attestation \
      kong/kuma-cp:{{page.version}}@${IMAGE_DIGEST} \
      --type='slsaprovenance' \
      --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
      --certificate-identity-regexp='^https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v[0-9]+.[0-9]+.[0-9]+$' \
      --certificate-github-workflow-repository='Kong/kong-mesh' \
      --certificate-github-workflow-name='build-test-distribute' \
      --certificate-github-workflow-trigger='push'
   ```

{% endnavtab %}

{% navtab slsa-verifier %}

1. Parse the image manifest using `regctl`

   ```sh
   export IMAGE_DIGEST=$(regctl manifest digest kong/kuma-cp:{{page.version}})
   ```

2. Run the `slsa-verifier verify-image ...` command:

   ```sh
   slsa-verifier verify-image \
      kong/kuma-cp:{{page.version}}@${IMAGE_DIGEST} \
      --print-provenance \
      --provenance-repository 'kong/notary' \
      --source-uri 'github.com/Kong/kong-mesh' \
      --source-tag '{{page.version}}'
   ```

{% endnavtab %}
{% endnavtabs %}
