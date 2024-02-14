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
{:.note}
The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

1. Get the [list of all control planes](https://docs.konghq.com/konnect/api/control-planes/latest/#/Control%20Planes/list-control-planes) so you can copy the control plane ID associated with the `default` control plane:
  ```sh
  curl --request GET \
    --url https://us.api.konghq.com/v2/control-planes \
    --header 'Authorization: Bearer <personal-access-token>' \
    --header 'accept: application/json'
  ```
  In this guide, we will assign your service to the `default` control plane for the sake of simplicity.

1. [Create a service](https://docs.konghq.com/konnect/api/control-plane-configuration/latest/#/Services/create-service) for your API that is assigned to the `default` control plane:
  ```bash
  curl --request POST \
    --url https://{region}.api.konghq.com/v2/control-planes/{defaultControlPlaneId}/core-entities/services \
    --header 'Authorization: Bearer <personal-access-token>' \
    --header 'Content-Type: application/json' \
    --header 'accept: application/json' \
    --data '{
        "name": "my_service",
        "host": "httpbin.org",
        "path": "/my_api"
    }'
  ```
  This service represents your backend API. Be sure to replace the PAT as well as the following placeholders with your own values:
  * `defaultControlPlaneId`: The ID of the default control plane. This associates the service with that control plane.
  * `name`: The name you want to display for your service.
  * `host`: The host of the upstream server. This is case sensitive.
  * `path`: The path to be used in requests to the upstream server.
  Be sure to save the service ID from the response to use it in the next step.

1. [Add a route](https://docs.konghq.com/konnect/api/control-plane-configuration/latest/#/Routes/create-route) to your service:
  ```bash
  curl --request POST \
    --url https://{region}.api.konghq.com/v2/control-planes/{defaultControlPlaneId}/core-entities/routes \
    --header 'Authorization: Bearer <personal-access-token>' \
    --header 'Content-Type: application/json' \
    --header 'accept: application/json' \
    --data '{
        "name": "my_route",
        "hosts": [
          "httpbin.org"
        ],
        "paths": [
          "/my_api"
        ],
        "service": {
          "id": "49248arf-b90c-4c0b-9529-3a949dfc10d1"
        }
    }'
  ```
  This route defines what is exposed to clients. Be sure to replace the PAT as well as the following placeholders with your own values:
  * `defaultControlPlaneId`: The ID of the default control plane. This associates the service with that control plane.
  * `name`: The name you want to display for your route.
  * `host`: A list of domain names that match this route. This is case sensitive.
  * `path`: A list of paths that match this route.
  * `"service": "id"`: The ID of the service you created in the previous step. This should be part of the response from the previous request.

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

  <a href="/hub/kong-inc/key-auth/how-to/basic-example/?tab=konnect-api" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Protect my APIs with authentication</div>
  </a>

  <a href="/hub/kong-inc/rate-limiting/?tab=konnect-api" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Rate limit my APIs</div>
  </a>

  <a href="/konnect/dev-portal/applications/enable-app-reg/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Make my APIs available to customers</div>
  </a>

</div>