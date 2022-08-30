---
title: Enable Key Authentication for Application Registration
badge: enterprise
---

You can use the Key Authentication plugin for authentication in conjunction with
the Application Registration plugin.

The key auth plugin uses the same Client ID as generated for the Kong OAuth2 plugin.
You can use the same Client ID credential for a Service that has the OAuth2 plugin enabled.

## Prerequisites

* Create a Service.
* Enable the [Application Registration plugin](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/enable-application-registration) on a Service.
* Activate your application for a Service if you have not already done so. The
Service Contract must be approved by an Admin if auto approve is not enabled.
* [Generate a credential](#gen-client-id-cred) if you don't want to use the default credential initially created for you.

## Enable Key Authentication in Kong Manager

In Kong Manager, access the Service for which you want to enable key authentication for
use with application registration:

1. From your Workspace, in the left navigation pane, go to **API Gateway > Services**.
2. On the Services page, select the Service and click **View**.
3. In the Plugins pane in the Services page, click **Add a Plugin**.
4. On the Add New Plugin page in the Authentication section, find the
   **Key Authentication** Plugin and click **Enable**.

   ![Key Authentication plugin panel](/assets/images/docs/dev-portal/key-auth-plugin-panel.png)

5. Complete the fields as appropriate for your application. In this example, the Service is already
   prepopulated. Refer to the parameters described in the next section,
   [Key Authentication Configuration Parameters](#key-auth-params),
   to complete the fields.

6. Click **Create**.

### Key Authentication Configuration Parameters {#key-auth-params}

| Form Parameter | Description                                                                       |
|:---------------|:----------------------------------------------------------------------------------|
| `Service` | The Service that this plugin configuration will target. Required. |
| `Anonymous` | An optional string (Consumer UUID) value to use as an anonymous Consumer if authentication fails. If empty (default), the request fails with an `4xx`. Note that this value must refer to the Consumer `id` attribute that is internal to Kong, and **not** its `custom_id`. |
| `Hide Credentials` | Whether to show or hide the credential from the Upstream service. If `true`, the plugin strips the credential from the request (i.e., the header, query string, or request body containing the key) before proxying it. Default: `false`. |
| `Key in Body` | If enabled, the plugin reads the request body (if said request has one and its MIME type is supported) and tries to find the key in it. Supported MIME types: `application/www-form-urlencoded`, `application/json`, and `multipart/form-data`. Default: `false`. |
| `Key in Header` | If enabled (default), the plugin reads the request header and tries to find the key in it. Default: true. |
| `Key in Query` | If enabled (default), the plugin reads the query parameter in the request and tries to find the key in it. Default: true. |
| `Key Names` | Describes an array of parameter names where the plugin will look for a key. The client must send the authentication key in one of those key names, and the plugin will try to read the credential from a header, request body, or query string parameter with the same name. The key names may only contain [a-z], [A-Z], [0-9], [_] underscore, and [-] hyphen. Required. Default: `apikey`. |
| `Run on Preflight` | Indicates whether the plugin should run (and try to authenticate) on `OPTIONS` preflight requests. Default: `true`. |

## Generate a Credential {#gen-client-id-cred}

Generate a Client ID credential to use as an API key. You can generate multiple
credentials.

1. In the **Dev Portal > My Apps** page, click **View** for an application.

2. In the **Authentication** pane, click **Generate Credential**.

   ![Application Authentication Pane](/assets/images/docs/dev-portal/generate-cred-dev-portal.png)

   Now you can make requests using the Client ID as an API Key.

## Make Requests with an API Key (Client Identifier)

The Client ID of your credentials can be used as an API key to make authenticated requests to a Service.

**Tip:** You can also access key request instructions directly within the user interface from the
information icon in the Services details area of your application. Click the **i** icon to open the Service Details page.

![Services Pane](/assets/images/docs/dev-portal/portal-info-modal-key-auth.png)

Scroll to view all of the available examples.

![Service Details Page Embedded Key Usage Instructions](/assets/images/docs/dev-portal/service-details-key-auth-usage.png)

### About API Key Locations in a Request

{% include /md/plugins-hub/api-key-locations.md %}

### Make a request with the key as a query string parameter

{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -X POST {proxy}/{route}?apikey={CLIENT_ID}
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http {proxy}/{route}?apikey={CLIENT_ID}
```
{% endnavtab %}
{% endnavtabs %}

Response (will be the same for all valid requests regardless of key location):

```bash
HTTP/1.1 200 OK
...
```

### Make a request with the key in a header

{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -X POST {proxy}/{route} \
--header "apikey: {CLIENT_ID}"
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http {proxy}/{route} apikey:{CLIENT_ID}
```
{% endnavtab %}
{% endnavtabs %}

### Make a request with the key in the body

{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -X POST {proxy}/{route} \
--data "apikey:={CLIENT_ID}"
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http {proxy}/{route} apikey={CLIENT_ID}
```
{% endnavtab %}
{% endnavtabs %}

**Note:** The `key_in_body` parameter must be set to `true`.
