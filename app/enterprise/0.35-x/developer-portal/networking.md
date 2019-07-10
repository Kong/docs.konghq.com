---
title: Kong Dev Portal Networking
book: portal
---

## Networking Configuration Reference


#### portal_gui_protocol

**Description**

Sets the protocol the Dev Portal will use to construct the URL.

**Valid inputs:** `http`, `https`


#### portal_gui_host

**Description:**

Sets the host name for the Dev Portal URL.

**Example:** `localhost:8003`


#### portal_gui_use_subdomains
**Description:**

Determines where the Dev Portal will expect the Workspace name to be included 
in the request URL.

When this option is `off` the Dev Portal will use the following URL scheme:

```
scheme://<HOSTNAME>/<WORKSPACE>/index
```

**Example:** `http://localhost:8003/default/login`


When this option is `on` the Dev Portal will follow this URL scheme:

```
scheme://<WORKSPACE>.<HOSTNAME>
```
**Example:** `http://default.localhost:8003/login`


#### portal_cors_origins
**Description**

List of allowed domains for `Access-Control-Allow-Origin` header. This can be
used to resolve CORS issues in custom networking environment.s
