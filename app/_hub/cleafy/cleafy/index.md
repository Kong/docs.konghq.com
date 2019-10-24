---
name: Cleafy plugin for Kong
publisher: Cleafy

categories:
  - security

type: plugin

desc: Integrate Kong API Gateway with Cleafy threat detection & protection for API-based apps
description: |
  Cleafy patented threat detection & protection technology protects web and mobile
  apps against the most advanced attacks from malware based on Man-In-The-Browser
  (MITB), Man-In-The-Middle (MITM), RAT-in-The-Browser, Mobile Overlay,
  SMS Grabbing and other vectors. Cleafy is client-less and does neither impact
  the user experience nor the endpoint performance. Cleafy is application-transparent
  and does not require any change to the monitored application. Cleafy smoothly
  integrates into any application delivery architecture, typically at ADC or API
  Gateway level. Cleafy plugin for Kong makes possible to leverage Cleafy in any
  Kong-powered architecture. For more details visit https://cleafy.com/resources.

support_url: https://www.cleafy.com

# license_type: "Included in the standard Cleafy license"
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

privacy_policy_url: https://www.iubenda.com/privacy-policy/31282315

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.13.x
      - 0.14.x
  enterprise_edition:
    compatible:
      - 0.33-x
      - 0.34-x

params:
  name: cleafy
  api_id: true
  service_id: true
  consumer_id: true
  route_id: true

  config:
    - name: api_address
      required: yes
      default:
      value_in_examples: http://cleafy.com
      description: Specifies the URL pointing to the Cleafy API.
    - name: accept_encoding
      required: no
      default:
      value_in_examples:
      description: |
        Specifies the type of encoding accepted from the backend server. This
        plugin does not support gzip-encoded requests.

###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# Your headers must be Level 3 or 4 (parsing to h3 or h4 tags in HTML).
# This is represented by ### or #### notation preceding the header text.
###############################################################################
# BEGIN MARKDOWN CONTENT
---

### Cleafy-Stream Kong plugin

### Installation

Plugin installation mainly depends on where your Kong installation runs:

#### Standalone Installation
Once the .rock file has been obtained from your Cleafy distributor it can be installed using the luarocks package manager.
```
luarocks install cleafy-plugin-for-kong-VERSION.rock
```

### Typical configuration (via curl)

Register Cleafy backend as a Kong service:

```shell
$ curl -i -X POST --url http://url-to-kong-api:8001/services/ --data 'name=cleafy'  --data 'url=<url-to-cleafy-api>'
```

Moreover, each application you want to manage via Kong must be registered as a service:

```shell
$ curl -i -X POST --url http://url-to-kong-api:8001/services/ --data 'name=app1'  --data 'url=<url-to-app1-application-server>'
```

For each application registered (Cleafy excluded) you must define two Kong routes: the first routing traffic to the application server and the second routing traffic to the Cleafy backend:

```shell
$ curl -i -X POST --url http://url-to-kong-api:8001/routes/ --data 'hosts[]=<hostname>' --data 'service.id=<cleafy-service-id>' --data 'paths[]=/<ingestion-prefix>'

$ curl -i -X POST --url http://url-to-kong-api:8001/routes/ --data 'hosts[]=<hostname>' --data 'service.id=<app-service-id>'
```

Then you must activate the *stream* plugin over **each** app-related route:

```shell
$ curl -i -X POST --url http://url-to-kong-api:8001/plugins/ --data 'name=stream' --data 'route_id=<app-route-id' --data 'config.api_address=<cleafy-api-address>' --data 'config.api_token=<ingestion-token>'
```
