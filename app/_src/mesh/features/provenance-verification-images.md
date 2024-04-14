---
title: Verify Build Provenance for Signed Kong Mesh Images
badge: enterprise
---

Starting with 2.7.0, {{site.mesh_product_name}} produces build provenance for docker container images, which can be verified using `cosign` / `slsa-verifier` with attestations published to a Docker Hub repository.

This guide provides steps to verify build provenance for signed {{site.mesh_product_name}} Docker container images in two different ways:

* A minimal example, used to verify an image without leveraging any annotations
* A complete example, leveraging optional annotations for increased trust

For the minimal example, you only need a Docker manifest digest and a GitHub repo name.

{:.important .no-icon}
> The Docker manifest digest is required for build provenance verification. The manifest digest can be different from the platform specific image digest for a specific distribution.

For the complete example, you need the same details as the minimal example, as well as any of the optional annotations you wish to verify:

| Shorthand | Description | Example Value |
|---|---|---|
| `<repo>` | GitHub repository | `kong-mesh` |
| `<workflow name>` | GitHub workflow name | `build-test-distribute` |
| `<workflow trigger>` | Github workflow trigger name | `push` |

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

5. Set the `COSIGN_REPOSITORY` environment variable:

   ```sh
   export COSIGN_REPOSITORY=kong/notary
   ```

{:.important .no-icon}
> The GitHub owner is case-sensitive (`Kong/kong-mesh` vs `kong/kong-mesh`).

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
   'kumahq/kuma-cp:2.7.0-testprov@sha256:865d9e92fe793d827f20e3c84ff20630a994ae21701ef8b1342bd5418de946eb' \
   --type='slsaprovenance' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='^https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v[0-9]+.[0-9]+.[0-9]+$'
```

The command will exit with `0` when the `cosign` verification is completed:

```sh
...
echo $?
0
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
   'kumahq/kuma-cp:2.7.0-testprov@sha256:865d9e92fe793d827f20e3c84ff20630a994ae21701ef8b1342bd5418de946eb' \
   --print-provenance \
   --source-uri 'github.com/kumahq/kuma'
```

The command will print "Verified SLASA provenance" if successful:

```sh
...
PASSED: Verified SLSA provenance
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
   --certificate-github-workflow-name='<workflow name>' \
   --certificate-github-workflow-trigger='<workflow trigger>'
```

Here's the same example using sample values instead of placeholders:

```sh
cosign verify-attestation \
   'kumahq/kuma-cp:2.7.0-testprov@sha256:865d9e92fe793d827f20e3c84ff20630a994ae21701ef8b1342bd5418de946eb' \
   --type='slsaprovenance' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='^https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v[0-9]+.[0-9]+.[0-9]+$' \
   --certificate-github-workflow-repository='kumahq/kuma' \
   --certificate-github-workflow-name='build-test-distribute' \
   --certificate-github-workflow-trigger='push'
```

#### Using slsa-verifier

Run the `slsa-verifier verify-image ...` command:

```sh
slsa-verifier verify-image \
   <image>:<tag>@sha256:<manifest_digest> \
   --print-provenance \
   --source-uri 'github.com/Kong/<repo>' \
   --source-tag '<release-tag-version>'
```

Here's the same example using sample values instead of placeholders:

```sh
slsa-verifier verify-image \
   'kumahq/kuma-cp:2.7.0-testprov@sha256:865d9e92fe793d827f20e3c84ff20630a994ae21701ef8b1342bd5418de946eb' \
   --print-provenance \
   --source-uri 'github.com/kumahq/kuma' \
   --source-tag '2.7.0-testprov'
```
