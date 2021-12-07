---
title: Using Kong's Service Map
---

### Introduction

Get a high-level view of your architecture with Kong Enterprise’s real-time visual Service Map. Analyze inter-service dependencies across teams and platforms to improve governance and minimize risk.

The Service Map gives a visual response of mapping the traffic flowing through your services. To view the Service Map, you must install and configure the Kong Collector plugin and enable Kong Brain. If you have Kong Immunity, you can automatically view Immunity alerts.

### Prerequisites

* Kong Enterprise installed and configured
* Kong Collector Plugin installed and configured
* Kong Collector App installed and configured


For more information, see the [Kong Brain and Kong Immunity Installation and Configuration Guide](/enterprise/{{page.kong_version}}/brain-immunity/install-configure).

### Service Map Overview

Kong’s Service Map provides a graphical representation of requests that flow through Kong Enterprise.

* Kong Service Map is available from the Service Map tab. The Service Map populates with traffic as seen in Kong Brain.

   ![Kong Service Map](https://doc-assets.konghq.com/1.3/service-map/kong_service_map.png)


* As traffic hits services running in Kong, the Service Map populates and maps those requests through hosts. The Service Map also displays protocol, timestamp, and other metadata associated with the routes and methods used for those requests. The Service Map can be filtered by hosts, as well as by Workspace.

   ![Kong Service Map Traffic](https://doc-assets.konghq.com/1.3/service-map/kong_service_map_traffic.png)


* With Kong Immunity, you can view Immunity alerts within the Service Map and click through the Alerts dashboard for further investigation.

  ![Kong Immunity](https://doc-assets.konghq.com/1.3/service-map/kong_immunity.png)


### Set up the Service Map

The Kong Service Map uses **Kong Brain** and the **Kong Collector Plugin**. To populate the Service Map, configure the Kong Collector Plugin and enable Kong Brain. Once traffic starts flowing, the Service Map begins to populate with a visual representation of requests flowing through Kong, and traffic is updated in minute intervals.

If you have **Kong Immunity**, and the Kong Collector Plugin is configured, Kong Immunity is automatically enabled and Immunity alerts populate and display in the Service Map as they occur.

  ![Kong Service Map Set Up](https://doc-assets.konghq.com/1.3/service-map/kong_service_map_setup.png)

For more information, see the [Kong Brain and Kong Immunity Installation and Configuration Guide](/enterprise/{{page.kong_version}}/brain-immunity/install-configure).
