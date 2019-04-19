---

name: Route By Header
publisher: Kong Inc.
version: 0.34-x

desc: Route request based on request headers
description: |
   Kong Enterprise plugin to route requests based on request headers.
enterprise: true
type: plugin
categories:
  - traffic-control

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 0.34-x

params:
  name: route-by-header
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: rules
      required: false
      default: {}
      value_in_examples:
      description: |
        List of [rules](#rules)

---

## Rules

| parameter | description |
| --- | --- |
| `condition` |  List of headers name and value pairs |
| `upstream_name` |  Target hostname where traffic will be routed in case of condition match |

Note: if more than one pair of header name and value is provided, the plugin looks for all of these
in the request - that is, requests must contain all of the specified headers with the specified
values for a match to occur.

## Usage

The plugin will route a request to a new upstream target if it matches one of the
configured rules. Each `rule` consists of a `condition` object and an
`upstream_name` object. For each request coming into Kong, the plugin will try to find a `rule` where
all the headers defined in the `condition` field have the same value as in the incoming request.
The first such match dictates the upstream to which the request is forwarded to.

## Example

Let's run through an example scenario to demonstrate the plugin. Let's say we have
a Kong service `searviceA`, which routes all the requests to upstream `default.domain.com`.

Add an upstream object and a target:

```bash
$ curl -i -X POST http://kong:8001/upstreams -d name=default.domain.com
HTTP/1.1 201 Created
...
{created_at":1534537731231, .. "slots":10000}
```

```bash
$ curl -i -X POST http://kong:8001/upstreams/default.domain.com/targets --data target="default.host.com:9000"
HTTP/1.1 201 Created
...
{"created_at":1534538010468, .. ,"id":"ffd8815b-fd6c-4e0e-aa67-06e9cda39c3b"}
```

Now we will add a `service` and a `route` object, using the upstream `default.domain.com` we just created:

```bash
$ curl -i -X POST http://kong:8001/services --data protocol=http --data host=default.domain.com --data name=serviceA
HTTP/1.1 201 Created
...
{"host":"default.domain.com", .. ,"write_timeout":60000}
```

```bash
$ curl -i -X POST http://kong:8001/routes  --data "paths[]=/" --data service.id=6e7f5274-62da-469e-bdd5-03c4a212c15b
HTTP/1.1 201 Created
...
{"created_at":1534538701, .. ,"id":"12ceb66b-51ed-488a-9de0-112270e6f370"}
```

Now any request made to service `serviceA` will be routed to the upstream `default.domain.com`.
But let's say we want to route some of these requests to different upstreams, dynamically, based on some
information provided through request headers. This is the exact situation where this plugin can be helpful.

Let's apply this plugin on `serviceA` to route all requests with a header `Location`
set to `us-east` to upstream `east.domain.com` and requests with a header `Location`
set to `us-west` to upstream `west.domain.com`.

Add the two upstreams and corresponding targets:

```bash
$ curl -i -X POST http://localhost:8001/upstreams -d name=east.domain.com
HTTP/1.1 201 Created
...
{"created_at":1534541064946, .. ,"slots":10000}
```

```bash
$ curl -i -X POST http://kong:8001/upstreams/east.domain.com/targets --data target="east.host.com:9001"
HTTP/1.1 201 Created
...
{"created_at":1534541248416, .. ,"id":"3164a588-09d7-4a72-895f-fa19535e3682"}
```

```bash
$ curl -i -X POST http://localhost:8001/upstreams -d name=west.domain.com
HTTP/1.1 201 Created
...
{"created_at":1534541385227, .. ,"slots":10000}
```

```bash
$ curl -i -X POST http://kong:8001/upstreams/west.domain.com/targets --data target="west.host.com:9002"
HTTP/1.1 201 Created
...
{"created_at":1534541405038, .. ,"id":"96cb469f-280f-4b0a-bd3d-1a0599b82585"}
```

Enable plugin on service `serviceA`:

```bash
$ curl -i -X POST http://kong:8001/services/serviceA/plugins -H 'Content-Type: application/json' --data '{"name": "route-by-header", "config": {"rules":[{"condition": {"location":"us-east"}, "upstream_name": "east.doamin.com"}, {"condition": {"location":"us-west"}, "upstream_name": "west.doamin.com"}]}}'
HTTP/1.1 201 Created
...
{"created_at":1534540916000,"config":{"rules":{"":"{\"condition\": {\"location\":\"us-east\"}, \"upstream_name\": \"east.doamin.com\"}, {\"condition\": {\"location\":\"us-west\"}, \"upstream_name\": \"west.doamin.com\"}"}},"id":"0df16085-76b2-4a50-ac30-c8a1eade389a","enabled":true,"service_id":"6e7f5274-62da-469e-bdd5-03c4a212c15b","name":"route-by-header"}

```

Now, any request with header `Location` set to `us-east` will route to upstream
`east.domain.com` and requests with header `Location` set to `us-west` will route
to upstream `west.domain.com`.

You can also provide multiple headers as matching condition. The plugin does an `AND`
on the provided headers in the `condition` field of each rule.

Let's patch above plugin to add one more rule with multiple headers:

```bash
$ curl -i -X PATCH http://kong:8001/plugins/0df16085-76b2-4a50-ac30-c8a1eade389a -H 'Content-Type: application/json' --data '{"name": "route-by-header", "config": {"rules":[{"condition": {"location":"us-east"}, "upstream_name": "east.doamin.com"}, {"condition": {"location":"us-west"}, "upstream_name": "west.doamin.com"},  {"condition": {"location":"us-south", "region": "US"}, "upstream_name": "south.doamin.com"}]}}'
HTTP/1.1 200 OK
...
{"created_at":1534540916000,"config":{"rules":{"":"{\"condition\": {\"location\":\"us-east\"}, \"upstream_name\": \"east.doamin.com\"}, {\"condition\": {\"location\":\"us-west\"}, \"upstream_name\": \"west.doamin.com\"}, {\"condition\": {\"location\":\"us-south\", \"region\": \"us\"}, \"upstream_name\": \"south.doamin.com\"}"}},"id":"0df16085-76b2-4a50-ac30-c8a1eade389a","enabled":true,"service_id":"6e7f5274-62da-469e-bdd5-03c4a212c15b","name":"route-by-header"}
```

Now we have an additional rule which routes any request with header `Location` set to
`us-south` and `Region` set to `US` route to upstream `south.domain.com`.
