---
title: Set up an audit log replay job
content_type: how-to
badge: enterprise
beta: true
---

You can use the {{site.konnect_short_name}} Organization Settings API to configure replay jobs for [audit logging](/konnect/org-management/audit-logging). 

Replay jobs are useful when you have missed audit log entries due to an error or a misconfigured audit
log webhook. You may create one replay job at a time per region, and request data from up to one week ago.
A replay job in a region will resend data for the requested timeframe to the webhook configured for that region.

## Prerequisites

Before you can request a replay job, your [audit log webhook](/konnect/org-management/audit-logging/webhook) 
must be enabled and ready to receive data. 

## Create or update a replay job

Create or update the replay job for a region by sending a `PUT` request to `/audit-log-replay-job` in the region where you want to retrieve data. The example below is for the `us` region.

```sh
curl -i -X PUT https://us.api.konghq.com/v2/audit-log-replay-job \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer TOKEN" \
    --data '{"start_at":"2023-03-27T20:00:00Z","end_at":"2023-03-27T20:00:00Z"}'
```

Replace the following placeholder with your own data:
* `TOKEN`: A {{site.konnect_short_name}} [personal access token](https://cloud.konghq.com/global/tokens) or 
  [system account token](/konnect/org-management/system-accounts).

`start_at` and `end_at` specify the timeframe for which you want to receive audit log events. `start_at` must be no more than seven days ago.

If the request is successful, you will receive a `202` response code and a response body containing the replay job details: 

```json
{
    "start_at":"2023-03-27T20:00:00Z",
    "end_at":"2023-03-27T20:00:00Z",
    "created_at":"2023-03-31T11:34:18Z",
    "status":"accepted"
}
```

## View replay job

You can view the audit log replay job in a given region by issuing a GET request. The example below retrieves an audit-log-replay-job in the `us` region:

```sh
curl https://us.api.konghq.com/v2/audit-log-replay-job \
    --header "Authorization: Bearer TOKEN"
```

You will receive a `200` response code and the following data:

```json
{
    "start_at":"2023-03-27T20:00:00Z",
    "end_at":"2023-03-27T20:00:00Z",
    "created_at":"2023-03-31T11:34:18Z",
    "status":"accepted"
}
```

## Replay job status

A replay job can be in one of the following statuses:

* `accepted`: The job has been accepted for scheduling.
* `pending`: The job has been scheduled.
* `running`: The job is in progress.
* `completed`: The job has finished with no errors.
* `failed`: The job has failed.

When a replay job is `running`, a request to update the job will return a `409` response code until it has completed or failed.


## See also
* [Audit logging in {{site.konnect_short_name}}](/konnect/org-management/audit-logging/)
* [Set up an audit log webhook](/konnect/org-management/audit-logging/webhook)
* [Audit log event reference](/konnect/org-management/audit-logging/reference/)
* [Organization Settings API](https://developer.konghq.com/spec/e46e7742-befb-49b1-9bf1-7cbe477ab818/d36126ee-ab8d-47b2-960f-5703da22cced/)
