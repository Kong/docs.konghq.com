<!-- The turn on RBAC content is used in both the event-hooks examples page and the getting started guide's manage-teams page. -->

To enable RBAC, you will need the initial KONG_PASSWORD that was used when you first installed {{site.base_gateway}} and ran migrations. This is also the default password for the Super Admin, and will be required once RBAC is on.

{% navtabs %}
{% navtab UNIX-based system or Windows %}
1. Modify configuration settings below in your `kong.conf` file. Navigate to the file at `/etc/kong/kong.conf`:
    ```sh
    cd /etc/kong/
    ```
2. Copy the `kong.conf.default` file so you know you have a working copy to fall back to.
    ```sh
    cp kong.conf.default kong.conf
    ```
3. Now, edit the following settings in `kong.conf`:

    ```
    echo >> “enforce_rbac = on” >> /etc/kong/kong.conf
    echo >> “admin_gui_auth = basic-auth” >> /etc/kong.conf
    echo >> “admin_gui_session_conf = {"secret":"secret","storage":"kong","cookie_secure":false}”
    ```

    This turns on RBAC, tells {{site.base_gateway}} to use basic authentication (username/password), and tells the Sessions plugin how to create a session cookie.

    The cookie is used for all subsequent requests to authenticate the user until it expires. The session has a limited duration and renews at a configurable interval, which helps prevent an attacker from obtaining and using a stale cookie after the session has ended.

4. Restart {{site.base_gateway}} and point to the new config file:
    ```
    kong restart -c /etc/kong/kong.conf
    ```
{% endnavtab %}
{% navtab Docker %}

If you have a Docker installation, run the following command to set the needed environment variables and reload the gateway's configuration.

{:.note}
> **Note:** Make sure to replace `{KONG-CONTAINER-ID}` with the ID of your container.

```bash
echo "KONG_ENFORCE_RBAC=on
KONG_ADMIN_GUI_AUTH=basic-auth
KONG_ADMIN_GUI_SESSION_CONF='{\"secret\":\"secret\",\"storage\":\"kong\",\"cookie_secure\":false}'
kong reload exit" | docker exec -i {KONG_CONTAINER_ID} /bin/sh
```

This turns RBAC on, tells {{site.base_gateway}} to use basic authentication (username/password), and tells the Sessions plugin how to create a session cookie.

The cookie is used for all subsequent requests to authenticate the user, until it expires. The session has a limited duration and renews at a configurable interval, which helps prevent an attacker from obtaining and using a stale cookie after the session has ended.

{% endnavtab %}
{% endnavtabs %}

{% if_version lte:2.8.x %}
Outside of this guide, you will likely want to modify these settings differently, depending on your installation. You can read more about these settings here: [Basic Auth for Kong Manager](/gateway/latest/kong-manager/auth/basic/).
{% endif_version %}

{% if_version gte:3.0.x %}
Outside of this guide, you will likely want to modify these settings differently, depending on your installation. You can read more about these settings here: [Basic Auth for Kong Manager](/gateway/{{page.release}}/kong-manager/auth/basic/).
{% endif_version %}
