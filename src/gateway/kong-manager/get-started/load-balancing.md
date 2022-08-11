---
title: Load balancing in Kong Manager
---

This tutorial walks you through setting up load balancing across targets in Kong Manager.

If you prefer to use the Admin API, check out the [{{site.base_gateway}} getting started guide](/gateway/latest/get-started/improve-performance/).

## Set up upstreams and targets

In this tutorial, you will create an upstream named `example_upstream` and add two targets to it.

1. Access your Kong Manager instance and your **default** workspace.
2. Go to **API Gateway** > **Upstreams**.
3. Click **New Upstream**.
4. For this example, enter `example_upstream` in the **Name** field.
5. Scroll down and click **Create**.
6. On the Upstreams page, find the new upstream service and click **View**.
7. Scroll down and click **New Target**.
8. In the target field, specify `httpbin.org` with port `80`, and click **Create**.
9. Create another target, this time for `mockbin.org` with port `80`. Click **Create**.
10. Open the **Services** page.
11. Find your `example_service` and click **Edit**.
12. Change the **Host** field to `example_upstream`, then click **Update**.

You now have an Upstream with two targets, `httpbin.org` and `mockbin.org`, and a service pointing to that Upstream.

## Validate the upstream services

1. With the upstream configured, validate that it’s working by visiting the route `http://<admin-hostname>:8000/mock` using a web browser or CLI.
2. Refresh the page a few times. The site should change back and forth from `httpbin` to `mockbin`.

## Summary and next steps

In this topic, you:

* Created an upstream object named `example_upstream` and pointed the service `example_service` to it.
* Added two targets, `httpbin.org` and `mockbin.org`, with equal weight to the upstream.

If you have a {{site.konnect_product_name}} subscription, go on to [Managing Administrative Teams](/gateway/{{page.kong_version}}/get-started/comprehensive/manage-teams).
