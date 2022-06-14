---
title: Manage Services through ServiceHub
no_version: true
---

An implementation is a Gateway Service. By implementing a Konnect Service
version, you create a Gateway Service in the version's runtime group.

## Implement a Service version (Kong Gateway) {#implement-service-version}

Expose the Service version by pointing it to an upstream service and creating
a Route for the proxy. Traffic travelling through this proxy Route can use any
runtime instance in the runtime group that the Service version belongs to.

{:.note}
> **Note:** Currently, the only supported implementation type is a
{{site.base_gateway}} runtime.


1. In the {% konnect_icon servicehub %} Service Hub, select a Service version.

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
    or delete the version, click the **Version actions** menu.

    You can find the linked Gateway Service in the Runtime Manager.

## Add a Route to a version

When creating an implementation, you only create one Route. If the Service version
needs more Routes, you can add them to the version after creating the
first one.

All Routes are created in the same runtime group as their parent Service version.

1. In the {% konnect_icon servicehub %} Service Hub, select a Service version.

1. In the **Routes** section, click **+ Add route**.

1. Fill in the fields as described in [Implement a Service Version](#implement-service-version),
then click **Create**.

## Verify an implementation

For any runtime instance created with the provided Docker script (see
[Setting up a Kong Gateway Runtime](/konnect/runtime-manager/runtime-instances/gateway-runtime-docker)),
the default proxy URL is `localhost:8000`.

Enter the proxy URL into your browser’s address bar and append any route path.
The final URL should look something like this:

```bash
http://localhost:8000/foo
```

If successful, you’ll be able to access your upstream service. The Service
version's overview page will also update with a new record for status
code `200`. This might take a few moments.
