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

{% if_version lte:1.9.x %}
### Data plane tokens

As part of joining and synchronizing with the mesh, every sidecar needs to authenticate with
the control plane. On {{site.mesh_product_name}}, this is accomplished by using a data plane token.
Typically on Universal mode, creating and managing data plane tokens is a manual step for the mesh operator.
However, {{site.mesh_product_name}} on ECS handles automatically provisioning data plane tokens for your services.

An additional ECS token controller runs in the cluster with permissions to use
the {{site.mesh_product_name}} API to create data plane tokens and put them in AWS secrets.

New ECS services are given access to an AWS secret. When they
join the cluster, the controller requests a new data plane token scoped to that service.

### Mesh communication

With {{site.mesh_product_name}} on ECS, each service enumerates
other services it contacts in the mesh and

[exposes them in `Dataplane` specification][dpp-spec].

## Deployment

This section covers ECS-specific parts of running {{site.mesh_product_name}}, using the
[example Cloudformation](https://github.com/Kong/kong-mesh-ecs) as a guide.

### Control plane

{{site.mesh_product_name}} runs in Universal mode on ECS. The example setup repository uses an AWS RDS
database as a PostgreSQL backend. It also uses ECS service discovery to enable ECS
tasks to communicate with {{site.mesh_product_name}} the control plane.

The example Cloudformation includes two Cloudformation stacks for
[creating a cluster](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/vpc.yaml) and
[deploying {{site.mesh_product_name}}](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/controlplane.yaml)

### ECS controller

The controller is published as a docker image
`docker.io/kong/kong-mesh-ecs-controller:0.1.0`.

#### API permissions

To generate data plane tokens, the controller
needs to authenticate with the {{site.mesh_product_name}} API and be authorized to create
new data plane tokens.

The example repository [launches the control plane with two additional containers](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/controlplane.yaml#L358-L387)
that handle fetching this global secret and
[covers bootstrapping this controller and running it as an ECS task](https://github.com/Kong/kong-mesh-ecs/blob/main/README.md#ecs-controller).

Any option that enables operators to query the API from `localhost` (for
example, an SSH container in the task) can extract the admin token.

After `kumactl` is configured with the control plane, you can generate a new user
token for the controller with `kumactl generate user-token`. For example:

```
kumactl generate user-token --name ecs-controller --group mesh-system:admin --valid-for 8766h
```

Configure the controller using the environment variables:

- `KUMA_API_TOKEN`: the API token
- `KUMA_API_CA_BYTES`: the CA used to verify the TLS certificates presented by the API.
  We recommend communicating with the {{site.mesh_product_name}} API over TLS (served on port `5682` by default).

#### IAM permissions

The controller uses the AWS API. The ECS task role must be authorized to perform the following actions:

- `ecs:ListTasks` and `ecs:DescribeTasks`
- `secretsmanager:GetSecretValue` and `secretsmanager:PutSecretValue`

These permissions can be further restricted by including a `Resource` or `Condition` in
the IAM policy statements. To make this easier, the controller supports the `--secret-name-prefix`
command line switch to prefix the names of the AWS secrets under which it saves tokens.

## Services

When deploying an ECS task to be included in the mesh, the following must be
considered.

### Outbounds

Services are bootstrapped with a `Dataplane` specification.

Transparent proxy is not supported on ECS, so the `Dataplane` resource for a
service must enumerate all other mesh services this service contacts and include them
[in the `Dataplane` specification as `outbounds`][dpp-spec].

See the example repository to learn
[how to handle the `Dataplane` template with Cloudformation](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/counter-demo/demo-app.yaml#L30-L46).

### `kuma.io/service` tag

Every ECS task must be tagged with the `kuma.io/service` tag so that
the controller includes the task in the mesh. The ECS task
authenticates to the mesh as this service. The tag value should match the
`kuma.io/service` value in the `Dataplane` resource.

### Sidecar

The sidecar must run as a container in the ECS task. It must also run with the AWS secret
that holds the data plane token created by the ECS controller.

The controller _does not create_ the secret, it only puts and gets it. The
AWS secret should be created and destroyed by the same mechanism that creates the
ECS service (for example, a Cloudformation stack).

See the example repository for [an example container
definition](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/counter-demo/demo-app.yaml#L205-L243).

#### Initialization

When a task starts, the following happens:

1. The task requests the `token` JSON key from an existing AWS secret.
2. Initially, the secret does not contain this key and ECS continues
   trying to create the task.
3. Shortly after the task is created, while it's in the retry loop, the ECS
   controller sees the task and checks whether `token` exists in the corresponding secret.
4. The controller sees an empty secret and generates a new data plane token via the
   mesh API, saving the result as `token` in the secret.
5. Finally, ECS is able to fetch the `token` value and starts the task successfully.
{% endif_version %}
{% if_version gte:2.0.x %}
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

```yaml
- Name: KUMA_DP_SERVER_AUTH_TYPE
  Value: aws-iam
- Name: KUMA_DP_SERVER_AUTH_USE_TOKEN_PATH
  Value: "true"
- Name: KMESH_AWSIAM_AUTHORIZEDACCOUNTIDS
  Value: !Ref AWS::AccountId # this tells the CP which accounts can be used by DPs to authenticate
```

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
{% endif_version %}

<!-- links -->
{% if_version gte:2.2.x %}
[dpp-spec]: /mesh/{{page.release}}/production/dp-config/dpp-on-universal/
{% endif_version %}
{% if_version eq:2.1.x %}
[dpp-spec]: /mesh/{{page.release}}/generated/resources/proxy_dataplane/
{% endif_version %}
{% if_version eq:2.0.x %}
[dpp-spec]: /mesh/{{page.release}}/generated/resources/proxy_dataplane/
{% endif_version %}

{% if_version lte:1.9.x %}
[dpp-spec]: https://kuma.io/docs/1.8.x/generated/resources/proxy_dataplane/
{% endif_version %}

