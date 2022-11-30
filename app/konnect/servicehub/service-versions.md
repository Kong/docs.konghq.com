---
title: Manage Konnect Service Versions
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

Each service version is in one of the states:
* **Published**: This indicates that the service version is ready to be shared with API consumers. It displays in the Dev Portal where developers can request access to consume it via {{site.base_gateway}}. This is the default state.
* **Deprecated**: This indicates that the service version will be deprecated soon. It is still displayed in the Dev Portal and can receive API request via {{site.base_gateway}}. A banner with information about the deprecation is displayed at the top of the service version page in the Dev Portal and developers are notified via email that the version is deprecated.
* **Unpublished:** This indicates that the service version no longer displays in the Dev Portal, but it can still be accessed by existing Dev Portal applications via {{site.base_gateway}}.

{:.note}
> **Note:** If the service package associated with a service version is unpublished, the service version won't display in the Dev Portal.

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


## Manage the service version lifecycle

The service version lifecycle determines how and if a service version is displayed in the Dev Portal. 

1. From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), choose the service you want to manage the lifecycle of.

2. Select the service version you want to manage.

3. Click  **Service version actions** > **Edit version status**.

4. Select a service version status.
   
    1. Deprecation only: Click **Save** on the dialog to deprecate the service version and send consumers an email notification.

5. Click **Save**.

## Delete a service version

Deleting a service version permanently removes it and its implementation, routes, and plugins from the Service Hub.

1. From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select the service version you want to delete.

2. Click **Service version actions** > **Delete service version**.

3. Confirm the deletion by typing the name of the service version and clicking **Yes, delete**.
