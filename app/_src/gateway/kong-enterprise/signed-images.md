---
title: Verify Signatures for Signed Kong Images
badge: enterprise
---

Starting with {{site.ee_product_name}} 3.5.0.2, Docker container images are now signed using `cosign` with signatures published to a Docker Hub repository.

This guide provides steps to verify signatures for signed {{site.ee_product_name}} Docker container images in two different ways:
* A minimal example, used to verify an image without leveraging any annotations
* A complete example, leveraging optional annotations for increased trust

For the minimal example, you only need Docker details, a GitHub repo name, and a GitHub workflow filename.

For the complete example, you need the same details as the minimal example, as well as any of the optional annotations you wish to verify:

| Shorthand | Description | Example Value |
|---|---|---|
| `<repo>` | Github repository | `kong-ee` |
| `<workflow filename>` | Github workflow filename | `release.yml` |
| `<workflow name>` | Github workflow name | `Package & Release` |

Because Kong uses Github Actions to build and release, Kong also uses Github's OIDC identity to sign images, which is why many of these details are Github-related.

## Examples
### Prerequisites
For both examples, you need to:

1. Ensure `cosign` is installed.

2. Collect the necessary image details.

3. Set the `COSIGN_REPOSITORY` environment variable:

   ```sh
   export COSIGN_REPOSITORY=kong/notary
   ```

{:.important .no-icon}
> Github owner is case-sensitive (`Kong/kong-ee` vs `kong/kong-ee`).

### Minimal example

Run the `cosign verify ...` command:

```sh
cosign verify \
   <image>:<tag>@sha256:<digest> \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/<repo>/.github/workflows/<workflow filename>'
```

Here's the same example using sample values instead of placeholders:

```sh
cosign verify \
   'kong/kong-gateway:3.6.0.0-ubuntu@sha256:2f4d417efee8b4c26649d8171dd0d26e0ca16213ba37b7a6b807c98a4fd413e8' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/kong-ee/.github/workflows/release.yml'
```

The command will exit with `0` if the `cosign` verification was complete:

```sh
...
echo $?
0
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
   'kong/kong-gateway:3.6.0.0-ubuntu@sha256:2f4d417efee8b4c26649d8171dd0d26e0ca16213ba37b7a6b807c98a4fd413e8' \
   --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
   --certificate-identity-regexp='https://github.com/Kong/kong-ee/.github/workflows/release.yml' \
   -a repo='Kong/kong-ee' \
   -a workflow='Package & Release'
```
