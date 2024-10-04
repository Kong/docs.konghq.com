---
title: Dev Portal SMTP Configuration
badge: enterprise
---

Dev Portal enables SMTP configuration via email variables, which are used by the Dev Portal to send emails to Kong admins and developers.

For comprehensive documentation on SMTP configuration properties, see [Default Portal SMTP Configuration](/gateway/{{page.release}}/reference/configuration/#default-portal-smtp-configuration-section).

These settings can be modified in the `Kong Manager` under the Dev Portal `Settings / Email` tab, or by running the following command:

```bash
curl http://localhost:8001/workspaces/<WORKSPACE_NAME> \
  --data "config.<PROPERTY_NAME>=off"
```

If they are not modified manually, the Dev Portal will use the default value defined in the Kong Configuration file.

Dev Portal email content and styling can be customized via [template files](/gateway/{{page.release}}/kong-enterprise/dev-portal/customize/emails/).
