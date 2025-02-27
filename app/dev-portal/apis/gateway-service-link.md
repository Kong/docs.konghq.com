---
title: Link Gateway Service
---

Konnect APIs support linking to a Konnect Gateway Service, in order to enable Developer self-service to generate credentials /  API keys. This link will install the Konnect Application Auth (KAA) plugin on that service. The KAA plugin can only be configured from the associated Dev Portal/Published APIs.

> When linking an **API** to a **Gateway Service**, it is currently a 1:1 mapping. 

## Linking your Gateway Service to an API
* Browse to a **APIs**, or **Published APIs** for a specific Dev Portal, and select a specific API
* Click on the **Gateway Service** tab
* Click **Link Gateway Service**
* Select the appropriate Control Plane and Gateway Service
* Click **Submit**

In order for the Gateway Service to actually restrict access to the API, [learn more](/konnect/dev-portal/app-reg/index.md) about the configuring Developer & Application Registration for your Dev Portal.