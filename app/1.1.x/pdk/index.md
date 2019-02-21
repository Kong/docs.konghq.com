---
title: PDK
pdk: true
toc: true
---

## Plugin Development Kit

The Plugin Development Kit (or "PDK") is set of Lua functions and variables
 that can be used by plugins to implement their own logic.  The PDK is a
 [Semantically Versioned](https://semver.org/) component, originally
 released in Kong 0.14.0. The PDK will be guaranteed to be forward-compatible
 from its 1.0.0 release and on.

 As of this release, the PDK has not yet reached 1.0.0, but plugin authors
 can already depend on it for a safe and reliable way of interacting with the
 request, response, or the core components.

 The Plugin Development Kit is accessible from the `kong` global variable,
 and various functionalities are namespaced under this table, such as
 `kong.request`, `kong.log`, etc...




### kong.version

A human-readable string containing the version number of the currently
 running node.

**Usage**

``` lua
print(kong.version) -- "0.14.0"
```

[Back to TOC](#table-of-contents)


### kong.version_num

An integral number representing the version number of the currently running
 node, useful for comparison and feature-existence checks.

**Usage**

``` lua
if kong.version_num < 13000 then -- 000.130.00 -> 0.13.0
  -- no support for Routes & Services
end
```

[Back to TOC](#table-of-contents)


### kong.pdk_major_version

A number representing the major version of the current PDK (e.g.
 `1`). Useful for feature-existence checks or backwards-compatible behavior
 as users of the PDK.


**Usage**

``` lua
if kong.pdk_version_num < 2 then
  -- PDK is below version 2
end
```

[Back to TOC](#table-of-contents)


### kong.pdk_version

A human-readable string containing the version number of the current PDK.

**Usage**

``` lua
print(kong.pdk_version) -- "1.0.0"
```

[Back to TOC](#table-of-contents)


### kong.configuration

A read-only table containing the configuration of the current Kong node,
 based on the configuration file and environment variables.

 See [kong.conf.default](https://github.com/Kong/kong/blob/master/kong.conf.default)
 for details.

 Comma-separated lists in that file get promoted to arrays of strings in this
 table.


**Usage**

``` lua
print(kong.configuration.prefix) -- "/usr/local/kong"
-- this table is read-only; the following throws an error:
kong.configuration.prefix = "foo"
```

[Back to TOC](#table-of-contents)




### kong.db

Instance of Kong's DAO (the `kong.db` module).  Contains accessor objects
 to various entities.

 A more thorough documentation of this DAO and new schema definitions is to
 be made available in the future.


**Usage**

``` lua
kong.db.services:insert()
kong.db.routes:select()
```

[Back to TOC](#table-of-contents)


### kong.dns

Instance of Kong's DNS resolver, a client object from the
 [lua-resty-dns-client](https://github.com/kong/lua-resty-dns-client) module.

 **Note:** usage of this module is currently reserved to the core or to
 advanced users.


[Back to TOC](#table-of-contents)


### kong.worker_events

Instance of Kong's IPC module for inter-workers communication from the
 [lua-resty-worker-events](https://github.com/Kong/lua-resty-worker-events)
 module.

 **Note:** usage of this module is currently reserved to the core or to
 advanced users.


[Back to TOC](#table-of-contents)


### kong.cluster_events

Instance of Kong's cluster events module for inter-nodes communication.

 **Note:** usage of this module is currently reserved to the core or to
 advanced users.


[Back to TOC](#table-of-contents)


### kong.cache

Instance of Kong's database caching object, from the `kong.cache` module.

 **Note:** usage of this module is currently reserved to the core or to
 advanced users.


[Back to TOC](#table-of-contents)

