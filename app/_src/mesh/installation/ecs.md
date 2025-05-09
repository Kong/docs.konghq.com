---
title: Kong Mesh on Amazon ECS
---

This page describes running {{site.mesh_product_name}} on ECS and offers guidelines
for integrating {{site.mesh_product_name}} into your deployment process.

For a demo of {{site.mesh_product_name}} on ECS, see the [example repository for Cloudformation](https://github.com/Kong/kong-mesh-ecs).
This demo covers bootstrapping an ECS cluster from scratch, deploying {{site.mesh_product_name}}, and deploying some services into the mesh.

## Overview

On ECS, {{site.mesh_product_name}} runs in Universal mode. Every ECS task runs with an Envoy sidecar.
{{site.mesh_product_name}} supports tasks on the following launch types:

- Fargate
- EC2

The control plane itself also runs as an ECS service in the cluster.

{% warning %}
When using ECS Fargate it is impossible to use transparent proxy. This is because ECS tasks can't run with capabilities required to install transparent proxy.
{% endwarning %}

### Data plane authentication

As part of joining and synchronizing with the mesh, every sidecar needs to authenticate with
the control plane.

With {{site.mesh_product_name}}, this is typically accomplished by using a data plane token.
In Universal mode, creating and managing data plane tokens is a manual step for the mesh operator.

With {{site.mesh_product_name}} 2.0.0, you can instead configure the sidecar to authenticate
using the identity of the ECS task it's running as.

### Mesh communication

With {{site.mesh_product_name}} on ECS, each service enumerates
other mesh services it contacts
[in the `Dataplane` specification][dpp-spec].

## Deployment

This section covers ECS-specific parts of running {{site.mesh_product_name}}, using the
[example Cloudformation](https://github.com/Kong/kong-mesh-ecs) as a guide.

### Control plane

{{site.mesh_product_name}} runs in Universal mode on ECS. The example setup repository uses an AWS RDS
database as a PostgreSQL backend. It also uses ECS service discovery to enable ECS
tasks to communicate with the {{site.mesh_product_name}} control plane.

The example Cloudformation includes two Cloudformation stacks for
[creating a cluster](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/vpc.yaml) and
[deploying {{site.mesh_product_name}}](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/controlplane.yaml)

#### Workload identity

The data plane proxy attempts to authenticate using the IAM role of the ECS task
it's running under. The control plane assumes that if this role has been tagged
with certain `kuma.io/` tags, it can be authorized to run as the
corresponding Kuma resource identity.

In particular, every role must be tagged at a minimum with `kuma.io/type` set to
either `dataplane`, `ingress`, or `egress`. For `dataplane`, i.e. a normal data
plane proxy, the `kuma.io/mesh` tag is also required to be set.

This means that the setting of these two tags on IAM roles
must be restricted accordingly for your AWS account
(which must be explicitly given to the CP, see below).

The control plane must have the following options enabled. The example
Cloudformation [sets them via environment variables](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/controlplane.yaml#L334-L337):

{% if_version gte:2.7.x %}
```yaml
- Name: KUMA_DP_SERVER_AUTHN_DP_PROXY_TYPE
  Value: aws-iam
- Name: KUMA_DP_SERVER_AUTHN_ZONE_PROXY_TYPE
  Value: aws-iam
- Name: KUMA_DP_SERVER_AUTHN_ENABLE_RELOADABLE_TOKENS
  Value: "true"
- Name: KMESH_AWSIAM_AUTHORIZEDACCOUNTIDS
  Value: !Ref AWS::AccountId # this tells the CP which accounts can be used by DPs to authenticate
```
{% endif_version %}
{% if_version lte:2.6.x %}
```yaml
- Name: KUMA_DP_SERVER_AUTH_TYPE
  Value: aws-iam
- Name: KUMA_DP_SERVER_AUTH_USE_TOKEN_PATH
  Value: "true"
- Name: KMESH_AWSIAM_AUTHORIZEDACCOUNTIDS
  Value: !Ref AWS::AccountId # this tells the CP which accounts can be used by DPs to authenticate
```
{% endif_version %}

Every sidecar must have the [`--auth-type=aws` flag set as well](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/counter-demo/demo-app.yaml#L255).

## Services

When deploying an ECS task to be included in the mesh, the following must be
considered.

### Outbounds

Services are bootstrapped with a `Dataplane` specification.

Transparent proxy is not supported on ECS, so the `Dataplane` resource for a
service must enumerate all other mesh services this service contacts and include them
[in the `Dataplane` specification as `outbounds`][dpp-spec].

See the example repository to learn
[how to handle the `Dataplane` template with Cloudformation](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/counter-demo/demo-app.yaml#L31-L46).

### IAM role

The ECS task IAM role must also have some tags set in order to authenticate.
It must always have the `kuma.io/type` tag set to either `"dataplane"`,
`"ingress"`, or `"egress"`.

If it's a `"dataplane"` type, then it must also have the `kuma.io/mesh` tag set.
Additionally, you can set the `kuma.io/service` tag to further restrict its identity.

### Sidecar

The sidecar must run as a container in the ECS task.

See the example repository for [an example container
definition](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/counter-demo/demo-app.yaml#L213-L261).

<!-- links -->
[dpp-spec]: /mesh/{{page.release}}/production/dp-config/dpp-on-universal/
