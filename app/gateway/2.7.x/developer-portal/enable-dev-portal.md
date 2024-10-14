---
title: How To Enable the Dev Portal
badge: enterprise
---

Enable Dev Portal in the Kong Configuration or within a Docker container for Docker installations.

## Enable Dev Portal in the Kong Configuration

1. To enable the Dev Portal, the following properties must be set in the Kong
configuration file (`kong.conf`):

   ```bash
   portal = on
   ```

   {{site.base_gateway}} must be **restarted** for this value to take effect.

2. Enable the default Workspace Dev Portal via Kong Manager:

   1. Navigate to the default Workspace in Kong Manager
   2. Click the **Settings** link under **Dev Portal**
   3. Toggle the **Dev Portal Switch**

   It may take a few seconds for the Settings page to populate.

   To enable the default Workspace's Dev portal via the command line:

   ```bash
   curl -X PATCH http://localhost:8001/workspaces/default   --data "config.portal=true"
   ```

   - This will expose the **default Dev Portal** at [http://localhost:8003/default](http://localhost:8003/default)
   - The **Dev Portal Files endpoint** can be accessed at `:8001/files`
   - The **Public Dev Portal Files API** can be accessed at `:8004/files`

## Enable Dev Portal with Docker installation

{:.note}
> This feature is only available with a [{{site.konnect_product_name}} Enterprise](/gateway/{{page.release}}/plan-and-deploy/licenses/) subscription.

1. [Deploy a license](/gateway/{{page.release}}/plan-and-deploy/licenses/deploy-license/).

2. In your Docker container, set the Portal URL and set `KONG_PORTAL` to `on`:

    ```plaintext
    echo "KONG_PORTAL_GUI_HOST=localhost:8003 KONG_PORTAL=on kong reload exit" \
      | docker exec -i kong /bin/sh
    ```

    {:.note}
    > The `HOSTNAME` for `KONG_PORTAL_GUI_HOST` should not be preceded by a protocol, for example, `http://`.

3. Execute the following command:

    ```sh
    curl -X PATCH --url http://localhost:8001/workspaces/default \
        --data "config.portal=true"
    ```

4. Access the Dev Portal for the default workspace using the URL specified
in the `KONG_PORTAL_GUI_HOST` variable:

    ```sh
    http://localhost:8003/default
    ```
