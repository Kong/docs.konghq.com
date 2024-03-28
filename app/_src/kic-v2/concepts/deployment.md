---
title: Kong Ingress Controller Deployment
---

The {{site.kic_product_name}} is designed to be deployed in a variety of ways
based on uses-cases. This document explains various components involved
and choices one can make as per the specific use-case.

- [**Kubernetes Resources**](#kubernetes-resources):
  Various Kubernetes resources required to run the {{site.kic_product_name}}.
- [**Deployment options**](#deployment-options):
  A high-level explanation of choices that one should consider and customize
  the deployment to best serve a specific use case.

## Kubernetes Resources

The following resources are used to run the {{site.kic_product_name}}:

- [Namespace](#namespace)
- [Custom resources](#custom-resources)
- [RBAC permissions](#rbac-permissions)
- [Ingress Controller Deployment](#ingress-controller-deployment)
- [Kong Proxy service](#kong-proxy-service)
- [Database deployment and migrations](#database-deployment-and-migration)

These resources are created if the reference deployment manifests are used
to deploy the {{site.kic_product_name}}.
The resources are explained below for users to gain an understanding of how
they are used, so that they can be tweaked as necessary for a specific use-case.

### Namespace

> optional

The {{site.kic_product_name}} can be deployed in any [namespace][k8s-namespace].
If {{site.kic_product_name}} is being used to proxy traffic for all namespaces
in a Kubernetes cluster, which is generally the case,
it is recommended that it is installed in a dedicated
`kong` namespace but it is not required to do so.

The example deployments present in this repository automatically create a `kong`
namespace and deploy resources into that namespace.

### Custom Resources

> required

The Ingress resource in Kubernetes is a fairly narrow and ambiguous API, and
doesn't offer resources to describe the specifics of proxying.
To overcome this limitation, custom resources are used as an
"extension" to the existing Ingress API.

A few custom resources are bundled with the {{site.kic_product_name}} to
configure settings that are specific to Kong and provide fine-grained control
over the proxying behavior.

Please refer to the [custom resources](/kubernetes-ingress-controller/{{page.release}}/concepts/custom-resources/)
concept document for details.

### RBAC permissions

> required

The {{site.kic_product_name}} communicates with the Kubernetes API-server and
dynamically configures Kong to automatically load balance across pods
of a service as any service is scaled in or out.

For this reason, it requires [RBAC][k8s-rbac] permissions to access resources
stored in the Kubernetes object store.

It needs read permissions (get, list, watch) on the following Kubernetes resources:

{% if_version lte:2.9.x -%}
- Endpoints
{% endif_version -%}
{% if_version gte:2.9.x -%}
- EndpointSlices
{%- endif_version %}
- Events
- Nodes
- Pods
- Secrets
- Ingress
{% if_version gte:2.4.x -%}
- IngressClassParameters
{% endif_version -%}
- KongClusterPlugins
- KongPlugins
- KongConsumers
- KongIngress
- TCPIngresses
- UDPIngresses

By default, the controller listens above resources across all namespaces and will
need access to these resources at the cluster level
(using `ClusterRole` and `ClusterRoleBinding`).

In addition to these, it needs:

- Create, list, get, watch, delete and update `ConfigMap`s and `Leases` to
  facilitate leader-election.
  Please read this [document](/kubernetes-ingress-controller/{{page.release}}/concepts/ha-and-scaling/)
  for more details.
- Update permission on the Ingress resource to update the status of
  the Ingress resource.

If the {{site.kic_product_name}} is listening for events on a single namespace,
these permissions can be updated to restrict these permissions to a specific
namespace using `Role` and `RoleBinding resources`.

In addition to these, it is necessary to create a `ServiceAccount`, which
has the above permissions. The Ingress Controller Pod then has this
`ServiceAccount` association. This gives the Ingress Controller process
necessary authentication and authorization tokens to communicate with the
Kubernetes API-server.

[rbac.yaml](https://github.com/Kong/kubernetes-ingress-controller/tree/v{{ page.version }}/config/rbac)
contains the permissions needed for the {{site.kic_product_name}} to operate correctly.

### Ingress Controller deployment

> required

Kong Ingress deployment consists of the Ingress Controller deployed alongside
Kong. The deployment will be different depending on if a database is being
used or not.

The deployment(s) is the core which actually runs the {{site.kic_product_name}}.

See the [database](#database) section below for details.

### Kong Proxy service

> required

Once the {{site.kic_product_name}} is deployed, one service is needed to
expose Kong outside the Kubernetes cluster so that it can receive all traffic
that is destined for the cluster and route it appropriately.
`kong-proxy` is a Kubernetes service which points to the Kong pods which are
capable of proxying request traffic. This service will be usually of type
`LoadBalancer`, however it is not required to be such.
The IP address of this service should be used to configure DNS records
of all the domains that Kong should be proxying, to route the traffic to Kong.

### Database deployment and migration

> optional

The {{site.kic_product_name}} can run with or without a database.
If a database is being deployed, then following resources are required:

- A `StatefulSet` which runs a PostgreSQL pod backed with a `PersistentVolume`
  to store Kong's configuration.
- An internal Service which resolves to the PostgreSQL pod. This ensures
  that Kong can find the PostgreSQL instance using DNS inside
  the Kubernetes cluster.
- A batch `Job` to run schema migrations. This is required to be executed once
  to install bootstrap Kong's database schema.
  Please note that on an any upgrade for Kong version, another `Job` will
  need to be created if the newer version contains any migrations.

To figure out if you should be using a database or not, please refer to the
[database](#database) section below.

## Deployment options

Following are the different options to consider while deploying the
{{site.kic_product_name}} for your specific use case:

- [**Kubernetes Service Type**](#kubernetes-service-types):
  Chose between Load Balancer vs Node-Port
- [**Database**](#database):
  Backing Kong with a Database or running without a database
- [**Multiple Ingress Controllers**](#multiple-ingress-controllers):
  Running multiple {{site.kic_product_name}}s inside the same Kubernetes cluster
- [**Runtime**](#runtime):
  Using {{site.ce_product_name}} or {{site.ee_product_name}} (for Enterprise customers)
{% if_version gte: 2.9.x -%}
- [**Gateway Discovery**](#gateway-discovery):
  Dynamically discovering Kong's Admin API endpoints
- [**{{site.konnect_short_name}} integration**](#konnect-integration):
  Integration with the Kong's {{site.konnect_short_name}} platform
{% endif_version %}

### Kubernetes Service Types

Once deployed, any Ingress Controller needs to be exposed outside the
Kubernetes cluster to start accepting external traffic.
In Kubernetes, Service abstraction is used to expose any application
to the rest of the cluster or outside the cluster.

If your Kubernetes cluster is running in a cloud environment, where
Load Balancers can be provisioned with relative ease, it is recommended
that you use a Service of type `LoadBalancer` to expose Kong to the outside
world.
For the {{site.kic_product_name}} to function correctly, it is also required
that a L4 (or TCP) Load Balancer is used and not an L7 (HTTP(s)) one.

If your Kubernetes cluster doesn't support a service of type `LoadBalancer`,
then it is possible to use a service of type `NodePort`.

### Database

Until Kong 1.0, a database was required to run Kong.
Kong 1.1 introduced a new mode, DB-less, in which Kong can be configured
using a config file, and removes the need to use a database.

It is possible to deploy and run the {{site.kic_product_name}} with or without a
database. The choice depends on the specific use-case and results in no
loss of functionality.

#### Without a database

In DB-less deployments, Kong's Kubernetes ingress controller runs
alongside and dynamically configures
Kong as per the changes it receives from the Kubernetes API server.

Following figure shows what this deployment looks like:

![Kong DB-less](/assets/images/products/kubernetes-ingress-controller/dbless-deployment.png "Kong DB-less architecture")

In this deployment, only one Deployment is required, which is comprised of
a Pod with two containers, a Kong container which proxies the requests
and a controller container which configures Kong.

`kong-proxy` service would point to the ports of the Kong container in the
above deployment.

Since each pod contains a controller and a Kong container, scaling out
simply requires horizontally scaling this deployment to handle more traffic
or to add redundancy in the infrastructure.

#### With a Database

In a deployment where Kong is backed by a DB, the deployment architecture
is a little different.

Please refer to the below figure:

![Kong with a database](/assets/images/products/kubernetes-ingress-controller/db-deployment.png "Kong with database")

In this type of deployment, there are two types of deployments created,
separating the control and data flow:

- **Control-plane**: This deployment consists of a pod(s) running
  the controller alongside
  a Kong container, which can only configure the database. This deployment
  does not proxy any traffic but only configures Kong. If multiple
  replicas of this pod are running, a leader election process will ensure
  that only one of the pods is configuring Kong's database at a time.
- **Data-plane**: This deployment consists of pods running a
  single Kong container which can proxy traffic based on the configuration
  it loads from the database. This deployment should be scaled to respond
  to change in traffic profiles and add redundancy to safeguard from node
  failures.
- **Database**: The database is used to store Kong's configuration and propagate
  changes to all the Kong pods in the cluster. All Kong containers, in the
  cluster should be able to connect to this database.

A database driven deployment should be used if your use-case requires
dynamic creation of Consumers and/or credentials in Kong at a scale large
enough that the consumers will not fit entirely in memory.

### Multiple Ingress Controllers

It is possible to run multiple instances of the {{site.kic_product_name}} or
run a Kong {{site.kic_product_name}} alongside other Ingress Controllers inside
the same Kubernetes cluster.

There are a few different ways of accomplishing this:

- Using `kubernetes.io/ingress.class` annotation:
  It is common to deploy Ingress Controllers on a cluster level, meaning
  an Ingress Controller will satisfy Ingress rules created in all the namespaces
  inside a Kubernetes cluster.
  Use the annotation on Ingress and Custom resources to segment
  the Ingress resources between multiple Ingress Controllers.
  **Warning!**
  When you use another Ingress Controller, which is default for cluster
  (without set any `kubernetes.io/ingress.class`), be aware of using default `kong`
  ingress class. There is special behavior of the default `kong` ingress class,
  where any ingress resource that is not annotated is picked up.
  Therefore with different ingress class then `kong`, you have to use that
  ingress class with every Kong CRD object (plugin, consumer) which you use.
- Namespace based isolation:
  {{site.kic_product_name}} supports a deployment option where it will satisfy
  Ingress resources in a specific namespace. With this model, one can deploy
  a controller in multiple namespaces and they will run in an isolated manner.
- If you are using {{site.ee_product_name}}, you can run multiple Ingress Controllers
  pointing to the same database and configuring different workspaces inside
  {{site.ee_product_name}}. With such a deployment, one can use either of the above
  two approaches to segment Ingress resources into different Workspaces in
  {{site.ee_product_name}}.

### Runtime

The {{site.kic_product_name}} is compatible with a variety of runtimes:

#### {{site.ce_product_name}}

This is the [Open-Source Gateway](https://github.com/kong/kong) runtime.
The Ingress Controller is primarily developed against releases of the
open-source gateway.

#### {{site.ee_product_name}}

The {{site.kic_product_name}} is also compatible with the full-blown version of
{{site.ee_product_name}}. This runtime ships with Kong Manager, Kong Portal, and a
number of other enterprise-only features.
[This doc](/kubernetes-ingress-controller/{{page.release}}/concepts/k4k8s-with-kong-enterprise) provides a high-level
overview of the architecture.

[k8s-namespace]: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
[k8s-rbac]:https://kubernetes.io/docs/reference/access-authn-authz/rbac/

{% if_version gte: 2.9.x %}
### Gateway Discovery

{{site.kic_product_name}} can also be configured to discover deployed Gateways.
This works by using a separate {{site.base_gateway}} deployment which exposes a
Kubernetes Service which is backed by [Kong Admin API][admin] endpoints.
This Service endpoints can be then discovered by {{site.kic_product_name}}
through Kubernetes EndpointSlice watch.

{:.important}
> Gateway Discovery is only supported with DB-less deployments of Kong.

The overview of this type of deployment can be found on the figure below:

![Gateway Discovery overview](/assets/images/products/kubernetes-ingress-controller/gateway-discovery-diagram.png "Gateway Discovery overview")

In this type of architecture, there are two types of Kubernetes deployments created,
separating the control and data flow:

- **Control-plane**: This deployment consists of a pod(s) running the controller.
  This deployment does not proxy any traffic but only configures Kong.
  Leader election is enforced in this deployment when running with Gateway Discovery
  enabled to ensure only 1 controller instance is sending configuration to data
  planes at a time.
- **Data-plane**: This deployment consists of pods running Kong which can proxy
  traffic based on the configuration it receives via the [Admin API][admin].
  This deployment should be scaled to respond to change in traffic profiles
  and add redundancy to safeguard from node failures.

Both of those deployments can be scaled independently.

For more hands on experience with Gateway Discovery please see [our guide][gd-guide].

[admin]: /gateway/latest/admin-api/
[gd-guide]: /kubernetes-ingress-controller/{{page.release}}/guides/using-gateway-discovery

### {{site.konnect_short_name}} Integration

{{site.kic_product_name}} can be integrated with Kong's [{{site.konnect_short_name}}][konnect] platform. It's an
optional feature that allows configuring a {{site.konnect_short_name}} control plane with the same configuration as the one used
by {{site.kic_product_name}} for configuring local Kong Gateways. It enables using {{site.konnect_short_name}} UI
to inspect the configuration of your Kong instances in a **read-only** mode, track [Analytics][konnect-analytics],
and more.

For installation steps, please see the [{{site.kic_product_name}} for Kubernetes Association][konnect-kic] page.

![KIC {{site.konnect_short_name}} overview](/assets/images/products/kubernetes-ingress-controller/kic-konnect-diagram.png "KIC {{site.konnect_short_name}} overview")

From the architecture perspective, the integration is similar to the [Gateway Discovery](#gateway-discovery) and
builds on top of it. The difference is that {{site.kic_product_name}} additionally configures a control plane in {{site.konnect_short_name}}
using the public [Admin API][admin] of the {{site.konnect_short_name}}'s Gateway Manager. The connection between {{site.kic_product_name}}
and {{site.konnect_short_name}} is secured using mutual TLS.

As {{site.kic_product_name}} calls {{site.konnect_short_name}}'s APIs, outbound traffic from {{site.kic_product_name}}'s pods must be allowed to reach {{site.konnect_short_name}}'s `*.konghq.com` [hosts](/konnect/network#hostnames).

{:.important}
> {{site.kic_product_name}}'s control plane in {{site.konnect_short_name}} is **read-only**.
> Although the configuration displayed in {{site.konnect_short_name}} will match the configuration used by proxy instances, it cannot be modified from the GUI.
> You must still modify the associated Kubernetes resources to change proxy configuration.
> In the event of a connection  failure between {{site.kic_product_name}} and {{site.konnect_short_name}},
> {{site.kic_product_name}} will continue to update data plane proxy configuration normally, but will not
> update the control plane's configuration until it can connect to {{site.konnect_short_name}} again.

[konnect]: /konnect/
[konnect-kic]: /konnect/runtime-manager/kic/
[konnect-analytics]: /konnect/analytics/

{% endif_version %}
