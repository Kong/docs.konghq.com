---
title: Set Up Intelligent Load Balancing
---

In this topic, you’ll learn about configuring upstream services, and create multiple targets for load balancing.

If you are following the getting started workflow, make sure you have completed [Secure Services Using Authentication](/getting-started-guide/{{page.kong_version}}/secure-services) before moving on.

## What are Upstreams?

An **Upstream Object** refers to your upstream API/service sitting behind Kong Gateway, to which client requests are forwarded. In Kong Gateway, an Upstream Object represents a virtual hostname and can be used to health check, circuit break, and load balance incoming requests over multiple services (targets).

In this topic, you’ll configure the service created earlier (`example_service`) to point to an upstream instead of the host. For the purposes of our example, the upstream will point to two different targets, `httpbin.org` and `mockbin.org`. In a real environment, the upstream will point to the same service running on multiple systems.

Here is a diagram illustrating the setup:

![Upstream targets](/assets/images/docs/getting-started-guide/upstream-targets.png)

## Why load balance across upstream targets?

In the following example, you’ll use an application deployed across two different servers, or upstream targets. Kong Gateway needs to load balance across both servers, so that if one of the servers is unavailable, it automatically detects the problem and routes all traffic to the working server.

## Configure Upstream Services

In this section, you will create an Upstream named `example_upstream` and add two targets to it.

{% navtabs %}
{% navtab Using the Admin API %}

1. Call the Admin API on port `8001` and create an Upstream named `example_upstream`.

    *Using cURL*:
    ```
    $ curl -X POST http://<admin-hostname>:8001/upstreams \
    --data name=example_upstream
    ```
    *Or using HTTPie*:
    ```
    $ http POST :8001/upstreams name=example_upstream
    ```

2. Update the service you created previously to point to this upstream.

    *Using cURL*:
    ```
    $ curl -X PATCH http://<admin-hostname>:8001/services/example_service \
    --data host='example_upstream'
    ```
    *Or using HTTPie*:
    ```
    $ http PATCH :8001/services/example_service host='example_upstream'
    ```

3. Add two targets to the upstream, each with port 80: `mockbin.org:80` and `httpbin.org:80`.

    *Using cURL*:
    ```
    $ curl -X POST http://<admin-hostname>:8001/upstreams/example_upstream/targets \
    --data target=’mockbin.org:80’

    $ curl -X POST http://<admin-hostname>:8001/upstreams/example_upstream/targets \
    --data target=’httpbin.org:80’
    ```
    *Or using HTTPie*:
    ```
    $ http POST :8001/upstreams/example_upstream/targets target=mockbin.org:80
    $ http POST :8001/upstreams/example_upstream/targets target=httpbin.org:80
    ```
{% endnavtab %}

{% navtab Using Kong Manager %}

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
{% endnavtab %}
{% endnavtabs %}

You now have an Upstream with two targets, `httpbin.org` and `mockbin.org`, and a service pointing to that Upstream.

## Validate the Upstream Services

1. With the upstream configured, validate that it’s working by visiting the route `http://<admin-hostname>:8000/mock` using a web browser or CLI.
2. Continue hitting the endpoint and the site should change from `httpbin` to `mockbin`.

## Summary and next steps

In this topic, you:
* Created an Upstream object named `example_upstream` and pointed the Service `example_service` at it.
* Added two targets, `httpbin.org` and `mockbin.org`, with equal weight to the Upstream.

If you're a Kong Enterprise user, go on to [Managing Administrative Teams](/getting-started-guide/{{page.kong_version}}/manage-teams).
