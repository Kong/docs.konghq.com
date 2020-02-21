---
title: Kong Brain & Kong Immunity Installation and Configuration Guide
---


**Kong Brain** and **Kong Immunity** help automate the entire API and service development life cycle. By automating processes for configuration, traffic analysis and the creation of documentation, Kong Brain and Kong Immunity help organizations improve efficiency, governance, reliability and security. Kong Brain automates API and service documentation and Kong Immunity uses advanced machine learning to analyze traffic patterns to diagnose and improve security.

When you purchase Kong Brain and/or Kong Immunity, you obtain both add-ons together or individually:
* Kong Brain and Kong Immunity
* Kong Brain
* Kong Immunity

![Kong Brain and Kong Immunity](https://doc-assets.konghq.com/1.3/brain_immunity/KongBrainImmunity_overview.png)

This guide provides information about how to install, configure, and use Kong Brain and/or Kong Immunity and its components on Kong Enterprise. Sections in this guide include:

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Configure the Collector App and Collector Plugin](#configure-the-collector-app-and-collector-plugin)
- [Monitor the Collector](#monitor-the-collector)
- [Using Kong Brain](#using-kong-brain)
- [Using Kong Immunity](#using-kong-immunity)

### Overview
Kong Brain and Kong Immunity are installed as add-ons on Kong Enterprise, using a Collector App and a Collector Plugin to communicate with Kong Enterprise. The diagram illustrates how the Kong components work together, and are described below:
* **Kong Enterprise**
* **Kong Brain** (Brain) and/or **Kong Immunity** (Immunity) add-ons, according to your purchase.
* **Collector App** enables communication between Kong Enterprise and Brain and/or Immunity. The Kong Collector App comes with your purchase of Bran and/or Immunity.
* **Collector Plugin** enables communication between Kong Enterprise and Kong Collector App.  The Kong Collector Plugin comes with your purchase of Brain and/or Immunity.

### Prerequisites
Prerequisites for installing and configuring Brain and/or Immunity with Kong Enterprise include:
* **Kong Enterprise** version 0.35.3+ or later, with a minimum of one Kong node and a working datastore (PostgreSQL).
* Access to a platform for the Collector App with Docker installed. This system must be networked to communicate with the Kong Enterprise system where you have the Collector Plugin installed.
* Access to Kong Bintray repository (https://bintray.com/kong), including your access credentials supplied by Kong. (BINTRAY_USERNAME, BINTRAY_API_KEY)
* Docker compose file of your purchased version of Brain and/or Immunity, which display in Bintray as one of the following:
   * kong/kong-brain-immunity-base
   * kong/kong-brain-base
   * kong/kong-immunity-base
* Redis instance, which is included with Brain and/or Immunity.
* Swagger, which is included with Brain and/or Immunity.

### Configure the Collector App and Collector Plugin
To enable Kong Brain (Brain) and/or Kong Immunity (Immunity), you must first configure the Collector App and the Collector Plugin. This includes:
* Deploying the Collector Plugin, which captures and sends traffic to the Collector App for data collection and processing.
* Deploying the Collector App on your Docker aware platform.
* Configuring the Collector Plugin and the Collector App to talk to each other.
* Testing the configuration to confirm everything is up and running.

Steps are:
- [Step 1. Set up the Collector App](#step-1-set-up-the-collector-app)
- [Step 2. Set up the Collector Plugin](#step-2-set-up-the-collector-plugin)
- [Step 3: Set up with Docker Compose](#step-3-set-up-with-docker-compose)
- [Step 4. (Optional) Opt-Out of HAR Redaction](#step-4-advanced-configuration-opt-out-of-har-redaction)
- [Step 5. (Optional) Using a different Redis instance](#step-5-using-a-different-redis-instances-optional)
- [Step 6. Confirm the Collector App is working](#step-6-confirm-the-collector-app-is-working)


#### Step 1. Set up the Collector App
Access release-script files to run and install Brain and/or Immunity from Bintray.
**Note:** You should receive your Bintray credentials with your purchase of Kong Enterprise. If you need Bintray credentials, contact from **Kong Support**.
1. Log in to **Bintray** and retrieve your BINTRAY_USERNAME and BINTRAY_API_KEY.
2. Click your **username** to get the dropdown menu.
3. Click **Edit Profile** to get your BINTRAY_USERNAME.
4. Click **API Key** to get your BINTRAY_API_KEY.

The release-scripts given are:
1. **docker-compose.yml** - sets up collector app
2. **with-db.yml** - creates postgres container that collector app will use if database instance not already provided.
3. **with-redis.yml** - creates redis instance that collector app will use if redis instance not already provided.


##### Docker login
To download the bintray you will first need to docker login to Bintray to the brain/immunity repo
```docker login -u BINTRAY_USERNAME -p BINTRAY_API_KEY kong-docker-kong-brain-immunity-base.bintray.io```

Also login to docker:
```docker login```
Then follow the login steps when prompted.

##### Bringing up Collector App with Redis and Db
To bring up the full Collector app with it's own database and redis, run:
```
KONG_HOST={KONG HOST URL} KONG_PORT={KONG PORT} KONG_MANAGER_PORT={KONG MANAGER PORT} KONG_MANAGER_URL={KONG MANAGER URL} docker-compose -f docker-compose.yml -f with-db.yml -f with-redis.yml up -d
```

##### Bringing up Collector App alone
If you already have an outside database and would not like to bring up Postgres with the collector up, first make sure you have a collector table in the database
```psql -U user -c "CREATE DATABASE collector;"```

If the postgres and redis instances are
Then you can bring up collector with:
```
SQLALCHEMY_DATABASE_URI=postgres://{POSTGRES-USER}:{POSTGRES-PASSWORD}@{POSTGRES HOST}:{POSTGRES POST}/collector CELERY_BROKER_URL={REDIS URI} docker-compose -f docker-compose.yml up -d
```

#### Step 2. Set up the Collector Plugin
Enable the Collector Plugin using the Admin API:

```
$ http --form POST http://<KONG_HOST>:8001/<workspace>/plugins name=collector config.service_token=foo config.host=<COLLECTOR_HOST> config.port=<COLLECTOR_PORT> config.https=false config.log_bodies=true
```

>(Optional) It is possible to set up the Collector Plugin to only be applied to specific routes or services, by adding `route.id=<ROUTE_ID>` or `service.id=<SERVICE_ID>` to the request.

```
$ http --form POST http://<KONG_HOST>:8001/<workspace>/plugins name=collector config.service_token=foo config.host=<COLLECTOR_HOST> config.port=<COLLECTOR_PORT> config.https=false config.log_bodies=true route.id=<ROUTE_ID>
```

* The port and host are configurable, but must match the Collector App.
* Confirm this step. Hit one of the URLs mapped through the Collector App. For example,
```
/<workspace name>/collector/alerts
```


#### Step 3: Set up with Docker Compose
>Note: Using Docker Compose is recommended to deploy Brain and Immunity, as documented in this guide. You can also use Docker Swarm or Kubernetes for deployment, although steps are not currently included in this guide.

The information you need to run the Collector App, Brain and/or Immunity is included in the docker-compose files. The steps in this section will start several Docker containers, including a collector, a worker, and a scheduler.

Kong provides a private Docker image that is used by the compose files. This image is distributed by Bintray, and the following is required for access:
* Your Bintray User ID
* Your Bintray API key
* A server where you want to run Brain and/or Immunity with Docker installed

Your Bintray credentials are provided to you with your purchase of Kong Enterprise. If you do not have these credentials, contact **Kong Support**.

1. SSH/PuTTY into your running instance where you want to install Brain and/or Immunity.

2. Log into Docker, and enter the repo you have access to. For example, ```kong-docker-kong-brain-immunity-base```.

```
docker login -u <BINTRAY_USERNAME> -p <BINTRAY_API_KEY> <enter your repo here>.bintray.io
```

3. Pull down the files for Docker Compose.

```
wget https://<BINTRAY_USERNAME>:<BINTRAY_API_KEY>@kong.bintray.com/<kong-brain-immunity-base>/docker-compose.zip
```
* If successful, you should see docker-compose.zip in your current directory.

4. Unzip the package into the directory of your choice.

5. Run Docker Compose using the files to start Brain and/or Immunity.

```
KONG_HOST=<KONG HOST> KONG_PORT=<8001> SQLALCHEMY_DATABASE_URI=<postgres://kong@localhost:5432/collector> docker-compose -f docker-compose.yml -f with-redis.yml up
```
* If successful, you should see `docker-compose.zip` in your current directory.

* Replace KONG_HOST and KONG_PORT with the host and port of your kong admin api
   * ```KONG_HOST```: the public IP address or Hostname of the system which is running Brain
   * ```KONG_PORT```: Usually 8001, but may be set otherwise
* You are adding A postgres database


#### Step 4. (Advanced Configuration) Opt-Out of HAR Redaction
**Note**: You must specifically opt-out, or turn off, HAR Redaction in order to store all of your data. The Default setting is to redact.

The Collector App default does not store body data values and attachments in traffic data. In the ```Har['postData']['text']``` field, all values are replaced with the value's type. This does not affect the performance of Brain or Immunity, however, this can impact your ability to investigate some Immunity related alerts by looking at the offending HARs that created those alerts.

If you want to store body data in the Collector App, you can do so by setting the Collector’s REDACT_BODY_DATA by updating the environment variable in docker-compose.yml or declaring it in your docker-compose up command as follows:

```
$ REDACT_BODY_DATA=False docker-compose -f docker-compose.yml -f with-redis.yml up
```


#### Step 5. Using a different Redis instance _(optional)_
To use your own instance of Redis instead of the one provided by the container, change the command to use your database, Redis, or both.

```
$ REDIS_URI=<redis://localhost:6379/> KONG_HOST=<KONG HOST> KONG_PORT=<8001> docker-compose -f docker-compose.yml up
```


#### Step 6. Confirm the Collector App is working
Requests to the status endpoint will confirm the Collector App is up and running in addition to providing Brain and/or Immunity status and version number.

```
curl http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/status
```

### Using Kong Brain

Once you have the Collector plugin and infrastructure up and running, Kong Brain does not require additional configuration as it is automatically enabled. Once data is flowing through the Collector system, Brain starts generating swagger files and service-maps as displayed on the Dev Portal.

#### Generated Open-API Spec files

To create Brain's Swagger files, the Collector endpoint /swagger returns a swagger file, generated considering traffic that match the submitted filter parameters: `host`, `route_id`, `service_id` and `workspace_name`. Also, it fills the fields `title`, `version` and `description` within the swagger file with the respective submitted parameters.

```
http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/swagger?host=<request_host>&openapi_version=<2|3>&route_id=<route_id>&service_id=<service_id>&workspace_name=<workspace_name>?title=
```

### Using Kong Immunity

#### Immunity Model Training

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

#### Checking Models Trained

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

#### Configure Alert Severity

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



1. Create a new Slack app

[**https://api.slack.com/apps?new_app=1**](https://api.slack.com/apps?new_app=1)

Pick a name and the workspace where the app will run.


Enable incoming webhook in your app
After submitting the app creation form you are redirected to your newly created app’s page. In “Add features and functionality” click on “Incoming webhooks” to enable them.
Change the OFF switch to ON. That will make visible a button “Add new webhook to workspace”, click on it.


That will redirect you to a page where you can select the channel the webhook will post messages. Select the channel and click in authorize.


Configuring Slack Channels Immunity provides the endpoint /notifications/slack/config for adding, deleting, and viewing your slack configurations.

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

### Charts in Slack notifications

Some alerts include images to better describe the context in which the alert was created. We rely on Amazon S3 to store the images that are sent to Slack. In order to have notifications with images, please provide access information to an S3 bucket (with permission to add files), by setting the environment variables: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.

### Clean Up the Data

Collector will clean the amount of HARs stored daily up to the max number of hars specified in the environment variable `MAX_HARS_STORAGE` and tables with extracted information to a max of two weeks of data. This means that at any day, the max number of HARs stored is the `MAX_HARS_STORAGE` + days_incoming_number_of_hars. If no `MAX_HARS_STORAGE` is specified, collector defaults to keeping 2 million hars in the database.


You can set your own value of `MAX_HARS_STORAGE` by setting the app environment variable through whatever means you've been deploying collector.


Additionally, collector provides an endpoint to delete the HARs data at /clean-hars. This endpoint accepts get and post and takes one parameter `max_hars_storage` which will delete all hars until only the value passed with `max_hars_storage` remains and contains the most recent HARs added to the database. If no value is passed to `max_hars_storage`, it will clean the database to the default value set with the environment variable `MAX_HARS_STORAGE`. An example of using this endpoint with curl looks like this:

```
curl -d '{"max_hars_storage":10000} \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/clean-hars
```

### Troubleshooting-Common-Setup-Pitfalls

#### “I'm sending requests with strange parameters, but I'm not seeing any alerts related to it”

There are a couple of things that can prevent the alerts you're expecting from showing up. First, check your Collector instance again at `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>` and make sure it's returning HARS data. If you’re not seeing data, there are 2 possible explanations. First, its likely your Brain plugin setup is not correct. Retry setting up your Brain plugin, for example making sure that the host specified on config is the same as `<COLLECTOR_HOST>`, until you see data coming in on `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>`. Second, if the plugin setup is correct but your test request data is not coming through, then make sure that the url you are sending your test data through is correct. For data to reach Collector, it must be sent through the kong service or route configured.

If you are seeing data, let's examine the data that you've sent. The data given back are the last 100 requests Brain has. Click on one of them, and drill in until you get to `queryString`. Pro tip: if you don't have random traffic coming into your system, and you know the last request you sent was the one with the strange parameters that you expected to trigger an alert, then the last entry in the list returned should correspond directly to that strange parameters request you sent.


On this view, check the contents of `queryString`. The `queryString` entry will list all parameters sent with the request your examining. If this entry is empty, then it indicates that no parameters were sent with this request, and properly sending parameters with your test request is the first step to seeing corresponding alerts.


If the `queryString` is looking good and you're still not seeing alerts, then it might be that your models haven't been built yet. When you first start Immunity, training is automatically scheduled to occur on the hour, every hour for the first week. This means that the first hour of immunity activation will trigger no alerts because no models have been trained. You can check which endpoints have models by hitting `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/monitoredendpoints` and verify that the endpoint that you're testing with is included in the list of endpoints with models.


If you're not seeing any endpoints being returned with /monitoredendpoints, then it's likely training hasn't happened. If you haven’t triggered training via the `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer` endpoint and it's within the first hour of Brain activation, then it's likely no model has been made. If you would like to trigger training and not wait for the auto-generated models, hit `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer` with the start parameter set to yesterday, and the end parameter set to tomorrow. This will create models using all available data.


If you are seeing endpoints but not the endpoint you're testing, this likely means that not enough data for that endpoint is available for proper model training. If it's possible to test alert generation with another endpoint on the /monitoredendpoints list, then switching your testing endpoint is recommended. If not, please create normal traffic for your test endpoint and hit `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer` again for full training. Then confirm that your test endpoint is listed in /monistorendpoints.

### Still having problems?

Email us at immunity@konghq.com with your bug report, please use the following format.

```
Summary
Please include a description of what happened, and a description of what you expected to happen
Steps To Reproduce (With pictures if helpful)
1.
2.
3.
4.
Additional Details & Logs
* Immunity version (same as Brain version on Brain image name)
* Immunity logs (docker compose -f <files used to start containers, with -f put in front of each file name> logs)
* Immunity configuration
* Deployment Method (docker deployment, bare metals, kubernetes ? etc)
```

### Send us feature requests

#### Send us a feature request to immunity@konghq.com!

```
`Summary of Proposed Feature`
`SUMMARY_GOES_HERE`
`User steps through feature (if applicable)`
`1.`
`2.`
`3.`
`4.`
```
