---
title: Troubleshooting Kong Manager OSS
content_type: reference
badge: oss
---

## Kong Manager OSS URL doesn't work

**Problem:** 

You installed {{site.ce_product_name}} and it's running, but you can't access Kong Manager OSS.
Most likely, the port wasn't exposed during installation.

**Solution:**

Install a new instance and map port `8002` during installation.
For example, with a [Docker install](/gateway/{{page.release}}/install/docker/?install=oss):

```
 -p 127.0.0.1:8002:8002
```
