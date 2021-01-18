---
title: Implement and Test a Service
no_search: true
no_version: true
beta: true
---

## Implement a Service Version
Create a Service Implementation to expose your service to clients. When you
create an implementation, you also specify the Route to it. This Route,
combined with the proxy URL for the Service, will point to the endpoint
specified in the Service Implementation.

1. On the **example_service** overview, in the Version section, click **v.1**.

2. On the **v.1** overview, click **New Implementation**.

3. In the **Create Implementation** dialog, in step 1, create a new Service
Implementation to associate with your Service Version.

    1. Click the **Add using URL** radio button. This is the default.

    2. In the URL field, enter `http://mockbin.org`.

    3. Use the defaults for the 6 Advanced Fields.

    4. Click **Next**.

4. In step 2, **Add a Route** to add a route to your Service Implementation.

    For this example, enter the following:

    1. For Name, enter `mockbin`.

    2. For Path(s), click **Add Path** and enter `/mock`.

    3. For the remaining fields, use the default values listed.

    4. Click **Create**.

        The **v.1** Service Version overview displays.

        If you want to view the configuration, edit or delete the implementation,
        or delete the version, click the Actions menu.

## Verify the Implementation

1. From the top of the Service Version overview page, copy the **Proxy URL**.

2. Paste the URL into your browser’s address bar and append the route path you
just set. For example:

    ```
    http://konginc123456789.khcp.konghq.com/mock
    ```

    If successful, you should see the homepage for `mockbin.org`. On your Service
    Version overview page, you’ll see a record for status code 200. This might take
    a few moments.

And that's it! You have your first service set up, running, and routing
traffic proxied through a {{site.base_gateway}} runtime.

To summarize, in this topic you:

* Implemented the Service Version with the Route `/mock`. This means if an HTTP
request is sent to the Kong Gateway node and it matches route `/mock`, that
request is sent to `http://mockbin.org`.
* Abstracted a backend/upstream service and put a route of your choice on the
front end, which you can now give to clients to make requests.
