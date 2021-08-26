---
title: Kong Immunity Overview
toc: true
redirect_from:
  - /enterprise/2.2.x/brain-immunity/overview
  - /enterprise/2.2.x/brain-immunity/auto-generated-specs
  - /enterprise/latest/brain-immunity/auto-generated-specs
  - /enterprise/2.2.x/brain-immunity/service-map
  - /enterprise/latest/brain-immunity/auto-generated-specs
---


## Overview

**Kong Immunity** (Immunity) uses advanced machine learning to analyze traffic patterns in real-time to improve security, mitigate breaches and isolate issues.  

Immunity monitors all traffic that flows through Kong Enterprise. When an anomaly is detected, Immunity sends an alert to Kong Manager and displays on the Alerts dashboard. Alerts are built to signal the health of your microservices system and help pinpoint which endpoints are struggling.

Immunity helps organizations improve efficiency, governance, reliability, and security.

![Kong Immunity architecture](/assets/images/docs/ee/brain-immunity/immunity-overview.png)

Immunity is installed on {{site.ee_product_name}}, using Kubernetes or Docker. The Collector App and Collector Plugin enable Immunity to communicate with {{site.base_gateway}}. The diagram above illustrate how the components work together.


## About Kong Immunity
Immunity autonomously identifies service issues with machine learning-powered anomaly detection. Features include:

### Create a Baseline for Healthy Traffic
Traffic patterns provide a window into the behavior and performance of services under different conditions. To understand your existing traffic patterns, Immunity ingests data flowing through the Kong data plane to create a baseline for healthy traffic. As anomalies are detected and addressed through changes to the Kong Enterprise configuration, Immunity continuously adapts this baseline.

### Autonomously Identify Anomalies
To identify potential issues, inefficiencies or performance bottlenecks, Immunity flags traffic that deviates from the expected or desired patterns without disrupting services. Depending on your needs and goals, you can adjust the settings of Immunity to recognize individual traffic events, patterns and other types of anomalous activity.

### Automatically Alert
How quickly you respond to an event can mean the difference between a simple fix and a catastrophic outage. As Immunity detects anomalies in real time, it automatically sends a notification alerting you to the issue. Notifications are available via Slack and more. To avoid disruptions to your teams, you can designate specific users to receive alerts based on Role-Based Access Controls (RBAC) within [Kong Manager](/enterprise/latest/kong-manager/overview/).

### Analyze and Address Anomalies
To help effectively remedy issues in your services, Immunity allows you to review anomalies to understand the root cause and take action. In conjunction with [Kong Vitals](/enterprise/latest/vitals/overview/), you can fully understand a service's anomalous behavior and address the issue with just a few clicks. As the usage of Immunity increases, it learns your baseline behavior and continuously refines its model to better detect or ignore anomalies.
