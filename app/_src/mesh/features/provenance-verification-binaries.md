---
title: Verify Build Provenance for Kong Mesh Binaries
badge: enterprise
---

Starting with 2.8.0, {{site.mesh_product_name}} produces build provenance for binary artifacts, which can be verified using `cosign` / `slsa-verifier` with attestations published to a Docker Hub repository.

This guide provides steps to verify build provenance for signed {{site.mesh_product_name}} binary artifacts using:

* An example, leveraging optional annotations for increased trust

For the example, you will need a compressed binary file and provenance file as well as any of the optional annotations you wish to verify:

| Shorthand | Description | Example Value |
|---|---|---|
| `<repo>` | GitHub repository | `kong-mesh` |
| `<version>` | Artifact version to download | `{{page.kong_latest.version}}` |
| `<binary-files>` | Compressed binary files for the specified version | `kong-mesh-{{page.kong_latest.version}}-*-*.tar.gz` |
| `<provenance-file>` | Binary provenance file | `kong-mesh.intoto.jsonl` |

Because Kong uses GitHub Actions to build and release, Kong also uses GitHub's OIDC identity to generate build provenance for binary artifacts, which is why many of these details are GitHub-related.

## Examples

### Prerequisites

For both examples, you need to:

1. Ensure [slsa-verifier](https://github.com/slsa-framework/slsa-verifier?tab=readme-ov-file#installation) is installed.

2. [Download security assets](https://packages.konghq.com/public/kong-mesh-binaries-release/raw/names/security-assets/versions/{{page.kong_latest.version}}/security-assets.tar.gz) for the required version of {{site.mesh_product_name}} binaries

3. Extract the downloaded `security-assets.tar.gz` to access the provenance file `kong-mesh.intoto.jsonl`

   ```sh
   tar -xvzf security-assets.tar.gz
   ```

4. [Download compressed binaries](https://cloudsmith.io/~kong/repos/kong-mesh-binaries-release/packages/?q=name%3Akong-mesh-*+version%3A{{page.kong_latest.version}}) for the required version  of {{site.mesh_product_name}}

{:.important .no-icon}
> The GitHub owner is case-sensitive (`Kong/kong-mesh` vs `kong/kong-mesh`).

### Example

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
   --source-tag '{{page.kong_latest.version}}' \
   kong-mesh-{{page.kong_latest.version}}-*-*.tar.gz
```
