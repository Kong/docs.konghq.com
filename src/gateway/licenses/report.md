---
title: Monitor License Usage
badge: enterprise
---

Obtain information about your {{site.base_gateway}} deployment, including license usage and deployment information using the **License Report** module. Share this information with Kong to perform a health-check analysis of product utilization and overall deployment performance to ensure your organization is optimized with the best license and deployment plan for your needs.

How the license report module works:
*   The license report module manually generates a report containing usage and deployment data by sending a request to an endpoint, as defined below.
*   Share this report with your Kong representative to perform an analysis of your deployment.

What the license report module **does not** do:
*   The license report module does not automatically generate a report or send any data to any Kong servers.
*   The license report module does not track or generate any data other than the data that is returned in the response after you send a request to the endpoint.

## Generate a License Report
Run the license report module and share the output information with your Kong representative for a deployment analysis.

**Prerequisites**: You must have Admin privileges to generate a license report.

To generate a license report, from an HTTP client:

{% navtabs %}
{% navtab JSON response %}

For a JSON response, send an HTTP request to the Kong node endpoint
`/license/report`. For example, use this cURL command:

```bash
curl {ADMIN_API_URL}/license/report
```

A JSON response returns, similar to the example below:

```json
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: http://localhost:8002
Connection: keep-alive
Content-Length: 814
Content-Type: application/json; charset=utf-8
Date: Mon, 06 Dec 2021 12:04:28 GMT
Server: kong/2.7.0.1-enterprise-edition
Vary: Origin
X-Kong-Admin-Request-ID: R1jmopI6fjkOLdOuPJVLEmGh4sCLMpSY
{
   "counters": [
    {
        "bucket": "2021-09",
        "request_count": 30
    },
    {
        "bucket": "2020-10",
        "request_count": 42
    },

    {
        "bucket": "2021-11",
        "request_count": 296
    },
    {
        "bucket": "2021-12",
        "request_count": 58
    },
    {
        "bucket": "UNKNOWN",
        "request_count": 50
    }
  ],
   "db_version": "postgres 9.6.24",
   "kong_version": "2.7.0.1-enterprise-edition",
   "license_key": "KONGLICENSEKEY_NOTVALIDFORREAL_USAGE",
   "rbac_users": 0,
   "services_count": 27,
   "system_info": {
      "cores": 6,
      "hostname": "akongnode",
      "uname": "Linux x86_64"
   },
   "workspaces_count":1
}
```

{% endnavtab %}
{% navtab TAR file %}

For a TAR file, enter the following cURL command to make a call to the
Kong Admin API:

```bash
curl {ADMIN_API_URL}/license/report -o response.json && tar -cf report-$(date +"%Y_%m_%d_%I_%M_%p").tar response.json
```

A license report file is generated and archived to a `*.tar` file.

{% endnavtab %}
{% endnavtabs %}

## Report Structure

Field | Description
------|------------
`counters` | Counts the number of requests made in a given month. <br><br> &#8226; `bucket`: Year and month when the requests were processed. If the value in `bucket` is `UNKNOWN`, then the requests were processed before Kong Gateway 2.7.0.1. <br> &#8226; `request_count`: Number of requests processed in the given month and year.
`db_version` | The type and version of the datastore Kong Gateway is using.
`kong_version` | The version of the Kong Gateway instance.
`license_key` | An encrypted identifier for the current license key. If no license is present, the field displays as `UNLICENSED`.
`rbac_users` | The number of users registered with through RBAC.
`services_count` | The number of configured services in the Kong Gateway instance.
`system_info` | Displays information about the system running Kong Gateway. <br><br> &#8226; `cores`: Number of CPU cores on the node <br> &#8226; `hostname`: Encrypted system hostname <br> &#8226; `uname`: Operating system
`workspaces_count` | The number of workspaces configured in the Kong Gateway instance.
