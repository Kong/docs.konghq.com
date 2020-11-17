---
title: Alert Slack Integration
toc: true
redirect_from:
  - /enterprise/2.2.x/brain-immunity/slack-integration
---


## Introduction

Immunity can send Slack notifications for unusual traffic, using a Slack webhook to post messages to a Slack workspace. To obtain a webhook URL, use the steps in this topic.


## Create a New Slack App

1. [Create a new slack app](https://api.slack.com/apps?new_app=1) and save the webhook address.

2. Enable the incoming webhook in your app.

3. After submitting the app creation form, you are redirected to your newly created app’s page. In **Add features and functionality**, click on **Incoming webhooks** to enable them.

4. Change the OFF switch to **ON**.

5. Click **Add new webhook to workspace**. You are redirected to a page where you can select the channel where the webhook will post messages.

6. Select the channel and click **authorize**.


## Adding a Slack Configuration

To add your first Slack configuration:

1. Copy the webhook URL that you just created with your app (when you finished the Slack app creation, you should have been directed to a page where you could copy the webhook URL).

2. Create a POST request to `/notifications/slack/config` with an endpoint parameter equal to the webhook URL. For example, using cURL:

```bash
curl -d '{"endpoint":"www.your-slack-webhook.com"} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config
```
You have now successfully connected your Slack channel to Immunity and all alerts will notify you.

## Routing Different Alerts to Different Slack Channels

Immunity will send alerts to all Slack channels you ask it too. You can even restrict the type of alerts that go to a channel with additional parameters in your POST request.

To do so, the `/notifications/slack/config` endpoint takes these parameters on POST:

* `endpoint`: The endpoint that you would like the current POST request rule you're setting to apply to.
* `kong_entity`: Restricts notifications set to the endpoint to only those arising from the `service_id`, `route_id`, or workspace name specified here.
* `severity`: Will route only alerts with severity specified to the endpoint. Severity values can be one of "low", "medium", "high".
* `alert_type`: Will route only alerts.
* `enable`: When set to False, the rule in the POST request is disabled, meaning Immunity ignores that configuration rule. When set to True, the rule in enabled and Immunity routes traffic according to the full request rule. This parameter is set to True by default in all POST requests.

When you send a POST request with only the endpoint parameter specified (like the one above), Immunity routes all traffic to that endpoint. Once a more specific POST request is made with more parameters filled, for example:

```bash
curl -d '{"endpoint":"www.your-slack-webhook.com", "severity": "high"} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config
```

Immunity will no longer route all traffic to [www.your-slack-webhook.com](http://www.your-slack-webhook.com/), and only route alerts at high severity to [www.your-slack-webhook.com](http://www.your-slack-webhook.com/).


You can set multiple rules of varying specificity for the same endpoint. For example, let's say you want [www.your-slack-webhook.com](http://www.your-slack-webhook.com/) to show notifications on all alerts from `service_id = "my-service-1-id"` and only high-severity alerts on `route_id = "my-route-1-id"`, you can do so with two POST requests:

```bash
curl -d '{"endpoint":"www.your-slack-webhook.com", "kong_entity": "my-service-1-id"} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config


curl -d '{"endpoint":"www.your-slack-webhook.com", "severity": "high", \
 "kong_entity": "my-route-1-id"} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config
```

Once one specific Slack configuration rule is created for a given Slack endpoint, Immunity considers all following configuration rules as additive, meaning that each new rule will add more.

## Viewing Configured Rules

To view all the Slack rules and Slack you have configured, make a GET request to `/notifications/slack/config` like this:

```bash
curl -X GET http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config
```

This request returns a JSON object where each key is an endpoint configured. Its value are the rules configured in a tree-like structure with a boolean at the leaf of the tree indicating whether that rule is enabled or not. For the multi-config example we made above for [www.your-slack-webhook.com](http://www.your-slack-webhook.com/), the returned GET object will look like:

```json
{
  "www.your-slack-webhook.com": {
    "kong_entities": {
      "my-service-1-id": true,
      "my-route-1-id": {
        "severities": {
          "high": true
        }
      }
    }
  }
}
```

## Disabling a Rule

You might want to temporarily disable a rule you created. No problem, simply make the same POST request to /notifications/slack/config and add or change the enable parameter to false. Using the same example from above, let's set the configuration on [www.your-slack-webhook.com](http://www.your-slack-webhook.com/) on `my-service-1-id` to false.

```bash
curl -d '{"endpoint":"www.your-slack-webhook.com",
 "kong_entity": "my-service-1-id",
 "enable": false} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config
```

**Important:** When disabling a rule, use the exact same specification parameter values (`kong_entity`, `severity`, and `alert_type`) that were used to create the rule.

## Deleting a Rule

Sometimes you may want to delete a rule. Functionally, this is the same as disabling a rule in the sense that notifications will no longer be sent as the deleted or disabled rule specified. To delete a configuration rule, send a DELETE request to `/notifications/slack/config`, and just like with disabling rules, make sure you're passing the correct values to the configuration specifying parameters (`kong_entity`, `severity`, and `alert_type`). With the same example from above that disabled the config rule for `my-service-1-id`, a DELETE would look like:

```bash
curl -d '{"endpoint":"www.your-slack-webhook.com",
 "kong_entity": "my-service-1-id"} \
 -H "Content-Type: application/json" \
 -X DELETE http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config
```
