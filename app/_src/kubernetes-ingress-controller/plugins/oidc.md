---
title: OIDC
type: how-to
purpose: |
  How to configure the OIDC plugin
---

Kong Enterprise's OIDC plugin can authenticate requests using OpenID Connect protocol.
Learn to setup the OIDC plugin using the Ingress Controller. It is important that create a domain name to use OIDC plugin in a production environment. 

{% include /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false enterprise=true %}

{% include /md/kic/test-service-echo.md kong_version=page.kong_version %}

{% include /md/kic/http-test-routing.md kong_version=page.kong_version path='/echo' name='echo' hostname="127.0.0.1.nip.io" %}

This example uses `127.0.0.1.nip.io` as the host, you can use any domain name
of your choice. For demo purpose, you can [nip.io](http://nip.io) service to avoid setting up a DNS record.

Test the Ingress rule:

```bash
$ curl -i 127.0.0.1.nip.io/echo
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Length: 137
Connection: keep-alive
Date: Tue, 31 Oct 2023 21:26:56 GMT
X-Kong-Upstream-Latency: 0
X-Kong-Proxy-Latency: 1
Via: kong/3.4.1.0-enterprise-edition

Welcome, you are connected to node orbstack.
Running on Pod echo-74d47cc5d9-cqnh6.
In namespace default.
With IP address 192.168.194.7.
```

## Setup OIDC plugin

Now we are going to protect our dummy service with OpenID Connect
protocol using Google as our identity provider.

1. Setup an OAuth 2.0 application in [Google](https://developers.google.com/identity/protocols/oauth2/openid-connect). And set the `redirect_uri` to `http://127.0.0.1.nip.io/echo`.

    {:.note}
    > Your OAuth 2.0 application must have the `openid` scope.

1. After you have setup your application in Google, use the client ID and client secret and create a KongPlugin resource in Kubernetes.

    ```bash
    $ echo "
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: oidc-auth
    config:
      issuer: https://accounts.google.com/.well-known/openid-configuration
      client_id:
      - <client-id>
      client_secret:
      - <client-secret>
      redirect_uri:
      - http://127.0.0.1.nip.io/echo
    plugin: openid-connect
    " | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/oidc-auth created
    ```

    The `redirect_uri` parameter must be a URI that matches the Ingress rule that you created. You must also [add it to your Google OIDC configuration](https://developers.google.com/identity/protocols/oauth2/openid-connect#setredirecturi).

1. Enable the plugin on ingress.

    ```bash
    $ kubectl patch ingress echo -p '{"metadata":{"annotations":{"konghq.com/plugins":"oidc-auth"}}}'
    ingress.extensions/demo patched
    ```
    
## Test the configuration

Now, if you visit `http://127.0.0.1.nip.io/echo` in your web browser
Kong should redirect you to Google to verify your identity.
After you identify yourself, you should be able to browse our dummy service
once again.

This basic configuration permits any user with a valid Google account to access
the dummy service.
For setting up more complicated authentication and authorization flows, see the
[plugin docs](/gateway/latest/kong-plugins/authentication/oidc/google).
