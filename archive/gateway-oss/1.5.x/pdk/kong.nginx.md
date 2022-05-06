---
title: kong.nginx
pdk: true
toc: true
---

## kong.nginx

Nginx information module
 A set of functions allowing to retrieve Nginx-specific implementation
 details and meta information.



### kong.nginx.get_subsystem()

Returns the current Nginx subsystem this function is called from: "http"
 or "stream".

**Phases**

* any

**Returns**

* `string` subsystem Either `"http"` or `"stream"`


**Usage**

``` lua
kong.nginx.get_subsystem() -- "http"
```

[Back to TOC](#table-of-contents)

