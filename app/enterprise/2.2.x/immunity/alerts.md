---
title: Immunity Alerts
toc: true
redirect_from:
  - /enterprise/2.2.x/brain-immunity/alerts
---

### Introduction

Immunity monitors all traffic that flows through Kong Enterprise. When an anomaly is detected, Immunity sends an alert to Kong Manager and displays on the Alerts dashboard. Alerts are built to signal the health of your microservices system and help pinpoint which endpoints are struggling.  

### Alerts Dashboard
Use the Alerts Dashboard in Kong Manager to view and manage alerts. When an alert is generated, it is automatically added to the Alerts Dashboard. The dashboard gives a high-level overview of identified alerts, including severity level, event type, status, and details about the alert. Click an alert to drill down into more details to further investigate the issue.

### Types of Alerts
Immunity evaluates your traffic every minute and creates an alert when it detects an anomalous event on either of two entity types: endpoint traffic or consumer traffic.

* `Endpoint alerts` are generated from traffic belonging to one specific endpoint, for example, `GET www.testendpoint/start`.
* `Consumer alerts` are generated from any traffic in a Workspace belonging to a registered Kong consumer. This traffic is identified by the consumer ID.

#### Alert Events
Dependent on the entity type, being an endpoint or consumer, Immunity creates an alert and identifies them as one of the following event types:
* `value_type` alerts are triggered when incoming requests have a parameter value of a different type than is historically seen (such as Int instead of Str). Default severity level: Low.
* `unknown_parameter` alerts are triggered when requests include parameters not seen before. Default severity level: Low.
* `abnormal_value` alerts are triggered when requests contain values different from historical values seen paired with its parameter. Default severity level: Medium.
* `traffic` alerts are triggered when Immunity sees a rise in 4XX and 5XX error codes for incoming traffic, or when the overall traffic has an abnormal spike or dip. Default severity level: Medium.
* `latency_ms` alerts are triggered when incoming requests are significantly slower than historical records. Default severity level: High.
* `statuscode` alerts are triggered when the proportion of 4XX or 5XX error codes is increasing, regardless of traffic volume. Default severity level: High.

### Alert Severity Levels
Alerts are classified with four severity levels:
* **Low**: A low severity classification denotes the least important alerts. While you decide what a low severity means, we recommend that low severity indicates an alert that you want to review at a later time.
* **Medium**: A medium severity classification denotes a mid-level important alert. This level is an alert level you will likely address within the sprint.
* **High**: A high severity classification is the highest severity level alert. High alerts need to be addressed immediately and should be fixed as soon as possible.
* **Ignored**: Alerts that are designated as ignored are not surfaced in the Kong Manager, Slack alerts, or /alerts endpoint.


### Retrieving Generated Alerts
Monitor generated alerts using the following commands:

```bash
curl -d '{"start":"2020-01-08 10:00:00", "end":"2020-01-09 23:30:00"}' \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts
```

Or, access the alerts using a browser, using the ‘start and end’ values as parameters:

```bash
http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts?start=2020-01-01 00:00:00&end=2020-01-02 00:00:00
```

#### Alert Endpoint Parameters
The ‘/alerts’ endpoint uses the following parameters, which you can mix and match according to your monitoring needs:
* `start and end`: Returns only alerts generated between the values in start and end parameters passed.
* `alert_type`: Returns only alerts of the alert_type specified in the alert_type parameter. This parameter does not accept lists of alert types. The value passed must be one of [‘query_params’, ‘statuscode’, ‘latency_ms’, ‘traffic’]
* `url`: Returns only the alerts associated with the endpoint specified with URL parameter.
* `method`: Returns only alerts with the method specified. Must be one of these values: GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, or TRACE. Full capitalization is necessary.
* `workspace_id`: The ID of the Kong Workspace for the alerts you want returned.
* `route_id`: The Kong Route ID for the alerts you want returned.
* `service_id`: The Kong Service ID for the alerts you want returned.
* `system_restored`: A true/false value indicates you only want returned alerts where the system_restored value is matching the boolean value passed into this parameter.
* `severity`: One of "low", "medium", "high" which will restricts returned alerts of severities matching the value provided with this parameter.

#### Alert Objects
Two types of data are returned by the ‘/alerts’ endpoint: a list of generated alerts and alerts metadata.

##### List of Generated Alerts
The first is a list of the alerts generated, which are structured like this:
* `id`: The alert_id of the alert.
* `detected_at`: The time when the generated alert was detected. This time also correlates with the last time point in the data time series that generated this alert. For example, if the alert was generated on data from 1:00 pm to 1:01 pm, then the detected_at time corresponds with the most recent time point of 1:01 pm in the data used to make the alert.
* `detected_at_unix`: The time from detected_at expressed in Unix time.
* `url`: The URL that generated this alert.
* `alert_type`: The type of alert generated, will be one of [‘query_params’, ‘statuscode’, ‘latency_ms’, ‘traffic’].
* `summary`: The summary of the alert generated, includes a description of the anomalous event for clarity.
* `system_restored`: This parameter takes True or False as a value, and returns notifications where the anomalous event’s system_restored status matches the value passed in the parameter.
* `severity`: The severity level of this alert, values of [low, medium, high].

##### Alert Metadata
The second type of data returned is alerts metadata which describes the overall count of alerts and breaks down counts by alert type, severity, system_restored, and filtered_total.


### Configure Alert Severity

#### Creating or Updating Alert Severity Rules

Depending on your system needs, you can adjust the severities of your alerts to varying degrees of specificity. You can configure alert severity on alert type, kong `route_id` or `service_id`, or any combination of the two.

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

In the example above, to set the first alert type wide rule for all `unknown_parameter` alerts in your system, you would pass `unknown_parameter` to the `alert_name` parameter and null to the `kong_entity` parameter. Here's an example of what that cURL would look like:

```bash
curl -d '{"alert_name":"unknown_parameter", "kong_entity":null, "severity": "high"}' \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts/config
```

To add that second rule for `unknown_parameter` alerts only coming from a specific route, you'd make a request like this:

```bash
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

```bash
curl -d '{"alert_name":"unknown_parameter", "kong_entity":"your-route-id"}' \
 -H "Content-Type: application/json" \
 -X DELETE http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts/config
```

If you want to delete all configuration rules, you can by passing null values for both `kong_entity` and `alert_name` in your request. If you pass null for both `kong_entity` and `alert_name` parameters, all configurations will be deleted, like this:

```bash
curl -d '{"alert_name":null, "kong_entity":null}' \
 -H "Content-Type: application/json" \
 -X DELETE http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts/config
```

#### Viewing Alert Severity Configuration
To view the rules you already have configured, enter a get request to /alerts/config to view all the rules:

```bash
curl -X GET http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/alerts/config
```

In return, you'll get back a JSON like this, where each row is a configuration rule:

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

#### Reviewing High Value Information Alerts (HARS)
For value_type, unknown_parameter, and abnormal_value alerts, you can retrieve the HARS that created those alerts via the `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/hars` endpoint. This endpoint accepts `alert_id` and/or `har_id` as parameters and returns HARS related to the parameters sent. You must specify one of these two parameters to receive HARS on the `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/hars` endpoint.
These are the parameters `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/hars` accepts:

* `alert_id`: The id of the alert related to the HARS you'd like to inspect. This parameter only accepts one alert_id at a time (no lists).
* `har_ids`: A list of har_ids you want returned.

The response will include these values:
* `har_id`: The har id of the har returned
* `alert_id`: The alert_id of the alert_returned.
* `har`: The full har for the request that generated that har.

Here's an example using cURL:
```bash
curl -d '{"alert_id":1} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/hars
```

Here's an example using the browser
```bash
http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/hars?alert_id=1
```

### Cleaning HARS Database
Collector cleans the amount of HARS stored daily up to the max number of HARs specified in the environment variable `MAX_HARS_STORAGE` and tables with extracted information to a max of two weeks of data. This means that at any day, the max number of HARs stored is the `MAX_HARS_STORAGE` + days_incoming_number_of_hars. If no `MAX_HARS_STORAGE` is specified, Collector defaults to keeping two million HARS in the database.

You can set your own value of `MAX_HARS_STORAGE` by setting the app environment variable through whatever means you have been deploying Collector.

Additionally, Collector provides an endpoint to delete the HARs data at /clean-hars. This endpoint accepts GET and POST and takes one parameter `max_hars_storage` which will delete all HARS until only the value passed with `max_hars_storage` remains and contains the most recent HARs added to the database. If no value is passed to `max_hars_storage`, it will clean the database to the default value set with the environment variable `MAX_HARS_STORAGE`. An example of using this endpoint with cURL looks like this:

```bash
curl -d '{"max_hars_storage":10000} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/clean-hars
```
