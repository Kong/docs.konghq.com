---
title: Immunity Model Training
toc: true
redirect_from:
  - /enterprise/2.2.x/brain-immunity/model-training
---

## Introduction

Immunity automatically starts training its models once it is up and running and receiving data. Immunity creates a model for every unique endpoint + method combination it sees in incoming traffic. For example, if you have an endpoint [www.test-website.com/buy](http://www.test-website.com/buy) and traffic comes in with both GET and POST requests for that endpoint, Immunity will create two models: one for the endpoint + GET traffic and one for the endpoint + POST traffic.

The first model version gets created after the first hour and continuously retrains itself for the first week to provide the best possible model. After that, every week all models retrain with a week of data.

Clients are also provided with an endpoint to retrigger training themselves. Retraining is recommended when the context of your app is expected to have many changes. For example, there is an upcoming app release that will change several endpoints. If this is the case, you can POST to `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/resettrainer` to start the training cycle all over again.

Let’s say you’d like slightly more control over the data your model sees. For example, perhaps you know that weekend data is not particularly useful for model building because weekends are normally outliers that your team is prepared for. You can trigger model training for all models with a specified time period of data. Simply POST to `http://<BRAIN_HOST>:<COLLECTOR_PORT>/trainer` with the start and end time of data you want included in training, for example:

```bash
curl -d '{"start":"2019-01-08 10:00:00", "end":"2019-01-09 23:30:00"}' \
 -H "Content-Type: application/json" \
 -X POST http://<BRAIN_HOST>:<COLLECTOR_PORT>/trainer
```
or, in the browser like this:

```bash
http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer?start=&end=
```
** datetime value format: YYYY-MM-DD HH:mm:ss


Additionally, you can specify the Kong `service_id` or `route_id` of the URLs you want trained using the `kong_entity` parameter. Immunity then only trains URLs associated with the ID provided, and with the data specified by the start and end dates.

```bash
curl -d '{"start":"2019-01-08 10:00:00", "end":"2019-01-09 23:30:00", "kong_entity":"2beff163-061d-43ad-8d87-8f40d10805ba"}' \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer
```

## Checking Trained Models

Only endpoints + method combinations that have a model trained can be monitored for alerts. If you want to check which endpoints have models, you can use `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/monitoredendpoints`, which return a list of all models in the system. Each item in this list contains the following identifying information for the model:

* `base_url`: The URL of the traffic used to train the model.
* `method`: The method of the traffic used to train the model.
* `route_id`: The Kong `route_id` that the traffic used to train the model is associated with. **service_id**: The Kong `service_id` that the traffic used to train the model is associated with. **model_version_id**: The model version number of the current, active model.
* `active_models`: A JSON object containing information on the active status of each of the six (6) core alert types in Immunity (unknown_parameters, abnormal_value, latency, traffic, status codes, and value_type).

In this object, the value is a specific alert type and the value is a boolean value where `True` indicates that the model is actively monitoring for that alert type.

In general, if an endpoint and method combination model does not appear on the returned object from `/monitoredendpoints`, this is likely because not enough traffic has been seen by Immunity to build a reliable model.

## Configure Auto-Training

### Restarting Training Schedules

Immunity automatically sets up training jobs when it first starts up, and retrains all models on an optimized schedule based on the time when data started flowing through Immunity. If you have experienced large changes in the type of data you expect to flow through Immunity and do not feel comfortable choosing an optimal time period to use for retraining with the `/trainer` endpoint, you can re-trigger Immunity's auto-training by posting to the `/trainer/reset` endpoint. Immunity will then recreate its retraining schedule as if it was just being started and newly ingesting data.

```bash
curl -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer/reset
```

Or, you can also accomplish this by posting to `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/resettrainer`.


### Configuring Auto-Training Rules

For best results, Immunity retrains on a regular basis. If you do not need to retrain your models regularly and are happy with your current model, you can stop auto retraining via a POST request to the `/trainer/config` endpoint. This endpoint takes these parameters:

* `workspace_name`: The workspace name of the workspace that the configuration will be applied to.
* `method`: One of values: GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE. Specifying a method will restrict the rule being made on auto-training to only traffic matching the method specified. When this value is null, all traffic from all methods are included in the rule.
* `enable`: `True` or `False`, where `True` means auto-training is on and `False` means auto-training is off for the `kong_entity` specified.

You can turn off auto-training for a particular Route or Service using a cURL request:

```bash
curl -d '{"kong_entity":"your-route-id", "enable":false}' \
 -H "Content-Type: application/json" \
 -X POST http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer/config
```

Similarly, if you turned off auto-training for a Route and want to turn it back on, you can post to `/trainer/config` with `"enable":true`.

These configurations will only apply to training started by Immunity's auto-training schedule. Other training requests made by `/trainer` will not be affected by this configuration.

### Viewing Configuration Rules

To view all of your configured training rules, create a GET request to `/trainer/config`:

```bash
curl -X GET http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer/config
```

A list of all rules is returned, where `kong_entity` refers to the `service_id` or `route_id` the rule applies to, and enabled is a true or false value.

### Resetting or Deleting Configured Rules

To delete a single auto-train rule that you created, you can send a delete request to `/trainer/config` with a `kong_entity` parameter and value of the `service_id` or `route_id` of the rule you want to delete.

```bash
curl -d '{"kong_entity":"your-route-id"}' \
 -H "Content-Type: application/json" \
 -X DELETE http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer/config
```

Without a rule established, Immunity defaults to auto-training. Once you delete a configured rule, Immunity will continue or start auto-training on the Route or Service of the deleted rule.


If you want to delete all the configurations you created, send an empty DELETE request to `/trainer/config`:

```bash
curl -X http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/trainer/config
```
