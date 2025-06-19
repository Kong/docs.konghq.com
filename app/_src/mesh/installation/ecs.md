---
title: {{site.mesh_product_name}} on Amazon ECS
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

Every sidecar must have the [`--auth-type=aws` flag set as well](https://github.com/Kong/kong-mesh-ecs/blob/878b019793723b802af2bf05c84e80f88d336a98/deploy/counter-demo/demo-app.yaml#L255).

## Services

When deploying an ECS task to be included in the mesh, the following must be
considered.

### Outbounds

Services are bootstrapped with a `Dataplane` specification.

Transparent proxy is not supported on ECS, so the `Dataplane` resource for a
service must enumerate all other mesh services this service contacts and include them
[in the `Dataplane` specification as `outbounds`][dpp-spec]. {% if_version gte:2.11.x %}
Since `2.11.x`, we have introduced a new feature that leverages Route53 to simplify migration to the mesh. Please see the [Dynamic Outbounds](#dynamic-outbounds) section for more details.
{% endif_version %}

See the example repository to learn
[how to handle the `Dataplane` template with Cloudformation](https://github.com/Kong/kong-mesh-ecs/blob/878b019793723b802af2bf05c84e80f88d336a98/deploy/counter-demo/demo-app.yaml#L31-L46).

{% if_version gte:2.11.x %}
#### Dynamic outbounds

> [!WARNING]
> This feature does not support IPv6.

In `2.11.x`, we introduced an option to leverage Route53 to simplify migration to the mesh. This functionality creates Route53 domains that resolve to local addresses by DNS, which can then be used by applications. The `{{site.mesh_product_name}} Control Plane` is responsible for generating domains and local addresses, and it ensures their availability to the application. It removes the burden of manually maintaining outbounds and enables faster, more automated migration.

See the example repository to learn
[how to handle the `Dataplane` template with Cloudformation](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/counter-demo/demo-app.yaml#L31-L42).

> [!NOTE]
> AWS enforces a [limit of 5 requests per second to the Route53 API per AWS profile](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/DNSLimitations.html#:~:text=For%20the%20Amazon%20Route%2053,a%20value%20of%20Rate%20exceeded%20.). {{site.mesh_product_name}} performs initial requests for each Hosted Zone on startup, and thereafter makes additional requests only if changes are needed, at intervals of 10 seconds by default (this can be adjusted using the `KMESH_RUNTIME_AWS_ROUTE53_REFRESH_INTERVAL` setting)

##### Deployment instructions

**Create private hosted zone**

As mentioned above, this functionality works with Route53 in AWS. You need to create a [private Hosted Zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-private.html) in the VPC used for the Mesh deployment, using the domain your application will use to communicate with Mesh services.

**Required Permissions for the Control Plane**

The {{site.mesh_product_name}} control plane needs to communicate with the AWS API. To do this, it requires specific permissions that allow it to manage Route53:

```yaml
        "route53:GetHostedZone",               // to fetch details of a specific zone
        "route53:ListResourceRecordSets",      // to check existing records
        "route53:ChangeResourceRecordSets"     // to create, update, or delete DNS records
```

**Control-plane configuration**

Because the configuration relies on dynamic allocation of local addresses, you must set the Control Plane IPAM values within the localhost range:

* `KUMA_DNS_SERVER_CIDR=127.1.0.0/16`
* `KUMA_IPAM_MESH_MULTI_ZONE_SERVICE_CIDR=127.2.0.0/16`
* `KUMA_IPAM_MESH_EXTERNAL_SERVICE_CIDR=127.3.0.0/16`
* `KUMA_IPAM_MESH_SERVICE_CIDR=127.4.0.0/16`
* `KUMA_DNS_SERVER_SERVICE_VIP_PORT=8080`

>[!NOTE]
> `KUMA_DNS_SERVER_SERVICE_VIP_PORT` must be greater than 1024 since applications cannot bind to privileged ports on ECS Fargate
> `KUMA_DNS_SERVER_CIDR` and `KUMA_IPAM_MESH_*` needs to be in loopback range.

In addition, configure the private Hosted Zone details:

* `KUMA_DNS_SERVER_DOMAIN=<hosted-zone-domain>`
* `KMESH_RUNTIME_AWS_ROUTE53_ENABLED=true` 
* `KMESH_RUNTIME_AWS_ROUTE53_HOSTED_ZONE_ID=<hosted-zone-id>`

The example Cloudformation [sets them via environment variables](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/controlplane.yaml#L364-L382):

**MeshService Integration**
If you are using [MeshService](/mesh/{{page.release}}/networking/meshservice/), you must provide the Hosted Zone ID when creating a [HostnameGenerator](/mesh/{{page.release}}/networking/hostnamegenerator/):

```
type: HostnameGenerator
name: hosted-zone-mesh-services
spec:
  selector:
    meshService:
      matchLabels:
        kuma.io/origin: zone
  template: "{{ .DisplayName }}.svc.mesh.local"
  extension:
    type: Route53
    config:
      hostedZoneId: <hosted-zone-id>
```

Replace `<hosted-zone-id>` with the ID of the Hosted Zone that matches the `.svc.mesh.local` domain.

**Dataplane configuration**

Previously, users had to define all outbounds before deployment. Since version `2.11.x`, manual configuration is no longer required. You can start the dataplane with the [`--bind-outbounds`](https://github.com/Kong/kong-mesh-ecs/blob/main/deploy/counter-demo/demo-app.yaml#268) flag and provide a simplified Dataplane resource:

```yaml
type: Dataplane
name: "{{ dpname }}"
mesh: "{{ mesh }}"
networking:
  address: "{{ address }}"
  inbound:
  - port: {{ port }}
    servicePort: {{ servicePort }}
    tags:
      kuma.io/service: "{{ service }}"
      kuma.io/protocol: "{{ protocol }}"
```

**How does communication work?**

The control plane creates DNS entries in the Hosted Zone, which can be resolved by your application to loopback addresses. These entries either point to:

* a loopback address with a shared port (`KUMA_DNS_SERVER_SERVICE_VIP_PORT`), or
* a loopback address and actual service port when using [`MeshService`](/mesh/{{page.release}}/networking/meshservice/).

A local sidecar proxy exposes a listener on the loopback address and port. Traffic from your application to these addresses is intercepted and routed through the sidecar.

Example:

Let’s assume we have a `demo-app` that communicates with a `redis` service. The control plane is configured with:
* `KUMA_DNS_SERVER_SERVICE_VIP_PORT=8080`
* `KUMA_DNS_SERVER_DOMAIN=mesh.local`
* `KUMA_DNS_SERVER_CIDR=127.1.0.0/16`
* `KMESH_RUNTIME_AWS_ROUTE53_ENABLED=true` 
* `KMESH_RUNTIME_AWS_ROUTE53_HOSTED_ZONE_ID=Z123...`

Once I make a request to `demo-app.mesh.local:8080`, the traffic will be intercepted by the local sidecar.
{% endif_version %}

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
