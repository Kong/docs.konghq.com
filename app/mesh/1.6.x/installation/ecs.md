---
title: Kong Mesh on Amazon ECS
---

This page describes running Kong Mesh on ECS and offers guidelines
for integrating Kong Mesh into your deployment process.

For inspiration, we have an [example repository of Cloudformation](https://github.com/Kong/kong-mesh-ecs)
that covers bootstrapping an ECS cluster from scratch, deploying Kong Mesh
and deploying some services into the mesh.

## Overview

On ECS, Kong Mesh runs in Universal mode. Every ECS task runs with an Envoy sidecar.
Kong Mesh supports tasks on the following launch types:

- Fargate
- EC2

The control plane itself also runs as an ECS service in the cluster.

### Dataplane tokens

As part of joining and synchronizing with the mesh, every sidecar needs to authenticate with
the control plane. On Kong Mesh, this is accomplished by using a dataplane token.
Typically on Universal mode, creating and managing Dataplane tokens is a manual step for the mesh operator.
However, Kong Mesh on ECS handles automatically provisioning dataplane tokens for your services.

An additional ECS token controller runs in the cluster with permissions to use
the Kong Mesh API to create dataplane tokens and put them in AWS secrets.

New ECS services are given access to an AWS secret. When they
join the cluster, the controller requests a new dataplane token scoped to that service.

### Mesh communication

With Kong Mesh on ECS, it's the responsibility of each service to enumerate
other services it contacts in the mesh and
[expose them in `Dataplane` specification](https://kuma.io/docs/1.4.x/documentation/dps-and-data-model/#dataplane-specification).

## Deployment

Deploying and using Kong Mesh on ECS involves mainly three aspects. This
section will cover these ECS-specific parts of running Kong Mesh and refer to the
example Cloudformation.

### Kong Mesh control plane

Kong Mesh runs in Universal mode on ECS. Our example setup repository uses an AWS RDS
database as a PostgreSQL backend. We also use ECS service Discovery to enable ECS
tasks to communicate with Kong Mesh the control plane.

The example Cloudformation includes two Cloudformation stacks for [creating a
cluster](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/vpc.yaml) and
[deploying Kong Mesh](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/controlplane.yaml)

### Kong Mesh ECS controller

The controller is published as a docker image
`docker.io/kong/kong-mesh-ecs-controller:0.1.0`.

#### API permissions

In order to generate dataplane tokens, the controller
needs to authenticate with the Kong Mesh API and be authorized to create
new dataplane tokens.

Our example repository [launches the control plane with two additional containers](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/controlplane.yaml#L358-L387)
that handle fetching this global secret and
[covers bootstrapping this controller and running it as an ECS task](https://github.com/Kong/kong-mesh-ecs/blob/main/README.md#ecs-controller).

Any option that enables operators to query the API from `localhost` (e.g. an SSH
container in the task) will allow extracting the admin token.

Once we have `kumactl` configured with this token, we can generate a new user
token for the controller with a command like:

```
kumactl generate user-token --name ecs-controller --group mesh-system:admin --valid-for 8766h
```

We can configure our controller with this token using:

- the `KUMA_API_TOKEN` environment variable

We recommend communicating with the Kong Mesh API over TLS (served on port `5682` by default) and the controller supports:

- the `KUMA_API_CA_BYTES` environment variable for passing the CA used to verify the TLS certificates presented by the API

#### IAM permissions

The controller uses the AWS API and its ECS task role must be authorized to perform:

- `ecs:ListTasks` and `ecs:DescribeTasks`
- `secretsmanager:GetSecretValue` and `secretsmanager:PutSecretValue`

These permissions can of course be further restricted by including a `Resource` or `Condition` in
the IAM policy statements. To make this easier, the controller supports:

- a `--secret-name-prefix` command line switch to prefix the names of the
  AWS secrets under which it saves tokens

See [the example controller Cloudformation](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/controller.yaml) for how all of this ties together.

## Services

When deploying an ECS task to be included in the mesh, the following must be
considered.

### Outbounds

Like on Universal, services are bootstrapped with a `Dataplane` specification.

Transparent proxy is not supported on ECS and so the `Dataplane` resources for a
service must enumerate all other mesh services that service contacts and include them
[in `Dataplane` specification as `outbounds`](https://kuma.io/docs/1.4.x/documentation/dps-and-data-model/#dataplane-specification).

See the example repository for [how to handle the Dataplane template
with Cloudformation](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/counter-demo/demo-app.yaml#L30-L46).

### `kuma.io/service` tag

Every ECS task must be tagged with the `kuma.io/service` tag in
order for the controller to include the task in the mesh. The ECS task
authenticates to the mesh as this service and it should match the
`kuma.io/service` value in the `Dataplane` resource.

### Sidecar

The sidecar must run as a container in the ECS task and be passed the AWS secret
that holds the dataplane token created by the ECS controller.

The controller _does not create_ the secret, it only puts and gets it. The
AWS secret should be created and destroyed by the same mechanism that creates the
ECS service (e.g. a Cloudformation stack).

See the example repository for [an example container
definition](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/counter-demo/demo-app.yaml#L205-L243).

#### Initialization

When a task starts, the following happens:

1. The task requests the `token` JSON key from an existing AWS secret.
1. Initially, the secret does not contain this key and ECS will continue
   trying to create the task.
1. Shortly after the task is created, while it's in the retry loop, the ECS
   controller sees the task and checks whether `token` exists in the corresponding secret.
1. The controller sees an empty secret and generates a new dataplane token via the
   mesh API, saving the result as `token` in the secret.
1. Finally, ECS is able to fetch the `token` value and starts the task successfully.
