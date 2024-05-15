<!---shared with plugins that accept custom lua code --->

Sandboxing consists of several limitations in the way the Lua code can be executed,
for heightened security.

The following functions are not available because they can be used to abuse the system:

* `string.rep`: Can be used to allocate millions of bytes in one operation.
* `{set|get}metatable`: Can be used to modify the metatables of global objects (strings, numbers).
* `collectgarbage`: Can be abused to kill the performance of other workers.
* `_G`: Is the root node which has access to all functions. It is masked by a temporary table.
* `load{file|string}`: Is deemed unsafe because it can grant access to the global environment.
* `raw{get|set|equal}`: Potentially unsafe because sandboxing relies on some metatable manipulation.
* `string.dump`: Can display confidential server information (such as implementation of functions).
* `math.randomseed`: Can affect the host system. {{site.base_gateway}} already seeds the random number generator properly.
* All `os.*` (except `os.clock`, `os.difftime`, and `os.time`). `os.execute` can significantly alter the host system.
* `io.*`: Provides access to the hard drive.
* `dofile|require`: Provides access to the hard drive.

The exclusion of `require` means that plugins must only use PDK functions `kong.*`. The `ngx.*` abstraction is
also available, but it is not guaranteed to be present in future versions of the plugin.

In addition to the above restrictions:

* All the provided modules (like `string` or `table`) are read-only and can't be modified.
* Bytecode execution is disabled.
{% if_version gte:3.3.x %}
* The `kong.cache` points to a cache instance that is dedicated to the Serverless Functions plugins. It does not provide access to the global {{site.base_gateway}} cache. It only exposes the `get` method. Explicit write operations like `set` or `invalidate` are not available.
{% endif_version %}
