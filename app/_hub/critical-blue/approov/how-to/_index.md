## APPROOV TOKEN PLUGIN

Learn how to integrate [Approov](https://approov.io){:target="_blank"}{:rel="noopener noreferrer"} in the [Kong API Gateway](https://konghq.com/kong/) by enabling the [Approov Token](https://www.approov.io/docs/latest/approov-usage-documentation/#approov-tokens){:target="_blank"}{:rel="noopener noreferrer"} check with the native [Kong JWT plugin](https://docs.konghq.com/hub/kong-inc/jwt){:target="_blank"}{:rel="noopener noreferrer"}, and use this plugin to add the [Approov Token Binding](https://www.approov.io/docs/latest/approov-usage-documentation/#token-binding){:target="_blank"}{:rel="noopener noreferrer"} check.

**NOTE:**
The Kong compatibility list of supported versions for the Approov Token plugin is not exhaustive, previous versions not listed may work, but are untested. Please [contact us](https://info.approov.io/contact-us){:target="_blank"}{:rel="noopener noreferrer"} in case you need to integrate Approov with untested or incompatible Kong versions.

### APPROOV QUICK START

For a quick start of integrating Approov in your current Kong API Gateway please follow this [guide](https://github.com/approov/kong_approov-plugin/blob/master/docs/APPROOV_QUICK_START.md){:target="_blank"}{:rel="noopener noreferrer"}.


### APPROOV DEMO

This [demo](https://github.com/approov/kong_approov-plugin/blob/master/docs/APPROOV_KONG_PLUGIN_DEMO.md) has the goal of showing to both experienced and inexperienced Kong users how Approov can be integrated into the Kong API Gateway, and also includes the Approov Token Binding check, an advanced feature of Approov, that can be used to bind a user authentication token with the Approov token.


### KONG ADMIN

In order to setup the Approov Token check in the quick start and in the demo we have used the Kong Admin API via `curl` requests, as in the official Kong docs.

#### Step by Step

Read the [Step by Step](https://github.com/approov/kong_approov-plugin/blob/master/docs/KONG_ADMIN_API_STEP_BY_STEP.md){:target="_blank"}{:rel="noopener noreferrer"} guide to learn how to use the [./kong-admin](https://github.com/approov/kong_approov-plugin/blob/master/bin/kong-admin.sh){:target="_blank"}{:rel="noopener noreferrer"} helper script. This script wraps the `curl` requests for interacting with the Kong Admin API to setup the demo.

#### Deep Dive

Take the [deep dive](https://github.com/approov/kong_approov-plugin/blob/master/docs/KONG_ADMIN_API_DEEP_DIVE.md){:target="_blank"}{:rel="noopener noreferrer"} to learn how to use the Kong Admin API with raw `curl` requests and read the detailed explanations for each request.
