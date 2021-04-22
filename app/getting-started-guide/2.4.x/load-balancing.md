---
title: Set Up Intelligent Load Balancing
---

In this topic, you’ll learn about configuring upstream services, and create multiple targets for load balancing.

If you are following the getting started workflow, make sure you have completed [Secure Services Using Authentication](/getting-started-guide/{{page.kong_version}}/secure-services) before moving on.

## What are Upstreams?

An **Upstream Object** refers to your upstream API/service sitting behind {{site.base_gateway}}, to which client requests are forwarded. In {{site.base_gateway}}, an Upstream Object represents a virtual hostname and can be used to health check, circuit break, and load balance incoming requests over multiple services (targets).

In this topic, you’ll configure the service created earlier (`example_service`) to point to an upstream instead of the host. For the purposes of our example, the upstream will point to two different targets, `httpbin.org` and `mockbin.org`. In a real environment, the upstream will point to the same service running on multiple systems.

Here is a diagram illustrating the setup:

![Upstream targets](/assets/images/docs/getting-started-guide/upstream-targets.png)

## Why load balance across upstream targets?

In the following example, you’ll use an application deployed across two different servers, or upstream targets. {{site.base_gateway}} needs to load balance across both servers, so that if one of the servers is unavailable, it automatically detects the problem and routes all traffic to the working server.

## Configure Upstream Services

In this section, you will create an Upstream named `upstream` and add two targets to it.

{% navtabs %}
{% navtab Using Kong Manager %}

1. Access your Kong Manager instance and your **default** workspace.
2. Go to **API Gateway** > **Upstreams**.
3. Click **New Upstream**.
4. For this example, enter `upstream` in the **Name** field.
5. Scroll down and click **Create**.
6. On the Upstreams page, find the new upstream service and click **View**.
7. Scroll down and click **New Target**.
8. In the target field, specify `httpbin.org` with port `80`, and click **Create**.
9. Create another target, this time for `mockbin.org` with port `80`. Click **Create**.
10. Open the **Services** page.
11. Find your `example_service` and click **Edit**.
12. Change the **Host** field to `upstream`, then click **Update**.
{% endnavtab %}
{% navtab Using the Admin API %}

Call the Admin API on port `8001` and create an Upstream named `upstream`:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -X POST http://<admin-hostname>:8001/upstreams \
  --data name=upstream
```
{% endnavtab %}
{% navtab HTTPie %}    
```sh
$ http POST :8001/upstreams \
  name=upstream
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

Update the service you created previously to point to this upstream:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -X PATCH http://<admin-hostname>:8001/services/example_service \
  --data host='upstream'
```
{% endnavtab %}
{% navtab HTTPie %}    
```sh
$ http PATCH :8001/services/example_service \
  host='upstream'
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

Add two targets to the upstream, each with port 80: `mockbin.org:80` and
`httpbin.org:80`:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -X POST http://<admin-hostname>:8001/upstreams/upstream/targets \
  --data target='mockbin.org:80'

$ curl -X POST http://<admin-hostname>:8001/upstreams/upstream/targets \
  --data target='httpbin.org:80'
```
{% endnavtab %}
{% navtab HTTPie %}    
```sh
$ http POST :8001/upstreams/upstream/targets \
  target=mockbin.org:80
$ http POST :8001/upstreams/upstream/targets \
  target=httpbin.org:80
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

{% endnavtab %}

{% navtab Using decK (YAML) %}
1. In your `kong.yaml` file, create an Upstream with two targets, each with port
80: `mockbin.org:80` and `httpbin.org:80`.

    ``` yaml
    upstreams:
    - name: upstream
      targets:
        - target: httpbin.org:80
          weight: 100
        - target: mockbin.org:80
          weight: 100
    ```

2. Update the service you created previously, pointing the `host` to this
Upstream:

    ``` yaml
    services:
      host: upstream
      name: example_service
      port: 80
      protocol: http
    ```

    After these updates, your file should now look like this:

    ``` yaml
    _format_version: "1.1"
    services:
    - host: upstream
      name: example_service
      port: 80
      protocol: http
      routes:
      - name: mocking
        paths:
        - /mock
        strip_path: true
        plugins:
        - name: key-auth
          enabled: false
    consumers:
    - custom_id: consumer
      username: consumer
      keyauth_credentials:
      - key: apikey
    upstreams:
    - name: upstream
      targets:
        - target: httpbin.org:80
          weight: 100
        - target: mockbin.org:80
          weight: 100
    plugins:
    - name: rate-limiting
      config:
        minute: 5
        policy: local
    - name: proxy-cache
      config:
        content_type:
        - "application/json; charset=utf-8"
        cache_ttl: 30
        strategy: memory
    ```

3. Sync the configuration:

    ``` bash
    $ deck sync
    ```
{% endnavtab %}
{% endnavtabs %}

You now have an Upstream with two targets, `httpbin.org` and `mockbin.org`, and a service pointing to that Upstream.

## Validate the Upstream Services

1. With the Upstream configured, validate that it’s working by visiting the route `http://<admin-hostname>:8000/mock` using a web browser or CLI.
2. Continue hitting the endpoint and the site should change from `httpbin` to `mockbin`.

## Summary and next steps

In this topic, you:
* Created an Upstream object named `upstream` and pointed the Service `example_service` to it.
* Added two targets, `httpbin.org` and `mockbin.org`, with equal weight to the Upstream.

If you have a {{site.konnect_product_name}} subscription, go on to [Managing Administrative Teams](/getting-started-guide/{{page.kong_version}}/manage-teams).
