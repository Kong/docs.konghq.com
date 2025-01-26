---
title: kong2tf
---

The `kong2tf` command converts a {{ site.base_gateway }} declarative configuration file in to Terraform manifests that can be used with [terraform-provider-konnect](https://github.com/kong/terraform-provider-konnect/).

`kong2tf` generates a manifest that contains a `control_plane_id` variable. Update your manifest and change the default or set the `TF_VAR_control_plane_id` environment variable before running `terraform apply`.

```hcl
variable "control_plane_id" {
  type = string
  default = "YOUR_CONTROL_PLANE_ID"
}
```

## Adopting existing resources

`kong2tf` can be used to adopt existing {{ site.konnect_short_name }} resources using Terraform.

1. Run `deck gateway dump --with-id -o kong.yaml`
1. Run `deck file kong2tf`
    ```bash
    deck file kong2tf \
      --generate-imports-for-control-plane-id YOUR_CONTROL_PLANE_ID \
      -s kong.yaml \
      -o main.tf
    ```

This generates a `main.tf` file that contains `resource` and `import` blocks that look like the following:

```hcl
resource "konnect_gateway_consumer" "alice" {
  username = "alice"
  tags = ["billing-consumers"]

  control_plane_id = var.control_plane_id
}

import {
  to = konnect_gateway_consumer.alice
  id = "{\"id\": \"8d7a8097-585a-4952-b24d-445bebc74c64\", \"control_plane_id\": \"YOUR_CONTROL_PLANE_ID\"}"
}
```

Run `terraform plan` followed by `terraform apply` to import the existing resources in to your Terraform state.

If `terraform plan` shows unexpected credential changes, it is due to credentials being encrypted in the {{ site.base_gateway }} database. Re-run `deck file kong2tf` with the `--ignore-credential-changes` flag to add a `lifecycle` block that ignores changes in state.

## Limitations

If you are using custom plugins, `kong2tf` will generate Terraform resources that do not exist.

For example, if you have a plugin named `demo-functionality`, `kong2tf` will generate `konnect_plugin_demo_functionality` resources. This resource does not exist in the Terraform provider. To use the `demo-functionality` plugin, use the `konnect_gateway_custom_plugin` and specify `demo-functionality` in the `name` property:

```hcl
resource "konnect_gateway_custom_plugin" "demo_functionality_global" {
  name    = "demo-functionality"
  enabled = true
  config    = jsonencode({
    do_something = true
  })
  control_plane_id = var.control_plane_id
}
```

## Configuration options

The table below shows the most used configuration options. For a complete list, run `deck file kong2kic --help`.

| Flag | Description |
|------|-------------|
| `--generate-imports-for-control-plane-id` | VGenerate terraform import statements for the control plane ID |
| `--ignore-credential-changes` | Enable flag to add a 'lifecycle' block to each consumer credential, that ignores any changes from local to remote state. |