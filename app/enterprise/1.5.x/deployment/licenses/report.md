---
title: Monitor License Usage
---


## Overview
Obtain information about your Kong Enterprise deployment, including license usage and deployment information using the **License Report** module. Share this information with Kong to perform a health-check analysis of product utilization and overall deployment performance to ensure your organization is optimized with the best license and deployment plan for your needs.

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
       "system_info":{
          "cores":6,
          "hostname":"264da9b95dfa",
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
   <td>Kong Enterprise version
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
   <td>counters.req_count
   </td>
   <td>Number of requests node/cluster processed
   </td>
  </tr>
</table>
