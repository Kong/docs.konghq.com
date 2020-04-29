---
name: Approov Mobile App Attestation
publisher: CriticalBlue Ltd

categories:
  - authentication

type: integration

desc: Ensure that only genuine mobile app instances can connect to your server or cloud backend

description: |
  With Approov, you control which apps can access your mobile app backend API in a secure and easily deployable manner. Users can confidently allow API access from iOS and Android devices knowing that Approov will only authenticate legitimate apps and does not rely on app-embedded secrets or keys.

  This capability prevents the misuse of your API by either automated software agents or unauthorized third-party apps, providing the basis for a range of API access management policies.

support_url: https://approov.zendesk.com/hc/en-gb/requests/new

source_url: https://github.com/approov/kong_approov-plugin

kong_version_compatibility:
  community_edition:
    compatible:
      - 1.5.x
      - 1.4.x
      - 1.3.x
  enterprise_edition:
    compatible:
      - 1.5.x

---

## Using the plugin

Learn how to integrate [Approov](https://approov.io) with the Kong Gateway by enabling the [Approov Token](https://www.approov.io/docs/latest/approov-usage-documentation/#approov-tokens) check with the native [Kong JWT plugin](https://docs.konghq.com/hub/kong-inc/jwt/), then using this plugin to add the [Approov Token Binding](https://www.approov.io/docs/latest/approov-usage-documentation/#token-binding) check.

### Approv quickstart

To quickly get started with integrating Approov in your current Kong Gateway, follow this condensed [guide](https://github.com/approov/blob/master/docs/APPROOV_QUICK_START.md).

### Aproov demo

This [demo](https://github.com/approov/blob/master/docs/APPROOV_KONG_PLUGIN_DEMO.md) shows both experienced and inexperienced Kong Gateway users how Approov can be integrated in the Kong Gateway, and also includes the Approov Token Binding check, an advanced feature of Approov.

### Kong Admin API

In both the quickstart guide and demo above, we access the Kong Admin API via `curl` requests to set up the Approov token check, just like it is done in the official docs for Kong.

- **Step by step:** Read the [Step by Step](https://github.com/approov/blob/master/docs/KONG_ADMIN_API_STEP_BY_STEP.md) guide for learning how to use the [./kong-admin](/bin/kong-admin.sh) helper script. This script wraps the `curl` requests for interacting with the Kong Admin API in order to setup the demo.
- **Deep dive:** Take a [deep dive](https://github.com/approov/blob/master/docs/KONG_ADMIN_API_DEEP_DIVE.md) to learn how to use the Kong Admin API with raw `curl` requests, and read the detailed explanations for each request.
