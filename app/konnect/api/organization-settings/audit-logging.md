---
title: Set up an audit log webhook
content_type: how-to
badge: enterprise
beta: true
---

You can use the Konnect Organization Settings API to configure webhooks for [audit logging](/konnect/org-management/audit-logging). 

Webhooks are invoked via an HTTP request using the following retry rules:

- Minimum retry wait time: 1 second
- Maximum retry wait time: 30 seconds
- Maximum number of retries: 4

A retry is done on connection error, server error (`500` status code), or too many requests (`429` status code).

## Prerequisites

Before you can push Konnect audit logs to an external service, you need to configure the service to receive logs. 
This configuration is specific to your vendor.

1. Configure a data collection endpoint to push logs to in one of the following SIEM providers:
    * Microsoft Azure Sentinel
    * Splunk Enterprise Security
    * IBM QRadar
    * ArcSight
    * LogRhythm

2. Create an access token, or find the credentials that you will need to access this endpoint.

## Create a webhook

Now that you have an external endpoint and authorization credentials, you can set up a webhook in Konnect.

Create a webhook by sending a `PUT` request to the `/audit-log-webhook` endpoint with the connection details for your SIEM vendor:

```sh
curl -i -X PUT https://global.api.konghq.com/v2/audit-log-webhook \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer PAT" \
    --data '{"endpoint":"https://example.com/audit-logs","enabled":true,"authorization":"Bearer example-token"}'
```

Replace the following placeholders with your own data:
* `PAT`: A Konnect [personal access token](https://cloud.konghq.com/global/tokens) for the organization that you're tracking.
* `"endpoint":"https://example.com/audit-logs"`: The external endpoint that will receive audit log messages.
* `"authorization":"Bearer example-token"`: The access token for your log collection service. 

    For example, if you are setting up the webhook for Splunk, you would provide a Splunk access token: `"authorization":"Splunk example-token12234352535235"`

If the connection is successful, you will receive a `200` response code, and a response body containing the webhook's configuration details: 

```json
{
    "endpoint":"https://example.com/audit-logs",
    "authorization":"<example-token>",
    "enabled":true
}
```

You should now start receiving logs at your endpoint from the configured organization. 

## View webhook configuration

You can view audit log webhooks by running the following:

```sh
curl https://global.api.konghq.com/v2/audit-log-webhook \
    --header "Authorization: Bearer PAT"
```

You will receive a `200` response code and the following data, with the authorization token hidden:

```json
{
    "endpoint":"https://example.com/audit-logs",
    "enabled":true
}
```

## See also
* [Audit logging in Konnect](/konnect/org-management/audit-logging/)
* [Audit log event reference](/konnect/org-management/audit-logging/reference/)
* [Organization Settings API](https://developer.konghq.com/spec/e46e7742-befb-49b1-9bf1-7cbe477ab818/d36126ee-ab8d-47b2-960f-5703da22cced/)