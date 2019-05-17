---
title: How To Enable the Dev Portal
book: portal
toc: false
---

To enable the Dev Portal, the following properties must be set in the Kong 
configuration file (`kong.conf`):

```
portal = on
portal_gui_protocol = http
portal_gui_host = localhost:8003
```

Kong must be **restarted** for these values to take effect.

- This will expose the **default Dev Portal** at [http://localhost:8003/default](http://localhost:8003/default)
- The **Dev Portal Files endpoint** can be accessed at `:8001/files`
- The **Public Dev Portal Files API** can be accessed at `:8004/files`

