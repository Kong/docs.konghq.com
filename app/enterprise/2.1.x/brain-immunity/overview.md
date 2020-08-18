---
title: Kong Brain & Kong Immunity Overview
---

**Kong Brain** and **Kong Immunity** help automate the entire API and service development life cycle. By automating processes for configuration, traffic analysis and the creation of documentation, Kong Brain and Kong Immunity help organizations improve efficiency, governance, reliability and security. Kong Brain automates API and service documentation and Kong Immunity uses advanced machine learning to analyze traffic patterns to diagnose and improve security.

![Kong Brain and Kong Immunity](/assets/images/docs/ee/brain_immunity_overview.png)

### About Kong Brain
Kong Brain automates tasks, increases visibility and ensures consistency across complex architectures. Other features include:

#### Visually Map Services
Get a high-level view of your architecture with a real-time visual service map. Analyze inter-service dependencies across teams and platforms to improve governance and minimize risk.

#### Auto-generate Documentation
Standardize docs with hands-free creation of OpenAPI spec files for all your services. Transition seamlessly to spec-first development to increase collaboration and developer efficiency.

#### Streamline Issue Resolution
Contextualize issues and take immediate action by surfacing Kong Immunity anomaly alerts in the service map. Rapidly identify issues impacting services to reduce risk and minimize downtime.


### About Kong Immunity
Kong Immunity autonomously identify service issues with machine learning-powered anomaly detection. Other features include:

#### Create a Baseline for Healthy Traffic
Traffic patterns provide a window into the behavior and performance of services under different conditions. To understand your existing traffic patterns, Kong Immunity ingests data flowing through the Kong data plane to create a baseline for healthy traffic. As anomalies are detected and addressed through changes to the Kong Enterprise configuration, Kong Immunity continuously adapts this baseline. 

#### Autonomously Identify Anomalies
To identify potential issues, inefficiencies or performance bottlenecks, Kong Immunity flags traffic that deviates from the expected or desired patterns without disrupting services. Depending on your needs and goals, you can adjust the settings of Kong Immunity to recognize individual traffic events, patterns and other types of anomalous activity.

#### Automatically Alert
How quickly you respond to an event can mean the difference between a simple fix and catastrophic outage. As Kong Immunity detects anomalies in real-time, it automatically sends a notification alerting you to the issue. Notifications are available via email, Slack and more. To avoid disruptions to your teams, you can designate specific users to receive alerts based on Roles Based Access Controls (RBAC) within Kong Manager. 

#### Analyze and Address Anomalies
To help effectively remedy issues in your services, Kong Immunity allows you to review anomalies to understand the root cause and take action. In conjunction with Kong Vitals, you can fully understand a service's anomalous behavior and address the issue with just a few clicks. As the usage of Kong Immunity increases, it learns your baseline behavior and continuously refines its model to better detect or ignore anomalies.
