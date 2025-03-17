---
title: Create a service mesh using Kong Mesh, Terraform, and Konnect
---

{% assign KM_VERSION = "2.9.3" %}
{% assign TF_BETA_VERSION = "0.1.0" %}
{% assign TF_VERSION = "2.4.1" %}
{% assign TF_TIME_VERSION = "0.13.0" %}
{% assign TF_KUBERNETES_VERSION = "2.35.1" %}
{% assign TF_HELM_VERSION = "2.17.0" %}

## Introduction

This guide explains how to create and manage Kong Mesh using Terraform and Konnect.
It covers:
* setting up the Terraform environment,
* configuring providers,
* deploying a Global Control Plane with a Mesh in Konnect,
* and deploying a zone.

## Requirements

- [Personal Access Token](/konnect/org-management/access-tokens/)
- [terraform](https://www.terraform.io/) (tested on `1.5.5`)
- [k3d](https://k3d.io/stable/#installation) (tested on k3d `v5.8.1`, k3s `v1.31.4-k3s1`)

## Versions of the provider

### konnect

The `konnect` provider is the [General Availability](/mesh/{{page.release}}/availability-stages/#general-availability) version.
Features initially available in the beta version (`konnect-beta`) will move to the GA version (`konnect`) once they are stable and fully tested.

Below is an example of how to use the `konnect` provider in your Terraform configuration:

```hcl
terraform {
    required_providers {
        konnect = {
            source = "kong/konnect"
            version = "{{ TF_VERSION }}"
        }
    }
}
```

### konnect-beta

There is a [beta version](/availability-stages/#beta) of the provider called `konnect-beta` that has the latest features.

Currently, Mesh resources are available only in the beta provider, but they will be available in the `konnect` provider shortly.

Below is an example of how to use the `konnect-beta` provider in your Terraform configuration:

```hcl
terraform {
  required_providers {
    konnect-beta = {
      source  = "kong/konnect-beta"
      version = "{{ TF_BETA_VERSION }}"
    }
  }
}
```

### Usage in this guide

In this guide we will use both the `konnect` and `konnect-beta` providers to demonstrate how to manage Kong Mesh resources using Terraform.

## Setup

In this step we will set up the Terraform configuration to use the `konnect` and `konnect-beta` providers and initialize it with your Personal Access Token.

Create a new directory and add a file called `main.tf`.

Put in `main.tf`:
```hcl
terraform {
  required_providers {
    konnect = {
      source = "kong/konnect"
      version = "{{ TF_VERSION }}"
    }
    konnect-beta = {
      source  = "kong/konnect-beta"
      version = "{{ TF_BETA_VERSION }}"
    }
  }
}

variable "konnect_personal_access_token" {
    type    = string
}

variable "region" {
    type    = string
    default = "us"
}

provider "konnect" {
    personal_access_token = var.konnect_personal_access_token
    server_url            = "https://${var.region}.api.konghq.com"
}

provider "konnect-beta" {
    personal_access_token = var.konnect_personal_access_token
    server_url            = "https://${var.region}.api.konghq.com"
}
```

To use the Personal Access Token, export it as an environment variable:

```bash
export TF_VAR_konnect_personal_access_token="kpat_..." # or "spat_..."
```

You can also set the region using "region" variable.
The default value is "us".
You can override it by setting the environment variable `TF_VAR_region`:

```bash
export TF_VAR_region="eu"
```

Run init to download the providers:

```bash
terraform init
```

You should see a green text:

```
Terraform has been successfully initialized!
```

If you run:

```bash
terraform apply
```

You should see a message that no resources are defined:

```
No changes. Your infrastructure matches the configuration.
```

## Creating a Global Control Plane in Konnect

Below is an example of how to create a Global Control Plane in Konnect using Terraform:

```hcl
resource "konnect_mesh_control_plane" "my_meshcontrolplane" {
  provider    = konnect-beta
  name        = "tf-cp"
  description = "A control plane created using terraform"
  labels = {
    "terraform" = "true"
  }
}
```

```bash
terraform apply
```

You should see:

```
  # konnect_mesh_control_plane.my_meshcontrolplane will be created
  + resource "konnect_mesh_control_plane" "my_meshcontrolplane" {
      + created_at  = (known after apply)
      + description = "A control plane created using terraform"
      + features    = (known after apply)
      + id          = (known after apply)
      + labels      = {
          + "terraform" = "true"
        }
      + name        = "tf-cp"
      + updated_at  = (known after apply)
    }
```

## Creating a Mesh

```hcl
resource "konnect_mesh" "mesh1" {
  provider = konnect-beta
  type     = "Mesh"
  cp_id    = konnect_mesh_control_plane.my_meshcontrolplane.id
  name     = "my-mesh"
  depends_on = [konnect_mesh_control_plane.my_meshcontrolplane]
  skip_creating_initial_policies = [ "*" ]
}
```

Notice `cp_id` is set to the id of the control plane created in the previous step,
and `depends_on` is set to the control plane resource to ensure the control plane is created first,
also `skip_creating_initial_policies` is set to `["*"]` to skip creating the default policies so that everything is tracked by terraform.

```bash
terraform apply
```

Let's now add `mTLS` to that mesh:

```hcl
resource "konnect_mesh" "mesh1" {
  provider = konnect-beta
  type     = "Mesh"
  cp_id    = konnect_mesh_control_plane.my_meshcontrolplane.id
  name     = "my-mesh"
  depends_on = [konnect_mesh_control_plane.my_meshcontrolplane]
  skip_creating_initial_policies = [ "*" ]

  mtls = {
    "backends" = [
      {
        "name" = "ca-1"
        "type" = "builtin"
      }
    ]
    "mode"           = "permissive"
    "enabledBackend" = "ca-1"
  }
}
```

```bash
terraform apply
```

you should see mesh being updated in place:

```
  # konnect_mesh.mesh1 will be updated in-place
  ~ resource "konnect_mesh" "mesh1" {
      + mtls                           = {
          + backends = [
              + {
                  + name = "ca-1"
                  + type = "builtin"
                },
            ]
        }
        name                           = "my-mesh"
        # (3 unchanged attributes hidden)
    }
```

For full schema of the Mesh resource, see the [konnect-beta provider documentation](https://github.com/Kong/terraform-provider-konnect-beta/blob/v{{ TF_BETA_VERSION }}/docs/resources/mesh.md).

## Adding an example policy

Policies examples now contain an additional tab called "Terraform" showing a terraform representation of a policy.

Let's take an example from [MeshTrafficPermission page](/mesh/{{page.release}}/policies/meshtrafficpermission/#allow-all)

We need to adjust it to our setup by adding the provider, the control plane id, mesh name, depends_on and labels:

```hcl
provider = konnect-beta
cp_id    = konnect_mesh_control_plane.my_meshcontrolplane.id
mesh     = konnect_mesh.mesh1.name
depends_on = [konnect_mesh.mesh1]
labels = {
    "kuma.io/mesh" = konnect_mesh.mesh1.name
}
```

{% warning %}
Autogenerated labels like "kuma.io/mesh", "kuma.io/origin" etc. have to be manually added to the resources.
This limitation will be removed in the GA release.
{% endwarning %}

The resulting resource looks like this:

```hcl
resource "konnect_mesh_traffic_permission" "allow_all" {
    provider = konnect-beta
    cp_id    = konnect_mesh_control_plane.my_meshcontrolplane.id
    mesh     = konnect_mesh.mesh1.name
    depends_on = [konnect_mesh.mesh1]
    labels = {
        "kuma.io/mesh" = konnect_mesh.mesh1.name
    }
    type = "MeshTrafficPermission"
    name = "allow-all"
    spec = {
        from = [
            {
                target_ref = {
                    kind = "Mesh"
                }
                default = {
                    action = "Allow"
                }
            }
        ]
    }
}
```

## Impact of Renaming Resources

Certain properties (like Mesh name, policy name, etc.) are used as identifiers and changing them will result in a new resource being created and all dependant resources being recreated.

So changing mesh name to `another-name`

```hcl
resource "konnect_mesh" "mesh1" {
  # ...
  name = "another-name"
  # ...
}
```

Will result in forced replacement of both `mesh` and `mesh_access_log` resources:

```
    # konnect_mesh.mesh1 must be replaced
-/+ resource "konnect_mesh" "mesh1" {
      ~ name                           = "mesh1" -> "another-name" # forces replacement
        # (4 unchanged attributes hidden)
    }

  # konnect_mesh_access_log.konnect_mesh_traffic_permission must be replaced
-/+ resource "konnect_mesh_traffic_permission" "allow_all" {
      ~ creation_time     = "2025-03-13T09:53:00.606442Z" -> (known after apply)
      ~ labels            = {
          ~ "kuma.io/mesh" = "mesh1" -> "another-name"
        }
      ~ mesh              = "mesh1" -> "another-name" # forces replacement
```

## Deploying a Kubernetes Zone

To deploy a Kubernetes zone you can use any Kubernetes services, in this guide we will use `k3d` to create a local Kubernetes cluster.

Create a new k3d cluster:
```bash
k3d cluster create tfmink
```

Write `tfmink` cluster configuration:
```bash
export KUBECONFIG=$(k3d kubeconfig write tfmink)
```

Update the `main.tf` file to include the time, kubernetes and helm provider:

```hcl
terraform {
  required_providers {
    konnect = {
      source = "kong/konnect"
    }
    konnect-beta = {
      source  = "kong/konnect-beta"
      version = "{{ TF_BETA_VERSION }}"
    }
    time = {
      source  = "hashicorp/time"
      version = "{{ TF_TIME_VERSION }}"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "{{ TF_KUBERNETES_VERSION }}"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "{{ TF_HELM_VERSION }}"
    }
  }
}
```

Add a variable pointing to the Kubeconfig file: 

```hcl
variable "k8s_cluster_config_path" {
  type        = string
  description = "The location where this cluster's kubeconfig will be saved to."
  default     = "~/.config/k3d/kubeconfig-tfmink.yaml"
}
```

You can override that variable by setting the environment variable `TF_VAR_k8s_cluster_config_path`.

We need to create a system account and a token to authenticate the zone:

```hcl
resource "konnect_system_account" "zone_system_account" {
  depends_on = [konnect_mesh_control_plane.my_meshcontrolplane]
  name            = "mesh_${konnect_mesh_control_plane.my_meshcontrolplane.id}_${var.zone_name}"
  description     = "Terraform generated system account for authentication zone ${var.zone_name} in ${konnect_mesh_control_plane.my_meshcontrolplane.id} control plane."
  konnect_managed = false
}

resource "konnect_system_account_role" "zone_system_account_role" {
  depends_on = [konnect_system_account.zone_system_account]
  account_id       = konnect_system_account.zone_system_account.id
  entity_id        = konnect_mesh_control_plane.my_meshcontrolplane.id
  entity_region    = var.region
  entity_type_name = "Mesh Control Planes"
  role_name        = "Connector"
}

resource "time_offset" "one_year_from_now" {
  offset_years = 1
}

resource "konnect_system_account_access_token" "zone_system_account_token" {
  depends_on = [konnect_system_account.zone_system_account, time_rotating.rotate, time_offset.one_year_from_now]
  account_id = konnect_system_account.zone_system_account.id
  expires_at = time_offset.one_year_from_now.rfc3339
  name       = konnect_system_account.zone_system_account.name
}
```

We need to create a namespace and a secret to hold the Zone token:

```hcl
resource "kubernetes_namespace" "kong_mesh_system" {
  metadata {
    name = "kong-mesh-system"
    labels = {
      "kuma.io/system-namespace" = "true"
    }
  }
}

resource "kubernetes_secret" "mesh_cp_token" {
  metadata {
    name = "cp-token"
    namespace = kubernetes_namespace.kong_mesh_system.metadata.0.name
  }

  data = {
    token = konnect_system_account_access_token.zone_system_account_token.token
  }

  type = "opaque"

  depends_on = [kubernetes_namespace.kong_mesh_system]
}
```

And create a values file called `values.tftpl` with templated values for zone, address and control plane id:

```yaml
kuma:
  controlPlane:
    mode: zone
    zone: ${zone_name}
    kdsGlobalAddress: grpcs://${region}.mesh.sync.konghq.com:443
    konnect:
      cpId: ${cp_id}
    secrets:
      - Env: KMESH_MULTIZONE_ZONE_KDS_AUTH_CP_TOKEN_INLINE
        Secret: cp-token
        Key: token
  ingress:
    enabled: true
  egress:
    enabled: true
```

And finally we can create a zone deployment using `helm_release`:

```hcl
variable "zone_name" {
  type        = string
  description = "The name of the cluster."
  default     = "zone1"
}

resource "helm_release" "kong_mesh" {
  name       = "kong-mesh"
  repository = "https://kong.github.io/kong-mesh-charts"
  chart      = "kong-mesh"
  version    = "{{ KM_VERSION }}"

  namespace = kubernetes_namespace.kong_mesh_system.metadata.0.name
  upgrade_install = true

  values = [templatefile("values.tftpl", {
    zone_name = var.zone_name,
    region    = var.region,
    cp_id     = konnect_mesh_control_plane.my_meshcontrolplane.id
  })]

  depends_on = [konnect_mesh_control_plane.my_meshcontrolplane, kubernetes_secret.mesh_cp_token]
}
```

After that run `init -upgrade` to download the new providers:

```bash
terraform init -upgrade
```

And finally apply the changes:

```bash
terraform apply
```

You should see 7 resources created and `helm_release` can take some time to create.
In my case it took 53 seconds:

```
helm_release.kong_mesh: Creation complete after 53s [id=kong-mesh]
```

You can check that the `MeshTrafficPermission` we created earlier is now available in the zone:

```bash
kubectl get meshtrafficpermissions.kuma.io -A
```

should print:

```
NAMESPACE          NAME
kong-mesh-system   allow-all-wd5xx76vc44b498c
```

## Rotating the token

Instead of using `time_offset` resource you can use `time_rotating` resource to rotate the token every minute:

```hcl
resource "time_rotating" "example" {
  rotation_minutes = 1
}
```

Then, zone system account token needs updating to use that resource.
We're adding a 15 minutes offset to the rotation time to ensure the token is rotated before it expires:

```hcl
resource "konnect_system_account_access_token" "zone_system_account_token" {
  depends_on = [konnect_system_account.zone_system_account, time_rotating.rotate, time_rotating.rotate]
  account_id = konnect_system_account.zone_system_account.id
  expires_at = timeadd(time_rotating.rotate.rotation_rfc3339, "15m")
  name       = konnect_system_account.zone_system_account.name
}
```

{% tip %}
In production environment you should tune the rotation and offset time to your needs.
{% endtip %}

That will cause the token to be rotated if, a minute passes `terraform apply`.
If you execute `terraform apply` immediate after you'll see:

```
No changes. Your infrastructure matches the configuration.
```

Buf if you run it after a minute you will see zone system account token recreated and kubernetes secret updated:

```
  # konnect_system_account_access_token.zone_system_account_token must be replaced
-/+ resource "konnect_system_account_access_token" "zone_system_account_token" {
      ~ created_at   = "2025-03-13T11:49:42Z" -> (known after apply)
      ~ expires_at   = "2025-03-13T12:05:41Z" # forces replacement -> (known after apply) # forces replacement
      ~ id           = "354b4bee-dfbc-4a10-b1e1-9dcaf4382c72" -> (known after apply)
      + last_used_at = (known after apply)
        name         = "mesh_fe75caba-be28-4ff8-850b-4f573f836160_zone1"
      ~ token        = "spat_Qwb8wBAYJdhTn0m1CaHoP7uXtprbN0xpu3TAG5wbAYAgrHh8g" -> (known after apply)
      ~ updated_at   = "2025-03-13T11:49:42Z" -> (known after apply)
        # (1 unchanged attribute hidden)
    }

  # kubernetes_secret.mesh_cp_token will be updated in-place
  ~ resource "kubernetes_secret" "mesh_cp_token" {
      ~ data                           = (sensitive value)
        id                             = "kong-mesh-system/cp-token"
        # (3 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }
```

{% warning %}
Currently the control-plane will not pick up the new token automatically. You need to manually restart the control-plane to pick up the new token:

```bash
kubectl rollout restart -n kong-mesh-system deployment kong-mesh-control-plane
```

This limitation will be lifted in the next release.
{% endwarning %}

## Cleaning up

Simply run:

```bash
terraform destroy
```

This will clean up all the resources that you created.
