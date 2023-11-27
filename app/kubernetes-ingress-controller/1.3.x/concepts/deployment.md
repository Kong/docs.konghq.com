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

Please refer to the [custom resources](/kubernetes-ingress-controller/{{page.kong_version}}/concepts/custom-resources/)
concept document for details.

### RBAC permissions

> required

The {{site.kic_product_name}} communicates with the Kubernetes API-server and
dynamically configures Kong to automatically load balance across pods
of a service as any service is scaled in our out.

For this reason, it requires RBAC permissions to access resources stored
in Kubernetes object store.

It needs read permissions (get,list,watch)
on the following Kubernetes resources:

- Endpoints
- Nodes
- Pods
- Secrets
- Ingress
- KongPlugins
- KongConsumers
- KongCredentials
- KongIngress

By default, the controller listens for events and above resources across
all namespaces and will need access to these resources at the cluster level
(using `ClusterRole` and `ClusterRoleBinding`).

In addition to these, it needs:

- Create a ConfigMap and read and update ConfigMap for to facilitate
  leader-election. Please read this [document](/kubernetes-ingress-controller/{{page.kong_version}}/concepts/ha-and-scaling/)
  for more details.
- Update permission on the Ingress resource to update the status of
  the Ingress resource.

If the Ingress Controller is listening for events on a single namespace,
these permissions can be updated to restrict these permissions to a specific
namespace using `Role` and `RoleBinding resources`.

In addition to these, it is necessary to create a `ServiceAccount`, which
has the above permissions. The Ingress Controller Pod then has this
`ServiceAccount` association. This gives the Ingress Controller process
necessary authentication and authorization tokens to communicate with the
Kubernetes API-server.

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

- A `StatefulSet` which runs a PostgreSQL pod backed with a `PersistenceVolume`
  to store Kong's configuration.
- An internal `Service` which resolves to the PostgreSQL pod. This ensures
  that Kong can find the PostgreSQL instance using DNS inside
  the Kubernetes cluster.
- A batch `Job` to run schema migrations. This is required to be executed once
  to install bootstrap Kong's database schema.
  Please note that on an any upgrade for Kong version, another `Job` will
  need to be created if the newer version contains any migrations.

To figure out if you should be using a database or not, please refer to the
[database](#database) section below.

## Deployment options

Following are the difference options to consider while deploying the
{{site.kic_product_name}} for your specific use case:

- [**Kubernetes Service Type**](#kubernetes-service-types):
  Chose between Load Balancer vs Node-Port
- [**Database**](#database):
  Backing Kong with a Database or running without a database
- [**Multiple Ingress Controllers**](#multiple-ingress-controllers):
  Running multiple {{site.kic_product_name}}s inside the same Kubernetes cluster
- [**Runtime**](#runtime):
  Using Kong or {{site.ee_product_name}} (for {{site.ee_product_name}} customers)

### Kubernetes Service Types

Once deployed, any Ingress Controller needs to be exposed outside the
Kubernetes cluster to start accepting external traffic.
In Kubernetes, `Service` abstraction is used to expose any application
to the rest of the cluster or outside the cluster.

If your Kubernetes cluster is running in a cloud environment, where
Load Balancers can be provisioned with relative ease, it is recommended
that you use a Service of type `LoadBalancer` to expose Kong to the outside
world. For the Ingress Controller to function correctly, it is also required
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

Following figure shows how this deployment looks like:

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

## Multiple Ingress Controllers

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
  pointing to the same database and configuring different Workspaces inside
  {{site.ee_product_name}}. With such a deployment, one can use either of the above
  two approaches to segment Ingress resources into different Workspaces in
  {{site.ee_product_name}}.

## Runtime

The {{site.kic_product_name}} is compatible a variety of runtimes:

### {{site.base_gateway}} (OSS)

This is the [Open-Source Gateway](https://github.com/kong/kong) runtime.
The Ingress Controller is primarily developed against releases of the
open-source gateway.

### {{site.ee_product_name}} K8S

If you are a {{site.ee_product_name}} customer, you have access to two more runtimes.

The first one, {{site.ee_product_name}} K8S, is an package that takes the Open-Source
{{site.base_gateway}} and adds enterprise-only plugins to it.

You simply need to deploy {{site.ee_product_name}} K8S instead of the Open-Source
Gateway in-order to take full-advantage of enterprise plugins.

### {{site.ee_product_name}}

The {{site.kic_product_name}} is also compatible with the full-blown version of
{{site.ee_product_name}}. This runtime ships with Kong Manager, Kong Portal, and a
number of other enterprise-only features.
[This doc](/kubernetes-ingress-controller/{{page.kong_version}}/concepts/k4k8s-with-kong-enterprise) provides a high-level
overview of the architecture.

[k8s-namespace]: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
