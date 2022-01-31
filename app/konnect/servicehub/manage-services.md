---
title: Manage Services through ServiceHub
no_version: true
---

## Services

### Add a Service to the Catalog

1. From the left navigation menu, click **Services** to open ServiceHub.

1. Click **Add New Service**.

1. Enter a **Service Name**.

    A Service name can be any string containing letters, numbers, or characters;
    for example, `service_name`, `Service Name`, or `Service-name`.

1. Enter a **Version Name**.

    A version name can be any string containing letters, numbers, or characters;
    for example, `1.0.0`, `v.1`, or `version#1`. A Service can have multiple
    versions.

1. (Optional) Enter a **Description**.

1. Click **Create**.

    A new Service is created and {{site.konnect_short_name}} automatically
    redirects to the Service's overview page.

### Update a Service

1. From the left navigation menu, click **Services**.

1. Select a Service from the list.

1. Edit the Service name and description directly on this page: click on either
element to reveal a text box, enter the new text, then click outside of the text
box to save.

### Delete a Service

1. From the left navigation menu, click **Services**.

1. Select a Service from the list.

1. In the top right of the overview page, click the **Actions** menu and select
**Delete**.

1. In the dialog that appears, confirm that you want to delete this Service.

## Service Versions and Implementations

### Create a New Service Version

Service versions have a Published status by default upon creation.

1. From the left navigation menu, click **Services**.

1. Select a Service from the dropdown menu.

1. Navigate to **Versions**, and click **+ New Version**.

1. Enter a version name and click **Create** to save.

### Set a Service Version to Draft

A draft service version will not appear on the Dev Portal UI and will still be editable in the Konnect Admin UI.

1. From the left navigation menu, click **Services**.

1. Select a Service from the dropdown menu.

1. Navigate to **Versions**.

1. Click on the version you want to set as a draft, and you'll be taken to the version detail page.

1. Click on the **Actions** dropdown menu.

1. Click **Set as Draft** to set the Service version as a draft.

    To publish the Service version, click **Publish** in the **Actions** dropdown.

### Deprecate a Service Version

Deprecating a service version will show a Deprecated status. Endpoints are still fully useable.

1. From the left navigation menu, click **Services**.

1. Select a Service from the dropdown menu.

1. Navigate to **Versions**.

1. Click on the version you want to deprecate, and you'll be taken to the version detail page.

1. Click on the **Actions** dropdown menu.

1. Click **Deprecate** to deprecate the Service version.

   A Deprecated version can be changed back to Published status. Click **Undeprecate** in the **Actions** dropdown.

### Archive a Service Version

Archiving prevents that version from showing up on the Dev Portal UI.

The Service version will still appear when managing services through ServiceHub. However, users will not be able to send requests to the Service version endpoints, and those endpoints will no longer be supported.

1. From the left navigation menu, click **Services**.

1. Select a Service from the dropdown menu.

1. Navigate to **Versions**.

1. Click on the version you want to archive, and you'll be taken to the version detail page.

1. Click on the **Actions** dropdown menu.

1. Click **Archive** to archive the Service version.

    An Archived version can be changed back to Published status, and the endpoints will be accessible again. Click **Publish** in the **Actions** dropdown.

### Delete a Service Version

Deleting a Service version _permanently_ deletes that version.

1. From the left navigation menu, click **Services**.

1. Select a Service from the dropdown menu.

1. Navigate to **Versions**.

1. Click on the version you want to delete, and you'll be taken to the version detail page.

1. Click on the **Actions** dropdown menu.

1. Click **Delete** to permanently delete the Service version.

### Implement a Service Version (Kong Gateway) {#implement-service-version}

<div class="alert alert-ee blue">
<b>Note:</b> Currently, the only supported implementation type is a
{{site.base_gateway}} runtime.
</div>

1. From the left navigation menu, click **Services**, then select a Service
version.

1. Click **New Implementation**.

1. In the **Create Implementation** dialog, in step 1, enter the connection
details for the upstream service.

    1. Enter a URL in the default **Add using URL** field, or switch to
    **Add using Protocol, Host and Path** and enter each piece separately.

    2. (Optional) Expand to **View 6 Advanced Fields** and further customize your
    implementation.

        See the [Service Object](/gateway/latest/admin-api/#service-object)
        documentation for parameter descriptions.

    3. Click **Next**.

1. In step 2, **Add a Route** to your Service Implementation.

    1. Enter any name.

        This Route name must be unique in the account. Variations on
        capitalization are considered unique, for example, `foo` and `Foo`.

    2. For **Method**, enter an HTTP method or a comma-separated list of methods
    that match this Route.

        For example, `GET` or `GET, POST`.

    3. For **Path(s)**, click **Add Path** and enter a path in the format
    `/<path>`.

    4. (Optional) Click **View 4 Advanced Fields** to see all options.
    You can accept the defaults, or further customize your Route.

        See the [Route Object](/gateway/latest/admin-api/#route-object)
        documentation for parameter descriptions.

    5. Click **Create**.

    The Service version overview displays.

    If you want to view the configuration, edit or delete the implementation,
    or delete the version, click the **Actions** menu.

#### Add a Route to a Version

When creating an implementation, you only create one Route. If the Service version
needs more Routes, you can add them to the version after creating the
first one.

1. From the left navigation menu, click **Services**, then select a Service
version.

1. In the **Routes** section, click **New Route**.

1. Fill in the fields as described in [Implement a Service Version](#implement-service-version),
then click **Create**.

### Verify an Implementation

For any runtime instance created with the provided Docker script (see
[Setting up a Kong Gateway Runtime](/konnect/runtime-manager/)),
the default proxy URL is `localhost:8000`.

Enter the proxy URL into your browser’s address bar and append any route path.
The final URL should look something like this:

```bash
http://localhost:8000/foo
```

If successful, you’ll be able to access your upstream service. The Service
version's overview page will also update with a new record for status
code `200`. This might take a few moments.
