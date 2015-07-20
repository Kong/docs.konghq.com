---
title: Benchmark
---

# Performance Benchmark

We set Kong up on AWS and load tested it to get some performance metrics. The setup consisted of three `m3.medium` EC2 instances; one for Kong, one for Cassandra and a third for an upstream API. After adding the upstream API's `target_url` into Kong we load tested from 1 to 2000 concurrent connections. Complete [reproduction instructions](https://gist.github.com/montanaflynn/01376991f0a3ad07059c) are available and we are currently working towards automating a suite of benchmarks to compare against subsequent releases.

Over two minutes **117,185** requests with an average latency of **10ms** at **976 requests a second** or about **84,373,200 requests a day** went through Kong and back with only a single timeout.

![Benchmark](/assets/images/benchmark.png)
