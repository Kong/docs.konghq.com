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
| `<version>` | Artifact version to download | `{{page.kong_latest.version}}` |

Because Kong uses GitHub Actions to build and release, Kong also uses GitHub's OIDC identity to generate build provenance for container images, which is why many of these details are GitHub-related.

## Examples

### Prerequisites

For both examples, you need to:

1. Ensure `cosign` / `slsa-verifier` is installed.

2. Ensure `regctl` is installed.

3. Collect the necessary image details.

4. Parse the `<manifest_digest>` for the image using `regctl`.

   ```sh
   regctl manifest digest kong/kuma-cp:2.8.0
   ```

5. Set the `COSIGN_REPOSITORY` environment variable:

   ```sh
   export COSIGN_REPOSITORY=kong/notary
   ```

{:.important .no-icon}
> The GitHub owner is case-sensitive (`Kong/kong-mesh` vs `kong/kong-mesh`).

### Example

#### Using Cosign

Run the `cosign verify-attestation ...` command:

```sh
cosign verify-attestation \
   'kong/kuma-cp:2.8.0@<TODO_IMAGE_DIGEST>' \
   --type='slsaprovenance' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='^https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v[0-9]+.[0-9]+.[0-9]+$' \
   --certificate-github-workflow-repository='Kong/kong-mesh' \
   --certificate-github-workflow-name='build-test-distribute' \
   --certificate-github-workflow-trigger='push'
```

#### Using slsa-verifier

Run the `slsa-verifier verify-image ...` command:

```sh
slsa-verifier verify-image \
   'kong/kuma-cp:2.8.0@<TODO_IMAGE_DIGEST>' \
   --print-provenance \
   --provenance-repository 'kong/notary' \
   --source-uri 'github.com/Kong/kong-mesh' \
   --source-tag '2.8.0'
```
