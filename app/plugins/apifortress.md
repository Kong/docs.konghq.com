---
id: page-plugin
title: Plugins - API Fortress
header_title: API Fortress
header_icon: /assets/images/icons/plugins/apifortress.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: How it works
      - label: Configuration
---
This plugin forward s serialized request / response bundles to the [API Fortress] platform for full payload testing. Send the bundles to API Fortress in the **cloud** or the **on-prem engine instance**.

Create the tests in the API Fortress visual composer. Tests can verify every detail of an API conversation - including request and response headers, and every field in an XML, JSON, or plain text payload.

If a test fails, you will be notified via email, SMS, or any 3rd party app you configure in the API Fortress dashboard.

Use different projects for different environments to host tests for development, staging, or production. Select which by configuring the Kong plugin.

----

## How it works

The plugin sends serialized traffic to your API Fortress account, identified by an api key.
The number of bundles being sent can be limited during configuration by setting the threshold key.
In the configuration you're also allowed to select the project that will host the tests.

For each bundle, API Fortress will choose which tests need to run, using the [Automatch] pattern configuration against the origin URL.

----

## Configuration



```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins/ \
    --data "name=apifortress" \
    --data "config.endpoint=CHOSEN_ENDPOINT" \
    --data "config.apikey=YOUR_API_KEY" \
    --data "config.secret=YOUR_SECRET" \
    --data "config.projectId=YOUR_PROJECT_ID" \
    --data "config.threshold=THRESHOLD_SETTING"
```



parameter                          | description
---                                | ---
`name`                             | The name of the plugin
`config.endpoint`                  | The endpoint to send the requests to. The default for the cloud service is `https://mastiff.apifortress.com/app/api/rest/v2/test/runAutomatch`
`config.apikey`                    | Identifies your company in API Fortress
`config.secret`                    | Works as a cypher passphrase
`config.projectId`                 | The id of the project hosting the tests
`config.threshold`                 | A number working as a limit to the number of forwarded bundles. Every multiple of `threshold` will be sent. Ie. if threshold is 3, then the 3rd, 6th, 9th are sent

----
## Notes
- This plugin can generate a lot of outbound traffic. We suggest you adjust the threshold setting accordingly.
- To use this plugin with the cloud service, you will need at least a Tier 1 account.

[API Fortress]: http://apifortress.com
[Automatch]: http://apifortress.com/doc/automatch/
