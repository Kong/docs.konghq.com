---
title: Manage Services through Service Hub
no_version: true
---

An implementation is a Gateway service. By implementing a {{site.konnect_short_name}} service
version, you create a Gateway service in the version's runtime group.

## Implement a service version ({{site.base_gateway}}) {#implement-service-version}

Expose the service version by pointing it to an upstream service and creating
a route for the proxy. Traffic traveling through this proxy route can use any
runtime instance in the runtime group that the service version belongs to.

{:.note}
> **Note:** Currently, the only supported implementation type is a
{{site.base_gateway}} runtime.


From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version.
Add an implementation from this page:

1. Click **New Implementation**.

1. In the **Create Implementation** dialog, in step 1, enter the connection
details for the upstream service.

    1. Enter a name for the Gateway service.

        The name can be any string containing letters, numbers, or the following
        characters: `.`, `-`, `_`, `~`, `:`. Do not use spaces.

        For example, you can use `example_service`, `ExampleService`, `Example-Service`.
        However, `Example Service` is invalid.

    1. Enter a URL in the default **Add using URL** field, or switch to
    **Add using Protocol, Host and Path** and enter each piece separately.

    1. Optional: Expand to **View 6 Advanced Fields** and further customize your
    implementation.

        See the [Service Object](/gateway/latest/admin-api/#service-object)
        documentation for parameter descriptions.

    1. Click **Next**.

1. In step 2, **Add a Route** to your service implementation.

    1. Enter any name.

        This route name must be unique in the account. Variations on
        capitalization are considered unique, for example, `foo` and `Foo`.

    1. For **Method**, enter an HTTP method or a comma-separated list of methods
    that match this route.

        For example, `GET` or `GET, POST`.

    1. For **Path(s)**, click **Add Path** and enter a path in the format
    `/<path>`.

    1. Optional: Click **View 4 Advanced Fields** to see all options.
    You can accept the defaults, or further customize your route.

        See the [Route Object](/gateway/latest/admin-api/#route-object)
        documentation for parameter descriptions.

    1. Click **Create**.

    If you want to view the configuration, edit or delete the implementation,
    or delete the version, click the **Version actions** drop-down menu from the version overview.

    You can find the linked Gateway service in the Runtime Manager.

## Add a route to a version

When creating an implementation, you only create one route. If the service version
needs more routes, you can add them to the version after creating the
first one.

All routes are created in the same runtime group as their parent service version.

{:.important}
> **Important**: Starting with {{site.base_gateway}} 3.0.0.0, the router supports logical expressions.
Regex routes must begin with a `~` character. For example: `~/foo/bar/(?baz\w+)`.
Learn more in the [route configuration guide](/gateway/latest/key-concepts/routes/expressions/).

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version.
Add a route from this page:

1. In the **Routes** section, click **Add route**.

1. Fill in the fields as described in [Implement a Service Version](#implement-service-version),
then click **Create**.

## Verify an implementation

For any runtime instance created with the provided Docker script (see
[Setting up a {{site.base_gateway}} Runtime](/konnect/runtime-manager/runtime-instances/gateway-runtime-docker)),
the default proxy URL is `localhost:8000`.

Enter the proxy URL into your browser’s address bar and append any route path.
The final URL should look something like this:

```bash
http://localhost:8000/foo
```

If successful, you’ll be able to access your upstream service. The service
version's overview page will also update with a new record for status
code `200`. This might take a few moments.
