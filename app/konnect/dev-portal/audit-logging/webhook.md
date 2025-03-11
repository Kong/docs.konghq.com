---
title: Set up an audit log webhook for Dev Portal
content_type: how-to
---

You can use the {{site.konnect_short_name}} UI or the [Audit Logs](/konnect/api/audit-logs/latest/) and [Portal Management](/konnect/api/portal-management/latest/) APIs to configure webhooks for [audit logging](/konnect/dev-portal/audit-logging/). 

{% include_cached /md/konnect/audit-logging/webhook-overview-prereq-siem-config.md desc='Dev Portal' %}


## Create a webhook

{% navtabs %}
{% navtab Konnect UI %}
Before you configure the webhook, you must first create an audit log destination. This allows you to set your audit log destination (the endpoint URL for your SIEM provider) and reuse it. 

1. From {% konnect_icon organizations %} [**Organization**](https://cloud.konghq.com/organization) in the sidebar, click **Audit Logs Setup**.
1. On the **Webhook Destination** tab, click **New Webhook** and configure the following:
   * **Name**: The name you want to display for the audit log destination.
   * **Endpoint**: The external endpoint that will receive audit log messages. 
   * **Authorization Header**: The authorization type and credential to pass to your log collection endpoint. 
    {{site.konnect_short_name}} will send this string in the `Authorization` header of requests to that endpoint.

     For example, if you are setting up the webhook for Splunk, you could provide a Splunk access token: 
     `"authorization":"Splunk example-token12234352535235"`.
        
    * **Log Format**: The output format of each log message. Can be CEF or JSON.
    * **Disable SSL Verification**: Disables SSL verification of the host endpoint when delivering payloads. We recommend disabling SSL verification only when using self-signed SSL certificates in a non-production environment as this can subject you to man-in-the-middle and other attacks.
1. To configure the Dev Portal audit log webhook, navigate to {% konnect_icon dev-portal %} [**Dev Portal**](https://cloud.konghq.com/portal) in the sidebar.
   
   You can alternatively configure these settings by navigating to [**Organization > Audit Logs Setup**](https://cloud.konghq.com/global/organization/audit-logs) under the **Dev Portal** tab.
1. Click the Dev Portal you want to configure the webhook for and then click **Settings**.
1. Click the **Audit Logs** tab.
1. Enable the webhook and then select the SIEM provider endpoint from the **Endpoint** drop down menu. You can't customize the events that {{site.konnect_short_name}} sends to the logs.
1. Click **Save**.

{% endnavtab %}
{% navtab API %}

Now that you have an external endpoint and authorization credentials, you can set up an audit log destination in {{site.konnect_short_name}}. The `/audit_log_destinations` endpoint allows you to set your audit log destination, which includes the endpoint URL and access key for your SIEM provider, and reuse it. 

1. Create an audit log destination by sending a request to the [`/audit-log-destinations`](/konnect/api/audit-logs/latest/) endpoint with the connection details for your SIEM provider:

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

    Be sure to replace the following placeholder values:
    * `<personal-access-token>`: Your {{site.konnect_short_name}} [personal access token (PAT)](/konnect/api/#authentication).
    * `endpoint`: The external endpoint that will receive audit log messages. Check your SIEM documentation to find out where to send CEF or JSON data.
    * `authorization`: The authorization type and credential to pass to your log collection endpoint. 
    {{site.konnect_short_name}} will send this string in the `Authorization` header of requests to that endpoint. For example, if you are setting up the webhook for Splunk, you could provide a Splunk access token: `"authorization":"Splunk example-token12234352535235"`.
    * `log_format`: The output format of each log message. Can be `cef` or `json`.
    * `name`: A unique human-readable name to identify this destination.
    * `skip_ssl_verification`: (Optional) Set to `true` to skip SSL verification of the host endpoint when delivering payloads. We recommend skipping SSL verification only when using self-signed SSL certificates in a non-production environment as this can subject you to man-in-the-middle and other attacks.

    If the request is successful, you will receive a `200` response code, and a response body containing the audit log destination's configuration details. Be sure to save the audit log destination `id` for the next step. 

1. Create a webhook by sending a PATCH request to the [`/audit-log-webhook`](/konnect/api/portal-management/latest/) endpoint with your configured audit log destination:

    ```sh
    curl -i -X PATCH https://{region}.api.konghq.com/v2/portals/{portalId}/audit-log-webhook \
     --header "Content-Type: application/json" \
     --header "Authorization: Bearer <personal-access-token>" \
     --data '{
         "audit_log_destination_id": "05atf3f2-9d07-4e46-8115-c58ca594d00e",
         "enabled": true
     }'
    ```

    Be sure to replace the following placeholder values:
    * `{region}.api.konghq.com`: The region your Dev Portal is located in. Can be `us`, `au`, or `eu`.
    * `<personal-access-token>`: Your {{site.konnect_short_name}} [personal access token (PAT)](/konnect/api/#authentication).
    * `{portalId}`: The ID of the Dev Portal with your webhook.
    * `audit_log_destination_id`: The ID of the audit log destination that you want to use.

    You can't customize the events that {{site.konnect_short_name}} sends to the logs.

    If the request is successful, you will receive a `200` response code, and a response body containing the webhook's configuration details.

{% endnavtab %}
{% endnavtabs %}

Your webhook should now start receiving audit logs.

## View audit log webhook status

{% navtabs %}
{% navtab Konnect UI %}

1. In {% konnect_icon dev-portal %} [**Dev Portal**](https://cloud.konghq.com/portal), click the Dev Portal you want to view the webhook status job for.
   
   You can alternatively view your audit log webhook status by navigating to [**Organization > Audit Logs Setup**](https://cloud.konghq.com/global/organization/audit-logs). Under the **Dev Portal** tab, click the Dev Portal you want to view the log status for.
1. Click **Settings** in the sidebar, then click the **Audit Logs** tab.
1. Click the **Status** tab.

A badge will display next to the title of the webhook with the status of the webhook.

To see the last attempt timestamp and the last response code, use the [audit log API](/konnect/api/audit-logs/latest/).

{% endnavtab %}
{% navtab API %}

View your audit log webhook status by sending a GET request to the [`/audit-log-webhook/status`](/konnect/api/portal-management/latest/) endpoint:

```sh
curl -i -X GET https://{region}.api.konghq.com/v2/portals/{portalId}/audit-log-webhook/status \
    --header "Authorization: Bearer <personal-access-token>"
```

Be sure to replace the following placeholder values:
* `{region}.api.konghq.com`: The region your Dev Portal is located in. Can be `us`, `au`, or `eu`.
* `<personal-access-token>`: Your {{site.konnect_short_name}} [personal access token (PAT)](/konnect/api/#authentication).
* `{portalId}`: The ID of the Dev Portal with your webhook.

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
