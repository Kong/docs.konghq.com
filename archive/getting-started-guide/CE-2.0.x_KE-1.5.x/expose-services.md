---
title: Expose your Services with Kong Gateway
---

In this topic, you’ll learn how to expose your Services using Routes.

If you are following the Getting Started workflow, make sure you have completed [Prepare to Administer Kong Gateway](/getting-started-guide/{{page.kong_version}}/prepare) before moving on.

If you are not following the Getting Started workflow, make sure you have Kong Gateway installed and started.

## What are Services and Routes?

**Service** and **Route** objects let you expose your services to clients with Kong Gateway. When configuring access to your API, you’ll start by specifying a Service. In Kong Gateway, a Service is an entity representing an external upstream API or microservice &mdash; for example, a data transformation microservice, a billing API, and so on.

The main attribute of a Service is its **URL**, where the service listens for requests. You can specify the URL with a single string, or by specifying its protocol, host, port, and path individually.

Before you can start making requests against the Service, you will need to add a Route to it. Routes determine how (and if) requests are sent to their Services after they reach Kong Gateway. A single Service can have many Routes.

After configuring the Service and the Route, you’ll be able to start making requests through Kong Gateway.

This diagram illustrates the flow of requests and responses being routed through the Service to the backend API.

![Services and routes](/assets/images/docs/getting-started-guide/route-and-service.png)

## Add a Service

For the purpose of this example, you’ll create a Service pointing to the Mockbin API. Mockbin is an “echo” type public website that returns requests back to the requester as responses. This visualization will be helpful for learning how Kong Gateway proxies API requests.

Kong Gateway exposes the RESTful Admin API on port `:8001`. The gateway’s configuration, including adding Services and Routes, is done through requests to the Admin API.

{% navtabs %}
{% navtab Using the Admin API %}

1. Define a Service with the name `example_service` and the URL `http://mockbin.org`.

    *Using cURL*:
    ```
    $ curl -i -X POST http://<admin-hostname>:8001/services \
    --data name=example_service \
    --data url='http://mockbin.org'
    ```
    *Or using HTTPie*:
    ```
    $ http POST :8001/services name=example_service url='http://mockbin.org'
    ```
    If the service is created successfully, you'll get a 201 success message.

2. Verify the service’s endpoint.

    *Using cURL*:
    ```
    $ curl -i http://<admin-hostname>:8001/services/example_service
    ```
    *Or using HTTPie*:
    ```
    $ http :8001/services/example_service
    ```

{% endnavtab %}
{% navtab Using Kong Manager %}

1. On the Workspaces tab in Kong Manager, scroll to the Workspace section and click the **default** workspace.

    This example uses the default workspace, but you can also create a new workspace, or use an existing workspace.

2. Scroll down to **Services** and click **Add a Service**.

3. In the **Create Service** dialog, enter the name `example_service` and the URL `http://mockbin.org`.

4. Click **Create**.

The service is created, and the page automatically redirects back to the `example_service` overview page.
{% endnavtab %}
{% endnavtabs %}

## Add a Route

For the Service to be accessible through the Kong Gateway, you need to add a Route to it.

{% navtabs %}
{% navtab Using the Admin API %}

Define a Route (`/mock`) for the Service (`example_service`) with a specific path that clients need to request. Note at least one of the hosts, paths, or methods must be set for the route to be matched to the service.

*Using cURL*:
  ```
  $ curl -i -X POST http://<admin-hostname>:8001/services/example_service/routes \
  --data 'paths[]=/mock' \
  --data 'name=mocking'
  ```

*Or using HTTPie*:
  ```
  $ http :8001/services/example_service/routes paths:='["/mock"]' name=mocking
  ```

A 201 message will be returned indicating the route was created successfully.

{% endnavtab %}
{% navtab Using Kong Manager %}
1. From the `example_service` overview page, scroll down to the Routes section and click **New Route**.  

    The Create Route dialog displays with the Service field auto-populated with the Service name and ID number. This field is required.

    **Note:** If the Service field is not automatically populated, click **Services** in the left navigation pane. Find your Service, click the clipboard icon next to the id field, then go back to the Create Route page and paste it into the Service field.

2. Enter a name for the Route, and at least one of the following fields: Host, Methods, or Paths. For this example, use the following:
      1. For **Name**, enter `mocking`
      2. For **Path(s)**, click **Add Path** and enter `/mock`

3. Click **Create**.

The route is created and you are automatically redirected back to the `example_service` overview page. The new Route appears under the Routes section.

{% endnavtab %}
{% endnavtabs %}

## Verify the Route is forwarding requests to the Service

{% navtabs %}
{% navtab Using the Admin API %}

Using the Admin API, issue the following:

*Using cURL*:
```
$ curl -i -X GET http://<admin-hostname>:8000/mock
```

*Or using HTTPie*:
```
$ http :8000/mock
```

{% endnavtab %}
{% navtab Using Kong Manager %}

By default, Kong handles proxy requests on port `:8000`.

From a web browser, enter `http://<admin-hostname>:8000/mock`.

{% endnavtab %}
{% endnavtabs %}


## Summary and next steps
In this section, you:
* Added a service named `example_service` with a URL of `http://mockbin.org`.
* Added a route named `/mock`.
* This means if an HTTP request is sent to the Kong Gateway node on port `8000` (the proxy port) and it matches route `/mock`, then that request is sent to `http://mockbin.org`.
* Abstracted a backend/upstream service and put a route of your choice on the front end, which you can now give to clients to make requests.

Next, go on to learn about [enforcing rate limiting](/getting-started-guide/{{page.kong_version}}/protect-services).
