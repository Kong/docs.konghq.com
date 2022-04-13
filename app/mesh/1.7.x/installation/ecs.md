---
title: Kong Mesh on Amazon ECS
---

This page describes running Kong Mesh on ECS and offers guidelines
for integrating Kong Mesh into your deployment process.

For a demo of Kong Mesh on ECS, see the [example repository for Cloudformation](https://github.com/Kong/kong-mesh-ecs).
This demo covers bootstrapping an ECS cluster from scratch, deploying Kong Mesh, and deploying some services into the mesh.

## Overview

On ECS, Kong Mesh runs in Universal mode. Every ECS task runs with an Envoy sidecar.
Kong Mesh supports tasks on the following launch types:

- Fargate
- EC2

The control plane itself also runs as an ECS service in the cluster.

### Data plane tokens

As part of joining and synchronizing with the mesh, every sidecar needs to authenticate with
the control plane. On Kong Mesh, this is accomplished by using a data plane token.
Typically on Universal mode, creating and managing data plane tokens is a manual step for the mesh operator.
However, Kong Mesh on ECS handles automatically provisioning data plane tokens for your services.

An additional ECS token controller runs in the cluster with permissions to use
the Kong Mesh API to create data plane tokens and put them in AWS secrets.

New ECS services are given access to an AWS secret. When they
join the cluster, the controller requests a new data plane token scoped to that service.

### Mesh communication

With Kong Mesh on ECS, each service enumerates
other services it contacts in the mesh and
[exposes them in `Dataplane` specification](https://kuma.io/docs/latest/reference/dpp-specification).

## Deployment

This section covers ECS-specific parts of running Kong Mesh, using the
[example Cloudformation](https://github.com/Kong/kong-mesh-ecs) as a guide.

### Kong Mesh control plane

Kong Mesh runs in Universal mode on ECS. The example setup repository uses an AWS RDS
database as a PostgreSQL backend. It also uses ECS service discovery to enable ECS
tasks to communicate with Kong Mesh the control plane.

The example Cloudformation includes two Cloudformation stacks for
[creating a cluster](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/vpc.yaml) and
[deploying Kong Mesh](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/controlplane.yaml)

### Kong Mesh ECS controller

The controller is published as a docker image
`docker.io/kong/kong-mesh-ecs-controller:0.1.0`.

#### API permissions

To generate data plane tokens, the controller
needs to authenticate with the Kong Mesh API and be authorized to create
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
  We recommend communicating with the Kong Mesh API over TLS (served on port `5682` by default).

#### IAM permissions

The controller uses the AWS API. The ECS task role must be authorized to perform the following actions:

- `ecs:ListTasks` and `ecs:DescribeTasks`
- `secretsmanager:GetSecretValue` and `secretsmanager:PutSecretValue`

These permissions can be further restricted by including a `Resource` or `Condition` in
the IAM policy statements. To make this easier, the controller supports the `--secret-name-prefix`
command line switch to prefix the names of the AWS secrets under which it saves tokens.

To see how this all ties together, refer back to the
[example controller Cloudformation](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/controller.yaml).

## Services

When deploying an ECS task to be included in the mesh, the following must be
considered.

### Outbounds

Services are bootstrapped with a `Dataplane` specification.

Transparent proxy is not supported on ECS, so the `Dataplane` resource for a
service must enumerate all other mesh services this service contacts and include them
[in the `Dataplane` specification as `outbounds`](https://kuma.io/docs/latest/reference/dpp-specification).

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
1. Initially, the secret does not contain this key and ECS continues
   trying to create the task.
1. Shortly after the task is created, while it's in the retry loop, the ECS
   controller sees the task and checks whether `token` exists in the corresponding secret.
1. The controller sees an empty secret and generates a new data plane token via the
   mesh API, saving the result as `token` in the secret.
1. Finally, ECS is able to fetch the `token` value and starts the task successfully.
