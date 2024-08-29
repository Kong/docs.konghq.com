---
title: Set up an audit log webhook
content_type: how-to
badge: enterprise
---

You can use the {{site.dev-portal_short_name}} UI or the Audit Logs API to configure webhooks for [audit logging](/konnect/dev-portal/audit-logging/).

Webhooks are invoked via an HTTPS request using the following retry rules:

- Minimum retry wait time: 1 second
- Maximum retry wait time: 30 seconds
- Maximum number of retries: 4

A retry is performed on connection error, server error (`500` HTTP status code), or too many requests (`429` HTTP status code).

{:.note}
> **Notes:**
Only supports HTTPS Webhook endpoints.

## Prerequisites

You must have **Org Admin** permissions to set up audit log webhooks.

you must have a configured a audit log destination that can be used to receive audit logs.

## Create a webhook

{% navtabs %}
{% navtab Konnect UI %}

1. From the navigation menu, open {% konnect_icon Dev-portal %} **Settings**, then **Audit Logs Setup**.
1. Fill in the fields in the **Setup** tab.
    * **Audit log Destination**: select the destination that you want to use from the drop down list
    * 
1. Switch the toggle to `Enabled`, then save your webhook configuration.

{% endnavtab %}
{% navtab API %}

Create a webhook by sending a request to the `/audit-log-webhook` endpoint with the connection details for your SIEM vendor:

```sh
curl -i -X PATCH https://global.api.konghq.com/v2/portals/{portalId}/audit-log-webhook \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer TOKEN" \
    --data '{"audit_log_destination_id":"09bbf3f2-9d07-4e46-8115-c58ca703d00e","enabled":true}'
```

Replace the following placeholders with your own data:
* `global.api.konghq.com`: The region your org is in. Can be `global` to target all regions, `us`, or `eu`.
* `TOKEN`: A {{site.konnect_short_name}} [personal access token](https://cloud.konghq.com/global/tokens) or
  [system account token](/konnect/dev-portal/system-accounts/).
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
curl global.api.konghq.com/v2/portals/{portalId}/audit-log-webhook \
    --header "Authorization: Bearer TOKEN"
```

You will receive a `200` response code and the following data. Note that the `authorization` property is not included in any responses:

```json
{
    "audit_log_destination_id": "9bbf3f2-9d07-4e46-8115-c58ca703d00e",
    "enabled":true
}
```

View your audit log webhook status by running the following command:

```sh
curl global.api.konghq.com/v2/portals/{portalId}/audit-log-webhook/status \
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
