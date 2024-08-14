---
title: Set up an audit log destination
content_type: how-to
badge: enterprise
---

You can use the {{site.dev-portal_short_name}} UI or the Audit Logs API to configure destinations for [audit logging](/konnect/org-management/audit-logging/).
  
## Prerequisites

You must have **Org Admin** or **Portal Admin** permissions to set up audit log destinations for portal.

Before you can push {{site.dev-portal_short_name}} audit logs to an external service, you also need to configure the service to receive logs. 
This configuration is specific to your vendor.

You can configure a webhook into any application that supports the [ArcSight CEF Format](https://docs.centrify.com/Content/IntegrationContent/SIEM/arcsight-cef/arcsight-cef-format.htm) or raw JSON.

1. Check your SIEM documentation to find out where to send CEF or raw JSON data.

1. In your log collection service, configure a data collection endpoint to push logs to.

1. Take note of the authorization credentials that you need to access this endpoint. {{site.konnect_short_name}} supports any HTTP authorization header type.

1. Configure your firewall settings to allow traffic through the port that you're going to use. 
See the [Konnect ports and network requirements](/konnect/network/).

## Create a destination

{% navtabs %}
{% navtab Konnect UI %}

1. From the navigation menu, open {% konnect_icon organizations %} **Organization**, then **Audit Logs Setup** and **Destinations**
1. Fill in the fields in the **Destinations** tab.
   * **Region endpoint**: The external endpoint that will receive audit log messages. 
   * **Authorization Header**: The authorization type and credential to pass to your log collection endpoint. 
    {{site.konnect_short_name}} will send this string in the `Authorization` header of requests to that endpoint.

     For example, if you are setting up the webhook for Splunk, you could provide a Splunk access token: 
     `"authorization":"Splunk example-token12234352535235"`.
        
    * **Log Format**: The output format of each log message. Can be CEF or JSON.
    * **Skip SSL Verification**: Skip SSL verification of the host endpoint when delivering payloads.

     {:.note}
     > We strongly recommend not setting this to `true` as you are subject to man-in-the-middle and other attacks. This option should be considered only when using self-signed SSL certificates in a non-production environment.

{% endnavtab %}
{% navtab API %}

Now that you have an external endpoint and authorization credentials, you can set up a destination in {{site.konnect_short_name}}.

Create a destination by sending a request to the `/audit-log-destinations` endpoint with the connection details for your SIEM vendor:

```sh
curl -i -X PATCH https://global.api.konghq.com/v2/audit-log-destinations \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer TOKEN" \
    --data '{"endpoint":"https://example.com/audit-logs","authorization":"Bearer example-token","log_format":"cef"}'
```

Replace the following placeholders with your own data:
* `global.api.konghq.com`: Audit log destinations are global and are available for webhooks in all regions to be used.
* `TOKEN`: A {{site.dev-portal_short_name}} token
* `"endpoint":"https://example.com/audit-logs"`: The external endpoint that will receive audit log messages. 
   
   {:.note}
    > Check your SIEM documentation to find out where to send CEF data.
    
* `"authorization":"Bearer example-token"`: The authorization type and credential to pass to your log collection endpoint. 
{{site.konnect_short_name}} will send this string in the `Authorization` header of requests to that endpoint.

    For example, if you are setting up the webhook for Splunk, you could provide a Splunk access token: `"authorization":"Splunk example-token12234352535235"`.

* `log_format`: The output format of each log message. Can be `cef` or `json`.
* `skip_ssl_verification`: (Optional) Set to `true` to skip SSL verification of the host endpoint when delivering payloads.

  {:.note}
  > We strongly recommend not setting this to `true` as you are subject to man-in-the-middle and other attacks. This option should be considered only when using self-signed SSL certificates in a non-production environment.

If the request is successful, you will receive a `200` response code, and a response body containing the webhook's configuration details: 

```json
{
    "id": "07ec3858-066b-4629-bdc5-d4aa893b424d",
    "endpoint":"https://example.com/audit-logs",
    "log_format":"cef",
    "skip_ssl_verification":false,
    "updated_at":"2023-04-01T00:00:01Z"
}
```

{% endnavtab %}
{% endnavtabs %}


![Audit log webhook](/assets/images/products/konnect/audit-logs/konnect-audit-log-webhook.png)

{% endnavtab %}
{% navtab API %}

View your audit log destination configuration by running the following command:

```sh
curl https://global.api.konghq.com/v2/audit-log-destinations \
    --header "Authorization: Bearer TOKEN"
```

You will receive a `200` response code and the following data. Note that the `authorization` property is not included in any responses:

```json
{
    "id": "07ec3858-066b-4629-bdc5-d4aa893b424d",
    "endpoint":"https://example.com/audit-logs",
    "log_format":"cef",
    "skip_ssl_verification":false,
    "updated_at":"2023-04-01T00:00:01Z"
}
```


## More information
* [Audit logging in {{site.konnect_short_name}}](/konnect/org-management/audit-logging/)
* [Audit log event reference](/konnect/org-management/audit-logging/reference/)
* [Set up an audit log replay job](/konnect/org-management/audit-logging/replay-job/)
* [Verify audit log signatures](/konnect/org-management/audit-logging/verify-signatures/)
* [Audit Logs API](/konnect/api/audit-logs/latest/)
