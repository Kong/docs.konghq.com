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
