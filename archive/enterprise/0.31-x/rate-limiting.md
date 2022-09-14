---
title: Enterprise Rate Limiting Library
---

## Overview

This library is designed to provide an efficient, scalable, eventually-consistent sliding window rate limiting library. It relies on atomic operations in shared ngx memory zones to track window counters within a given node, periodically syncing this data to a central data store (current Cassandra, Postgres, and Redis).

A sliding window rate limiting implementation tracks the number of hits assigned to a specific key (such as an IP address, Consumer, Credential, etc) within a given time window, taking into account previous hit rates to smooth out a calculated rate, while still providing a familiar windowing interface that modern developers are used to (e.g., n hits per second/minute/hour). This is similar to a fixed window implementation, in which request rates reset at the beginning of the window, but without the "reset bump" from which fixed window implementations suffer, while providing a more intuitive interface beyond what leaky bucket or token bucket implementations can offer. Note that we use the term "hit" instead of "request" when referring to incrementing values for rate limit keys, because this library provides an abstract rate limiting interface; a sliding window implementation may have uses outside of HTTP request rate limiting, thus, we describe this library in a more abstract sense.

A sliding window takes into account a weighted value of the previous window when calculating the current rate for a given key. A window is defined as a period of time, starting at a given "floor" timestamp, where the floor is calculated based on the size of the window. For window sizes of 60 seconds, the floor always falls at the 0th second (e.g., at the beginning of any given minute). Likewise, windows with a size of 30 seconds will begin at the 0th and 30th seconds of each minute.

Consider a rate limit of 10 hits per minute. In this configuration, this library will calculate the hit rate of a given key based on the number of hits for the current window (starting at the beginning of the current minute), and a weighted percentage of all hits of the previous window (e.g., the previous minute). This weight is calculated based on the current timestamp with respect to the window size in question; the farther away the current time is from the start of the previous window, the lower the weight percentage. This value is best expressed through an example:

```
current window rate: 10
previous window rate: 40
window size: 60
window position: 30 (seconds past the start of the current window)
weight = .5 (60 second window size - 30 seconds past the window start)

rate = 'current rate' + 'previous weight' * 'weight'
     = 10             + 40                * ('window size' - 'window position') / 'window size'
     = 10             + 40                * (60 - 30) / 60
     = 10             + 40                * .5
     = 30
```
Strictly speaking, the formula used to define the weighting percentage is as follows:

`weight = (window_size - (time() % window_size)) / window_size`

Where `time()` is the value of the current Unix timestamp.

Each node in the Kong cluster relies on its own in-memory data store as the source of truth for rate limiting counters. Periodically, each node pushes a counter increment for each key it saw to the cluster, which is expected to atomically apply this diff to the appropriate key. The node then retrieves this key's value from the data store, along with other relevant keys for this data sync cycle. In this manner, each node shares the relevant portions of data with the cluster, while relying on a very high-performance method of tracking data during each request. This cycle of converge -> diverge -> reconverge among nodes in the cluster provides our eventually-consistent model.

he periodic rate at which nodes converge is configurable; shorter sync intervals will result in less divergence of data points when traffic is spread across multiple nodes in the cluster (e.g., when sitting behind a round robin balancer), whereas longer sync intervals put less r/w pressure on the datastore, and less overhead on each node to calculate diffs and fetch new synced values. The desirable value here depends on use case; when using cluster syncing to refresh nodes periodically (e.g., to inform new cluster nodes of counter data), a value of 10-30 seconds may be desirable, to minimize data store traffic. Contrarily, environments demanding stronger consistency between nodes (such as orchestrated deployments involving a high churn rate among cluster membership, or cases where strict rate limiting policies must be applied to node sitting behind a non-hashing load balancer) should use a lower sync period, on the order of milliseconds. The minimum possible value is 0.001 (1 millisecond), though practically this value is limited by network performance between Kong nodes and the configured data store.

In addition to periodic data sync behavior, this library can implement rate limiting counter in a synchronous pattern by defining its `sync_rate` as `0`. In such a case, the given counter will be applied directly to the datastore. This behavior is desirable in cases where stronger consistency among the cluster is desired; such a configuration comes with the cost of needing to communicate with the datastore (or Redis) on every request, which can induce noticeable latency into the request ("noticeable" being a relative term of typically a few milliseconds, depending on the performance of the storage mechanism in question; for comparison, Kong typically processes requests on the order of tens of microseconds).

This library can also forgo syncing counter data entirely, and only apply incremental counters to its local memory zone, by defining a `sync_rate` value of less than `0`. This behavior is useful when cluster-wide syncing of data is unnecessary, such as environments using only a single Kong node, or where Kong nodes live behind a hashing load balancer and are treated as isolated instances.

Module configuration data, such as sync rate, shared dictionary name, storage policy, etc, is kept in a per-worker public configuration table. Multiple configurations can be defined as stored as arbitrary `namespaces` (more on this below).

## Developer Notes
### Public Functions
The following public functions are provided by this library:

`ratelimiting.new`

_syntax: ok = ratelimiting.new(opts)_

Define configurations for a new namespace. The following options are accepted:

- dict: Name of the shared dictionary to use
- sync_rate: Rate, in seconds, to sync data diffs to the storage server.
- strategy: Storage strategy to use. currently cassandra, postgres, and redis are supported. Strategies must provide several public - functions defined below.
- strategy_opts: A table of options used by the storage strategy. Currently only applicable for the 'redis' strategy.
- namespace: String defining these config values. A namespace may only be defined once; if a namespace has already been defined on this worker, an error is thrown. If no namespace is defined, the literal string "default" will be used.
- window_sizes: A list of window sizes used by this configuration.

`ratelimiting.increment`

_syntax: rate = ratelimiting.increment(key, window_size, value, namespace?)_

Increment a given key for window_size by value. If namespace is undefined, the "default" namespace is used. value can be any number Lua type (but ensure that the storage strategy in use for this namespace can support decimal values if a non-integer value is provided). This function returns the sliding rate for this key/window_size after the increment of value has been applied.

`ratelimit.sliding_window`

_syntax: rate = ratelimit.sliding_window(key, window_size, cur_diff?, namespace?)_

Return the current sliding rate for this key/window_size. An optional cur_diff value can be provided that overrides the current stored diff for this key. If `namespace` is undefined, the "default" namespace is used.

`ratelimiting.sync`

_syntax: ratelimiting.sync(premature, namespace?)_

Sync all currently stored key diffs in this worker with the storage server, and retrieve the newly synced value. If namespace is undefined, the "default" `namespace` is used. Before the diffs are pushed, another sync call for the given namespace is scheduled at `sync_rate` seconds in the future. Given this, this function should typically be called during the `init_worker` phase to initialize the recurring timer. This function is intended to be called in an `ngx.timer` context; hence, the first variable represents the injected `premature` param.

`ratelimiting.fetch`

_syntax: ratelimiting.fetch(premature, namespace, time, timeout?)_

Retrieve all relevant counters for the given namespace at the given time. This function establishes a shm mutex such that only one worker will fetch and populate the shm per execution. If timeout is defined, the mutex will expire based on the given timeout value; otherwise, the mutex is unlocked immediately following the dictionary update. This function can be called in an `ngx.timer` context; hence, the first variable represents the injected `premature` param.

### Strategy Functions

Storage strategies must provide the following interfaces:

#### strategy_class.new
_syntax: strategy = strategy_class.new(dao_factory, opts)_

Implement a new strategy object. `opts` is expected to be a table type, and can be used to pass opaque/arbitrary options to the strategy class.

#### strategy:push_diffs
_syntax: strategy:push_diffs(diffs)_

Push a table of key diffs to the storage server. diffs is a table provided in the following format:

```
[1] = {
    key = "1.2.3.4",
    windows = {
      {
        window    = 12345610,
        size      = 60,
        diff      = 5,
        namespace = foo,
      },
      {
        window    = 12345670,
        size      = 60,
        diff      = 5,
        namespace = foo,
      },
    }
  },
  ...
  ["1.2.3.4"] = 1,
  ...
  ```

#### strategy:get_counters

_syntax: rows = strategy:get_counters(namespace, window_sizes, time?)_

Return an iterator for each key stored in the datastore/redis for a given `namepsace` and list of window sizes. 'time' is an optional unix second- precision timestamp; if not provided, this value will be set via `ngx.time()`. It is encouraged to pass this via a previous defined timestamp, depending on the context (e.g., if previous calls in the same thread took a nontrivial amount of time to run).

#### strategy:get_window

_syntax: window = strategy:get_window(key, namespace, window_start, window_size)_

Retrieve a single key from the data store based on the values provided.
