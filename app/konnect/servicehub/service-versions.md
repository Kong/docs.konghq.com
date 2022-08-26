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

Every service version may be in one of the states: "Published", "Deprecated" and "Unpublished":
* **Published**: This indicates that the service version is ready to be shared with the API consumers. It is exposed to Dev Portal where developers can request access to consume it via the {{site.base_gateway}}. This is default state.
* **Deprecated**: This indicates that the service version will be deprecated soon. It will still be exposed to the Dev Portal and receive API request via {{site.base_gateway}}. Banner with information about deprecation will be displayed at the top of the service version page in Dev Portal.
* **Unpublished**: This indicates that the service version is no longer exposed to Dev Portal but can still be accessed by existing Dev Portal Application via {{site.base_gateway}}.

{:.note}
> **Note:** If service package to which service version is associated is unpublished, the service version won't be exposed to Dev Portal.

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


## Managing a service version lifecycle

Changing service version status will have an impact on its visibility in Dev Portal. 

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service, then selects its service version which status you would like to adjust. Then follow these steps:

1. From the **Service version actions** drop-down menu, select **Edit version status**.

2. In dialog you can select appropriate status. Next to each status there is a brief explanation which pops up on icon hover.

    1. In some cases there might be an additional step to fulfill.

3. Click **Save** to adjust status of service version.

## Delete a service version

Deleting a service version permanently removes it and its implementation, routes, and plugins from the Service Hub.

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version, then delete it:

* From the **Service version actions** drop-down menu, select **Delete service version**, then confirm deletion in the dialog.
* Confirm deletion by typing name of service version and click **Yes, delete**
