---
title: Add your API to Konnect
---

Some explanation of how you created a demo service etc. in wizard onboarding, and this will help you add your own APIs to Konnect to test.

If you used the [in-app onboarding wizard in {{site.konnect_short_name}}](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=gateway-quickstart-install), you already should've created a demo service.

In this guide, you will take this one step further by adding your own API to {{site.konnect_short_name}}. 

## Add your API

{% navtabs %}
{% navtab Konnect UI %}
1. In the {% konnect_icon runtimes %} [**Gateway Manager**](https://cloud.konghq.com/us/gateway-manager), select the **Default** control plane.

1. Select **Gateway Services** from the side navigation bar, then **New Gateway Service**.

1. From the **Add a Gateway Service** dialog, create a new service:

  1. Enter a unique name for the Gateway service, or
  specify a Gateway service that doesn't yet have a version connected to it.

       For the purpose of this example, enter `example_gateway_service`.

       The name can be any string containing letters, numbers, or the following
       characters: `.`, `-`, `_`, `~`, or `:`. Do not use spaces.

       For example, you can use `example_service`, `ExampleService`, `Example-Service`.
       However, `Example Service` is invalid.

  1. In the **add using upstream URL** field, enter `http://httpbin.org`.

  1. Use the defaults for the remaining fields.

  1. Click **Save**.

1. Add a route to your service implementation by clicking the **Add a Route** button now visible from the Gateway service dashboard.

    For this example, enter the following:

    * **Name**: `httpbin`
    * **Protocols**: `HTTP`, `HTTPS`
    * **Path(s)**: `/mock`

1. Click **Save**.

{% endnavtab %}
{% navtab Konnect API %}
1. Create service with your API:

```sh
curl --request POST \
  --url https://us.api.konghq.com/v2/control-planes/9524ec7d-36d9-465d-a8c5-83a3c9390458/core-entities/services \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{"name":"my-service","retries":5,"protocol":"http","host":"example.com","port":80,"path":"/some_api","connect_timeout":6000,"write_timeout":6000,"read_timeout":6000,"tags":["user-level"],"client_certificate":{"id":"4e3ad2e4-0bc4-4638-8e34-c84a417ba39b"},"tls_verify":true,"tls_verify_depth":null,"ca_certificates":["4e3ad2e4-0bc4-4638-8e34-c84a417ba39b"],"enabled":true}'
```
2. Add route.
3. Verify? 
{% endnavtab %}
{% endnavtabs %}

## Verify the implementation

If you used the Docker script to connect a data plane
earlier in [Configure a data plane node](/konnect/getting-started/configure-data-plane-node/),
your default proxy URL is `localhost:8000`.

Enter the proxy URL into your browser’s address bar and append the route path
you just set. The final URL should look something like this:

```
http://localhost:8000/mock
```

If successful, you should see the homepage for `httpbin.org`. In the Gateway Manager you will now see a **200** responses recorded in the **Analytics** tab.

And that's it! You have your first service set up, running, and routing
traffic proxied through a {{site.base_gateway}} data plane node.

## Next steps

Now that you've added your API to {{site.konnect_short_name}}, you can continue to test {{site.konnect_short_name}}'s capabilities:

<div class="docs-grid-install max-2">

  <a href="/hub/kong-inc/key-auth/how-to/basic-example/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Protect my APIs with authentication</div>
  </a>

  <a href="/hub/kong-inc/rate-limiting/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Rate limit my APIs</div>
  </a>

  <a href="/konnect/dev-portal/applications/enable-app-reg/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Make my APIs available to customers</div>
  </a>

</div>