---
title: FAQ
---

Can't find what you're looking for on this page? Let us know at team-docs@konghq.com.

### Kong crashes on start (MDB_CORRUPTED)

**Q:** I receive the following error when starting Kong: 
```
2022/04/11 12:01:07 [crit] 32790#0: *7 [lua] init.lua:648: init_worker(): worker initialization error: failed to create and open LMDB database: MDB_CORRUPTED: Located page was wrong type; this node must be restarted, context: init_worker_by_lua*
```

**A:** Your local configuration cache is corrupt. Remove your LMDB cache (located at `<prefix>/dbless.lmdb`, which is located at  `/usr/local/kong/dbless.lmdb` by default) and restart {{site.base_gateway}}. This forces the {{site.base_gateway}} node to reload the configuration from the control plane because the corrupted cache was deleted.

---
