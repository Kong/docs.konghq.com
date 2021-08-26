<!-- The turn on RBAC content is used in both the event-hooks examples page and the getting started guide's manage-teams page. -->

To enable RBAC, you will need the initial KONG_PASSWORD that was used when you first installed {{site.base_gateway}} and ran migrations. This is also the default password for the Super Admin, and will be required once RBAC is on.

{% navtabs %}
{% navtab UNIX-based system or Windows %}
1. Modify configuration settings below in your `kong.conf` file. Navigate to the file at `/etc/kong/kong.conf`:
    <pre><code>cd /etc/kong/</code></pre>
2. Copy the `kong.conf.default` file so you know you have a working copy to fall back to.
    <pre><code>cp kong.conf.default kong.conf</code></pre>
3. Now, edit the following settings in `kong.conf`:

    <pre><code>echo >> “enforce_rbac = on” >> /etc/kong/kong.conf<br>echo >> “admin_gui_auth = basic-auth” >> /etc/kong.conf<br>echo >> “admin_gui_session_conf = {"secret":"secret","storage":"kong","cookie_secure":false}”</code></pre>

    This will turn on RBAC, tell {{site.base_gateway}} to use basic authentication (username/password), and tell the Sessions Plugin how to create a session cookie.

    The cookie is used for all subsequent requests to authenticate the user until it expires. The session has a limited duration and renews at a configurable interval, which helps prevent an attacker from obtaining and using a stale cookie after the session has ended.

4. Restart {{site.base_gateway}} and point to the new config file:
    <pre><code>kong restart -c /etc/kong/kong.conf</code></pre>
{% endnavtab %}
{% navtab Docker %}

If you have a Docker installation, run the following command to set the needed environment variables and reload the gateway's configuration.

**Note:** make sure to replace `<kong-container-id>` with the ID of your container.

<pre><code>echo "KONG_ENFORCE_RBAC=on \<br>KONG_ADMIN_GUI_AUTH=basic-auth \<br>KONG_ADMIN_GUI_SESSION_CONF='{\"secret\":\"secret\",\"storage\":\"kong\",\"cookie_secure\":false}' \<br>kong reload exit" | docker exec -i <div contenteditable="true">{KONG_CONTAINER_ID}</div> /bin/sh</code></pre>

This will turn on RBAC, tell {{site.base_gateway}} to use basic authentication (username/password), and tell the Sessions Plugin how to create a session cookie.

The cookie is used for all subsequent requests to authenticate the user, until it expires. The session has a limited duration and renews at a configurable interval, which helps prevent an attacker from obtaining and using a stale cookie after the session has ended.

{% endnavtab %}
{% endnavtabs %}

Outside of this guide, you will likely want to modify these settings differently, depending on your installation. You can read more about these settings here: [Basic Auth for Kong Manager](/enterprise/latest/kong-manager/authentication/basic/).