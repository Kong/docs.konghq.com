---
title: Services and Routes
badge: free
---

This tutorial walks you through creating services and routes in Kong Manager.

If you prefer to use the Admin API, check out the [{{site.base_gateway}} getting started guide](/gateway/latest/get-started/configure-services-and-routes/).

## Prerequisites

You need a {{site.base_gateway}} instance with Kong Manager [enabled](/gateway/{{page.kong_version}}/kong-manager/enable/).

## Add a service

In this tutorial, you’ll create a service pointing to the httpbin
API. Httpbin is an “echo” type public website that returns requests back to the
requester as responses.

On the Workspaces tab in Kong Manager:

1. Open the **default** workspace.

    This example uses the default workspace, but you can also create a new
    workspace, or use an existing workspace.

2. From the **Services** section, click **New Service**.

3. In the **Create service** dialog, enter the name `example_service` and the
URL `http://httpbin.org`.

4. Click **Create**.

The service is created, and the page automatically redirects back to the
`example_service` overview page.

## Add a route

For the service to be accessible through the API gateway, you need to add a
route to it.

1. From the `example_service` overview page, open **Routes** from the sub-menu
and click **New Route**.  
2. On the **Create route** page, the **Service** field is auto-populated with
    the service name and ID number. This field is required.

    If the Service field is not automatically populated, click
    **Services** in the left navigation pane. Find your service, click the
    clipboard icon next to the ID field, then go back to the **Create Route**
    page and paste it into the **Service field**.
3. Enter a name for the route, and at least one of the following fields: Host,
Methods, or Paths. For this example, use the following:
      1. For **Name**, enter `mocking`.
      2. For **Path(s)**, click **Add Path** and enter `/mock`.
4. Click **Create**.

Kong automatically redirects you to the `example_service` overview page.
The new route appears under the Routes section.

## Verify the route is forwarding requests to the service

By default, {{site.base_gateway}} handles proxy requests on port `8000`.

From a web browser, navigate to `http://localhost:8000/mock/anything`.

## Next steps

Next, you can learn about [enforcing rate limiting on a service](/gateway/{{page.kong_version}}/kong-manager/get-started/rate-limiting/) through Kong Manager.
