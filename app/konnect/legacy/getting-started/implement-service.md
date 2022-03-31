---
title: Implement and Test a Service
no_version: true
---

Create a Service implementation to expose your Service to clients.

When you create an implementation, you also specify the Route to it. This Route,
combined with the proxy URL for the Service, will lead to the endpoint
specified in the Service implementation.

## Prerequisites

If you're following the {{site.konnect_short_name}} quickstart guide,
make sure you have
[configured a Service](/konnect/legacy/getting-started/configure-service).

## Implement a Service Version

1. On the **example_service** overview, in the Versions section, click **v.1**.

2. Click **New Implementation**.

3. In the **Create Implementation** dialog, in step 1, create a new Service
implementation to associate with your Service version.

    1. Click the **Add using URL** radio button. This is the default.

    2. In the URL field, enter `http://mockbin.org`.

    3. Use the defaults for the **6 Advanced Fields**.

    4. Click **Next**.

4. In step 2, **Add a Route** to add a route to your Service Implementation.

    For this example, enter the following:

    1. For **Name**, enter `mockbin`.

    2. For **Method**, enter `GET`.

    3. For **Path(s)**, click **Add Path** and enter `/mock`.

    4. For the remaining fields, use the default values listed.

    5. Click **Create**.

    The **v.1** Service Version overview displays.

    If you want to view the configuration, edit or delete the implementation,
    or delete the version, click the **Actions** menu.

## Verify the Implementation

If you used the Docker script to create a container
earlier in [Configure a Runtime](/konnect/legacy/getting-started/configure-runtime),
your runtime's default proxy URL is `localhost:8000`.

Enter the proxy URL into your browser’s address bar and append the route path
you just set. The final URL should look something like this:

```
http://localhost:8000/mock
```

If successful, you should see the homepage for `mockbin.org`. On your Service
Version overview page, you’ll see a record for status code 200. This might
take a few moments.

And that's it! You have your first service set up, running, and routing
traffic proxied through a {{site.base_gateway}} runtime.

## Summary and Next Steps

To summarize, in this topic you:

* Implemented the Service version `v.1` with the Route `/mock`. This means if an HTTP
request is sent to the {{site.base_gateway}} node and it matches route `/mock`, that
request is sent to `http://mockbin.org`.
* Abstracted a backend/upstream service and put a route of your choice on the
front end, which you can now give to clients to make requests.

For next steps, check out some of the other things you can do in
{{site.konnect_saas}}:
* Enable plugins on a [Service](/konnect/legacy/manage-plugins/enable-service-plugin/) or a
[Route](/konnect/legacy/manage-plugins/enable-route-plugin/)
* [Set up the Dev Portal](/konnect/legacy/servicehub/dev-portal/service-documentation)
* [Manage your teams and users with RBAC](/konnect/legacy/org-management/users-and-roles)
