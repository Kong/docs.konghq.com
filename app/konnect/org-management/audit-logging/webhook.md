---
title: Set up an audit log webhook for a Konnect org
content_type: how-to
badge: enterprise
---

You can use the {{site.konnect_short_name}} UI or the Audit Logs API to configure webhooks for [audit logging](/konnect/org-management/audit-logging/). 

{% include_cached /md/konnect/audit-logging/webhook-overview-prereq-siem-config.md %}

## Create a webhook

{% navtabs %}
{% navtab Konnect UI %}

1. From the navigation menu, open {% konnect_icon organizations %} **Organization**, then **Audit Logs Setup**.
1. On the **Konnect** tab, configure the following webhook settings for the region you want to enable audit logs for:
   * **Region endpoint**: The external endpoint that will receive audit log messages. 
   * **Authorization Header**: The authorization type and credential to pass to your log collection endpoint. 
    {{site.konnect_short_name}} will send this string in the `Authorization` header of requests to that endpoint.

     For example, if you are setting up the webhook for Splunk, you could provide a Splunk access token: 
     `"authorization":"Splunk example-token12234352535235"`.
        
    * **Log Format**: The output format of each log message. Can be CEF or JSON.
    * **Skip SSL Verification**: Skip SSL verification of the host endpoint when delivering payloads.

     {:.note}
     > We strongly recommend not setting this to `true` as you are subject to man-in-the-middle and other attacks. This option should be considered only when using self-signed SSL certificates in a non-production environment.

1. Switch the toggle to `Enabled`, then save your webhook configuration.

{% endnavtab %}
{% navtab API %}

Now that you have an external endpoint and authorization credentials, you can set up a webhook in {{site.konnect_short_name}}.

The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

Create a webhook by sending a request to the `/audit-log-webhook` endpoint with the connection details for your SIEM vendor:

```sh
curl -i -X PATCH https://{region}.api.konghq.com/v2/audit-log-webhook \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer <personal-access-token>" \
    --data '{
        "endpoint": "https://example.com/audit-logs",
        "enabled": true,
        "authorization": "Bearer example-token",
        "log_format": "cef"
    }'
```

Be sure to replace the PAT token and the following placeholder values:
* `{region}.api.konghq.com`: The region your org is in. Can be `global` to target all regions, `us`, `au`, or `eu`.
* `endpoint`: The external endpoint that will receive audit log messages. Check your SIEM documentation to find out where to send CEF or JSON data.
* `authorization`: The authorization type and credential to pass to your log collection endpoint. 
    {{site.konnect_short_name}} will send this string in the `Authorization` header of requests to that endpoint. For example, if you are setting up the webhook for Splunk, you could provide a Splunk access token: `"authorization":"Splunk example-token12234352535235"`.
* `log_format`: The output format of each log message. Can be `cef` or `json`.
* `skip_ssl_verification`: (Optional) Set to `true` to skip SSL verification of the host endpoint when delivering payloads. We recommend only using this when using self-signed SSL certificates in a non-production environment as this can subject you to man-in-the-middle and other attacks.

If the request is successful, you will receive a `200` response code, and a response body containing the webhook's configuration details.

{% endnavtab %}
{% endnavtabs %}

Your webhook should now start receiving audit logs. 

## View audit log webhook status

{% navtabs %}
{% navtab Konnect UI %}

You can view the status of your webhook through the **Audit Logs Setup** page under 
{% konnect_icon organizations %} **Organization**. A badge will display next to the title of the webhook with the status of the webhook.

To see the last attempt timestamp and the last response code, use the audit log API.

{% endnavtab %}
{% navtab API %}

View your audit log webhook configuration by sending a GET request to the `/audit-log-webhook` endpoint:

```sh
curl -i -X GET https://{region}.api.konghq.com/v2/audit-log-webhook \
    --header "Authorization: Bearer <personal-access-token>"
```

You will receive a `200` response code and the following data. Note that the `authorization` property is not included in any responses:

```json
{
    "endpoint":"https://example.com/audit-logs",
    "log_format":"cef",
    "enabled":true,
    "skip_ssl_verification":false,
    "updated_at":"2023-04-01T00:00:01Z"
}
```

View your audit log webhook status by sending a GET request to the `/audit-log-webhook/status` endpoint:

```sh
curl -i -X GET https://{region}.api.konghq.com/v2/audit-log-webhook/status \
    --header "Authorization: Bearer <personal-access-token>"
```

You will receive a `200` response code and a response body with information about the webhook status:

```json
{
    "last_attempt_at": "2023-04-04T18:11:16Z",
    "last_response_code": 200,
    "webhook_enabled": true,
    "webhook_status": "active"
}
```

{% endnavtab %}
{% endnavtabs %}


## More information
* [Audit logging in {{site.konnect_short_name}}](/konnect/org-management/audit-logging/)
* [Audit log event reference](/konnect/reference/audit-logs/)
* [Set up an audit log replay job](/konnect/org-management/audit-logging/replay-job/)
* [Verify audit log signatures](/konnect/reference/verify-signatures/)
* [Audit Logs API](/konnect/api/audit-logs/latest/)