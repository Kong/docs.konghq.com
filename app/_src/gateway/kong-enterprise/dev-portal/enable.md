---
title: Enable the Dev Portal
badge: enterprise
---

If you're running {{site.base_gateway}} with a database (either in traditional
or hybrid mode), you can use the Dev Portal.

Dev Portals are tied to workspaces. Each workspace has a separate Dev Portal instance.

Enabling the Dev Portal exposes the following URLs:
* The workspace's Dev Portal URL.
For example, for the `default` workspace, the URL is: `http://localhost:8003/default`.
* Dev Portal files endpoint: `http://localhost:8001/files`
* Public Dev Portal files API: `http://localhost:8004/files`

To enable the Dev Portal, you must first [deploy a license](/gateway/{{page.release}}/licenses/deploy/).

{% navtabs %}
{% navtab Docker %}

1. In your Docker container, set the Portal URL and set `KONG_PORTAL` to `on`:

    ```sh
    echo "KONG_PORTAL_GUI_HOST=localhost:8003 KONG_PORTAL=on kong reload exit" \
      | docker exec -i kong-container-name /bin/sh
    ```

    Replace `kong-container-name` with your {{site.base_gateway}} container.

    {:.note}
    > The `HOSTNAME` for `KONG_PORTAL_GUI_HOST` should not be preceded by a protocol. For example, `http://`.

1. Enable the Dev Portal for a workspace:

    ```sh
    curl -i -X PATCH http://localhost:8001/workspaces/default \
      --data "config.portal=true"
    ```

1. Access the Dev Portal for the workspace using the URL specified
in the `KONG_PORTAL_GUI_HOST` variable:

    ```sh
    http://localhost:8003/default
    ```

{% endnavtab %}
{% navtab Linux (kong.conf) %}

1. To enable the Dev Portal, the following property must be set in the Kong
configuration file ([`kong.conf`](/gateway/{{page.release}}/production/kong-conf/)):

   ```
   portal = on
   ```

   Restart {{site.base_gateway}} for this value to take effect:

   ```
   kong reload
   ```

1. Enable Dev Portal for a workspace using one of the following methods:

{% capture enable-portal %}
{% navtabs %}
{% navtab Kong Manager %}

<!-- vale off -->
1. Navigate to a workspace in Kong Manager.
2. In the **Dev Portal** menu section, click **Overview**.
3. Click the button to **Enable Developer Portal**.
<!-- vale on -->

{% endnavtab %}
{% navtab Admin API %}

```bash
curl -i -X PATCH http://localhost:8001/workspaces/default \
  --data "config.portal=true"
```

{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ enable-portal | indent | replace: " </code>", "</code>"}}

{% endnavtab %}
{% endnavtabs %}

