---
title: Enable Kong Manager
---

If you're running {{site.base_gateway}} with a database (either in traditional
or hybrid mode), you can enable {{site.base_gateway}}'s graphical user interface
(GUI), Kong Manager.

{% if_version gte:3.9.x %}

{:.note}
> **Note**: To configure Kong Manager to be accessible from multiple domains, you can list the domains as comma-separated values in the `admin_gui_url` parameter in your Kong configuration. For example:
  ```
  admin_gui_url = http://localhost:8002, http://127.0.0.1:8002
  ```
> If the `admin_gui_path` is also set, please update the Kong configuration:
  ```
  admin_gui_url = http://localhost:8002/manager, http://127.0.0.1:8002/manager
  admin_gui_path = /manager
  ```
> Make sure that each domain has proper DNS records and that the Kong instance is accessible from all specified domains.

{:.note}
> **Note**: If your setup involves multiple domains or subdomains, it’s generally recommended to remove the `cookie_domain` that setting in the `admin_gui_session_conf` or `admin_gui_auth_conf`. When `cookie_domain` is not specified, cookies are set for the origin domain by default. This allows the browser to manage cookies correctly for each domain independently, avoiding conflicts or scope issues.

> Example A: A request to `gui.konghq.com`/`other-gui.example.com` will only receive cookies for `gui.konghq.com`/`other-gui.example.com` instead of a broader `konghq.com`/`example.com domain` if `cookie_domain` is omitted
  ```
  admin_gui_url = http://gui.konghq.com, http://other-gui.example.com
  admin_gui_session_conf = {"secret":"Y29vbGJlYW5z","storage":"kong","cookie_secure":false} # omitted `cookie_domain`
  ```
> Example B: A request to `gui.konghq.com`/`other-gui.konghq.com` will receive cookies for `konghq.com`. This allows the cookie to be shared across all subdomains, but be cautious since it increases the cookie’s scope, which may lead to unintended side effects or security risks.
  ```
  admin_gui_url = http://gui.konghq.com, http://other-gui.konghq.com
  admin_gui_session_conf = {"secret":"Y29vbGJlYW5z","storage":"kong","cookie_secure":false,"cookie_domain" : "konghq.com"}
  ```
{% endif_version %}
{% navtabs %}
{% navtab Docker %}

1. Set the [`KONG_ADMIN_GUI_PATH`](/gateway/{{page.release}}/reference/configuration/#admin_gui_path) and [`KONG_ADMIN_GUI_URL`](/gateway/{{page.release}}/reference/configuration/#admin_gui_url) properties in the ([`kong.conf`](/gateway/{{page.release}}/production/kong-conf/)) configuration file to the DNS or IP address of your system, then restart {{site.base_gateway}} for the setting to take effect. For example:

    ```bash
    docker exec -i <KONG_CONTAINER_ID> /bin/sh -c "export KONG_ADMIN_GUI_PATH='/'; export KONG_ADMIN_GUI_URL='http://localhost:8002/manager'; kong reload; exit"
    ```
    Replace `KONG_CONTAINER_ID` with the ID of your Docker container.

2. Access Kong Manager on port `8002` at the path you specified in `KONG_ADMIN_GUI_PATH`, or the default URL `http://localhost:8002/workspaces`.

{% endnavtab %}
{% navtab Linux (kong.conf) %}

1. Update the [`admin_gui_url`](/gateway/{{page.release}}/reference/configuration/#admin_gui_url) property
  in the `kong.conf` configuration file to the DNS, or IP address, of your system. For example:

    ```
    admin_gui_path = /manager
    admin_gui_url = http://localhost:8002/manager
    ```

    This setting needs to resolve to a network path that can reach the operating system (OS) host.

2. Restart {{site.base_gateway}} for the setting to take effect, using the following command:

    ```bash
    kong restart -c {PATH_TO_KONG.CONF_FILE}
    ```

3. Access Kong Manager on port `8002` at the path you specified in `admin_gui_path`.

{% endnavtab %}
{% endnavtabs %}

## Next steps

* [Get started with managing {{site.base_gateway}}](/gateway/{{page.release}}/kong-manager/get-started/services-and-routes/)
* [Set up authentication for Kong Manager](/gateway/{{page.release}}/kong-manager/auth/)
* [Set up role-based access control to {{site.base_gateway}} resources](/gateway/{{page.release}}/kong-manager/auth/rbac/)
