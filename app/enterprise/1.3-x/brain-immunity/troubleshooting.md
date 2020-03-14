---
title: Troubleshooting-Common-Setup-Pitfalls
---

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
