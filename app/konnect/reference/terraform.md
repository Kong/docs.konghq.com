---
title: Terraform Provider
content_type: reference
description: Manage your Konnect entities using Terraform / OpenTofu
---

Kong provides [terraform-provider-konnect](https://github.com/Kong/terraform-provider-konnect), which allows you to manage your {{ site.konnect_short_name }} resources using Terraform.

The provider allows you to manage {{ site.konnect_short_name }} resources, {{ site.base_gateway }} resources and {{ site.mesh_product_name }} resources.

## Example

The following manifest creates a new Terraform managed Control Plane (CP), and a Gateway service and route within the CP. You can see an extended version of this manifest [in the repository](https://github.com/Kong/terraform-provider-konnect/blob/main/examples/scenarios/service-with-basic-auth.tf).

```hcl
terraform {
  required_providers {
    konnect = {
      source  = "kong/konnect"
    }
  }
}

provider "konnect" {
  personal_access_token = "kpat_YOUR_PAT"
  server_url            = "https://us.api.konghq.com"
}

# Create a new Control Plane
resource "konnect_gateway_control_plane" "tfdemo" {
  name         = "Terraform Control Plane"
  description  = "This is a sample description"
  cluster_type = "CLUSTER_TYPE_CONTROL_PLANE"
  auth_type    = "pinned_client_certs"

  proxy_urls = [
    {
      host     = "example.com",
      port     = 443,
      protocol = "https"
    }
  ]
}

# Configure a service and a route that we can use to test
resource "konnect_gateway_service" "httpbin" {
  name             = "HTTPBin"
  protocol         = "https"
  host             = "httpbin.konghq.com"
  port             = 443
  path             = "/"
  control_plane_id = konnect_gateway_control_plane.tfdemo.id
}

resource "konnect_gateway_route" "hello" {
  methods = ["GET"]
  name    = "Anything"
  paths   = ["/anything"]

  strip_path = false

  control_plane_id = konnect_gateway_control_plane.tfdemo.id
  service = {
    id = konnect_gateway_service.httpbin.id
  }
}
```

For an exhaustive list of supported resources and examples, see the [terraform-provider-konnect examples](https://github.com/Kong/terraform-provider-konnect/tree/main/examples).