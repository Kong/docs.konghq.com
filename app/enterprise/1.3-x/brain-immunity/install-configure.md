---
title: Kong Brain & Kong Immunity Installation and Configuration Guide
---

**Kong Brain** and **Kong Immunity** help automate the entire API and service development life cycle. By automating processes for configuration, traffic analysis and the creation of documentation, Kong Brain and Kong Immunity help organizations improve efficiency, governance, reliability and security. Kong Brain automates API and service documentation and Kong Immunity uses advanced machine learning to analyze traffic patterns to diagnose and improve security.

![Kong Brain and Kong Immunity](https://doc-assets.konghq.com/1.3/brain_immunity/KongBrainImmunity_overview.png)

## Overview
Kong Brain and Kong Immunity are installed as add-ons on Kong Enterprise, using a Collector App and a Collector Plugin to communicate with Kong Enterprise. The diagram illustrates how the Kong components work together, and are described below:
* **Kong Enterprise**
* **Kong Brain** (Brain) and **Kong Immunity** (Immunity) add-ons to your purchase of Kong Enterprise.
* **Collector App** enables communication between Kong Enterprise and Brain and Immunity. The Kong Collector App comes with your purchase of Bran and Immunity.
* **Collector Plugin** enables communication between Kong Enterprise and Kong Collector App. The Kong Collector Plugin comes with your purchase of Brain and Immunity.

## Version Compatibility

Kong Brain is deprecated, and Kong Immunity is no longer compatible with Kong Enterprise v1.3-x. To use Kong Immunity, you need to upgrade to Kong Enterprise v1.5.x or above.
See [Migrating to 1.5](/enterprise/1.5.x/deployment/migrations/) for more information.
