---
title: Load balancing in Kong Manager
badge: free
---

This tutorial walks you through setting up load balancing across targets in Kong Manager.

For Admin API instructions, check out the [{{site.base_gateway}} getting started guide](/gateway/latest/get-started/load-balancing/).

## Prerequisites

You need a {{site.base_gateway}} instance with Kong Manager [enabled](/gateway/{{page.kong_version}}/kong-manager/enable/).

## Set up upstreams and targets

In this tutorial, you will create an upstream named `example_upstream` and add two targets to it.

From the **Workspaces** tab in Kong Manager:

1. Open the **default** workspace.
2. From the menu, open **Upstreams**, then click **New Upstream**.
3. For this example, enter `example_upstream` in the **Name** field, then click **Create**.
4. Click on your new upstream to open its detail page.
5. From the sub-menu, open **Targets**, then click **New Target**.
6. In the target field, set the value `httpbin.org:80`, and click **Create**.
7. Create another target, this time for `httpbun.com:80`.
8. Open the **Services** page.
9. Open your `example_service`, then click **Edit**.
10. Change the **Host** field to `example_upstream`, then click **Update**.

You now have an upstream with two targets, `httpbin.org` and `httpbun.com`, and a service pointing to that upstream.

## Validate the upstream services

To test that {{site.base_gateway}} is load balancing traffic across the two targets: 

1. With the upstream configured, validate that it’s working by visiting the route `http://localhost:8000/mock` using a web browser or the shell.

2. Refresh the page a few times. The site should change back and forth from `httpbin` to `httpbun`.

## Next steps

Next, check out some guides on what else you can do in Kong Manager:
* [Set up authentication for Kong Manager](/gateway/{{page.kong_version}}/kong-manager/auth/)
* [Manage workspaces and teams with role-based access control (RBAC)](/gateway/{{page.kong_version}}/kong-manager/auth/workspaces-and-teams/)
* [Create custom workspaces](/gateway/{{page.kong_version}}/kong-manager/workspaces/)
