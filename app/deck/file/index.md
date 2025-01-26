---
title: decK File
---

decK's declarative configuration format is the canonical representation of a {{ site.base_gateway }} configuration in text form.

decK provides multiple tools for interacting with this declarative configuration (referred to as `kong` in the commands below).

| Command  | Description |
|----------|-------------|
| openapi2kong     | Convert an OpenAPI specification to Kong services and routes |
| kong2kic     | Convert a Kong declarative configuration file to [Kong Ingress Controller](/kubernetes-ingress-controller/) compatible CRDs. Supports both Gateway API and Ingress resources |
| kong2tf     | Convert a Kong declarative configuration file to Terraform manifests (Konnect only)|

decK also provides commands to manipulate declarative configuration files:

| Command  | Description |
|----------|-------------|
| patch     | Update values in a Kong declarative configuration file |
| add-plugins     | Add new plugin configurations to a Kong declarative configuration file |
| add-tags     | Add new tags to a Kong declarative configuration file |
| list-tags     | List all tags in a Kong declarative configuration file |
| remove-tags     | Remove tags to a Kong declarative configuration file |
| merge | Merge multiple files in to a single file, leaving `env` variables in place |
| render     | Render the final configuration sent to the Admin API in a single file |
| namespace     | Apply a namespace to routes in a decK file by path or hostname |
| convert     | Convert decK files from one format to another e.g. Kong 2.x to 3.x |

decK provides a `deck file lint` command which can be used to ensure that declarative configuration files meet defined standards before being used to configure {{ site.base_gateway }}.

Finally, the `deck file validate` command validates the state file locally against static schemas. This will not detect any conflicts on the server, but is much faster than `deck gateway validate`.