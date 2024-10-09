---
title: Set up an audit log replay job
content_type: how-to
badge: enterprise
---

You can use the {{site.dev-portal_short_name}} Audit Logs API to configure replay jobs for [audit logging](/konnect/dev-portal/audit-logging/). 

Replay jobs are useful when you have missed audit log entries due to an error or a misconfigured audit
log webhook. You may have one replay job at a time per region, and request data from up to one week ago.
A replay job in a region will resend data for the requested timeframe to the webhook configured for that region.

## Prerequisites

* [Org Admin or Portal Admin permissions](/konnect/org-management/teams-and-roles/teams-reference/)
* Your [audit log webhook](/konnect/dev-portal/audit-logging/webhook/) must be enabled and ready to receive data. 


## Configure a replay job

{% navtabs %}
{% navtab Konnect UI %}

1. In {% konnect_icon dev-portal %} [**Dev Portal**](https://cloud.konghq.com/portal), click the Dev Portal you want to configure a replay job for.
1. Click **Settings** in the sidebar, and then click the **Audit Logs** tab.
1. Click the **Replay** tab.
1. Choose a timeframe for which you want to replay the logs. 

   You can choose one of the preset relative increments for up to 24 hours, or 
   set a custom timeframe for up to 7 days.

1. Apply the timeframe, then click **Send Replay**.

{% endnavtab %}
{% navtab API %}
The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

Configure the replay job for a region by sending a `PUT` request to the `/audit-log-replay-job` endpoint:

```sh
curl -i -X PUT https://{region}.api.konghq.com/v2/portals/{portalId}/audit-log-replay-job \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer <personal-access-token>" \
    --data '{
        "start_at": "2023-03-27T20:00:00Z",
        "end_at": "2023-03-27T20:00:00Z"
    }'
```

Be sure to replace the [PAT token ](https://docs.konghq.com/konnect/api/#authentication) and the following placeholder values:
* `{region}.api.konghq.com`: The region your portal is located in. Can be `us`, `ap`, or `eu`.
* `{portalId}`: The ID of the Dev Portal with your webhook.
* `start_at` and `end_at`: Specify the timeframe for which you want to receive audit log events. `start_at` must be no more than seven days ago.

If the request is successful, you will receive a `202` response code and a response body containing the replay job details: 

```json
{
    "start_at":"2023-03-27T20:00:00Z",
    "end_at":"2023-03-27T20:00:00Z",
    "updated_at":"2023-03-31T11:34:18Z",
    "status":"accepted"
}
```

{% endnavtab %}
{% endnavtabs %}

## View replay job

{% navtabs %}
{% navtab Konnect UI %}

1. In {% konnect_icon dev-portal %} [**Dev Portal**](https://cloud.konghq.com/portal), click the Dev Portal you want to view the replay job for.
1. Click **Settings** in the sidebar, then click the **Audit Logs** tab.
1. Click the **Replay** tab.
1. Check the status table below the configuration field.

{% endnavtab %}
{% navtab API %}

You can view the audit log replay job in a given region by issuing a GET request to the `audit-log-replay-job` endpoint:

```sh
curl -i -X GET https://{region}.api.konghq.com/v2/portals/{portalId}/audit-log-replay-job \
    --header "Authorization: Bearer TOKEN"
```

Be sure to replace the PAT token and the following placeholder values:
* `{region}.api.konghq.com`: The region your portal is located in. Can be `us`, `ap`, or `eu`.
* `{portalId}`: The ID of the Dev Portal with your webhook.

You will receive a `200` response code and the job details:

```json
{
    "start_at":"2023-03-27T20:00:00Z",
    "end_at":"2023-03-27T20:00:00Z",
    "updated_at":"2023-03-31T11:34:18Z",
    "status":"accepted"
}
```

{% endnavtab %}
{% endnavtabs %}

## Replay job status

A replay job can be in one of the following statuses:

* `unconfigured`: Initial state. The job has not been set up.
* `accepted`: The job has been accepted for scheduling.
* `pending`: The job has been scheduled.
* `running`: The job is in progress.
* `completed`: The job has finished with no errors.
* `failed`: The job has failed.

When a replay job is `running`, a request to update the job will return a `409` response code until it has completed or failed.

## More information
* [Audit logging in {{site.konnect_short_name}}](/konnect/dev-portal/audit-logging/)
* [Set up an audit log webhook](/konnect/dev-portal/audit-logging/webhook/)
* [Audit log event reference](/konnect/reference/audit-logs/)
* [Verify audit log signatures](/konnect/reference/verify-signatures/)
* [Audit Logs API](/konnect/api/audit-logs/latest/)
