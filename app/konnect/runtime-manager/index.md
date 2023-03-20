---
title: About Runtime Manager
---

The [Runtime Manager](https://cloud.konghq.com/runtime-manager)
is a {{site.konnect_saas}} functionality module
that lets you catalogue, connect to, and monitor the status of all runtime
groups and instances in one place, as well as manage group configuration.

The Runtime Manager overview page displays a list of
runtime groups currently owned by the organization. From here, you can add or
delete runtime groups, or go into each individual group to manage runtime
instances and their global configuration.

With {{site.konnect_short_name}} acting as the control plane, a runtime instance
doesn't need a database to store configuration data. Instead, configuration
is stored in-memory on each node, and you can easily update all runtime instances
in a group with a few clicks.

The Runtime Manager, and the {{site.konnect_saas}} application as
a whole, does not have access or visibility into the data flowing through your
runtimes, and it does not store any data except the state and connection details
for each runtime instance.

## Runtime instances

A **runtime instance** is a single data plane node with a single instance of
a runtime, such as {{site.base_gateway}}. Runtime instances service traffic for the runtime
group. All runtime instances in one runtime group
must be of the same type. Currently, only {{site.base_gateway}} runtime types are supported.

Kong does not host runtimes. You must provide your own runtime
instances.

The Runtime Manager aims to simplify this process by providing a
script to provision a {{site.base_gateway}} runtime in a Docker container,
eliminating any confusion about initial configuration or setup.

You can also
choose to manually configure runtime instances on the following:
* Linux
* Kubernetes
* AWS
* Azure

See the [runtime instance installation options](/konnect/runtime-manager/runtime-instances/) for more detail.

### Runtime instances dashboard

The following describes the content of the Runtime Instances table found on the landing page of a runtime group.
You can sort the table by the `Last Ping` column.

SCREENSHOT HERE

Column | Description
-------|-------------
Host | The hostname of the instance.
Type | The runtime instance type. Currently, only {{site.base_gateway}} is supported.
Last Ping | The last time that this instance received a configuration update from the {{site.konnect_short_name}} control plane to proxy a service.
Version | The {{site.base_gateway}} version that this instance is running.
ID | The UUID of the instance.

## Runtime groups

{{site.konnect_short_name}} manages runtime configuration in runtime groups. A **runtime group** is a collection of API connectivity runtime instances
sharing the same configuration and behavior space. Each runtime group acts
as a separate control plane and can manage runtime configurations independently
of any other group. You can find a list of all runtime groups in your organization
on the [Runtime Manager overview](https://cloud.konghq.com/runtime-manager/).

Every organization has one default runtime group. The default runtime group is the foundational group in {{site.konnect_short_name}}.
Every region in every organization starts with one default group. This group can't be deleted, and its status as the default group can't be changed.

With an [Enterprise subscription](https://konghq.com/pricing/), you can configure additional
custom runtime groups. Use multiple groups in one {{site.konnect_short_name}} organization to
manage runtime instances and their configuration in any groupings you want.

Some common use cases for using multiple runtime groups include:

* **Environment separation:** Split environments based on their purpose, such as
development, staging, and production.
* **Region separation:** Dedicate each runtime group to a region or group of
regions. Spin up runtime instances in those regions for each runtime group.
* **Team separation:** Dedicate each runtime group to a different team and share
resources based on team purpose.

![runtime groups](/assets/images/docs/konnect/konnect-runtime-groups-example.png)
> _**Figure 1:** Example runtime group configuration with three runtime groups: the default group, a development group, and a production group. {{site.konnect_short_name}} is the SaaS-managed global management plane that controls all of the groups, while the runtime groups contain self-managed runtime instances._

Access to each runtime group is configurable on a team-by-team basis using
entity-specific permissions. For more information, see [Administer teams](/konnect/org-management/teams-and-roles).

[Set up and manage runtime groups &rarr;](/konnect/runtime-manager/runtime-groups/manage)

### Runtime group dashboard

For each runtime group, you can view traffic, error rate, and {{site.base_gateway}} service analytics for instances in a runtime group. This allows you to see how much of a runtime group is used. You can also select the time frame of analytics that you want to display.

The following describes the content of the table found on the [Runtime Manager overview](https://cloud.konghq.com/runtime-manager/).

SCREENSHOT HERE

Column | Description
-------|-------------
Name | The name of the runtime group. This group name must be unique in the organization.
ID | A unique ID for the group. This ID is automatically generated when a group is created.
Type | Types of runtimes that this group contains. Currently, the only supported runtime type is {{site.base_gateway}}.

<!--
Labels | A list of labels on the runtime group in the form of key:value pairs. -->

[Runtime group dashboard &rarr;](/konnect/runtime-manager/runtime-groups/dashboard)

### Runtime group configuration

For each runtime group, you can spin up runtime instances and configure
the following {{site.base_gateway}} objects:
* Gateway services
* Routes
* Consumers
* Consumer Groups
* Plugins
* Upstreams
* Certificates
* SNIs
* Vaults

When there are multiple runtime groups, any object configuration only
applies to the runtime group that it was created in. Consumers and
their authentication mechanisms don't carry over to other runtime groups.

[{{site.base_gateway}} configuration in {{site.konnect_short_name}} &rarr;](/konnect/runtime-manager/gateway-config)

## Plugins

You can extend {{site.konnect_short_name}} by using plugins. Kong provides a set of standard Lua plugins that get bundled with {{site.konnect_short_name}}. The set of plugins you have access to depends on your installation.

Custom plugins can also be developed by the Kong Community and are supported and maintained by the plugin creators. If they are published on the Kong Plugin Hub, they are called Community or Third-Party plugins.

See the [{{site.konnect_short_name}} plugin ordering documentation](/konnect/runtime-manager/plugins/) for more information.