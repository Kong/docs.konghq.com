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

*   For a JSON response, send an HTTP request to the Kong node endpoint` /license/report`. For example, use this cURL command:

    ```
    curl '<ADMIN_API_URL>/license/report'
    ```

    A JSON response returns, similar to the example below.

    ```
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
        },
       "db_version":"postgres 9.6.24",
       "kong_version":"2.7.0.1-enterprise-edition",
       "license_key":"KONGLICENSEKEY_NOTVALIDFORREAL_USAGE",
       "rbac_users":0,
       "services_count": 27,
       "system_info":{
          "cores":6,
          "hostname":"akongnode",
          "uname":"Linux x86_64"
       },
       "workspaces_count":1
    }
    ```

* For a TAR file, enter the following cURL command to make a call to Kong Admin API.

    ```
    curl <ADMIN_API_URL>/license/report -o response.json && tar -cf report-$(date +"%Y_%m_%d_%I_%M_%p").tar response.json
    ```
    A license report file is generated and archives a report to *.tar file.

## Report Structure

<table>
  <tr>
   <td>Field
   </td>
   <td>Description
   </td>
  </tr>
  <tr>
   <td>kong_version
   </td>
   <td>{{site.base_gateway}} version
   </td>
  </tr>
  <tr>
   <td>license_key
   </td>
   <td>Current license key identifier
   </td>
  </tr>
  <tr>
   <td>db_version
   </td>
   <td>Storage name and version of node/cluster
   </td>
  </tr>
  <tr>
   <td>system_info.cores
   </td>
   <td>System CPU cores of node
   </td>
  </tr>
  <tr>
   <td>system_info.hostname
   </td>
   <td>System hostname
   </td>
  </tr>
  <tr>
   <td>system_info.uname
   </td>
   <td>System uname
   </td>
  </tr>
  <tr>
   <td>workspaces_count
   </td>
   <td>Number of workspaces
   </td>
  </tr>
  <tr>
   <td>rbac_users
   </td>
   <td>Number of RBAC users
   </td>
  </tr>
  <tr>
   <td>services_count
   </td>
   <td>Number of Kong Services
   </td>
  </tr>
  <tr>
   <td>counters.bucket
   </td>
   <td>Year and month when the requests were processed, or "UNKNOWN" for requests processed before Kong 2.7.0.1.
   </td>
  </tr>
  <tr>
   <td>counters.request_count
   </td>
   <td>Number of requests processed in the given month and year
   </td>
  </tr>
</table>
