---
name: Cleafy plugin for Kong
publisher: Cleafy

#header_icon: #FIXME # (optional) Uncomment only if you are submitting an icon

categories:
  - security

type: plugin

desc: Integrate Kong API GW with Cleafy threat detection & protection for API-based apps

description: | 
  Cleafy protects online services against today’s targeted attacks. Cleafy patented real-time threat detection and protection technology is effective in detecting account takeover and transaction tampering leveraging Man-In-The-Browser (MITB), Man-In-The-Middle (MITM), Mobile Overlay, SIM Swap, API Abuse, and others advanced techniques.

  Cleafy real-time continuous risk assessment prevents sensitive data loss and payment fraud while minimizing false positives and operational impact. Cleafy threat visibility also makes possible to implement automated threat responses and an adaptive security posture.

  Cleafy is client-less and does not require any change to the monitored applications. Cleafy passively monitors application traffic by integrating into any application delivery architecture, typically at ADC or API Gateway level. Cleafy plugin for Kong allows Cleafy to smoothly integrate into any Kong-powered architecture. 

  For more details visit [the Cleafy resources page](https://cleafy.com/resources){:target="_blank"}{:rel="noopener noreferrer"}.

support_url: https://www.cleafy.com

license_type: Included in the standard Cleafy license

privacy_policy_url: https://www.iubenda.com/privacy-policy/31282315

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.13.x
      - 0.14.x
      - 1.0.x
      - 1.1.x
      - 1.2.x
      - 1.3.x
      - 1.4.x
      - 1.5.x
      - 2.0.x
      - 2.1.x
  enterprise_edition:
    compatible:
      - 0.33-x
      - 0.34-x
      - 0.35-x
      - 0.36-x

params:
  name: cleafy-plugin-for-kong
  api_id: false
  service_id: false
  consumer_id: false
  route_id: true
  dbless_compatible: yes
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
      description: Specifies the type of encoding accepted from the backend server. This plugin does not support gzip-encoded requests.
      
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
