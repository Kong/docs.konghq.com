---
title: Set up an audit log webhook for Dev Portal
content_type: how-to
badge: enterprise
---

You can use the {{site.konnect_short_name}} UI or the Audit Logs API to configure webhooks for [audit logging](/konnect/dev-portal/audit-logging/). 

{:.note}
> **Note:** Currently, Dev Portal audit logs only support authorization logs, which are triggered when a user logs in to Dev Portal.

{% include_cached /md/konnect/audit-logging/webhook-overview-prereq-siem-config.md %}


## Create a webhook

{% navtabs %}
{% navtab Konnect UI %}
1. From the navigation menu, open {% konnect_icon organizations %} **Organization**, then **Audit Logs Setup** and **Destinations**
1. Fill in the fields in the **Destinations** tab. This allows you to set your audit log destination (the endpoint URL for your SIEM provider) and reuse it. 
   * **Region endpoint**: The external endpoint that will receive audit log messages. 
   * **Authorization Header**: The authorization type and credential to pass to your log collection endpoint. 
    {{site.konnect_short_name}} will send this string in the `Authorization` header of requests to that endpoint.

     For example, if you are setting up the webhook for Splunk, you could provide a Splunk access token: 
     `"authorization":"Splunk example-token12234352535235"`.
        
    * **Log Format**: The output format of each log message. Can be CEF or JSON.
    * **Skip SSL Verification**: Skip SSL verification of the host endpoint when delivering payloads.

     {:.note}
     > We strongly recommend not setting this to `true` as you are subject to man-in-the-middle and other attacks. This option should be considered only when using self-signed SSL certificates in a non-production environment.
1. From the navigation menu, open {% konnect_icon Dev-portal %} **Settings**, then **Audit Logs Setup**.
1. Fill in the fields in the **Setup** tab.
    * **Audit log Destination**: select the destination that you want to use from the drop down list
    * 
1. Switch the toggle to `Enabled`, then save your webhook configuration.

{% endnavtab %}
{% navtab API %}

Now that you have an external endpoint and authorization credentials, you can set up an audit log destination in {{site.konnect_short_name}}. The `/audit_log_destinations` endpoint allows you to set your audit log destination, which includes the endpoint URL and access key for your SIEM provider, and reuse it. 

The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

1. Create an audit log destination by sending a request to the `/audit-log-destinations` endpoint with the connection details for your SIEM provider:

    ```sh
    curl -i -X POST https://global.api.konghq.com/v2/audit-log-destinations \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer <personal-access-token>" \
    --data '{
        "endpoint": "https://example.com/audit-logs",
        "authorization": "<SIEM-access-token>",
        "log_format": "cef",
        "name": "example destinations name"
    }'
    ```

    Be sure to replace the PAT token and the following placeholder values:
    * `endpoint`: The external endpoint that will receive audit log messages. Check your SIEM documentation to find out where to send CEF or JSON data.
    * `authorization`: The authorization type and credential to pass to your log collection endpoint. 
    {{site.konnect_short_name}} will send this string in the `Authorization` header of requests to that endpoint. For example, if you are setting up the webhook for Splunk, you could provide a Splunk access token: `"authorization":"Splunk example-token12234352535235"`.
    * `log_format`: The output format of each log message. Can be `cef` or `json`.
    * `name`: A unique human-readable name to identify this destination.
    * `skip_ssl_verification`: (Optional) Set to `true` to skip SSL verification of the host endpoint when delivering payloads. We recommend only using this when using self-signed SSL certificates in a non-production environment as this can subject you to man-in-the-middle and other attacks.

    If the request is successful, you will receive a `200` response code, and a response body containing the webhook's configuration details. Be sure to save the audit log destination `id` for the next step. 

1. Create a webhook by sending a PATCH request to the `/audit-log-webhook` endpoint with your configured audit log destination:

    ```sh
    curl -i -X PATCH https://{region}.api.konghq.com/v2/portals/{portalId}/audit-log-webhook \
     --header "Content-Type: application/json" \
     --header "Authorization: Bearer <personal-access-token>" \
     --data '{
         "audit_log_destination_id": "05atf3f2-9d07-4e46-8115-c58ca594d00e",
         "enabled": true
     }'
    ```

    Replace the following placeholders with your own data:
    * `{region}.api.konghq.com`: The region your Dev Portal is located in. Can be `us`, `au`, or `eu`.
    * `audit_log_destination_id`: The ID of the audit log destination that you want to use.

    If the request is successful, you will receive a `200` response code, and a response body containing the webhook's configuration details.

{% endnavtab %}
{% endnavtabs %}

Your webhook should now start receiving audit logs.

## View audit log webhook status

{% navtabs %}
{% navtab Konnect UI %}

You can view the status of your webhook through the **Audit Logs Setup** page under
{% konnect_icon organizations %} **Organization**.

Notice the status badge next to title of the webhook. For example, the following webhook is active:

![Audit log webhook](/assets/images/products/konnect/audit-logs/konnect-audit-log-webhook.png)

To find the last attempt timestamp and the last response code, use the audit log API.

{% endnavtab %}
{% navtab API %}

The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

View your audit log webhook status by sending a GET request to the `/audit-log-webhook/status` endpoint:

```sh
curl -i -X GET https://{region}.api.konghq.com/v2/portals/{portalId}/audit-log-webhook/status \
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
* [Audit logging in {{site.konnect_short_name}}](/konnect/dev-portal/audit-logging/)
* [Audit log event reference](/konnect/reference/audit-logs/)
* [Set up an audit log replay job](/konnect/dev-portal/audit-logging/replay-job/)
* [Verify audit log signatures](/konnect/reference/verify-signatures/)
* [Audit Logs API](/konnect/api/audit-logs/latest/)
