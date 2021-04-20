---
title: Vitals with InfluxDB
redirect_from: 
  - /enterprise/2.2.x/admin-api/vitals/vitals-influx-strategy
  - /enterprise/latest/admin-api/vitals/vitals-influx-strategy
---

## Overview

This document covers integrating Kong Vitals with a new or existing InfluxDB
time series server or cluster. Leveraging a time series database for Vitals data
can improve request and Vitals performance in very-high traffic {{site.ee_product_name}}
clusters (such as environments handling tens or hundreds of thousands of
requests per second), without placing addition write load on the database
backing the Kong cluster.

For using Vitals with a database as the backend (i.e. PostgreSQL, Cassandra), 
please refer to [Kong Vitals](/enterprise/{{page.kong_version}}/admin-api/vitals/).

## Setting up Kong Vitals with InfluxDB

### Step 1. Install Kong Gateway

If you have not installed {{site.base_gateway}}, a Docker installation will work for the purposes of this guide. 
See [Install {{site.base_gateway}} on Docker](/enterprise/{{page.kong_version}}/deployment/installation/docker)
for installation instructions.

**When you get to
[Step 5. Start the gateway with Kong Manager](/enterprise/{{page.kong_version}}/deployment/installation/docker/#start-gateway),
use the following configuration instead:**

```bash
$ docker run -d --name kong-ee --network=kong-ee-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-ee-database" \
  -e "KONG_PG_PASSWORD=kong" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -e "KONG_ADMIN_GUI_URL=http://<DNSorIP>:8002" \
  -e "KONG_VITALS_STRATEGY=influxdb" \
  -e "KONG_VITALS_TSDB_ADDRESS=influxdb:8086" \
  -p 8000:8000 \
  -p 8443:8443 \
  -p 8001:8001 \
  -p 8444:8444 \
  -p 8002:8002 \
  -p 8445:8445 \
  -p 8003:8003 \
  -p 8004:8004 \
  kong-ee
```

<div class="alert alert-ee blue">
<strong>Note:</strong> For <code>KONG_ADMIN_GUI_URL</code>, replace <code>&lt;DNSorIP&gt;</code>
with with the DNS name or IP of the Docker host. <code>KONG_ADMIN_GUI_URL</code>
<i>should</i> have a protocol, for example, <code>http://</code>.
</div>

If you already have a {{site.base_gateway}} instance, skip to Step 2.

### Step 2. Deploy a {{site.ee_product_name}} License

You will not be able to access the Kong Vitals functionality without a valid
{{site.ee_product_name}} license attached to your {{site.base_gateway}} instance.

See [Deploy an Enterprise License](/enterprise/{{page.kong_version}}/deployment/licenses/deploy-license)
for instructions to apply a license to your {{site.base_gateway}} instance.

If you already have a {{site.ee_product_name}} license attached to your {{site.base_gateway}}
instance, skip to Step 3.

### Step 3. Start an InfluxDB database

Production-ready InfluxDB installations should be deployed as a separate
effort, but for proof-of-concept testing, running a local InfluxDB instance
is possible via Docker:

```bash
$ docker run -p 8086:8086 \
  --network=<YOUR_NETWORK_NAME> \
  --name influxdb \
  -e INFLUXDB_DB=kong \
  influxdb:1.8.4-alpine
```

<div class="alert alert-warning">
You <strong>must</strong> use the listed version of
InfluxDB as the most recent version will <strong>not</strong> work.  
</div>

Writing Vitals data to InfluxDB requires that the `kong` database is created, 
this is done using the `INFLUXDB_DB` variable.

### Step 4. Configure {{site.base_gateway}}

<div class="alert alert-ee blue">
<strong>Note:</strong> If you used the configuration in 
<a href="#step-1-installing-kong-gateway-on-docker">Step 1. Installing {{site.base_gateway}} on Docker</a>,
then you do not need to complete this step.
</div>

In addition to enabling Kong Vitals, {{site.base_gateway}} must be configured to use InfluxDB as the
backing strategy for Vitals. The InfluxDB host and port must also be defined:

```bash
$ echo "KONG_VITALS_STRATEGY=influxdb KONG_VITALS_TSDB_ADDRESS=influxdb:8086 kong reload exit" \
| docker exec -i kong-ee /bin/sh
```

## InfluxDB Measurements

Kong Vitals records metrics in two InfluxDB measurements- `kong_request`, which
contains field values for request latencies and HTTP, and tags for various Kong
entities associated with the requests (e.g., the Route and Service in question,
etc.), and `kong_datastore_cache`, which contains points about cache hits and
misses. Measurement schemas are listed below:

```
> show tag keys
name: kong_request
tagKey
------
consumer
hostname
route
service
status_f
wid
workspace

name: kong_datastore_cache
tagKey
------
hostname
wid
```

```
> show field keys
name: kong_request
fieldKey	         fieldType
--------	         ---------
kong_latency       integer
proxy_latency      integer
request_latency    integer
status             integer

name: kong_datastore_cache
fieldKey  fieldType
--------  ---------

hits      integer
misses    integer
```

The tag `wid` is used to differentiate the unique worker ID per host, to avoid
duplicate metrics shipped at the same point in time.

As demonstrated above, the series cardinality of the `kong_request` measurement
varies based on the cardinality of the Kong cluster configuration - a greater
number of Service/Route/Consumer/Workspace combinations handled by Kong results
in a greater series cardinality as written by Vitals. Please consult the
[InfluxDB sizing guidelines](https://docs.influxdata.com/influxdb/v1.7/guides/hardware_sizing/)
for reference on appropriately sizing an InfluxDB node/cluster. Note that the
query behavior when reading Vitals data falls under the "moderate" load
category as defined by the above document - several `GROUP BY` statements and
functions are used to generate the Vitals API responses, which can require
significant CPU resources to execute when hundreds of thousands or millions of
data points are present.

## Query Behavior

Kong buffers Vitals metrics and writes InfluxDB points in batches to improve
throughput in InfluxDB and reduce overhead in the Kong proxy path. Each Kong
worker process flushes its buffer of metrics every 5 seconds or 5000 data points,
whichever comes first.

Metrics points are written with microsecond (`u`) precision. To comply with
the [Vitals API](/enterprise/{{page.kong_version}}/admin-api/vitals/#vitals-api), measurement
values are read back grouped by second. Note that due to limitations in the
OpenResty API, writing values with microsecond precision requires an additional
syscall per request.

Currently, Vitals InfluxDB data points are not downsampled or managed via
retention policy by Kong. InfluxDB operators are encouraged to manually manage
the retention policy of the `kong` database to reduce the disk space and memory
needed to manage Vitals data points. Currently, Kong Vitals ignores data points
older than 25 hours; it is safe to create a retention policy with a 25-hour
duration for measurements written by Kong.
