---
title: Deploy Kong Mesh using Terraform and Konnect
---

{% assign KM_VERSION = "2.9.3" %}
{% assign TF_BETA_VERSION = "0.1.1" %}
{% assign TF_VERSION = "2.4.1" %}
{% assign TF_TIME_VERSION = "0.13.0" %}
{% assign TF_KUBERNETES_VERSION = "2.35.1" %}
{% assign TF_HELM_VERSION = "2.17.0" %}

## Introduction

This guide explains how to create and manage {{site.mesh_product_name}} using Terraform and Konnect.
It covers:
* setting up the Terraform environment,
* configuring providers,
* deploying a Global Control Plane with a Mesh in Konnect,
* and deploying a zone.

## Prerequisites

### Requirements

- [Konnect Personal Access Token](/konnect/org-management/access-tokens/)
- [terraform](https://www.terraform.io/) (tested on `1.11.2`)
- [k3d](https://k3d.io/stable/#installation) (tested on k3d `v5.8.1`, k3s `v1.31.4-k3s1`)


### Terraform variables

This guide allows you to customise the access token and region used by your manifests.

Create a `variables.tf` file with the following contents:

```hcl
variable "konnect_personal_access_token" {
    type    = string
}

variable "region" {
    type    = string
}
```

These variables can be provided at runtime, or set using environment variables. Set the following environment variables, replacing `kpat_...` with your {{ site.konnect_short_name }} access token:

```bash
export TF_VAR_konnect_personal_access_token="kpat_..." # or "spat_..."
export TF_VAR_region="us"
```

### Provider Configuration

This guide uses the `konnect` and `konnect-beta` Terraform providers.

The `konnect` provider is the [General Availability](/mesh/{{page.release}}/availability-stages/#general-availability) version.
Features initially available in the beta version (`konnect-beta`) will move to the GA version (`konnect`) once they are stable and fully tested.

There is a [beta version](/availability-stages/#beta) of the provider called `konnect-beta` that has the latest features.

Mesh resources are available only in the beta provider, but they will be available in the `konnect` provider shortly.

Create a `providers.tf` file with the following contents:

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

provider "konnect" {
    personal_access_token = var.konnect_personal_access_token
    server_url            = "https://${var.region}.api.konghq.com"
}

provider "konnect-beta" {
    personal_access_token = var.konnect_personal_access_token
    server_url            = "https://${var.region}.api.konghq.com"
}
```

Download the providers using `terraform init`:

```bash
terraform init
```

You will see the following message in green text:

```
Terraform has been successfully initialized!
```

## Mesh Resources

At this point you have installed and configured the providers successfully. It's time to create some resources using the {{ site.konnect_short_name }} API.

### Mesh Control Plane

Create a file named `main.tf` and add the following to create a Global Control Plane in {{ site.konnect_short_name }}:

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

After saving the file, run `terraform apply -auto-approve` to create the resource.

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

### Creating a Mesh

Now that there is a Control Plane, we can create a new Mesh.

Notice that the `cp_id` property is set to the ID of the control plane created in the previous step.

The `skip_creating_initial_policies` property is set to `["*"]` to skip creating the default policies so that all resources in the Mesh are tracked by Terraform.

Add the following to `main.tf`:

```hcl
resource "konnect_mesh" "my_mesh" {
  provider = konnect-beta

  name     = "my-mesh"
  type     = "Mesh"
  skip_creating_initial_policies = [ "*" ]

  cp_id    = konnect_mesh_control_plane.my_meshcontrolplane.id
}
```

Run `terraform apply -auto-approve` and watch as Terraform creates a new Mesh in your Control Plane.

Let's add `mTLS` to the mesh. Replace the `konnect_mesh` resource you added in `main.tf` with the following definition:

```hcl
resource "konnect_mesh" "my_mesh" {
  provider = konnect-beta

  name     = "my-mesh"
  type     = "Mesh"
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

  cp_id    = konnect_mesh_control_plane.my_meshcontrolplane.id
}
```

Run `terraform apply -auto-approve` and you will see the Mesh being updated in place:

```
  # konnect_mesh.my_mesh will be updated in-place
  ~ resource "konnect_mesh" "my_mesh" {
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

### Adding an example policy

The Kong Mesh documentation policy examples now contain an additional "Terraform" tab showing a Terraform representation of a policy.

Let's take an example from [MeshTrafficPermission page](/mesh/{{page.release}}/policies/meshtrafficpermission/#allow-all)

{% warning %}
Autogenerated labels like "kuma.io/mesh", "kuma.io/origin" etc. have to be manually added to the resources.
This limitation will be removed in the GA release.
{% endwarning %}

Add the following policy to `main.tf`:

```hcl
resource "konnect_mesh_traffic_permission" "allow_all" {
 provider = konnect-beta

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
 labels   = {
   "kuma.io/mesh" = konnect_mesh.my_mesh.name
 }

 cp_id    = konnect_mesh_control_plane.my_meshcontrolplane.id
 mesh     = konnect_mesh.my_mesh.name
}


```

Run `terraform apply -auto-approve` to create the policy.

### Impact of Renaming Resources

Certain properties (like Mesh name, policy name, etc.) are used as identifiers and changing them will result in a new resource being created and all dependant resources being recreated.

So changing mesh name to `another-name`

```hcl
resource "konnect_mesh" "my_mesh" {
  # ...
  name = "another-name"
  # ...
}
```

Will result in forced replacement of both `mesh` and `konnect_mesh_traffic_permission` resources:

```
    # konnect_mesh.my_mesh must be replaced
-/+ resource "konnect_mesh" "my_mesh" {
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

### Create a cluster

Create a new k3d cluster:

```bash
k3d cluster create tfmink
```

Store the `tfmink` cluster configuration in `$KUBECONFIG`:

```bash
export KUBECONFIG=$(k3d kubeconfig write tfmink)
```

In `variables.tf` add a variable pointing to the Kubeconfig file and configure Helm and Kubernetes providers, and a variable for the zone name:

```hcl
variable "k8s_cluster_config_path" {
  type        = string
  description = "The location where this cluster's kubeconfig will be saved to."
}

variable "zone_name" {
    type    = string
    default = "tfzone1"
}
```

Then set `TF_VAR_k8s_cluster_config_path` to your `kubeconfig` value:

```bash
export TF_VAR_k8s_cluster_config_path=$KUBECONFIG
```

### Configure the Kubernetes and Helm providers

Update the `providers.tf` with the following contents to include the time, kubernetes and helm providers:

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

Then add some provider configuration blocks to the bottom of `providers.tf`:

```hcl
provider "helm" {
    kubernetes {
        config_path = pathexpand(var.k8s_cluster_config_path)
    }
}

provider "kubernetes" {
    config_path = pathexpand(var.k8s_cluster_config_path)
}
```

Run `init -upgrade` to download the new providers:

```bash
terraform init -upgrade
```

### Create a system account

Create a new file named `system-account.tf` with the following contents to create a system account and a token to authenticate the zone:

```hcl
resource "konnect_system_account" "zone_system_account" {
  name            = "mesh_${konnect_mesh_control_plane.my_meshcontrolplane.id}_${var.zone_name}"
  description     = "Terraform generated system account for authentication zone ${var.zone_name} in ${konnect_mesh_control_plane.my_meshcontrolplane.id} control plane."
  konnect_managed = false
}

resource "konnect_system_account_role" "zone_system_account_role" {
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
  account_id = konnect_system_account.zone_system_account.id
  expires_at = time_offset.one_year_from_now.rfc3339
  name       = konnect_system_account.zone_system_account.name
}
```

Store this token in Kubernetes by creating `k8s.tf` with the following contents:

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
}
```

### Create a Zone deployment

Create a values file called `values.tftpl` with templated values for zone, address and control plane id:

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

Create a `zone.tf` file containing the following to create a zone:

```hcl
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
}
```

And finally apply the changes:

```bash
terraform apply -auto-approve
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

## Cleaning up

Congratulations! You just deployed a Mesh Control Plane, Mesh, policies and a Zone to Kubernetes.

To clean up all resources created by this guide, run the following command:

```bash
terraform destroy
```