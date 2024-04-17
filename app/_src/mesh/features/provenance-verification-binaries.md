---
title: Verify Build Provenance for Kong Mesh Binaries
badge: enterprise
---

Starting with 2.7.0, {{site.mesh_product_name}} produces build provenance for binary artifacts, which can be verified using `cosign` / `slsa-verifier` with attestations published to a Docker Hub repository.

This guide provides steps to verify build provenance for signed {{site.mesh_product_name}} binary artifacts in two different ways:

* A minimal example, used to verify an binary artifacts without leveraging any annotations
* A complete example, leveraging optional annotations for increased trust

For the minimal example, you only need a compressed binary file and provenance file.

For the complete example, you need the same details as the minimal example, as well as any of the optional annotations you wish to verify:

| Shorthand | Description | Example Value |
|---|---|---|
| `<repo>` | GitHub repository | `kong-mesh` |
| `<workflow name>` | GitHub workflow name | `build-test-distribute` |
| `<workflow trigger>` | Github workflow trigger name | `push` |

Because Kong uses GitHub Actions to build and release, Kong also uses GitHub's OIDC identity to generate build provenance for binary artifacts, which is why many of these details are GitHub-related.

## Examples

### Prerequisites

For both examples, you need to:

1. Ensure `slsa-verifier` is installed.

2. [Download binary artifacts]() of {{site.mesh_product_name}}

3. [Download provenance file for binary artifacts]() of {{site.mesh_product_name}}

{:.important .no-icon}
> The GitHub owner is case-sensitive (`Kong/kong-mesh` vs `kong/kong-mesh`).

### Minimal example

#### Using slsa-verifier

Run the `slsa-verifier verify-artifact...` command:

```sh
slsa-verifier verify-artifact \
   --print-provenance \
   --provenance-path '<path to binary-provenance-file>' \
   --source-uri 'github.com/Kong/<repo>' \
   '<path to binary-artifact>.tar.gz'
```

Here's the same example using sample values instead of placeholders where the download path is assumed to `/tmp`:

```sh
slsa-verifier verify-artifact \
   --print-provenance \
   --provenance-path '/tmp/<binary-provenance-file>.intoto.jsonl' \
   --source-uri 'github.com/Kong/<repo>' \
   '/tmp/<binary-artifact>.tar.gz'
```

The command will print "Verified SLASA provenance" if successful:

```sh
...
PASSED: Verified SLSA provenance
```

### Complete example

#### Using slsa-verifier

Run the `slsa-verifier verify-artifact ...` command:

```sh
slsa-verifier verify-artifact \
   --print-provenance \
   --provenance-path '<path to binary-provenance-file>' \
   --source-uri 'github.com/Kong/<repo>' \
   --source-tag '<release-tag-version>' \
   '<path to binary-artifact>.tar.gz'
```

Here's the same example using sample values instead of placeholders where the download path is assumed to `/tmp`:

```sh
slsa-verifier verify-artifact \
   --print-provenance \
   --provenance-path '/tmp/<binary-provenance-file>.intoto.jsonl' \
   --source-uri 'github.com/Kong/<repo>' \
   --source-tag '2.7.0' \
   '/tmp/<binary-artifact>.tar.gz'
```
