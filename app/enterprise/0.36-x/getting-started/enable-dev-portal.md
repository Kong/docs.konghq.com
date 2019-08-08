---
title: How To Enable the Dev Portal
toc: false
---

### Step 1 - Enable Dev Portal in the Kong Configuration

To enable the Dev Portal, the following properties must be set in the Kong 
configuration file (`kong.conf`):

```
portal = on
```

Kong Enterprise must be **restarted** for this value to take effect.

### Step 2 - Enable the default Workspace Dev Portal


To enable the default Workspace's Dev Portal via Kong Manager:

1. Navigate to the default Workspace in Kong Manager
2. Click the **Settings** link under **Dev Portal**
3. Toggle the **Dev Portal Switch**

It may take a few seconds for the Settings page to populate.

![Dev Portal Settings](https://konghq.com/wp-content/uploads/2019/05/Screen-Shot-2019-05-17-at-12.27.56-PM.png)


To enable the default Workspace's Dev portal via the command line:

```
curl -X PATCH http://localhost:8001/workspaces/default   --data "config.portal=true"
```

- This will expose the **default Dev Portal** at [http://localhost:8003/default](http://localhost:8003/default)
- The **Dev Portal Files endpoint** can be accessed at `:8001/files`
- The **Public Dev Portal Files API** can be accessed at `:8004/files`
