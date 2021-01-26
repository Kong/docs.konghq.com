---
title: Manage Services through ServiceHub
no_search: true
no_version: true
---

## Services
### Add a Service to the Catalog

1. From the left navigation menu, click **Services** to open ServiceHub.

2. Click **Add New Service**.

3. Enter a **Service Name**.

    A Service name can be any string containing letters, numbers, or characters;
    for example, `service_name`, `Service Name`, or `Service-name`.

4. Enter a **Version Name**.

    A version name can be any string containing letters, numbers, or characters;
    for example, `1.0.0`, `v.1`, or `version#1`. A Service can have multiple
    versions.

5. (Optional) Enter a **Description**.

6. Click **Create**.

    A new Service is created and {{site.konnect_short_name}} automatically
    redirects to the Service's overview page.

### Update a Service

1. From the left navigation menu, click **Services**.

2. Select a Service from the list.

3. Edit the Service name and description directly on this page: click on either
element to reveal a text box, enter the new text, then click outside of the text
box to save.

### Delete a Service

1. From the left navigation menu, click **Services**.

2. Select a Service from the list.

3. In the top right of the overview page, click the **Actions** menu and select
**Delete Service**.

4. In the dialog that appears, confirm that you want to delete this service.

## Service Versions and Implementations

### Create a New Service Version

1. From the left navigation menu, click **Services**.

2. Select a Service from the list.

3. In the **Versions** section, click **+ New Version**.

4. Enter a version name and click **Create** to save.

### Implement a Service Version (Kong Gateway) {#implement-service-version}

<div class="alert alert-ee blue">
<b>Note:</b> Currently, the only supported implementation type is a
{{site.ee_gateway_name}} runtime.
</div>

1. From the left navigation menu, click **Services**, then select a Service
version.

2. Click **New Implementation**.

3. In the **Create Implementation** dialog, in step 1, enter the connection
details for the upstream service.

    1. Enter a URL in the default **Add using URL** field, or switch to
    **Add using Protocol, Host and Path** and enter each piece separately.

    2. (Optional) Expand to **View 6 Advanced Fields** and further customize your
    implementation.

        See the [Service Object](/enterprise/latest/admin-api/#service-object)
        documentation for parameter descriptions.

    3. Click **Next**.

4. In step 2, **Add a Route** to your Service Implementation.

    1. Enter any name.

        This Route name must be unique in the account. Variations on
        capitalization are considered unique, for example, `foo` and `Foo`.

    2. For **Path(s)**, click **Add Path** and enter a path in the format
    `/<path>`.

    3. (Optional) Click **View 4 Advanced Fields** to see all options.
    You can accept the defaults, or further customize your Route.

        See the [Route Object](/enterprise/latest/admin-api/#route-object)
        documentation for parameter descriptions.

    4. Click **Create**.

    The Service version overview displays.

    If you want to view the configuration, edit or delete the implementation,
    or delete the version, click the **Actions** menu.

#### Add a Route to a Version

When creating an implementation, you only create one Route. If the Service version
needs more Routes, you can add them to the version after creating the
first one.

1. From the left navigation menu, click **Services**, then select a Service
version.

2. In the **Routes** section, click **New Route**.

3. Fill in the fields as described in [Implement a Service Version](#implement-service-version),
then click **Create**.

### Verify an Implementation

1. Open a Service version overview page.

2. From the top of the page, copy the **Proxy URL**.

3. Paste the URL into your browser’s address bar and append the route path you
just set. For example:

    ```
    http://konginc123456789.konnect.konghq.com/<route-path>
    ```

    If successful, you’ll be able to access your upstream service. The Service
    version's overview page will also update with a new record for status
    code `200`. This might take a few moments.
