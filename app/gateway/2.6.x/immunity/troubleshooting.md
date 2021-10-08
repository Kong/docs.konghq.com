---
title: Troubleshooting Common Issues
toc: true
redirect_from:
  - /enterprise/2.2.x/brain-immunity/troubleshooting
---

This troubleshooting topic contains common issues you might experience when using Kong Immunity, and troubleshooting tips for resolving these issues. Information is also provided about how to contact Kong to report an issue, and how to submit suggestions to help improve functionality.

## Common Issues and Troubleshooting Tips

### I'm not seeing traffic in the Collector App

If `http://<COLLECTOR_APP>:<COLLECTOR_PORT>` is returning an empty array,
confirm the Collector App can "talk" to Kong.

Check the `http://<COLLECTOR_APP>:<COLLECTOR_PORT>/status` endpoint:

```
$ curl -X http://<COLLECTOR_APP>:<COLLECTOR_PORT>/status`
```

When the Collector App communicates successfully with Kong, the **/status**
endpoint will return a JSON object with a **kong_status** object. For
example:

```json
{
  "immunity": {
    "available": true,
    "version": <VERSION>
  },
  "kong_status": {
    "is_collector_plugin_bundled": true,
    "url": "http://kong:8001",
    "version": "x.x.0.0-enterprise-edition"
  }
}
```

When the Collector App *cannot* communicate with Kong, the **kong_status**
object will be missing from the **/status** endpoint response. For example:

```json
{
  "immunity": {
    "available": true,
    "version": <VERSION>
  }
}
```

### Collector App is unable to communicate with Kong
When the `/status` endpoint is not returning a `kong_status` object, there are two possible reasons. First, it could be the Kong Admin environment variable for the Collector App is not set properly. The environment variables are:

* **KONG_PROTOCOL**: The protocol the Kong Admin API can be reached at. The possible values are `http` or `https`.
* **KONG_HOST**: The hostname the Kong Admin API can be reached at. If deploying with Docker Compose, this is the name of the Kong container specified in the compose file. If the Kong Admin has been exposed behind a web address, `KONG_HOST` must be that web address.
* **KONG_PORT**: The port where Kong Admin can be found. The Collector App requires this setting, along with `KONG_PROTOCOL` and `KONG_HOST`, to communicate with Kong Admin.
* **KONG_ADMIN_TOKEN**: The authentication token used to validate requests for the Kong Admin API, if RBAC is configured.

The Collector App will attempt to communicate with Kong via `{KONG_PROTOCOL}://{KONG_HOST}:{KONG_PORT}` and if `KONG_ADMIN_TOKEN` is configured, pass `{"Kong-Admin-Token":KONG_ADMIN_TOKEN}` as its requests' headers. You can check that the Collector App's environment variables are properly set by `ssh`-ing into the machine hosting the Collector App and sending a `GET` request to `{KONG_PROTOCOL}://{KONG_HOST}:{KONG_PORT}` with the appropriate headers from that machine.

If you cannot make successful requests to Kong Admin with `{KONG_PROTOCOL}://{KONG_HOST}:{KONG_PORT}`, first check to make sure that the Kong Admin URL (and `KONG_ADMIN_TOKEN`) you are attempting to connect with are correct. If they are correct, make sure that the respective machines hosting the Collector App and Kong Enterprise are able to communicate and ping each other.


### I'm not seeing any alerts, even though the Collector App is connected to Kong and is receiving traffic

Immunity waits at least an hour before it makes its first models. If the Collector App has not been up for very long, then the anomaly detection models used to generate alerts have not been created. These models are created using cURL. See [Immunity Model Training](/enterprise/{{page.kong_version}}/immunity/model-training) for more information.


### I triggered model training and I'm still not seeing alerts

If it has been more than an hour, and you are still not seeing alerts, the primary reason is that the models have not been generated yet. To check the status of your models, go to `http://<COLLECTOR-APP-URL>/monitoredendpoints`, which will return a list of working models Immunity has built with unique endpoints.

If the working models list is empty, it could mean that model training has not been successfully triggered. Review the Collector App logs to ascertain if this is the case.

Another likely cause for models not being generated is the Collector does not have enough data to make models. There are some alerts that require at least 50 requests, so ensure that the alert creating testing is exposed to enough traffic to make a model.

### I can't find or connect to Kong Brain

Kong Brain is deprecated and not available for use in Kong Enterprise version
2.1.4.2 and later.

## Still having problems? Contact us!
Email us at **immunity@konghq.com** to report an issue. Use the following format in your email:

```
Summary
Please include a description of the issue, and a description of what you expected to happen.
Steps To Reproduce (With pictures if helpful)
1.
2.
3.
4.
Additional Details & Logs
* Immunity version
* Immunity logs (docker compose -f <files used to start containers, with -f put in front of each file name> logs)
* Immunity configuration
* Deployment Method (docker deployment, bare metals, kubernetes ? etc)
```

## Send us feature requests
If you have a suggestion about a feature request, or suggestions about how to improve Immunity, send us feature request at **immunity@konghq.com**.

```
`Summary of Proposed Feature`
`SUMMARY_GOES_HERE`
`User steps through feature (if applicable)`
`1.`
`2.`
`3.`
`4.`
```
