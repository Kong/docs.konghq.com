---
title: Kong Brain and Kong Immunity Overview
---

## Overview

**Kong Brain** (Brain) and **Kong Immunity** (Immunity) help automate the entire API and service development life cycle. By automating processes for configuration, traffic analysis and the creation of documentation, Brain and Immunity help organizations improve efficiency, governance, reliability and security.  Brain automates API and service documentation and Immunity uses advanced machine learning to analyze traffic patterns to diagnose and improve security.

![Kong Brain and Kong Immunity](/assets/images/docs/ee/brain_immunity_overview.png)

Brain and Immunity are installed on Kong Enterprise, either on Kubernetes or Docker. The Collector App and Collector Plugin enable Brain and Immunity to communicate with Kong Enterprise. The diagram above illustrate how the components work together.


## About Kong Brain
Brain automates tasks, increases visibility, and ensures consistency across complex architectures. Other features include:

### Visually Map Services
Get a high-level view of your architecture with a real-time visual service map. Analyze inter-service dependencies across teams and platforms to improve governance and minimize risk. See [Using the Service Map](/enterprise/{{page.kong_version}}/brain-immunity/service-map/).

### Auto-generate Documentation
Standardize docs with hands-free creation of OpenAPI spec files for all your services. Transition seamlessly to spec-first development to increase collaboration and developer efficiency. See [Auto-Generated Specs](/enterprise/{{page.kong_version}}/brain-immunity/auto-generated-specs/).

### Streamline Issue Resolution
Contextualize issues and take immediate action by surfacing Immunity anomaly alerts in the service map. Rapidly identify issues impacting services to reduce risk and minimize downtime.

## About Kong Immunity
Immunity autonomously identifies service issues with machine learning-powered anomaly detection. Other features include:

### Create a Baseline for Healthy Traffic
Traffic patterns provide a window into the behavior and performance of services under different conditions. To understand your existing traffic patterns, Immunity ingests data flowing through the Kong data plane to create a baseline for healthy traffic. As anomalies are detected and addressed through changes to the Kong Enterprise configuration, Immunity continuously adapts this baseline.

### Autonomously Identify Anomalies
To identify potential issues, inefficiencies or performance bottlenecks, Immunity flags traffic that deviates from the expected or desired patterns without disrupting services. Depending on your needs and goals, you can adjust the settings of Immunity to recognize individual traffic events, patterns and other types of anomalous activity.

### Automatically Alert
How quickly you respond to an event can mean the difference between a simple fix and a catastrophic outage. As Immunity detects anomalies in real-time, it automatically sends a notification alerting you to the issue. Notifications are available via Slack and more. To avoid disruptions to your teams, you can designate specific users to receive alerts based on Role-Based Access Controls (RBAC) within [Kong Manager](/enterprise/latest/kong-manager/overview/).

### Analyze and Address Anomalies
To help effectively remedy issues in your services, Immunity allows you to review anomalies to understand the root cause and take action. In conjunction with [Kong Vitals](/enterprise/latest/vitals/overview/), you can fully understand a service's anomalous behavior and address the issue with just a few clicks. As the usage of Immunity increases, it learns your baseline behavior and continuously refines its model to better detect or ignore anomalies.
