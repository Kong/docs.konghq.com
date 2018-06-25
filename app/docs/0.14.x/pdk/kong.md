---
title: kong
pdk: true
---

# kong

Kong's "Plugin Development Kit" ("PDK")

## Table of Contents

* [kong.configuration](#kong_configuration)
* [kong.pdk_major_version](#kong_pdk_major_version)
* [kong.pdk_version](#kong_pdk_version)
* [kong.version](#kong_version)
* [kong.version_num](#kong_version_num)
* [kong.cache](#kong_cache)
* [kong.dao](#kong_dao)
* [kong.db](#kong_db)
* [kong.dns](#kong_dns)
* [kong.ipc](#kong_ipc)
* [kong.log](kong.log)
* [kong.table](kong.table)
* [kong.client](kong.client)
* [kong.ctx](kong.ctx)
* [kong.service.request](kong.service.request)
* [kong.service.response](kong.service.response)
* [kong.request](kong.request)
* [kong.response](kong.response)
* [kong.service](kong.service)




### <a name="kong_configuration"></a>kong.configuration

A read-only table containing the configuration of the current Kong node, based
 on the configuration file and environment variables.

 See [kong.conf.default](https://github.com/Kong/kong/blob/master/kong.conf.default) for details.
 Comma-separated lists in that file get promoted to arrays of strings in this
 table.th

**Usage**

``` lua
print(kong.configuration.prefix) -- "/usr/local/kong"
-- read-only, throws an error:
kong.configuration.custom_plugins = "foo"
```

[Back to TOC](#table-of-contents)


### <a name="kong_pdk_major_version"></a>kong.pdk_major_version

A number representing the major version of the current PDK (e.g.
 `1`). Useful for feature-existence checks or backwards-compatible behavior as
 users of the PDK.

**Usage**

``` lua
if kong.pdk_version_num < 2 then
-- PDK is below version 2
end
```

[Back to TOC](#table-of-contents)


### <a name="kong_pdk_version"></a>kong.pdk_version

A human-readable string containing the version number of the current PDK.

**Usage**

``` lua
print(kong.pdk_version) -- "1.0.0"
```

[Back to TOC](#table-of-contents)


### <a name="kong_version"></a>kong.version

A human-readable string containing the version number of the currently running node.

**Usage**

``` lua
print(kong.version) -- "0.13.0"
```

[Back to TOC](#table-of-contents)


### <a name="kong_version_num"></a>kong.version_num

An integral number representing the version number of the currently running
 node, useful for comparison and feature-existence checks.

**Usage**

``` lua
if kong.version_num < 13000 then -- 000.130.00 -> 0.13.0
-- no support for Routes & Services
end
```

[Back to TOC](#table-of-contents)




### <a name="kong_cache"></a>kong.cache

Instance of Kong's database caching object, from the `kong.cache` module.

 **Note:** usage of this module is currently reserved to the core or to advanced users.

[Back to TOC](#table-of-contents)


### <a name="kong_dao"></a>kong.dao

Instance of Kong's legacy DAO.  This has the same interface as the object
 returned by `new(config, db)` in core's `kong.dao.factory` module.

 * getkong.org: [Plugin Development Guide - Accessing the Datastore](https://getkong.org/docs/latest/plugin-development/access-the-datastore/)
 * Kong legacy DAO: https://github.com/Kong/kong/tree/master/kong/dao

[Back to TOC](#table-of-contents)


### <a name="kong_db"></a>kong.db

Instance of Kong's DAO (the new `kong.db` modules).  Contains accessor objects
 to various entities.
 A more thorough documentation of this DAO and new schema definitions is to be
 made available in the future, once this object will replace the old DAO as the
 standard interface with which to create custom entities in plugins.

**Usage**

``` lua
kong.db.services:insert()
kong.db.routes:select()
```

[Back to TOC](#table-of-contents)


### <a name="kong_dns"></a>kong.dns

Instance of Kong's DNS resolver, a client object from the
 [lua-resty-dns-client](https://github.com/kong/lua-resty-dns-client) module.

 **Note:** usage of this module is currently reserved to the core or to advanced users.

[Back to TOC](#table-of-contents)


### <a name="kong_ipc"></a>kong.ipc

Instance of Kong's IPC module for inter-workers communication from the
 [lua-resty-worker-events](https://github.com/Kong/lua-resty-worker-events)
 module.

 **Note:** usage of this module is currently reserved to the core or to advanced users.

[Back to TOC](#table-of-contents)

