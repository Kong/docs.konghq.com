---
title: Labels
content_type: reference
---

Labels are `key:value` pairs. They are case-sensitive attributes associated with entities. 
Labels allow an organization to specify metadata on an entity.

For example, you might use the label `location:us-west`, where `location` is the key and the `us-west` is the value.

A maximum of 5 user-defined labels are allowed on each resource.

**Key requirements:**
* Keys must be 63 characters or less, beginning and ending with an alphanumeric character (`[a-z0-9A-Z]`) with dashes (`-`), underscores (`_`), dots (`.`), and alphanumeric characters in between.
* Keys must not start with `kong`, `konnect`, `insomnia`, `mesh`, `kic` or `_`. These strings are reserved for Kong.
* Keys are case-sensitive.

**Value requirements:**
* Values must be 63 characters or less, beginning and ending with an alphanumeric character (`[a-z0-9A-Z]`) with dashes (`-`), underscores (`_`), dots (`.`), and alphanumeric characters in between.
* Values must not be empty.
* Values are **not** case-sensitive.


## Setting labels

You can use labels separately on the control plane and data planes.
* On the control plane, you can set labels for runtime groups, and for services in the Service Hub.
* On data planes, set labels through `kong.conf` or via environment variables using the [`cluster_dp_labels`](/gateway/latest/reference/configuration/#cluster_dp_labels) property. 
These labels are exposed through the `/nodes` endpoint of the {{site.konnect_short_name}} API.
