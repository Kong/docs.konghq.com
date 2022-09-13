---
title: Runtime Groups
no_version: true
---

{{site.konnect_short_name}} manages runtime configuration in runtime groups. Each runtime group acts
as a separate control plane and can manage runtime configurations independently
of any other group. You can find a list of all runtime groups in your organization
on the [Runtime Manager overview](https://cloud.konghq.com/runtime-manager/).

* A **runtime group** is a collection of API connectivity runtime instances
sharing the same configuration and behavior space.

* A **runtime instance** is a single data plane node with a single instance of
a runtime, such as {{site.base_gateway}}. Runtime instances service traffic for the runtime
group. All runtime instances in one runtime group
must be of the same type. Currently, only {{site.base_gateway}} runtime types are supported.

Every organization has one default runtime group.

With an [Enterprise subscription](https://konghq.com/pricing/), you can configure additional
custom runtime groups. Use multiple groups in one {{site.konnect_short_name}} organization to
manage runtime instances and their configuration in any groupings you want.

![runtime groups](/assets/images/docs/konnect/konnect-runtime-groups-example.png)
> _**Figure 1:** Example runtime group configuration with three runtime groups: the default group, a development group, and a production group. {{site.konnect_short_name}} is the SaaS-managed global management plane that controls all of the groups, while the runtime groups contain self-managed runtime instances._

## Default runtime group

The default runtime group is the foundational group in {{site.konnect_short_name}}. Every
organization starts with one default group.

This group can't be renamed or deleted, and its status as the default
group can't be changed.

### Application registration in the Dev Portal

When publishing documentation from the Service Hub to the Dev Portal, you can
publish API specs from any version -- no matter which runtime group the version
is in. However, application registration is only supported for service versions
running in the default runtime group.

So, if you want a service version to be available for application registration,
create the version in the *default* runtime group. This means that you can have a
mix of service versions running in different groups for different purposes.

For example, you might have:

* The latest version of a service published to the Dev Portal with the latest
spec, running in the *default* group with application registration enabled.

* A previous version of the service published to the Dev Portal,
running in the *default* group, but with application registration disabled.
Any app with existing credentials can continue using them, but the version is
not available for new registrations.

* Another previous version of the service, published to the Dev Portal, and
running in a *custom* runtime group. This version would only have the documentation
available, and developers would not have access to application registration for
this version.

Out of these three scenarios, only the service version in the first scenario
would be available for application registration.

## Multiple runtime groups
{:.badge .enterprise}

In addition to the default runtime group, you can also configure custom groups.
Splitting runtime instances and configuration into multiple
runtime groups provides multiple specialized environments in one account.

Some common use cases for using multiple runtime groups include:

* **Environment separation:** Split environments based on their purpose, such as
development, staging, and production.
* **Region separation:** Dedicate each runtime group to a region or group of
regions. Spin up runtime instances in those regions for each runtime group.
* **Team separation:** Dedicate each runtime group to a different team and share
resources based on team purpose.

[Set up and manage runtime groups &rarr;](/konnect/runtime-manager/runtime-groups/manage)

## Administration

Access to each runtime group is configurable on a team-by-team basis using
entity-specific permissions.

[Administer teams &rarr;](/konnect/org-management/teams-and-roles)

## Runtime group dashboard

For each runtime group, you can view traffic, error rate, and {{site.base_gateway}} service analytics for instances in a runtime group. This allows you to see how much of a runtime group is used. You can also select the time frame of analytics that you want to display. 

[Runtime group dashboard &rarr;](/konnect/runtime-manager/runtime-groups/dashboard)

## Runtime group configuration

For each runtime group, you can spin up runtime instances and configure
the following {{site.base_gateway}} objects:
* Gateway services
* Routes
* Consumers
* Plugins
* Upstreams
* Certificates
* SNIs

When there are multiple runtime groups, any object configuration only
applies to the runtime group that it was created in. Consumers and
their authentication mechanisms don't carry over to other runtime groups.

[{{site.base_gateway}} configuration in {{site.konnect_short_name}} &rarr;](/konnect/runtime-manager/gateway-config)

## References

### Runtime groups table

The following describes the content of the table found on the [Runtime Manager overview](https://cloud.konghq.com/runtime-manager/).

Column | Description
-------|-------------
Name | The name of the runtime group. This group name must be unique in the organization.
ID | A unique ID for the group. This ID is automatically generated when a group is created.
Type | Types of runtimes that this group contains. Currently, the only supported runtime type is {{site.base_gateway}}.

<!--
Labels | A list of labels on the runtime group in the form of key:value pairs. -->

### Runtime instances table

The following describes the content of the Runtime Instances table found on the landing page of a runtime group.
You can sort the table by the `Last Ping` column.

Column | Description
-------|-------------
Host | The hostname of the instance.
Type | The runtime instance type. Currently, only {{site.base_gateway}} is supported.
Last Ping | The last time that this instance received a configuration update from the {{site.konnect_short_name}} control plane to proxy a service.
Version | The {{site.base_gateway}} version that this instance is running.
ID | The UUID of the instance.
