---
title: Kong for Kubernetes Deployment Options
---

Kong for Kubernetes consists of a controller, which translates Kubernetes
resources into Kong configuration, and a proxy, which uses that configuration
to route and control traffic.

As of 2.1.x, Kong for Kubernetes with Kong Enterprise
(the [kong-gateway][enterprise-download] proxy image) supports DB-less
operation and is recommended for all deployments.
* [DB-less installation with the Kong Ingress Controller][k4k8s-enterprise-install]
* [Database-backed installation with or without the Kong Ingress Controller][k4k8s-with-enterprise-install]

### Migrating to 2.1.x and up

Existing users of the `kong-enterprise-k8s` image who want to use 2.1.x or later
should switch to the `kong-gateway` image.

If you encounter issues after switching images, please
[contact Kong Enterprise Support][support].

## DB-less versus database-backed deployments

When using Kong for Kubernetes, the source of truth for Kong's configuration is
the Kubernetes configuration in etcd: Kong's custom Kubernetes resources,
ingresses, and services provide the information necessary for the ingress
controller to configure Kong. This differs from Kong deployments that do not
use an ingress controller, where configuration in the database or DB-less
config file is the source of truth.

In traditional deployments, Kong's database (PostgreSQL or Cassandra) provides
a persistent store of configuration available to all Kong nodes to ensure
consistent proxy behavior across the cluster that is not affected by node
restarts. Because etcd provides this functionality in Kong for Kubernetes
deployments, it is not necessary to run an additional database, reducing
maintenance and infrastructure requirements.

While Kong for Kubernetes does not require a database, it is fully compatible
with PostgreSQL and requires it for some features. etcd still remains the
source of truth in database-backed deployments: the controller translate
Kubernetes resources from etcd into Kong configuration and inserts them into
the database via the Admin API.

## Choosing between DB-less or database-backed deployments

In general, DB-less deployments are simpler to maintain and require less
resources to run, and as such are the preferred option for Kong for Kubernetes.
These deployments must set `KONG_DATABASE=off` in their environment variables.

Database-backed deployments offer a wider range of features. Review the
sections below to determine if your use case requires a feature that is not
available in DB-less deployments.

### Feature availability

Some Kong Enterprise features are not available in DB-less deployments.
Use a database-backed deployment if you want to use:

* Dev Portal
* Immunity
* Teams (RBAC)
* Workspaces

In 2.1.x and later, the following features have support in DB-less mode, but
work differently than in DB-backed modes:

* Kong Manager (read-only)
* Vitals (using [Prometheus][vitals-prometheus] or [InfluxDB][vitals-influxdb]
  strategies)

Because Kong for Kubernetes is configured by the ingress controller, some
functionality in these features is different from traditional deployments:

* Instead of using Kong Manager, proxy configuration is managed by the
  controller, and you provide configuration via Kubernetes resources.
* Because the controller creates proxy configuration on behalf of users, you do
  not need to interact with the Admin API directly. Kong's own RBAC
  implementation isn't required for typical Kong for Kubernetes deployments, as
  they do not expose the Admin API; only the controller can access it.
  Kubernetes-level RBAC rules and namespaces should be used to restrict what
  configuration administrators can create.
* Ingress controller instances create configuration in a single workspace only
  (`default` by default). To use multiple workspaces, deploy
  multiple controller instances, setting the `CONTROLLER_KONG_WORKSPACE`
  environment variable to the workspace that instance should use. These
  instances should set `CONTROLLER_INGRESS_CLASS` to unique values for each
  instance to avoid creating duplicate configuration in workspaces. Note that
  if controller instances are deployed outside the Kong pod the Admin API must
  be exposed, and users should enable RBAC with workspace admin users for the
  controllers.  Set `CONTROLLER_KONG_ADMIN_TOKEN` to the RBAC user's token.
* The controller cannot manage configuration for features that require a
  database: it cannot create workspaces, Dev Portal content, admins, etc. These
  features must be configured manually through the Admin API or Kong Manager.

### Plugin compatibility

Not all plugins are compatible with DB-less operation. Review the
[list of supported plugins][supported-plugins] to see if you require a plugin
that needs a database.

Third-party plugins are generally compatible with DB-less as long as they do
not create custom entities (i.e. they do not add new entities that users can
create and modify through the Admin API).

### Manual configuration

DB-less configuration must be supplied as a complete unit: it is not possible
to add or modify entities individually through the Admin API, or provide
partial configuration that is added to existing configuration. As such, all
configuration must be sourced from Kubernetes resources so that the ingress
controller can render it into a complete configuration.

On database-backed deployments, users can create or modify configuration
through the Admin API. The ingress controller uses a tag (set by the
`CONTROLLER_KONG_ADMIN_FILTER_TAG` environment variable) to to identify
configuration that it manages. While the controller will revert changes to
configuration with its tag, other configuration is left as-is.

Although database-backed deployments can use controller-generated and
manually-added configuration simultaneously, Kong's recommended best practice
is to manage as much configuration through Kubernetes resources as possible.
Using both controller-managed and manual configuration can result in conflicts
between the two, and conflicts will prevent the controller from applying its
configuration. To minimize this risk:

* Use the [admission webhook][admission-webhook]
  to reject Kubernetes resources that conflict with other configuration, or are
  otherwise invalid.
* Manually create configuration in a workspace that is not managed by the
  controller. This avoids most conflicts, but not all: routes may still
  conflict depending on your [route validation][route-validation] setting.

Large numbers of consumers (and associated credentials) are the exception to
this rule: if your consumer count is in the tens of thousands, we recommend
that you create them and their credentials through the Admin API to reduce etcd
load.

## Migrating between deployment types

Because etcd is the source of truth for Kong's configuration, the ingress
controller can re-create Kong's proxy configuration even if the underlying
datastore changes.

While most Kubernetes resources can be left unchanged when migrating between
deployment types, users must remove any KongPlugin resources that use
unavailable plugins when migrating from a database-backed deployment to a
DB-less deployment. No changes to Kubernetes resources are required if
migrating in the opposite direction.

[enterprise-download]: https://hub.docker.com/r/kong/kong-gateway/
[admission-webhook]: https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/deployment/admission-webhook.md
[route-validation]: /enterprise/{{page.kong_version}}/property-reference/#route_validation_strategy
[supported-plugins]: https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/references/plugin-compatibility.md
[k4k8s-enterprise-install]: /enterprise/{{page.kong_version}}/deployment/installation/kong-for-kubernetes
[k4k8s-with-enterprise-install]: /enterprise/{{page.kong_version}}/deployment/installation/kong-on-kubernetes
[vitals-prometheus]: /enterprise/{{page.kong_version}}/vitals/vitals-prometheus-strategy/
[vitals-influxdb]: /enterprise/{{page.kong_version}}/vitals/vitals-influx-strategy/
[support]: https://support.konghq.com/
