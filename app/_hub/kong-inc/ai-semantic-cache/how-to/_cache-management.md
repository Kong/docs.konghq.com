---
nav_title: Cache management
title: Cache management
---

can get and set cache

basic cache management system

Time-to-live (TTLs) for entries

Basic Cache Eviction Policies (e.g. LFU/FIFO strategies)

Cache Size Manager (auto-avoid resource limitation breaches)

Access Controls

Fault Tolerance

e.t.c.

Due to the limitations of being a plugin in Kong Gateway, we will be mostly reliant on the back-end system’s (e.g. Redis, Qdrant, e.t.c.) facilities for things which fall under the “cache management system” category.

global configuration options

header options, and overrides

metrics and logging