---
title: Immunity Alerts
---

### Introduction

Immunity is working behind the scenes to monitor all the traffic that comes through Kong.  When it sees an anomaly, Immunity will send alerts to Kong Manager which can be found on Service Map and the Alerts page.  These alerts are built to signal the health of your microservices system and will help pinpoint which endpoints are struggling.


### Prerequisites
* Kong Enterprise installed and configured
* Kong Collector Plugin installed and configured
* Kong Collector App installed and configured


For more information, see the [Kong Brain and Kong Immunity Installation and Configuration Guide](/enterprise/{{page.kong_version}}/brain-immunity/install-configure).


### Immunity Model Training

Immunity automatically starts training its models once it is up and running and receiving data. Immunity will create a unique model for every unique endpoint + method combination it sees in incoming traffic. For example, if you have an endpoint [www.test-website.com/buy](http://www.test-website.com/buy) and traffic comes in with both GET and POST requests for that endpoint, Immunity will create two models one for the endpoint + GET traffic and one for the endpoint + POST traffic.


Our first model version gets created after the first hour and will continuously retrain itself for the first week to provide the best model possible. After that, every week all models retrain with a week of data.


We also provide clients an endpoint to retrigger training themselves. We recommend retraining when the context of your app is expected to change a lot. For example, maybe there is an upcoming app release that will change several endpoints. If this is the case, one can POST to `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/resettrainer` to start the training cycle all over again.


Let’s say you’d like slightly more control over the data your model sees, for example perhaps you know that weekend data is not particularly useful for model building because weekends are normally outliers that your team is prepared for. You can trigger model training for all models with a specified time period of data. Simply POST to `http://<BRAIN_HOST>:<COLLECTOR_PORT>/trainer`, with the start and end time of data you’d like included in training like this:

```
curl -d '{"start":"2019-01-08 10:00:00", "end":"2019-01-09 23:30:00"}' \
 -H "Content-Type: application/json" \
 -X POST http://<BRAIN_HOST>:<COLLECTOR_PORT>/trainer
```
or, in the browser like this:

```
http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer?start=&end=
```
** datetime value format: YYYY-MM-DD HH:mm:ss


Additionally, you can specify the kong service_id or route_id of the urls you would like trained using the kong_entity parameter. Immunity would then only train urls associated with the ID provided, and with the data specified by the start and end dates.

```
curl -d '{"start":"2019-01-08 10:00:00", "end":"2019-01-09 23:30:00", "kong_entity":"2beff163-061d-43ad-8d87-8f40d10805ba"}' \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer
```

### Checking Models Trained

Only endpoints + method combinations that have a model trained can be monitored for alerts. If you want to check which endpoints have models, you can use `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/monitoredendpoints` which will give back a list of all models in the system. Each item in this list contains the following identifying information for the model:



* `base_url`: The url of the traffic used to train the model.
* `method`: The method of the traffic used to train the model.
* `route_id`: The Kong route_id that the traffic used to train the model is associated with. **service_id**: The Kong service_id that the traffic used to train the model is associated with. **model_version_id**: The model version number of the current, active model.
* `active_models`: A json object containing information on the active status of each of the 6 core alert types in Immunity (unknown_parameters, abnormal_value, latency, traffic, status codes, and value_type).



In this object, the value is a specific alert type and the value is a boolean value where True indicates that the model is actively monitoring for that alert type.


In general, if a endpoint + method combination model does not appear on the returned object from `/monitoredendpoints`, this is likely because not enough traffic has been seen by Immunity to build a reliable model.

### Configure Auto-Training

#### Restarting Training Schedules

Immunity automatically sets up training jobs when it first starts up, and retrains all models on an optimized schedule based on time since data started flowing through Immunity. If you have experienced large changes in the type of data you expect to be coming through Immunity and do not feel comfortable choosing an "optimal" time period to use for retraining with the /trainer endpoint, you can re-trigger Immunity's auto-training by posting to the /trainer/reset endpoint. Immunity will then recreate its retraining schedule as if it was just being started and newly ingesting data.

```
curl -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer/reset
```

#### Configuring Auto-Training Rules

For best use, Immunity retrains on a regular basis. If you do not feel like you need to retrain your models regularly and are happy with the current model you have now, you can stop auto retraining via post request to the /trainer/config endpoint. This endpoint takes these parameters:



* `kong_entity`: The route_id or service_id that you would like to turn on or off auto-training.
* `method`: One of values: GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE. Specifying a method will restrict the rule being made on auto-training to only traffic matching the method specified. When this value is null, all traffic from all methods will be included in the rule.
* `enable`: True or False, where true means auto-training is on and false means auto-training is off for the `kong_entity` specified.



You can turn off auto-training for a particular route or service via curl request like this:

```
curl -d '{"kong_entity":"your-route-id", "enable":false}' \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer/config
```

Similarly, if you turned off auto-training for a route and feel like turning it back on, you can post to /trainer/config with enable = true.


These configurations will only apply to training started by Immunity's auto-training schedule. Other training requests made by /trainer won't be affected by this configuration.

#### Viewing Configuration Rules

To see all of your configured training rules, just create a get request to /trainer/config like this:

```
curl -X GET http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer/config
```

A list of all your rules will be returned, where `kong_entity` refers to the `service_id` or `route_id` the rule applies to, and enabled is a true or false value.

#### Resetting or Deleting Configured Rules

To delete a single auto-train rule that you created, you can send a delete request to /trainer/config with a `kong_entity` parameter and value of the `service_id` or `route_id` of the rule you would like to delete.

```
curl -d '{"kong_entity":"your-route-id"}' \
 -H "Content-Type: application/json" \
 -X DELETE http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer/config
```

Without a rule established, Immunity will default to auto-training. In other words, once you delete a configured rule, Immunity will continue or start auto-training on the route or service of the deleted rule.


If you would like to delete all the configurations you create, you can do so by sending an empty DELETE request to /trainer/config like this:

```
curl -X http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer/config
```

### Immunity Generated Alerts

Immunity evaluates your traffic every minute, and creates an alert when an anomalous event is detected.

#### Types of Generated Alerts

Immunity is monitoring different types of data points in all traffic coming through Kong. Alerts generated will be based on these data points. Here are the alert types of violations Immunity is looking for:
* `value_type`: These alerts are triggered when incoming requests have a value to a parameter of a different type (such as Int instead of Str) than seen historically.
* `unknown_parameter`: These alerts are triggered when requests include parameters not seen before.
* `abnormal_value`: These alerts are triggered when requests contain values abnormal to historical values seen paired with its parameter.
* `latency_ms`: These alerts are triggered when incoming requests are significantly slower than historical records.
* `traffic`: These alerts are triggered when Immunity sees a rise on 4XX and 5XX codes for incoming traffic, or when the overall traffic experiences an abnormal spike or dip.
* `statuscode`: When the proportion of 4XX or 5XX codes is increasing, regardless of traffic volume

#### Retrieving Generated Alerts

You can monitor the created alerts by running the following commands:

```
curl -d '{"start":"2019-01-08 10:00:00", "end":"2019-01-09 23:30:00"}' \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts
```

Or, you can access the alerts via browser, passing in the end and start values as parameters like this:

```
http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts?start=2019-01-01 00:00:00&end=2019-01-02 00:00:00
```

The /alerts endpoint takes these parameters and you can mix and match them to your monitoring needs:
* `start and end`: Returns only alerts generated between the values in start and end parameters passed.
* `alert_type`: Returns only alerts of the alert_type in specified in alert_type parameter. This parameter does not accept lists of alert types. The value passed must be one of [‘query_params’, ‘statuscode’, ‘latency_ms’, ‘traffic’]
* `url`: Returns only the alerts associated with the endpoint specified with url parameter.
* `method`: Returns only alerts with the method specified. Must be one of these values: GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, or TRACE. Full capitalization is necessary.
* `workspace_name`: The name of the Kong workspace for the alerts you want returned.
* `route_id`: The Kong Route id for the alerts you want returned
* `service_id`: The Kong Service id for the alerts you want returned
* `system_restored`: A true/false value indicated you only want returned alerts where the system_restored value is matching the boolean value passed into this parameter.
* `severity`: One of "low", "medium", "high" which will restrict returned alerts of severities matching the value provided with this parameter.

#### Alerts Object

Two types of data are returned by the /alerts endpoint. The first is a list of the alerts generated, which are structured like this:
* `id`: The alert_id of the alert.
* `detected_at`: The time in which the generated alert was detected at. This time also correlates with the last time point in the data time series that generated this alert. For example, if the alert was generated on data from 1:00 pm to 1:01 pm, then the detected_at time would correspond with the most recent time point of 1:01 pm in the data used to make that alert.
* `detected_at_unix`: The time from detected_at expressed in unix time.
* `url`: The url who’s data generated this alert.
* `alert_type`: the type of alert generated, will be one of [‘query_params’, ‘statuscode’, ‘latency_ms’, ‘traffic’]
* `summary`: The summary of the alert generated, includes a description of the anomalous event for clarity.
* `system_restored`: This parameter takes True or False as a value, and will return notifications where the anomalous event’s system_restored status matches the value passed in the parameter.
* `severity`: The severity level of this alert, values within [low, medium, high].

#### Alerts Metadata

The second type of data returned is alerts metadata which describes the overall count of alerts and breaks down counts by alert type, severity, system_restored, and filtered_total.

### Configure Alert Severity

#### Severity-Levels

Alerts can be classified on 4-severity levels:
* `low`: The low severity classification denotes the least important alerts to the user. While the user ultimately decides what a low severity means to them, we recommend that low severity indicates an alert that you'd want to look at eventually, but not right away. It's an alert you wouldn't wake up at 2 am to fix but something you'll find useful down the road maybe with planning or minor bug fixing.
* `medium`: A medium severity classification denotes a mid-level important alert to the user. We think of this level as not something you'd want to wake up at 2 am to fix, but not so unimportant that you would wait till sprint planning prep to address. This is a level where you'll likely address it within the sprint or couple of days following it coming up.
* `high`: A high severity classification is the highest severity level of alert. These are the alerts that you want to be woken up for in the middle of the night, the alert who's ping means all hands on deck.
* `ignored`: Alerts that are designated as ignored are not surfaced in the Kong Manager, slack alerts, nor /alerts endpoint. For the later, ignored relates will be returned when explicitly asked for via /alerts parameter "severity".

#### Immunity Default Severities

Immunity provides default severity levels based on the alert type, and these defaults are:

* `value_type`: low
* `unknown_parameter`: low
* `latency_ms`: high
* `traffic`: medium
* `statuscode`: high

#### Creating or Updated New Rules

Of course, we think you know your system best and you can adjust the severities of your alerts to varying degrees of specificity. Users of Immunity will be able to configure alert severity on alert type, kong `route_id` or `service_id`, or any combination of the two.

For example, if you decide that for your system, `unknown_parameter` alerts are always system-breaking you can set the severity configuration for `unknown_parameter` alerts to high. Let's say after doing so, you find that while usually an unknown_parameter alert is what you consider high-severity, there's one route where it's actually more of a medium. You can then specify a medium severity for `unknown_parameter` alerts generated only on that route and preserve the high-severity setting for the rest of `unknown_parameters` for the rest of your system.


To set a severity configuration on alerts, Immunity provides a /alerts/config endpoint. Posting to /alerts/config will create a new configuration, and requires these parameters:

* `workspace_name`: The workspace name of the workspace that the configuration will be applied to.  This parameter is required for proper functioning of the endpont.
* `severity`: the severity you want this rule to make, must be one of ['low', 'medium', 'high', 'ignored']. No other severity options will be accepted.

Optional parameters for greater specificity are:

* `alert_type`: one of the alert types from ['traffic', 'value_type', 'unknown_parameter', 'latency_ms', 'traffic', 'statuscode']. When this parameter is not passed, the created configuration will apply to all alert_types.
* `route_id`: the route_id for the entity you want to create the configuration for. If you make a configuration for a route, do not pass the service_id parameter with your request.
* `service_id`: the service_id for the entity you want to create the configuration for.
* `method`: the method of the service or route that you want to create the configuration for. When this parameter is not passed, the resulting configuration will apply to all methods.

Some restrictions: If you want to set a severity configuration for a route, provide just the route_id and not the service_id.

In the example above, to set the first alert type wide rule for all `unknown_parameter` alerts in your system, you would pass `unknown_parameter` to the `alert_name` parameter and null to the `kong_entity` parameter. Here's an example of what that curl would look like:

```
curl -d '{"alert_name":"unknown_parameter", "kong_entity":null, "severity": "high"}' \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts/config
```

To add that second rule for `unknown_parameter` alerts only coming from a specific route, you'd make a request like this:

```
curl -d '{"alert_name":"unknown_parameter", "kong_entity":"your-route-id", "severity": "medium"}' \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts/config
```

When determining which severity to assign, Immunity will look for your configurations and default to the configuration that's "most specific" to the alert in question. Immunity thinks of alert configuration specification like this (in order from most specific configuration to least specific configuration):

* kong `route_id` + `alert_name` combo
* kong `service_id` + `alert_name` combo
* `route_id`
* `service_id`
* `alert_name`
* Immunity `alert_name` defaults



When you hit the /alerts endpoint, for each alert, Immunity will first look for a rule specifying a severity for that route's kong `route_id` and `alert_name`. If it doesn't find a severity configuration, it moves down the list above until it returns the Immunity defaults for the alert's alert type.

#### Removing Alert Severity Rule

You can remove alert-severity configuration rules by sending a delete request to /alerts/config. This endpoint takes these parameters:
* `kong_entity`: The kong_entity of the rule you want deleted, or null for alert type rules.
* `alert_name`: The alert type of the rule you wanted deleted, or null for a `kong_entity` rule you want deleted.

```
curl -d '{"alert_name":"unknown_parameter", "kong_entity":"your-route-id"}' \
 -H "Content-Type: application/json" \
 -X DELETE http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts/config
```

If you want to delete all configuration rules, you can by passing null values for both `kong_entity` and `alert_name` in your request. If you pass null for both `kong_entity` and `alert_name` parameters, all configurations will be deleted, like this:

```
curl -d '{"alert_name":null, "kong_entity":null}' \
 -H "Content-Type: application/json" \
 -X DELETE http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts/config
```

#### Seeing-Alert-Severity-Configuration

To see what rules you already have made, make a get request to /alerts/config to see all the rules like this:

```
curl -X GET http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts/config
```

In return you'll get back a json like this, where each row is a configuration rule:

```json
[
  {"alert_name": null, "kong_entity": "route-id-1", "severity": "low"},
  {"alert_name": "traffic", "kong_entity": null, "severity": "high"},
  {"alert_name": "value_type", "kong_entity": "route-id-2", "severity": "medium"}
]
```

Any kong entity plus alert type rule will be represented by a json object with both `alert_name` and `kong_entity` are not null. In the example above, that would be
```json
{"alert_name": "value_type", "kong_entity": "route-id-2", "severity": "medium"}
```

An alert type wide rule will be represented by an json object where the `alert_name` is not null but the `kong_entity` is, like
```json
{"alert_name": "traffic", "kong_entity": null, "severity": "high"}
```

A kong entity wide rule is the reverse with a json object that has a non-null `kong_entity` value but a null `alert_name` value like
```json
{"alert_name": null, "kong_entity": "route-id-1", "severity": "low"}
```

#### Looking at Offending Hars

For value_type, unknown_parameter, and abnormal_value alerts, you can retrieve the hars that created those alerts via the `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/hars` endpoint. This endpoint accepts `alert_id` and/or `har_id` as parameters and returns hars related to the parameters sent. You must specify one of these two parameters to receive hars on the `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/hars` endpoint.
These are the parameters `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/hars` accepts:


* `alert_id`: The id of the alert related to the hars you'd like to inspect. This parameter only accepts one alert_id at a time (no lists).
* `har_ids`: A list of har_ids you want returned.


The response will include these values:
* `har_id`: The har id of the har returned
* `alert_id`: The alert_id of the alert_returned.
* `har`: The full har for the request that generated that har.


Here's an example using curl:

```
curl -d '{"alert_id":1} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/hars
```

Here's an example using the browser

```
http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/hars?alert_id=1
```

### Alert Slack Integration

If you choose, Immunity can send Slack notifications for unusual traffic. Immunity needs a Slack webhook to post messages to a Slack workspace. In order to obtain a webhook URL, do the following:

#### Create a new Slack app

First, [Create a new slack app](https://api.slack.com/apps?new_app=1) and save the webhook address.

Then, enable incoming webhook in your app. After submitting the app creation form you are redirected to your newly created app’s page. In “Add features and functionality” click on “Incoming webhooks” to enable them.
Change the OFF switch to ON. That will make visible a button “Add new webhook to workspace”, click on it.


That will redirect you to a page where you can select the channel the webhook will post messages. Select the channel and click in authorize.


#### Adding a Slack Configuration

To add your first Slack configuration, copy the webhook URL that you just created with your app (when you finished the Slack app creation, you should have been directed to a page where you could copy the webhook URL). Then, simply create a POST request to /notifications/slack/config with an endpoint parameter equal to the webhook URL. Here's an example via curl:

```
curl -d '{"endpoint":"www.your-slack-webhook.com"} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config
```

Now, you've successfully connected your Slack channel to Immunity and all alerts will notify you.

#### Routing Different Alerts to Different Slack Channels

Immunity will send alerts to all Slack channels you ask it too. You can even restrict the type of alerts that go to a channel with additional parameters in your POST request. To do so, the /notifications/slack/config endpoint takes these parameters on POST:


* `endpoint`: The endpoint that you would like the current POST request rule you're setting to apply to.
* `kong_entity`: Will restrict notifications set to the endpoint to only those arising from the service_id, route_id, or workspace name specified here.
* `severity`: Will route only alerts with severity specified to the endpoint. Severity values can be one of "low", "medium", "high".
* `alert_type`: Will route only alerts.
* `enable`: When set to False, the rule in the POST request is disabled, meaning Immunity will ignore that configuration rule. When set to True, the rule in enabled and Immunity will route traffic according to the full request rule. This parameter is set to True by default in all POST requests.


When you send a POST request with only the endpoint parameter specified (like the one we did above), Immunity will route all traffic to that endpoint. Once a more specific POST request is made with more parameters filled, for example:

```
curl -d '{"endpoint":"www.your-slack-webhook.com", "severity": "high"} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config
```

Immunity will no longer route all traffic to [www.your-slack-webhook.com](http://www.your-slack-webhook.com/), and only route alerts at high severity to [www.your-slack-webhook.com](http://www.your-slack-webhook.com/).


You can set multiple rules of varying specificity for the same endpoint. For example, let's say you want [www.your-slack-webhook.com](http://www.your-slack-webhook.com/) to show notifications on all alerts from `service_id = "my-service-1-id"` and only high-severity alerts on `route_id = "my-route-1-id"`, you can do so with two post requests:

```
curl -d '{"endpoint":"www.your-slack-webhook.com", "kong_entity": "my-service-1-id"} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config


curl -d '{"endpoint":"www.your-slack-webhook.com", "severity": "high", \
 "kong_entity": "my-route-1-id"} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config
```

Once one specific Slack configuration rule is created for a given Slack endpoint, Immunity considers all following configuration rules as "additive", meaning that each new rule will add more.

#### Seeing your configured Rules

Configured rules can get complicated. To see all the slack rules and slack urls you have configured, make a GET request to /notifications/slack/config like this:

```
curl -X GET http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config
```

Which will return a json object where each key is an endpoint configured its value are the rules configured in a tree like structure with a boolean at the leaf of the tree indicating whether that rule is enabled or not. For the multi-config example we made above for [www.your-slack-webhook.com](http://www.your-slack-webhook.com/), the returned GET object will look like:

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

#### Disabling a Rule

You might want to temporarily disable a rule you created. No problem, simply make the same POST request to /notifications/slack/config and add or change the enable parameter to false. Using the same example from above, let's set the configuration on [www.your-slack-webhook.com](http://www.your-slack-webhook.com/) on `my-service-1-id` to false.

```
curl -d '{"endpoint":"www.your-slack-webhook.com",
 "kong_entity": "my-service-1-id",
 "enable": false} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config
```

It's important when disabling a rule to use the exact same specification parameter values (kong_entity, severity, and alert_type) that were used to create the rule.

### Deleting a Rule

Sometimes you want to delete a rule. Functionally this is the same as disabling a rule in the sense that notifications will no longer be sent as the deleted or disabled rule specified. To delete a configuration rule, send a DELETE request to /notifications/slack/config, and just like with disabling rules, make sure you're passing the correct values to the configuration specifying parameters (kong_entity, severity, and alert_type). With the same example from above that disabled the config rule for `my-service-1-id`, a DELETE would look like:

```
curl -d '{"endpoint":"www.your-slack-webhook.com",
 "kong_entity": "my-service-1-id"} \
 -H "Content-Type: application/json" \
 -X DELETE http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/notifications/slack/config
```

### Clean Up the Data

Collector will clean the amount of HARs stored daily up to the max number of hars specified in the environment variable `MAX_HARS_STORAGE` and tables with extracted information to a max of two weeks of data. This means that at any day, the max number of HARs stored is the `MAX_HARS_STORAGE` + days_incoming_number_of_hars. If no `MAX_HARS_STORAGE` is specified, collector defaults to keeping 2 million hars in the database.


You can set your own value of `MAX_HARS_STORAGE` by setting the app environment variable through whatever means you've been deploying collector.


Additionally, collector provides an endpoint to delete the HARs data at /clean-hars. This endpoint accepts get and post and takes one parameter `max_hars_storage` which will delete all hars until only the value passed with `max_hars_storage` remains and contains the most recent HARs added to the database. If no value is passed to `max_hars_storage`, it will clean the database to the default value set with the environment variable `MAX_HARS_STORAGE`. An example of using this endpoint with curl looks like this:

```
curl -d '{"max_hars_storage":10000} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/clean-hars
```
