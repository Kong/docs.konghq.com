---
title: Performance Benchmark
header_icon: /assets/images/icons/icn-documentation.svg
header_title: Performance Benchmark
redirect_to: https://konghq.com/about-kong/benchmark/


# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# FIXME This file is dead code - it is no longer being rendered or utilized,
# and updates to this file will have no effect.
#
# The remaining contents of this file (below) will be deleted soon.
#
# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!


---

We set Kong up on AWS and load tested it to get some performance metrics. The setup consisted of three `m3.medium` EC2 instances; one for Kong, one for Cassandra and a third for an upstream API. After adding the upstream API's `upstream_url` into Kong we load tested from 1 to 2000 concurrent connections. Complete [reproduction instructions](https://gist.github.com/montanaflynn/01376991f0a3ad07059c) are available and we are currently working towards automating a suite of benchmarks to compare against subsequent releases.

Over two minutes **117,185** requests with an average latency of **10ms** at **976 requests a second** or about **84,373,200 requests a day** went through Kong and back with only a single timeout.

![Benchmark](/assets/images/benchmark.png)
