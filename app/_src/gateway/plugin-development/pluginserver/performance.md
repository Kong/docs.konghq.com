---
title: External plugin performance
content_type: reference
---

Depending on implementation details, Go plugins are able to use multiple CPU cores
and so perform best on a multi-core system. JavaScript plugins are currently
single-core only and there's no dedicated plugin server support.
Python plugins can use a dedicated plugin server to span workload to
multiple CPU cores as well.

Unlike Lua plugins where invoking PDK functions are handled in local processes,
calling PDK functions in external plugins implies inter-process communications and so is a
relatively expensive operation. Because of the expense of calling PDK functions in external plugins, the performance of Kong using external plugins is
highly related to the number of IPC (inter-process communication) calls in each request.

The following graph demonstrates the correlation between performance and count of IPC
calls per request. Numbers of RPS and latency are removed as they are dependent on
hardware and to avoid confusion.

<center><img title="RPS" src="/assets/images/products/plugins/external-plugins/rps.png"/></center>

<center><img title="Latency" src="/assets/images/products/plugins/external-plugins/latency.png"/></center>