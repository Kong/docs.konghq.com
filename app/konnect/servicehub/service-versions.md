---
title: Manage Konnect Service Versions
no_version: true
---

Every {{site.konnect_short_name}} service version is associated with one [runtime group](/konnect/runtime-manager/runtime-groups/).
Any configurations for the service version, such as implementations, plugins,
and routes, will also be associated with the same runtime group.

If a Service has multiple Service versions, each version can be
associated with a different runtime group, or with the same runtime group.
Through its versions, a Service can made be available in multiple environments,
simply by creating new Service versions in different runtime groups.

A common use case for this is environment specialization.
For example, if you have three runtime groups for `development`, `staging`, and
`production`, you can manage which environment the Service is available in by
assigning a version to that group at creation time. You might have v1 running
in `production`, and be actively working on v2 in `development`. Once it's
ready to test, you'd create v2 in `staging` before finally creating v2 in
`production` alongside v1.

{:.note}
> **Note:** You can't move a Service version from one runtime group to another.
Instead, create a new version of the Service in the new environment when you're
ready to move to it.

## Create a Service version

1. In the {% konnect_icon servicehub %} Service Hub, select a Service from the list.

1. Click **Service actions** > **Add new version**.

1. Enter a **Version Name**.

    A version name can be any string containing letters, numbers, or characters;
    for example, `1.0.0`, `v.1`, or `version#1`. A Service can have any number of
    versions.

1. Select a runtime group.

    Choose a group to deploy this version to a specific group of runtime
    instances. This determines which entities and runtimes the Service version
    has access to, and who has access to this version.

    {:.note}
    > **Note:** Application registration is only available for
    Services in the default runtime group, so if you plan on enabling
    [application registration](/konnect/dev-portal/applications/application-overview),
    choose `default` in this step.

    Different versions of the same Service can run in different runtime groups.
    The version name is unique within a group:

    * If you create multiple versions in the **same group**, they must have unique names.
    * If you create multiple versions in **different groups**, the versions can have the same name.

1. Click **Create** to save.

## Delete a service version

1. In the {% konnect_icon servicehub %} Service Hub, select a service from the list.

1. Navigate to **Versions**.

1. Click on the version you want to delete, and you'll be taken to the version detail page.

1. Click on the **Version actions** dropdown menu.

1. Click **Delete** to permanently delete the Service version.
