---
title: Labels
content_type: reference
---

Labels are `key:value` pairs. They are case sensitive attributes associated with entities. Labels allow an organization to specify metadata on an entity that can be used for filtering an entity list or for searching across entity types.

A maximum of 5 user-defined labels are allowed on each resource.

**Key requirements:**
* Keys must be 63 characters or less, beginning and ending with an alphanumeric character (`[a-z0-9A-Z]`) with dashes (`-`), underscores (`_`), dots (`.`), and alphanumerics between.
* Keys must not start with `kong`, `konnect`, `insomnia`, `mesh`, `kic` or `_`. These strings are reserved for Kong.
* Keys are case-sensitive.

**Value requirements:**
* Values must be 63 characters or less, beginning and ending with an alphanumeric character ([a-z0-9A-Z]) with dashes (`-`), underscores (`_`), dots (`.`), and alphanumerics between.
* Values must not be empty.