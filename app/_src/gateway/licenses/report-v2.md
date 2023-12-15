---
title: Monitor License Usage
badge: enterprise
---

Obtain information about your {{site.base_gateway}} database-backed deployment, including license usage and deployment information using the **License Report** module. Share this information with Kong to perform a health-check analysis of product utilization and overall deployment performance to ensure your organization is optimized with the best license and deployment plan for your needs.

How the license report module works:
*   The license report module manually generates a report containing usage and deployment data by sending a request to an endpoint, as defined below.
*   Share this report with your Kong representative to perform an analysis of your deployment.

What the license report module **does not** do:
*   The license report module does not automatically generate a report or send any data to any Kong servers.
*   The license report module does not track or generate any data other than the data that is returned in the response after you send a request to the endpoint.

{:.important}
> **Important:** The license report functionality cannot be used in a DB-less deployment.

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
Server: kong/{{page.versions.ee}}-enterprise-edition
Vary: Origin
X-Kong-Admin-Request-ID: R1jmopI6fjkOLdOuPJVLEmGh4sCLMpSY
{
    "plugins_count": {
        "tiers": {
            "enterprise": {
                "kafka-upstream": 2,
                "rate-limiting-advanced": 1
            },
            "free": {
                "cors": 1
            },
            "custom": {
            }
        },
        "unique_route_lambdas": 0,
        "unique_route_kafkas": 1
    },
    "routes_count": 5,
    "timestamp": 1697013865,
    "license": {
        "license_expiration_date": "2017-7-20",
        "license_key": "KONGLICENSEKEY_NOTVALIDFORREAL_USAGE"
    },
    "checksum": "2935ed72e118fbaca9c09b9a6065f08a8ea40851",
    "counters": {
        "buckets": [
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
        "total_requests": 476
    },
    "services_count": 27,
    "kong_version": "{{page.versions.ee}}-enterprise-edition",
    "db_version": "postgres 15.2",
    "system_info": {
        "cores": 6,
        "uname": "Linux x86_64",
        "hostname": "akongnode"
    },
    "deployment_info": {
        "type": "traditional"
    },
    "workspaces_count": 1
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
`counters` | Counts the number of requests. <br><br> &#8226; `buckets`: Counts the number of requests made in a given month. <br><br> &#8729; `bucket`: Year and month when the requests were processed. If the value in `bucket` is `UNKNOWN`, then the requests were processed before {{site.base_gateway}} 2.7.0.1. <br> &#8729; `request_count`: Number of requests processed in the given month and year. <br><br> &#8226; `total_requests`: Number of requests processed in the `buckets`. i.e. `total_requests` is equivalent to adding up the `request_count` of each item in `buckets`.
`plugins_count` | Counts the number of plugins in use. <br><br> &#8226; `tiers`: Separate counts by license tiers. <br><br> &#8729; `free`: Number of free plugins in use. <br> &#8729; `enterprise`: Number of enterprise plugins in use. <br> &#8729; `custom`: Number of custom plugins in use. <br><br> &#8226; `unique_route_lambdas`: Number of `awk-lambda` plugin in use. Only counts in case of the plugin is defined on a service-less route level and have a unique function name. <br> &#8226; `unique_route_kafkas`: Number of unique broker IPs listed in broker array across `kafka-upstream` plugin defined on a service-less route level.
`db_version` | The type and version of the datastore {{site.base_gateway}} is using.
`kong_version` | The version of the {{site.base_gateway}} instance.
`license` | Displays information about the current license running {{site.base_gateway}} instance. <br><br> &#8226; `license_expiration_date`: The date current license expires. If no license is present, the field displays as `2017-7-20`. <br> &#8226; `license_key`: Current license key. If no license is present, the field displays as `UNLICENSED`.
`rbac_users` | The number of users registered with through RBAC.
`services_count` | The number of configured services in the {{site.base_gateway}} instance.
`routes_count` | The number of configured routes in the {{site.base_gateway}} instance.
`system_info` | Displays information about the system running {{site.base_gateway}}. <br><br> &#8226; `cores`: Number of CPU cores on the node <br> &#8226; `hostname`: Encrypted system hostname <br> &#8226; `uname`: Operating system`
`deployment_info` | Displays information about the deployment running {{site.base_gateway}}. <br><br> &#8226; `type`: Type of the deployment mode <br> &#8226; `connected_dp_count`: Number of dataplanes across the cluster. If the deployment is not hybrid mode, the field is not displayed.
`timestamp` | Timestamp of the current response.
`checksum` | The checksum of the current report.
`workspaces_count` | The number of workspaces configured in the {{site.base_gateway}} instance.
