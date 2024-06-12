---
title: Verify Build Provenance for Kong Mesh Binaries
badge: enterprise
---

Starting with 2.7.4, {{site.mesh_product_name}} produces build provenance for binary artifacts, which can be verified using `cosign` / `slsa-verifier` with attestations published to a Docker Hub repository.

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
| `<version>` | Artifact version to download | `2.7.4` |
| `<binary-files>` | Compressed binary files for the specified version | `kong-mesh-2.7.4-*-*.tar.gz` |
| `<provenance-file>` | Binary provenance file | `kong-mesh.intoto.jsonl` |

Because Kong uses GitHub Actions to build and release, Kong also uses GitHub's OIDC identity to generate build provenance for binary artifacts, which is why many of these details are GitHub-related.

## Examples

### Prerequisites

For both examples, you need to:

1. Ensure `slsa-verifier` is installed.

2. [Download security assets](https://cloudsmith.io/~kong/repos/kong-mesh-binaries-release/packages/?q=name%3Asecurity-assets*+version%3A%3E%3D2.7.4) for the required version of {{site.mesh_product_name}} binaries 

3. Extract the downloaded `security-assets.tar.gz` to access the provenance file `kong-mesh.intoto.jsonl`

   ```sh
   tar -xvzf security-assets.tar.gz
   ```

4. [Download compressed binaries](https://cloudsmith.io/~kong/repos/kong-mesh-binaries-release/packages/?q=name%3Akong-mesh-*+version%3A%3E%3D2.7.4) for the required version  of {{site.mesh_product_name}}

{:.important .no-icon}
> The GitHub owner is case-sensitive (`Kong/kong-mesh` vs `kong/kong-mesh`).

### Minimal example

#### Using slsa-verifier

Run the `slsa-verifier verify-artifact...` command:

```sh
slsa-verifier verify-artifact \
   --print-provenance \
   --provenance-path '<provenance-file>' \
   --source-uri 'github.com/Kong/<repo>' \
   <binary-files>
```

Here's the same example using sample values instead of placeholders:

```sh
slsa-verifier verify-artifact \
   --print-provenance \
   --provenance-path 'kong-mesh.intoto.jsonl' \
   --source-uri 'github.com/Kong/kong-mesh' \
   kong-mesh-2.7.4-*-*.tar.gz
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
   --provenance-path '<provenance-file>' \
   --source-uri 'github.com/Kong/<repo>' \
   --source-tag '<version>' \
   <binary-files>
```

Here's the same example using sample values instead of placeholders:

```sh
slsa-verifier verify-artifact \
   --print-provenance \
   --provenance-path 'kong-mesh.intoto.jsonl' \
   --source-uri 'github.com/Kong/kong-mesh' \
   --source-tag '2.7.4' \
   kong-mesh-2.7.4-*-*.tar.gz
```
