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
Content-Length: 262
Content-Type: application/json; charset=utf-8
Date: Wed, 19 Feb 2020 05:54:23 GMT
Server: kong/1.3-enterprise-edition
Vary: Origin
X-Kong-Admin-Request-ID: 6fmfr4Zl3RGmOs5oY0HvT47zt0oDq54o
{
   "counters":{
      "req_cnt":22
   },
   "db_version":"postgres 9.5.20",
   "kong_version":"1.3-enterprise-edition",
   "license_key":"ASDASDASDASDASDASDASDASDASD_a1VASASD",
   "rbac_users":0,
   "services_count": 27,
   "system_info":{
      "cores":6,
      "hostname":"264da9b95dfa",
      "uname":"Linux x86_64"
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
`counters.req_count` | Counts the number of requests made since the license creation date.
`db_version` | The type and version of the datastore {{site.base_gateway}} is using.
`kong_version` | The version of the {{site.base_gateway}} instance.
`license_key` | An encrypted identifier for the current license key. If no license is present, the field displays as `UNLICENSED`.
`rbac_users` | The number of users registered with through RBAC.
`services_count` | The number of configured services in the {{site.base_gateway}} instance.
`system_info` | Displays information about the system running {{site.base_gateway}}. <br><br> &#8226; `cores`: Number of CPU cores on the node <br> &#8226; `hostname`: Encrypted system hostname <br> &#8226; `uname`: Operating system
`workspaces_count` | The number of workspaces configured in the {{site.base_gateway}} instance.
