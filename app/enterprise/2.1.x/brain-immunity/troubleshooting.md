---
title: Troubleshooting Common Issues
---

This troubleshooting topic contains common issues you might experience when using Kong Brain and Kong Immunity, and troubleshooting tips for how to resolve these issues. Information is also provided about how to contact Kong to report an issue, and how to submit suggestions to help improve functionality. 

## Common Issues and Troubleshooting Tips

### I'm sending traffic, but I don't see anything in the Service Map

The most common cause for the Service Map not displaying is a problem in the configuration between Kong Enterprise (Kong) and the Collector App which prevents traffic data from reaching the Collector App. To confirm the Collector App is receiving traffic from Kong, check `http://<COLLECTOR_APP>:<COLLECTOR_PORT>`.

When the Collector App has successfully connected to Kong, ```http://<COLLECTOR_APP>:<COLLECTOR_PORT>``` will return the latest 100 requests Kong has sent in the form of JSON objects. For example:
```
[{"route": {"id": "55039c17-2356-4329-9377-46f5d7fa0b5c", "name": "rebel-alliance-route", "paths": ["/resistance/(?<version>\\d+)"], "service": {"id": "db7fc153-0781-41a5-9794-1d449a4ab078"}, "protocols": ["http", "https"], "created_at": 1587752123, "strip_path": true, "updated_at": 1587752123, "path_handling": "v0", "preserve_host": false, "regex_priority": 0, "https_redirect_status_code": 426}, "tries": [{"ip": "172.18.x.x", "port": 6000, "balancer_start": 1587752246760, "balancer_latency": 0}], "request": {"uri": "/resistance/{int}/{file}", "url": "http://kong:8000/resistance/{int}/{file}", "size": "249", "method": "POST", "headers": {"host": "kong:8000", "accept": "*/*", "apikey": "happyunicorns", "connection": "keep-alive", "user-agent": "python-requests/2.21.0", "x-consumer-id": "c511b2b9-056c-429f-bff7-6dca0562d380", "content-length": "0", "accept-encoding": "gzip, deflate", "x-consumer-username": "Luke"}, "post_data": {}, "querystring": {"plan": "basic", "wait": "0", "user_id": "3", "statuscode": "200"}}, "service": {"id": "db7fc153-0781-41a5-9794-1d449a4ab078", "host": "testendpoints", "name": "hello-world", "path": "/", "port": 6000, "retries": 5, "protocol": "http", "created_at": 1587752123, "updated_at": 1587752123, "read_timeout": 60000, "write_timeout": 60000, "connect_timeout": 60000}, "consumer": {"id": "c511b2b9-056c-429f-bff7-6dca0562d380", "type": 0, "username": "Luke", "created_at": 1587752125}, "response": {"size": "308", "status": 200, "headers": {"via": "kong/x.x.0.0-enterprise-edition", "date": "Fri, 24 Apr 2020 18:17:26 GMT", "server": "gunicorn/19.9.0", "connection": "close", "content-type": "text/html; charset=utf-8", "string-header": "string-value", "content-length": "8", "integer-header": "1", "x-kong-proxy-latency": "0", "x-kong-upstream-latency": "2"}}, "client_ip": "172.18.x.xx", "latencies": {"kong": 0, "proxy": -1, "request": 0}, "started_at": 1587752246760, "workspaces": [{"id": "921231cd-e4ad-4c99-ae5d-bf52736b0c4c", "name": "RebelAlliance"}], "upstream_uri": "/pdf_54.pdf", "authenticated_entity": {"id": "a9064f96-d17a-4c3d-8330-d23a0d233089"}},]
```

### I'm not seeing traffic in the Collector App

If ```http://<COLLECTOR_APP>:<COLLECTOR_PORT>``` is returning an empty array, confirm the Collector App can "talk" to Kong. Check ```http://<COLLECTOR_APP>:<COLLECTOR_PORT>/status```. When the Collector App communicates successfully with Kong, the **/status** endpoint will return a JSON object with a **kong_status** object. For example:
```
{
  "brain": {
    "available": true,
    "version": <VERSION>
  },
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

When the Collector App cannot communicate with Kong, the **kong_status** object will be missing from the **/status** endpoint response. For example:

```
{
  "brain": {
    "available": true,
    "version": <VERSION>
  },
  "immunity": {
    "available": true,
    "version": <VERSION>
  }
}

```

### Collector App can't communicate with Kong
When the `/status` endpoint is not returning a `kong_status` object, there are two possible reasons. First, it could be the Kong Admin environment variable for the Collector App is not set properly. The environment variables are:

* **KONG_PROTOCOL**: The protocol the Kong Admin API can be reached at. The possible values are `http` or `https`.
* **KONG_HOST**: The hostname the Kong Admin API can be reached at. If deploying with Docker Compose, this is the name of the Kong container specified in the compose file. If the Kong Admin has been exposed behind a web address, `KONG_HOST` must be that web address.
* **KONG_PORT**: The port where Kong Admin can be found. The Collector App requires this setting, along with `KONG_PROTOCOL` and `KONG_HOST`, to communicate with Kong Admin.
* **KONG_ADMIN_TOKEN**: The authentication token used to validate requests for the Kong Admin API, if RBAC is configured.

The Collector App will attempt to communicate with Kong via `{KONG_PROTOCOL}://{KONG_HOST}:{KONG_PORT}` and if `KONG_ADMIN_TOKEN` is configured, pass `{"Kong-Admin-Token":KONG_ADMIN_TOKEN}` as its requests' headers. You can check that the Collector App's environment variables are properly set by `ssh`-ing into the machine hosting the Collector App and sending a `GET` request to `{KONG_PROTOCOL}://{KONG_HOST}:{KONG_PORT}` with the appropriate headers from that machine.

If you cannot make successful requests to Kong Admin with `{KONG_PROTOCOL}://{KONG_HOST}:{KONG_PORT}`, first check to make sure that the Kong Admin URL (and `KONG_ADMIN_TOKEN`) you are attempting to connect with are correct. If they are correct, make sure that the respective machines hosting the Collector App and Kong Enterprise are able to communicate and ping each other.

### Collector App can connect to Kong, and traffic is in the Collector App, but I don't see the Service Map in Kong Manager

When the Collector App is connected to Kong and successfully recieving traffic, but the Service Map is failing to populate, it's likely the Collector Plugin on Kong Enterprise is not configured properly. To check the Collector Plugin's configuration, go to `http://kong:8002/<WORKSPACE>/immunity/alerts` page in Kong Manager. When the Collector Plugin is configured properly, the `/immunity/alerts` page displays "Collector is connected".

![Kong Plugin Configured](/assets/images/docs/ee/brain-immunity/collector-plugin-configured-alerts-page.png)

If the `/immunity/alerts` page does not show the Collector Plugin is connected, check that the Collector App's URL is set for the Collector Plugin's `http_endpoint` variable. Also check that the machine hosting Kong Enterprise can successfully communicate with the Collector App on the URL provided to Collector Plugin's `http_endpoint` variable.


### I'm not seeing any alerts, even though the Collector App is connected to Kong and is receiving traffic

Immunity waits at least an hour before it makes its first models. If the Collector App has not been up for very long, then the anomaly detection models used to generate alerts have not been created. These models are created using cURL. See [Immunity Model Training](/enterprise/{{page.kong_version}}/brain-immunity/alerts/#immunity-model-training) for more information.

### I triggered model training and I'm still not seeing alerts

If it has been more than an hour, and you are still not seeing alerts, the primary reason is that the models have not been generated yet. To check the status of your models, go to `http://<COLLECTOR-APP-URL>/monitoredendpoints`, which will return a list of working models Immunity has built with unique endpoints.

If the working models list is empty, it could mean that model training has not been successfully triggered. Review the Collector App logs to ascertain if this is the case.

Another likely cause for models not being generated is the Collector does not have enough data to make models. There are some alerts that require at least 50 requests, so ensure that the alert creating testing is exposed to enough traffic to make a model.


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
* Immunity version (same as Brain version on Brain image name)
* Immunity logs (docker compose -f <files used to start containers, with -f put in front of each file name> logs)
* Immunity configuration
* Deployment Method (docker deployment, bare metals, kubernetes ? etc)
```

## Send us feature requests
If you have a suggestion about a feature request, or suggestions about how to improve Brain and Immunity, send us feature request at **immunity@konghq.com**.

```
`Summary of Proposed Feature`
`SUMMARY_GOES_HERE`
`User steps through feature (if applicable)`
`1.`
`2.`
`3.`
`4.`
```
