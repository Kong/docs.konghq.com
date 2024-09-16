---
title: Set up an audit log webhook for Dev Portal
content_type: how-to
badge: enterprise
---

You can use the {{site.konnect_short_name}} UI or the Audit Logs API to configure webhooks for [audit logging](/konnect/dev-portal/audit-logging/).

{% include_cached /md/konnect/audit-logging/webhook-overview-prereq-siem-config.md %}


## Create a webhook

{% navtabs %}
{% navtab Konnect UI %}
1. From the navigation menu, open {% konnect_icon organizations %} **Organization**, then **Audit Logs Setup** and **Destinations**
1. Fill in the fields in the **Destinations** tab. <!--explain why-->
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

Now that you have an external endpoint and authorization credentials, you can set up a destination in {{site.konnect_short_name}}. <!--explain why-->

Create a destination by sending a request to the `/audit-log-destinations` endpoint with the connection details for your SIEM vendor:

```sh
curl -i -X POST https://global.api.konghq.com/v2/audit-log-destinations \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer TOKEN" \
    --data '{"endpoint":"https://example.com/audit-logs","authorization":"Bearer example-token","log_format":"cef","name":"example destinations name"}'
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
* `name`: A unique human-readable name to identify this destination.
* `skip_ssl_verification`: (Optional) Set to `true` to skip SSL verification of the host endpoint when delivering payloads.

  {:.note}
  > We strongly recommend not setting this to `true` as you are subject to man-in-the-middle and other attacks. This option should be considered only when using self-signed SSL certificates in a non-production environment.

If the request is successful, you will receive a `200` response code, and a response body containing the webhook's configuration details: 

```json
{
    "id": "07ec3858-066b-4629-bdc5-d4aa893b424d",
    "name": "example destinations name",
    "endpoint":"https://example.com/audit-logs",
    "log_format":"cef",
    "skip_ssl_verification":false,
    "created_at":"2023-04-01T00:00:01Z",
    "updated_at":"2023-04-01T00:00:01Z"
}
```

View your audit log destination configuration by running the following command:

```sh
curl https://global.api.konghq.com/v2/audit-log-destinations \
    --header "Authorization: Bearer TOKEN"
```

You will receive a `200` response code and the following data. Note that the `authorization` property is not included in any responses:

```json
[
  {
    "id": "07ec3858-066b-4629-bdc5-d4aa893b424d",
    "name": "example destinations name",
    "endpoint":"https://example.com/audit-logs",
    "log_format":"cef",
    "skip_ssl_verification":false,
    "created_at":"2023-04-01T00:00:01Z",
    "updated_at":"2023-04-01T00:00:01Z"
  }
]
```

Create a webhook by sending a request to the `/audit-log-webhook` endpoint with the connection details for your SIEM vendor:

```sh
curl -i -X PATCH https://us.api.konghq.com/v2/portals/{portalId}/audit-log-webhook \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer TOKEN" \
    --data '{"audit_log_destination_id":"09bbf3f2-9d07-4e46-8115-c58ca703d00e","enabled":true}'
```

Replace the following placeholders with your own data:
* `us.api.konghq.com`: The region your portal is located in. Can be `us`, `ap` or `eu`.
* `TOKEN`: A {{site.konnect_short_name}} [personal access token](https://cloud.konghq.com/global/tokens) or
  [system account token](/konnect/org-management/system-accounts/).
* `audit_log_destination_id`: The ID of the audit log destination that you want to use.

If the request is successful, you will receive a `200` response code, and a response body containing the webhook's configuration details:

```json
{
    "audit_log_destination_id":"09bbf3f2-9d07-4e46-8115-c58ca703d00e",
    "enabled":true
}
```

{% endnavtab %}
{% endnavtabs %}

Your webhook should now start receiving audit logs.

## View webhook configuration and status

{% navtabs %}
{% navtab Konnect UI %}

You can view the status of your webhook through the **Audit Logs Setup** page under
{% konnect_icon organizations %} **Organization**.

Notice the status badge next to title of the webhook. For example, the following webhook is active:

![Audit log webhook](/assets/images/products/konnect/audit-logs/konnect-audit-log-webhook.png)

To find the last attempt timestamp and the last response code, use the audit log API.

{% endnavtab %}
{% navtab API %}

View your audit log webhook configuration by running the following command:

```sh
curl us.api.konghq.com/v2/portals/{portalId}/audit-log-webhook \
    --header "Authorization: Bearer TOKEN"
```

You will receive a `200` response code and the following data. Note that the `authorization` property is not included in any responses:

```json
{
    "audit_log_destination_id": "9bbf3f2-9d07-4e46-8115-c58ca703d00e",
    "enabled":true
}
```

<!-- once we have access to the API, I'd think we'd want to do a GET to the audit log destination id as well to get the other info like endpoint, log format, etc.-->

View your audit log webhook status by running the following command:

```sh
curl us.api.konghq.com/v2/portals/{portalId}/audit-log-webhook/status \
    --header "Authorization: Bearer TOKEN"
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

The attributes are defined as follows:

attribute | definition
--------- | ----------
`last_attempt at` | The last time {{site.konnect_short_name}} tried to send data to your webhook
`last_response_code` | The last response code from your webhook
`webhook_enabled` | The desired status of the webhook (from `audit-log-webhook.enabled`)
`webhook_status` | The actual status {{site.konnect_short_name}} of the webhook

A combination of `webhook_enabled` and `webhook_status` give a full picture of webhook status.

`webhook_enabled` | `webhook_status` | definition
--------------- | -------------- | ----------
true            | `active`       | {{site.konnect_short_name}} is ready to ship data to the webhook. Either no attempts have been made yet (`last_attempt_at` is not set), or the last attempt was successful.
true            | `inactive`     | Last attempt to send data failed, but customer wants data to resume.
false           | `active`       | Webhook config is saved. {{site.konnect_short_name}} is not shipping data to it per webhook configuration.
false           | `inactive`     |Last attempt to send data failed, and customer has turned off the webhook.
false           | `unconfigured` | The webhook for this region has not been configured yet.


## More information
* [Audit logging in {{site.konnect_short_name}}](/konnect/dev-portal/audit-logging/)
* [Audit log event reference](/konnect/dev-portal/audit-logging/reference/)
* [Set up an audit log replay job](/konnect/dev-portal/audit-logging/replay-job/)
* [Verify audit log signatures](/konnect/dev-portal/audit-logging/verify-signatures/)
* [Audit Logs API](/konnect/api/audit-logs/latest/)
