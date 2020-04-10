---
title: Kong Vitals with InfluxDB
---

## Overview

This document covers integrating Kong Vitals with a new or existing InfluxDB
time series server or cluster. Leveraging a time series database for Vitals data
can improve request and Vitals performance in very-high traffic Kong Enterprise
clusters (such as environments handling tens or hundreds of thousands of
requests per second), without placing addition write load on the database
backing the Kong cluster.

For using Vitals with a database as the backend (i.e. PostgreSQL, Cassandra), 
please refer to [Kong Vitals](/enterprise/{{page.kong_version}}/admin-api/vitals/).

## Getting Started

### Preparing InfluxDB

This guide assumes an existing InfluxDB server or cluster is already installed
and is accepting write traffic. Production-ready InfluxDB installations should
be deployed as a separate effort, but for proof-of-concept testing, running a 
local InfluxDB instance is possible via Docker:

```bash
$ docker run -p 8086:8086 \
      -v $PWD:/var/lib/influxdb \
      -e INFLUXDB_DB=kong \
      influxdb
```

Writing Vitals data to InfluxDB requires that the `kong` database is created, 
this is done using the `INFLUXDB_DB` variable.

### Configuring Kong

In addition to enabling Vitals, Kong must be configured to use InfluxDB as the
backing strategy for Vitals. The InfluxDB host and port must also be defined:

```
vitals_strategy = influxdb
vitals_tsdb_address = 127.0.0.1:8086 # the IP or hostname, and port, of InfluxDB
```

As with other Kong configurations, changes take effect on kong reload or kong
restart.

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
