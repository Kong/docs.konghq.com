---
title: kong.log
pdk: true
toc: true
---

## kong.log

This namespace contains an instance of a "logging facility", which is a
 table containing all of the methods described below.

 This instance is namespaced per plugin, and Kong will make sure that before
 executing a plugin, it will swap this instance with a logging facility
 dedicated to the plugin. This allows the logs to be prefixed with the
 plugin's name for debugging purposes.




### kong.log(...)

Write a log line to the location specified by the current Nginx
 configuration block's `error_log` directive, with the `notice` level (similar
 to `print()`).

 The Nginx `error_log` directive is set via the `log_level`, `proxy_error_log`
 and `admin_error_log` Kong configuration properties.

 Arguments given to this function will be concatenated similarly to
 `ngx.log()`, and the log line will report the Lua file and line number from
 which it was invoked. Unlike `ngx.log()`, this function will prefix error
 messages with `[kong]` instead of `[lua]`.

 Arguments given to this function can be of any type, but table arguments
 will be converted to strings via `tostring` (thus potentially calling a
 table's `__tostring` metamethod if set). This behavior differs from
 `ngx.log()` (which only accepts table arguments if they define the
 `__tostring` metamethod) with the intent to simplify its usage and be more
 forgiving and intuitive.

 Produced log lines have the following format when logging is invoked from
 within the core:

 ``` plain
 [kong] %file_src:%line_src %message
 ```

 In comparison, log lines produced by plugins have the following format:

 ``` plain
 [kong] %file_src:%line_src [%namespace] %message
 ```

 Where:

 * `%namespace`: is the configured namespace (the plugin name in this case).
 * `%file_src`: is the file name from where the log was called from.
 * `%line_src`: is the line number from where the log was called from.
 * `%message`: is the message, made of concatenated arguments given by the caller.

 For example, the following call:

 ``` lua
 kong.log("hello ", "world")
 ```

 would, within the core, produce a log line similar to:

 ``` plain
 2017/07/09 19:36:25 [notice] 25932#0: *1 [kong] some_file.lua:54 hello world, client: 127.0.0.1, server: localhost, request: "GET /log HTTP/1.1", host: "localhost"
 ```

 If invoked from within a plugin (e.g. `key-auth`) it would include the
 namespace prefix, like so:

 ``` plain
 2017/07/09 19:36:25 [notice] 25932#0: *1 [kong] some_file.lua:54 [key-auth] hello world, client: 127.0.0.1, server: localhost, request: "GET /log HTTP/1.1", host: "localhost"
 ```


**Phases**

* init_worker, certificate, rewrite, access, header_filter, body_filter, log

**Parameters**

* **...** :  all params will be concatenated and stringified before being sent to the log

**Returns**

*  Nothing; throws an error on invalid inputs.


**Usage**

``` lua
kong.log("hello ", "world") -- alias to kong.log.notice()
```

[Back to top](#konglog)


### kong.log.LEVEL(...)

Similar to `kong.log()`, but the produced log will have the severity given by
 `<level>`, instead of `notice`.  The supported levels are:

 * `kong.log.alert()`
 * `kong.log.crit()`
 * `kong.log.err()`
 * `kong.log.warn()`
 * `kong.log.notice()`
 * `kong.log.info()`
 * `kong.log.debug()`

 Logs have the same format as that of `kong.log()`. For
 example, the following call:

 ``` lua
  kong.log.err("hello ", "world")
 ```

 would, within the core, produce a log line similar to:

 ``` plain
 2017/07/09 19:36:25 [error] 25932#0: *1 [kong] some_file.lua:54 hello world, client: 127.0.0.1, server: localhost, request: "GET /log HTTP/1.1", host: "localhost"
 ```

 If invoked from within a plugin (e.g. `key-auth`) it would include the
 namespace prefix, like so:

 ``` plain
 2017/07/09 19:36:25 [error] 25932#0: *1 [kong] some_file.lua:54 [key-auth] hello world, client: 127.0.0.1, server: localhost, request: "GET /log HTTP/1.1", host: "localhost"
 ```


**Phases**

* init_worker, certificate, rewrite, access, header_filter, body_filter, log

**Parameters**

* **...** :  all params will be concatenated and stringified before being sent to the log

**Returns**

*  Nothing; throws an error on invalid inputs.


**Usage**

``` lua
kong.log.warn("something require attention")
kong.log.err("something failed: ", err)
kong.log.alert("something requires immediate action")
```

[Back to top](#konglog)


### kong.log.inspect(...)

Like `kong.log()`, this function will produce a log with the `notice` level,
 and accepts any number of arguments as well.  If inspect logging is disabled
 via `kong.log.inspect.off()`, then this function prints nothing, and is
 aliased to a "NOP" function in order to save CPU cycles.

 ``` lua
 kong.log.inspect("...")
 ```

 This function differs from `kong.log()` in the sense that arguments will be
 concatenated with a space(`" "`), and each argument will be
 "pretty-printed":

 * numbers will printed (e.g. `5` -> `"5"`)
 * strings will be quoted (e.g. `"hi"` -> `'"hi"'`)
 * array-like tables will be rendered (e.g. `{1,2,3}` -> `"{1, 2, 3}"`)
 * dictionary-like tables will be rendered on multiple lines

 This function is intended for use with debugging purposes in mind, and usage
 in production code paths should be avoided due to the expensive formatting
 operations it can perform. Existing statements can be left in production code
 but nopped by calling `kong.log.inspect.off()`.

 When writing logs, `kong.log.inspect()` always uses its own format, defined
 as:

 ``` plain
 %file_src:%func_name:%line_src %message
 ```

 Where:

 * `%file_src`: is the file name from where the log was called from.
 * `%func_name`: is the name of the function from where the log was called
   from.
 * `%line_src`: is the line number from where the log was called from.
 * `%message`: is the message, made of concatenated, pretty-printed arguments
   given by the caller.

 This function uses the [inspect.lua](https://github.com/kikito/inspect.lua)
 library to pretty-print its arguments.


**Phases**

* init_worker, certificate, rewrite, access, header_filter, body_filter, log

**Parameters**

* **...** :  Parameters will be concatenated with spaces between them and
 rendered as described

**Usage**

``` lua
kong.log.inspect("some value", a_variable)
```

[Back to top](#konglog)


### kong.log.inspect.on()

Enables inspect logs for this logging facility.  Calls to
 `kong.log.inspect` will be writing log lines with the appropriate
 formatting of arguments.


**Phases**

* init_worker, certificate, rewrite, access, header_filter, body_filter, log

**Usage**

``` lua
kong.log.inspect.on()
```

[Back to top](#konglog)


### kong.log.inspect.off()

Disables inspect logs for this logging facility.  All calls to
 `kong.log.inspect()` will be nopped.


**Phases**

* init_worker, certificate, rewrite, access, header_filter, body_filter, log

**Usage**

``` lua
kong.log.inspect.off()
```

[Back to top](#konglog)
