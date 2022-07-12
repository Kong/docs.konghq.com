---
title: Manage Konnect Service Versions
no_version: true
---

Every {{site.konnect_short_name}} service version is associated with one [runtime group](/konnect/runtime-manager/runtime-groups/).
Any configurations for the service version, such as implementations, plugins,
and routes, will also be associated with the same runtime group.

If a service has multiple service versions, each version can be
associated with a different runtime group, or with the same runtime group.
Through its versions, a service can made be available in multiple environments,
simply by creating new service versions in different runtime groups.

A common use case for this is environment specialization.
For example, if you have three runtime groups for `development`, `staging`, and
`production`, you can manage which environment the service is available in by
assigning a version to that group at creation time. You might have v1 running
in `production`, and be actively working on v2 in `development`. Once it's
ready to test, you'd create v2 in `staging` before finally creating v2 in
`production` alongside v1.

{:.note}
> **Note:** You can't move a service version from one runtime group to another.
Instead, create a new version of the service in the new environment when you're
ready to move to it.

## Create a service version

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service, then follow these steps:

1. From the **Service actions** drop-down menu, select **Add new version**.

1. Enter a version name.

    A version name can be any string containing letters, numbers, or characters;
    for example, `1.0.0`, `v.1`, or `version#1`. A service can have any number of
    versions.

1. Select a runtime group.

    Choose a group to deploy this version to a specific group of runtime
    instances. This determines which entities and runtimes the service version
    has access to, and who has access to this version.

    {:.note}
    > **Note:** Application registration is only available for
    services in the default runtime group, so if you plan on enabling
    [application registration](/konnect/dev-portal/applications/application-overview),
    choose `default` in this step.

    Different versions of the same service can run in different runtime groups.
    The version name is unique within a group:

    * If you create multiple versions in the _same group_, the versions must have unique names.
    * If you create multiple versions in _different groups_, the versions can have the same name.

1. Click **Create** to save.

## Delete a service version

Deleting a service version permanently removes it and its implementation, routes, and plugins from the Service Hub.

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version, then delete it:

* From the **Version actions** drop-down menu, select **Delete**, then confirm deletion in the dialog.
