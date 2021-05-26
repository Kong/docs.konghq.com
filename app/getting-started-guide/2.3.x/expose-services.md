---
title: Expose your Services with Kong Gateway
---

In this topic, you’ll learn how to expose your Services using Routes.

If you are following the Getting Started workflow, make sure you have completed
[Prepare to Administer {{site.base_gateway}}](/getting-started-guide/{{page.kong_version}}/prepare)
before moving on.

If you are not following the Getting Started workflow, make sure you have
{{site.base_gateway}} installed and started.

## What are Services and Routes?

**Service** and **Route** objects let you expose your services to clients with
Kong Gateway. When configuring access to your API, you’ll start by specifying a
Service. In {{site.base_gateway}}, a Service is an entity representing an external
upstream API or microservice &mdash; for example, a data transformation
microservice, a billing API, and so on.

The main attribute of a Service is its **URL**, where the service listens for
requests. You can specify the URL with a single string, or by specifying its
protocol, host, port, and path individually.

Before you can start making requests against the Service, you will need to add
a Route to it. Routes determine how (and if) requests are sent to their Services
after they reach Kong Gateway. A single Service can have many Routes.

After configuring the Service and the Route, you’ll be able to start making
requests through {{site.base_gateway}}.

This diagram illustrates the flow of requests and responses being routed through
the Service to the backend API.

![Services and routes](/assets/images/docs/getting-started-guide/route-and-service.png)

## Add a Service

For the purpose of this example, you’ll create a Service pointing to the Mockbin
API. Mockbin is an “echo” type public website that returns requests back to the
requester as responses. This visualization will be helpful for learning how Kong
Gateway proxies API requests.

{{site.base_gateway}} exposes the RESTful Admin API on port `:8001`. The gateway’s
configuration, including adding Services and Routes, is done through requests to
the Admin API.

{% navtabs %}
{% navtab Using Kong Manager %}

1. On the Workspaces tab in Kong Manager, scroll to the Workspace section and
click the **default** workspace.

    This example uses the default workspace, but you can also create a new
    workspace, or use an existing workspace.

2. Scroll down to **Services** and click **Add a Service**.

3. In the **Create Service** dialog, enter the name `example_service` and the
URL `http://mockbin.org`.

4. Click **Create**.

The service is created, and the page automatically redirects back to the
`example_service` overview page.
{% endnavtab %}
{% navtab Using decK (YAML) %}

1. In the `kong.yaml` file you exported in
[Prepare to Administer {{site.base_gateway}}](/getting-started-guide/{{page.kong_version}}/prepare/#verify-the-kong-gateway-configuration),
define a Service with the name `example_service` and the URL
`http://mockbin.org`:

    ``` yaml
    _format_version: "1.1"
    services:
    - host: mockbin.org
      name: example_service
      port: 80
      protocol: http
    ```
2. Save the file. From your terminal, sync the configuration to update your
gateway instance:

    ``` bash
    $ deck sync
    ```

    The message should show that you’re creating a service:

    ```
    creating service example_service
    Summary:
    Created: 1
    Updated: 0
    Deleted: 0
    ```

{% endnavtab %}
{% navtab Using the Admin API %}

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -i -X POST http://<admin-hostname>:8001/services \
  --data name=example_service \
  --data url='http://mockbin.org'
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
$ http POST :8001/services \
  name=example_service \
  url='http://mockbin.org'
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

If the service is created successfully, you'll get a 201 success message.

Verify the service’s endpoint:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -i http://<admin-hostname>:8001/services/example_service
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
$ http :8001/services/example_service
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

{% endnavtab %}
{% endnavtabs %}

## Add a Route

For the Service to be accessible through the API gateway, you need to add a
Route to it.

{% navtabs %}
{% navtab Using Kong Manager %}
1. From the `example_service` overview page, scroll down to the Routes section
and click **Add Route**.  

    The Create Route dialog displays with the Service field auto-populated with
    the Service name and ID number. This field is required.

    **Note:** If the Service field is not automatically populated, click
    **Services** in the left navigation pane. Find your Service, click the
    clipboard icon next to the id field, then go back to the Create Route
    page and paste it into the Service field.

2. Enter a name for the Route, and at least one of the following fields: Host,
Methods, or Paths. For this example, use the following:
      1. For **Name**, enter `mocking`.
      2. For **Path(s)**, click **Add Path** and enter `/mock`.

3. Click **Create**.

The Route is created and you are automatically redirected back to the
`example_service` overview page. The new Route appears under the Routes section.

{% endnavtab %}
{% navtab Using the Admin API %}

Define a Route (`/mock`) for the Service (`example_service`) with a specific
path that clients need to request. Note at least one of the hosts, paths, or
methods must be set for the Route to be matched to the service.

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -i -X POST http://<admin-hostname>:8001/services/example_service/routes \
  --data 'paths[]=/mock' \
  --data name=mocking
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
$ http :8001/services/example_service/routes \
  paths:='["/mock"]' \
  name=mocking
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

A 201 message indicates the Route was created successfully.

{% endnavtab %}
{% navtab Using decK (YAML) %}

1. Paste the following into the `kong.yaml` file, under the entry for
`example_service`:

    ``` yaml
    routes:
    - name: mocking
      paths:
      - /mock
      strip_path: true
    ```

    Your file should now look like this:

    ``` yaml
    _format_version: "1.1"
    services:
    - host: mockbin.org
      name: example_service
      port: 80
      protocol: http
      routes:
      - name: mocking
        paths:
        - /mock
        strip_path: true
    ```

2. Sync the configuration:

    ``` bash
    $ deck sync
    ```

3. (Optional) You can update your local file with the new configuration:

    <div class="alert alert-warning">
   
    <strong>Be careful!</strong> Any subsequent <code>deck dump</code> will
    overwrite the existing <code>kong.yaml</code> file. Create backups as needed.
    </div>

    ``` bash
    $ deck dump
    ```

    Alternatively, you will also see this configuration in the diff that decK
    shows when you're syncing a change to the configuration.

    You'll notice that both the Service and Route now have parameters that you
    did not explicitly set. These are default parameters that every Service and
    Route are created with:

    ``` yaml
    services:
    - connect_timeout: 60000
      host: mockbin.org
      name: example_service
      port: 80
      protocol: http
      read_timeout: 60000
      retries: 5
      write_timeout: 60000
      routes:
      - name: mocking
        paths:
        - /mock
        path_handling: v0
        preserve_host: false
        protocols:
        - http
        - https
        regex_priority: 0
        strip_path: true
        https_redirect_status_code: 426
    ```

    You can do this after any `deck sync` to see {{site.base_gateway}}'s most
    recent configuration.

    The rest of this guide continues using the simplified version of the
    configuration file without performing a `deck dump` for every step, to keep
    it easy to follow.

{% endnavtab %}
{% endnavtabs %}

## Verify the Route is forwarding requests to the Service

{% navtabs %}
{% navtab Using a Web Browser %}

By default, {{site.base_gateway}} handles proxy requests on port `:8000`.

From a web browser, enter `http://<admin-hostname>:8000/mock`.

{% endnavtab %}
{% navtab Using the Admin API %}

Using the Admin API, issue the following:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -i -X GET http://<admin-hostname>:8000/mock/request
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
$ http :8000/mock/request
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

{% endnavtab %}
{% endnavtabs %}


## Summary and next steps
In this section, you:
* Added a Service named `example_service` with a URL of `http://mockbin.org`.
* Added a Route named `/mock`.
* This means if an HTTP request is sent to the {{site.base_gateway}} node on
port `8000`(the proxy port) and it matches route `/mock`, then that request is
sent to `http://mockbin.org`.
* Abstracted a backend/upstream service and put a route of your choice on the
front end, which you can now give to clients to make requests.

Next, go on to learn about [enforcing rate limiting](/getting-started-guide/{{page.kong_version}}/protect-services).
