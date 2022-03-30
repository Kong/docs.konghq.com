---
title: Manage Services through ServiceHub
no_version: true
---

Through the [ServiceHub](https://cloud.konghq.com/servicehub/), you can
create and manage all Konnect Services, Service versions, and Service
implementations in one place.

## Konnect Services

Access all Konnect Service configuration through the
![service hub icon](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .konnect-icn .no-image-expand}
**ServiceHub**.

### Add a Service to the catalog

1. In the ![service hub icon](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .konnect-icn .no-image-expand}
ServiceHub, click **Add New Service**.

1. Enter a **Service Name**.

    A Service name can be any string containing letters, numbers, or the following
    characters: `.`, `-`, `_`, `~`, or `:`. Do not use spaces in Service names.

    For example, you can use `service_name`, `ServiceName`, or `Service-name`.
    However, `Service Name` is invalid.

1. (Optional) Enter a **Description**.

1. Click **Create**.

    A new Service is created and {{site.konnect_short_name}} automatically
    redirects to the Service's overview page.

### Update a Service

1. In the ![service hub icon](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .konnect-icn .no-image-expand}
ServiceHub, select a Service from the list.

1. Edit the Service name and description directly on this page: click on either
element to reveal a text box, enter the new text, then click outside of the text
box to save.

### Share a Service

If you have a Service Admin or Organization Admin role, you can share any
Service that you have access to.

For more information, see [Manage Teams, Roles, and Users](/konnect/org-management/teams-roles-users/#entity-and-role-sharing).

1. In the ![service hub icon](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .konnect-icn .no-image-expand}
ServiceHub, select a Service from the list.

1. Click **Share Service**.

1. Select a user or team to share the Service with.

1. Select a role to grant to the user or team.

1. Click **Share Service** to save.

### Delete a Service

1. In the ![service hub icon](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .konnect-icn .no-image-expand}
ServiceHub, select a Service from the list.

1. In the top right of the overview page, click the **Actions** menu and select
**Delete Service**.

1. In the dialog that appears, confirm that you want to delete this service.

## Service versions

Every Konnect Service version is associated with one runtime group.
Any configurations for the Service version, such as implementations, plugins,
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

### Create a new Service version

1. In the ![service hub icon](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .konnect-icn .no-image-expand}
ServiceHub, select a Service from the list.

1. Navigate to **Versions**, and click **+ New Version**.

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

### Delete a Service version

1. In the ![service hub icon](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .konnect-icn .no-image-expand}
ServiceHub, select a Service from the list.

1. Navigate to **Versions**.

1. Click on the version you want to delete, and you'll be taken to the version detail page.

1. Click on the **Actions** dropdown menu.

1. Click **Delete Version** to permanently delete the Service version.

## Service version implementations

### Implement a Service version (Kong Gateway) {#implement-service-version}

Expose the Service version by pointing it to an upstream service and creating
a Route for the proxy. Traffic travelling through this proxy Route can use any
runtime instance in the runtime group that the Service version belongs to.

{:.note}
> **Note:** Currently, the only supported implementation type is a
{{site.base_gateway}} runtime.

An implementation is a Gateway Service. By implementing a Konnect Service
version, you create a Gateway Service in the version's runtime group.

1. In the ![service hub icon](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .konnect-icn .no-image-expand}
ServiceHub, select a Service version.

1. Click **New Implementation**.

1. In the **Create Implementation** dialog, in step 1, enter the connection
details for the upstream service.

    1. Enter a name for the Gateway Service.

        This name must be unique to the runtime group. You can't use an
        existing Gateway Service here.

    1. Enter a URL in the default **Add using URL** field, or switch to
    **Add using Protocol, Host and Path** and enter each piece separately.

    1. (Optional) Expand to **View 6 Advanced Fields** and further customize your
    implementation.

        See the [Service Object](/gateway/latest/admin-api/#service-object)
        documentation for parameter descriptions.

    1. Click **Next**.

1. In step 2, **Add a Route** to your Service Implementation.

    1. Enter any name.

        This Route name must be unique in the account. Variations on
        capitalization are considered unique, for example, `foo` and `Foo`.

    1. For **Method**, enter an HTTP method or a comma-separated list of methods
    that match this Route.

        For example, `GET` or `GET, POST`.

    1. For **Path(s)**, click **Add Path** and enter a path in the format
    `/<path>`.

    1. (Optional) Click **View 4 Advanced Fields** to see all options.
    You can accept the defaults, or further customize your Route.

        See the [Route Object](/gateway/latest/admin-api/#route-object)
        documentation for parameter descriptions.

    1. Click **Create**.

    The Service version overview displays.

    If you want to view the configuration, edit or delete the implementation,
    or delete the version, click the **Actions** menu.

    You can find the linked Gateway Service in the Runtime Manager.

### Add a Route to a version

When creating an implementation, you only create one Route. If the Service version
needs more Routes, you can add them to the version after creating the
first one.

All Routes are created in the same runtime group as their parent Service version.

1. In the ![service hub icon](/assets/images/icons/konnect/icn-servicehub.svg){:.inline .konnect-icn .no-image-expand}
ServiceHub, select a Service version.

1. In the **Routes** section, click **New Route**.

1. Fill in the fields as described in [Implement a Service Version](#implement-service-version),
then click **Create**.

### Verify an implementation

For any runtime instance created with the provided Docker script (see
[Setting up a Kong Gateway Runtime](/konnect/configure/runtime-manager/runtime-instances/gateway-runtime-docker)),
the default proxy URL is `localhost:8000`.

Enter the proxy URL into your browser’s address bar and append any route path.
The final URL should look something like this:

```bash
http://localhost:8000/foo
```

If successful, you’ll be able to access your upstream service. The Service
version's overview page will also update with a new record for status
code `200`. This might take a few moments.
