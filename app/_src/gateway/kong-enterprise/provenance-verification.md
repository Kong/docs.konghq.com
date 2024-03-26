---
title: Verify Build Provenance for Signed Kong Images
badge: enterprise
---

Kong produces build provenance for docker container images, which can be verified using `cosign` / `slsa-verifier` with attestations published to a Docker Hub repository.

This guide provides steps to verify build provenance for signed {{site.ee_product_name}} Docker container images in two different ways:

* A minimal example, used to verify an image without leveraging any annotations
* A complete example, leveraging optional annotations for increased trust

For the minimal example, you only need a Docker manifest digest and a GitHub repo name.

{:.important .no-icon}
> The Docker manifest digest is required for build provenance verification. The manifest digest can be different from the platform specific image digest for a specific distribution.

For the complete example, you need the same details as the minimal example, as well as any of the optional annotations you wish to verify:

| Shorthand | Description | Example Value |
|---|---|---|
| `<repo>` | GitHub repository | `kong-ee` |
| `<workflow name>` | GitHub workflow name | `Package & Release` |
| `<workflow trigger>` | GitHub workflow trigger | `workflow_dispatch` |

Because Kong uses GitHub Actions to build and release, Kong also uses GitHub's OIDC identity to generate build provenance for container images, which is why many of these details are GitHub-related.

## Examples

### Prerequisites

For both examples, you need to:

1. Ensure `cosign` / `slsa-verifier` is installed.

2. Ensure `regctl` is installed.

3. Collect the necessary image details.

4. Parse the `<manifest_digest>` for the image using `regctl`.

   ```sh
   regctl manifest digest <image>:<tag>
   ```

{:.important .no-icon}
> The GitHub owner is case-sensitive (`Kong/kong-ee` vs `kong/kong-ee`).

### Minimal example

#### Using Cosign

Run the `cosign verify-attestation ...` command:

```sh
cosign verify-attestation \
   <image>:<tag>@sha256:<manifest_digest> \
   --type='slsaprovenance' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='^https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v[0-9]+.[0-9]+.[0-9]+$'
```

Here's the same example using sample values instead of placeholders:

```sh
cosign verify-attestation \
   'kong/kong-gateway:3.6.0.0-ubuntu@sha256:2f4d417efee8b4c26649d8171dd0d26e0ca16213ba37b7a6b807c98a4fd413e8' \
   --type='slsaprovenance' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='^https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v[0-9]+.[0-9]+.[0-9]+$'
```

#### Using slsa-verifier

Run the `slsa-verifier verify-image ...` command:

```sh
slsa-verifier verify-image \
   <image>:<tag>@sha256:<manifest_digest> \
   --print-provenance \
   --source-uri 'github.com/Kong/<repo>'
```

Here's the same example using sample values instead of placeholders:

```sh
slsa-verifier verify-image \
   'kong/kong-gateway:3.6.0.0-ubuntu@sha256:2f4d417efee8b4c26649d8171dd0d26e0ca16213ba37b7a6b807c98a4fd413e8' \
   --print-provenance \
   --source-uri 'github.com/Kong/kong-ee'
```

### Complete example

#### Using Cosign

Run the `cosign verify-attestation ...` command:

```sh
cosign verify-attestation \
   <image>:<tag>@sha256:<manifest_digest> \
   --type='slsaprovenance' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='^https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v[0-9]+.[0-9]+.[0-9]+$' \
   --certificate-github-workflow-repository='Kong/<repo>' \
   --certificate-github-workflow-name='<workflow name>'
```

Here's the same example using sample values instead of placeholders:

```sh
cosign verify-attestation \
   'kong/kong-gateway:3.6.0.0-ubuntu@sha256:2f4d417efee8b4c26649d8171dd0d26e0ca16213ba37b7a6b807c98a4fd413e8' \
   --type='slsaprovenance' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='^https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v[0-9]+.[0-9]+.[0-9]+$' \
   --certificate-github-workflow-repository='Kong/kong-ee' \
   --certificate-github-workflow-name='Package & Release'
```

#### Using slsa-verifier

Run the `slsa-verifier verify-image ...` command:

```sh
slsa-verifier verify-image \
   <image>:<tag>@sha256:<manifest_digest> \
   --print-provenance \
   --source-uri 'github.com/Kong/<repo>' \
   --build-workflow-input official="true"
```

Here's the same example using sample values instead of placeholders:

```sh
slsa-verifier verify-image \
   'kong/kong-gateway:3.6.0.0-ubuntu@sha256:2f4d417efee8b4c26649d8171dd0d26e0ca16213ba37b7a6b807c98a4fd413e8' \
   --print-provenance \
   --source-uri 'github.com/Kong/kong-ee' \
   --build-workflow-input official="true"
```
