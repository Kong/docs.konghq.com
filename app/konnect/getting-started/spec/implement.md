---
title: Implement a Service Version with Kong Gateway
no_version: true
---

Your Service is now shared with developers, and they can access the API spec
documentation. Next, you can let your developers interact with the Konnect
Service directly by building applications that can consume the Service.

To do this, first you need to implement the Service to expose it to clients.

## Prerequisites

If you're following the {{site.konnect_short_name}} API spec guide,
make sure you have [imported API docs into Konnect](/konnect/getting-started/spec/service/).

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

    * **Name**: `mockbin`
    * **Method**: `GET`
    * **Path(s)**: Click **Add Path** and enter `/mock`

    For the remaining fields, use the default values listed.

5. Click **Create**.

    The **v.1** Service Version overview displays.

    If you want to view the configuration, edit or delete the implementation,
    or delete the version, click the **Actions** menu.


## Set up a Kong Gateway instance

{{site.base_gateway}} data planes proxy service traffic.

1. From the left navigation menu, open **Runtime Manager**.

1. Select a runtime group. [to do: check what happens if you only have the default group - is it open automatically?]

1. Click **Configure Runtime**.

     The page opens to a **Configure New Runtime** form with the Docker tab
     selected.

1. Click **Copy Script**.

1. Replace the placeholder for `<your-password>` with your own
{{site.konnect_saas}} password.

1. Run the script on any host you choose.

    This script creates a Docker container running a simple
    {{site.base_gateway}} instance and connects it to your
    {{site.konnect_saas}} account.

1. Click **Done** to go to the Runtime Manager page.

Once the script has finished running, the Runtime Manager will include
a new entry for your instance and the tag in the **Sync Status** column should
say **Connected**.

{:.important}
> Important: {{site.konnect_saas}} provisions certificates for the data
plane. These certificates expire after six months and must be renewed. See
[Renew Certificates](/konnect/runtime-manager/renew-certificates).

## Verify the Implementation

The default proxy URL for this runtime is `http://localhost:8000`.

Enter the proxy URL into your browser’s address bar and append the route path
you just set. The final URL should look something like this:

```
http://localhost:8000/mock
```

If successful, you should see the homepage for `mockbin.org`. On your Service
Version overview page, you’ll see a record for status code 200. This might
take a few moments.

## Summary and Next Steps

To summarize, in this topic you:

* Implemented the Service version `v.1` with the Route `/mock`. This means if an HTTP
request is sent to the {{site.base_gateway}} node and it matches route `/mock`, that
request is sent to `http://mockbin.org`.
* Abstracted a backend/upstream service and put a route of your choice on the
front end, which you can now give to clients to make requests.

Next, [publish your Konnect Service to a Dev Portal instance](/konnect/getting-started/spec/publish/).
