---
title: Troubleshooting-Common-Setup-Pitfalls
---

## "Help, I don't see anything in Service Map but I have been sending traffic"

The most common cause for service map not showing up is a problem in the configuration between Kong and Collector App that prevents traffic data from reaching Collector App.  To see if Collector App has recieved traffic from Kong, check ```http://<COLLECTOR_APP>:<COLLECTOR_PORT>```.

When Collector App has successfully been connected to Kong, ```http://<COLLECTOR_APP>:<COLLECTOR_PORT>``` will return the latest 100 requests Kong has sent it in the form of JSON objects like this:
```
[{"route": {"id": "55039c17-2356-4329-9377-46f5d7fa0b5c", "name": "rebel-alliance-route", "paths": ["/resistance/(?<version>\\d+)"], "service": {"id": "db7fc153-0781-41a5-9794-1d449a4ab078"}, "protocols": ["http", "https"], "created_at": 1587752123, "strip_path": true, "updated_at": 1587752123, "path_handling": "v0", "preserve_host": false, "regex_priority": 0, "https_redirect_status_code": 426}, "tries": [{"ip": "172.18.0.3", "port": 6000, "balancer_start": 1587752246760, "balancer_latency": 0}], "request": {"uri": "/resistance/{int}/{file}", "url": "http://kong:8000/resistance/{int}/{file}", "size": "249", "method": "POST", "headers": {"host": "kong:8000", "accept": "*/*", "apikey": "happyunicorns", "connection": "keep-alive", "user-agent": "python-requests/2.21.0", "x-consumer-id": "c511b2b9-056c-429f-bff7-6dca0562d380", "content-length": "0", "accept-encoding": "gzip, deflate", "x-consumer-username": "Luke"}, "post_data": {}, "querystring": {"plan": "basic", "wait": "0", "user_id": "3", "statuscode": "200"}}, "service": {"id": "db7fc153-0781-41a5-9794-1d449a4ab078", "host": "testendpoints", "name": "hello-world", "path": "/", "port": 6000, "retries": 5, "protocol": "http", "created_at": 1587752123, "updated_at": 1587752123, "read_timeout": 60000, "write_timeout": 60000, "connect_timeout": 60000}, "consumer": {"id": "c511b2b9-056c-429f-bff7-6dca0562d380", "type": 0, "username": "Luke", "created_at": 1587752125}, "response": {"size": "308", "status": 200, "headers": {"via": "kong/2.0.0.0-enterprise-edition", "date": "Fri, 24 Apr 2020 18:17:26 GMT", "server": "gunicorn/19.9.0", "connection": "close", "content-type": "text/html; charset=utf-8", "string-header": "string-value", "content-length": "8", "integer-header": "1", "x-kong-proxy-latency": "0", "x-kong-upstream-latency": "2"}}, "client_ip": "172.18.0.11", "latencies": {"kong": 0, "proxy": -1, "request": 0}, "started_at": 1587752246760, "workspaces": [{"id": "921231cd-e4ad-4c99-ae5d-bf52736b0c4c", "name": "RebelAlliance"}], "upstream_uri": "/pdf_54.pdf", "authenticated_entity": {"id": "a9064f96-d17a-4c3d-8330-d23a0d233089"}},]
```

### "I'm not seeing traffic in Collector App"

If ```http://<COLLECTOR_APP>:<COLLECTOR_PORT>``` is returning an empty array then its important to first check that the Collector App can talk to Kong.  Check ```http://<COLLECTOR_APP>:<COLLECTOR_PORT>/status```.  When the Collector App can communicate successfully with Kong, the **/status** endpoint will return a json object with a **kong_status** object like this:
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
    "version": "2.0.0.0-enterprise-edition"
  }
}
```

When Collector App cannot connect with Kong, the **kong_status** object will be missing from the **/status** endpoint response and look like this:

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

#### Collector App is not able to communicate with Kong
When the **/status** endpoint is not returning a **kong_status** object there are two possible problems.  First, it could be that the Kong admin related environment variable for Collector App haven't been set properly.  These environment variables are:

1. **KONG_PROTOCOL**: The protocol that the Kong Admin API can be reached at. The possible values are http or https.
2. **KONG_HOST**: The hostname that the Kong Admin API can be reached at. If deploying with Docker Compose, this is the name of the Kong container specified in the compose file. If Kong Admin has been exposed behind a web address, KONG_HOST must be that web address.
3. **KONG_PORT**: The port where Kong Admin can be found.  Collector App requires this setting, along with KONG_PROTOCOL and KONG_HOST, to communicate with Kong Admin.
4. **KONG_ADMIN_TOKEN**: The authentication token used to validate requests for Kong Admin API, if RBAC is configured.

Collector will attempt to communicate with Kong via **{KONG_PROTOCAL}://{KONG_HOST}:{KONG_PORT}** and if KONG_ADMIN_TOKEN is configured, pass ```{"Kong-Admin-Token": KONG_ADMIN_TOKEN}``` as its requests' headers.  You can check that the Collector App's Kong environment variables are properly set by ssh-ing into the machine hosting the Collector App and sending a get request to **{KONG_PROTOCAL}://{KONG_HOST}:{KONG_PORT}** with appropriate headers from that machine.

If you cannot make successful requests to Kong Admin with **{KONG_PROTOCAL}://{KONG_HOST}:{KONG_PORT}**, first check to make sure that the Kong Admin url (and KONG_ADMIN_TOKEN) you are attempting to connect with are correct.  If they are correct, then make sure that the respective machines hosting the Collector App and Kong EE are able to communicate and ping each other.

### Collector App can connect to Kong, there is traffic in Collector App, but I still don't see Service Map in Kong Manager

When Collector App can connect to Kong and is successfully recieving traffic and Service Map still is failing to populate, then likely the Collector Plugin on Kong EE is not configured properly.  An easy way to see if the Collector Plugin is set properly is to go to **http://kong:8002/<WORKSPACE>/immunity/alerts** page in Kong Manager.  When the Collector Plugin is configured properly, the **/immunity/alerts** page will say "Collector is connected".

![Kong Plugin Configured](/assets/images/docs/brain-immunity/collector-plugin-configured-alerts-page.png)

If it does not say this, then check that Collector App's url set for Collector Plugin's **http_endpoint** variable is correct and that the machine hosting Kong EE can successfully communicate with Collector App on the url provided to Collector Plugin's **http_endpoint** variable.


## “I'm not seeing any alerts and I should have but Collector App is connected to Kong and is recieving traffic”

Immunity does wait at least an hour before it makes its first models.  If Collector App has not been up for that long, then the anomaly detection models used to generate alerts haven't been created.  These models can be created using curl.  See [Immunity's Alerts Page](/enterprise/{{page.kong_version}}/brain-immunity/alerts/#immunity-model-training) for more instructions.

### "It's been more than an hour and/or I triggered model training and I'm still not seeing alerts"

The primary cause for no alerts being generated is that models haven't been generated.  To check the status of your models, you can go to ```http://<COLLECTOR-APP-URL>/monitoredendpoints``` which will return a list of all the unique endpoints Immunity has built working models for.

If this list is empty, it could mean that either model training hasn't been successfully triggered.  Looking at the Collector App logs can help ascertain if this is the case.

Another likely cause for models not being made is that collector doesn't have enough data to make models.  There are some alerts that require at least 50 requests, so ensure that the alert creating testing is exposed to enough traffic to make a model.


## Still having problems?

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

## Send us feature requests

### Send us a feature request to immunity@konghq.com!

```
`Summary of Proposed Feature`
`SUMMARY_GOES_HERE`
`User steps through feature (if applicable)`
`1.`
`2.`
`3.`
`4.`
```
