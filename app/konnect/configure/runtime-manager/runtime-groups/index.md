---
title: Runtime Groups
no_version: true
---

Konnect manages runtime configuration in runtime groups. Each runtime group acts
as a separate control plane and can manage runtime configurations independently
of any other group. You can find a list of all runtime groups in your organization
on the [Runtime Manager overview](https://konnect.konghq.com/runtime-manager/).

* A **runtime group** is a collection of API connectivity runtime instances
sharing the same configuration and behavior space.

* A **runtime instance** is a single data plane node with a single instance of
a runtime, such as Kong Gateway. Runtime instances service traffic for the runtime
group. All runtime instances in one runtime group
must be of the same type. Currently, only Kong Gateway runtime types are supported.

Every organization has one default runtime group. With an Enterprise subscription,
you can configure two additional custom runtime groups in the same Konnect
account to manage runtime instances and their configuration in any groupings
you want.

_<diagram - do we have a diagram of how runtime groups work somewhere?>_

## Default runtime group

The default runtime group is the foundational group in Konnect. Every
organization starts with one default group.

This group can be renamed, but it can't be deleted, and its status as the default
group can't be changed.

_Q: Is there going to be some identifier for the default group besides the name?
If the name can be changed, then how would a future admin know which group is the default?_

### Application registration in the Dev Portal

When publishing documentation from the Service Hub to the Dev Portal, you can
publish API specs from any version -- no matter which runtime group the version
is in. However, application registration is only supported for Service versions
running in the default runtime group.

So, if you want a Service version to be available for application registration,
create the version in the *default* runtime group. This means that you can have a
mix of Service versions running in different groups for different purposes.

For example, you might have:

* The latest version of a Service published to the Dev Portal with the latest
spec, running in the *default* group with application registration enabled.

* A previous version of the Service published to the Dev Portal,
running in the *default* group, but with application registration disabled.

* Another previous version of the Service, published to the Dev Portal, and
running in a *custom* runtime group. This version would only have the documentation
available, and developers would not have access to application registration for
this version.

Out of these three scenarios, only the Service version in the first scenario
would be available for application registration.

## Multiple runtime groups
{:.badge .enterprise}

In addition to the default runtime group, you can also configure two additional
custom groups. Splitting runtime instances and configuration into multiple
runtime groups provides multiple specialized environments in one account.

Some common use cases for using multiple runtime groups include:

* **Environment separation:** Split environments based on their purpose, such as
development, staging, and production.
* **Region separation:** Dedicate each runtime group to a region or group of
regions. Spin up runtime instances in those regions for each runtime group.
* **Team separation:** Dedicate each runtime group to a different team and share
resources based on team purpose.

[Set up and manage runtime groups &rarr;](/konnect/configure/runtime-manager/runtime-groups/manage)

## Administration

Access to each runtime group is configurable on a team-by-team basis using
entity-specific permissions.

_Q: Do users default to the default runtime group?
Q: What happens to users when a custom group is deleted?_

[Administer teams &rarr;](/link)

## Global configuration

For each runtime group, you can spin up runtime instances and configure global
options for the following {{site.base_gateway}} objects:
* Consumers
* Plugins
* Upstreams
* Certificates
* SNIs

A **global** object is a set of configurations that apply to, or can be used
by, all objects in a runtime group. For example, if you set up a Proxy Caching
plugin in the default runtime group and set it to `Global`,
the plugin configuration will apply to all Service versions in the group.

When there are multiple runtime groups, configuration for any of the global
objects only applies to the runtime group that it was created in. Consumers and
their authentication mechanisms don't carry over to other runtime groups.

[Manage global entities &rarr;](/konnect/configure/runtime-manager/manage-entities)

## References

### Runtime groups table

The following describes the content of the table found on the [Runtime Manager overview](https://konnect.konghq.com/runtime-manager/).

Column | Description
-------|-------------
Name | The name of the runtime group. This group name must be unique in the organization.
ID | A unique ID for the group. This ID is automatically generated when a group is created.
Type | Types of runtimes that this group contains. Currently, the only supported runtime type is `Kong Gateway`.
Active instances | The number of runtime instances in this group that are `Connected`, `Normal`, or `In Sync`.
Labels | A list of labels on the runtime group in the form of key-value pairs.

<!--State | The status of the runtime group. Can be one of: <br> &#8226; `initializing` - The group is currently being provisioned. <br> &#8226; `deployed` - The group has been provisioned and is available for use.-->

### Runtime instances table

The following describes the content of the Runtime Instances table found on the landing page of a runtime group.
You can sort the table by the `Last Seen` or `Sync Status` columns.

Column | Description
-------|-------------
Host | The hostname of the instance.
IP | The IP of the instance.
Last Seen | The last time that this instance received a configuration update from the Konnect control plane. was used to proxy a Service.
Version | The Kong Gateway version that this instance is running.
Sync Status | Whether this instance is in sync with the Konnect control plane or not. Can be one of: <br> &#8226; `In Sync` - The instance has received the last configuration that the control plane sent and is therefore in sync with the control plane. <br> &#8226; `Out of Sync` - The instance did not receive the last configuration that the control plane sent out.
