---
title: Troubleshooting Kong Manager
content_type: reference
---

## Kong Manager URL doesn't resolve

**Problem:** 

You installed {{site.base_gateway}} and it's running, but you can't access Kong Manager.
Most likely, the port wasn't exposed during installation.

**Solution:**

Install a new instance and map port `8002` during installation.
For example, with a [Docker install](/gateway/{{page.release}}/install/docker/?install=oss):

```
 -p 127.0.0.1:8002:8002
```
