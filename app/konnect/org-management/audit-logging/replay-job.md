---
title: Set up an audit log replay job
content_type: how-to
---

You can use the {{site.konnect_short_name}} Audit Logs API to configure replay jobs for [audit logging](/konnect/org-management/audit-logging/). Replay jobs allow you to get audit logs for a specific time period in the past.

Replay jobs are useful when you have missed audit log entries due to an error or a misconfigured audit
log webhook. You may have one replay job at a time per region, and request data from up to one week ago.
A replay job in a region will resend data for the requested timeframe to the webhook configured for that region.

## Prerequisites

* [Org Admin permissions](/konnect/org-management/teams-and-roles/teams-reference/)
* Your [audit log webhook](/konnect/org-management/audit-logging/webhook/) must be enabled and ready to receive data. 


## Configure a replay job

{% navtabs %}
{% navtab Konnect UI %}

1. From the navigation menu, open {% konnect_icon organizations %} **Organization**, then **Audit Logs Setup**.
1. On the **Konnect** tab, click the **Replay** tab for the region webhook that you want to replay.
1. Choose a timeframe for which you want to replay the logs. 

   You can choose one of the preset relative increments for up to 24 hours, or 
   set a custom timeframe for up to 7 days.

1. Apply the timeframe, then click **Send Replay**.

{% endnavtab %}
{% navtab API %}

Configure the replay job for a region by sending a `PUT` request to the [`/audit-log-replay-job`](/konnect/api/audit-logs/latest/#/Audit%20Logs/update-audit-log-replay-job) endpoint in the region where you want to retrieve data:

```sh
curl -i -X PUT https://{region}.api.konghq.com/v2/audit-log-replay-job \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer <personal-access-token>" \
    --data '{
        "start_at": "2023-03-27T20:00:00Z",
        "end_at": "2023-03-27T20:00:00Z"
    }'
```

Be sure to replace the following placeholder values:
* `{region}.api.konghq.com`: The region your portal is located in. Can be `us`, `ap`, or `eu`.
* `<personal-access-token>`: Your {{site.konnect_short_name}} [personal access token (PAT)](/konnect/api/#authentication).
* `{portalId}`: The ID of the Dev Portal with your webhook.
* `start_at` and `end_at`: Specify the timeframe for which you want to receive audit log events. `start_at` must be no more than seven days ago.

If the request is successful, you will receive a `202` response code and a response body containing the replay job details.

{% endnavtab %}
{% endnavtabs %}

## View replay job

{% navtabs %}
{% navtab Konnect UI %}

1. From the navigation menu, open {% konnect_icon organizations %} **Organization**, then **Audit Logs Setup**.
1. Switch to the **Replay** tab.
1. Check the status table below the configuration field.

![Audit log replay](/assets/images/products/konnect/audit-logs/konnect-audit-log-replay.png)

{% endnavtab %}
{% navtab API %}

You can view the audit log replay job in a given region by issuing a GET request to the [`audit-log-replay-job`](/konnect/api/audit-logs/latest/#/Audit%20Logs/get-audit-log-replay-job) endpoint:

```sh
curl https://{region}.api.konghq.com/v2/audit-log-replay-job \
    --header "Authorization: Bearer <personal-access-token>"
```

Be sure to replace the following placeholder values:
* `{region}.api.konghq.com`: The region your portal is located in. Can be `us`, `ap`, or `eu`.
* `<personal-access-token>`: Your {{site.konnect_short_name}} [personal access token (PAT)](/konnect/api/#authentication).

You will receive a `200` response code and the job details.

{% endnavtab %}
{% endnavtabs %}

## Replay job status

A replay job can be in one of the following statuses:

| Status | Description |
| -------|-------------|
| `unconfigured` | Initial state. The job has not been set up. |
| `accepted` | The job has been accepted for scheduling. |
| `pending` | The job has been scheduled. |
| `running` | The job is in progress. When a replay job is `running`, a request to update the job will return a `409` response code until it has completed or failed. |
| `completed` | The job has finished with no errors. |
| `failed` | The job has failed. |

## More information
* [Audit logging in {{site.konnect_short_name}}](/konnect/org-management/audit-logging/)
* [Set up an audit log webhook](/konnect/org-management/audit-logging/webhook/)
* [Audit log event reference](/konnect/org-management/audit-logging/reference/)
* [Verify audit log signatures](/konnect/reference/verify-signatures/)
* [Audit Logs API](/konnect/api/audit-logs/latest/)
