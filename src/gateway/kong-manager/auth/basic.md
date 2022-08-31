---
title: Enable Basic Auth for Kong Manager
badge: enterprise
content_type: how-to
---

Enable [basic authentication](/hub/kong-inc/basic-auth) on a Kong Manager instance.

## Prerequisites
You have [super admin permissions](/gateway/{{page.kong_version}}/kong-manager/auth/super-admin)
or a user that has `/admins` and `/rbac` read and write access.

## Set up basic authentication

1. In [`kong.conf`](/gateway/{{page.kong_version}}/reference/configuration), configure the following properties:

    ```
    enforce_rbac = on
    admin_gui_auth = basic-auth
    admin_gui_session_conf = { "secret":"set-your-string-here" }
    ```

    This enables RBAC, sets `basic-auth` as the authentication method, and creates a session secret.

    Kong Manager uses the Sessions plugin in the background.
    This plugin (configured with `admin_gui_session_conf`) requires a secret and is configured securely by default.

    * Under all circumstances, the `secret` must be manually set to a string.
    * If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`.
    * If using different domains for the Admin API and Kong Manager, `cookie_samesite` must be set to `off`.
    Learn more about these properties in [Session Security in Kong Manager](/gateway/{{page.kong_version}}/kong-manager/auth/sessions/#session-security), and see [example configurations](/gateway/{{page.kong_version}}/kong-manager/auth/sessions/#example-configurations).


2. Start or reload Kong and point to the `kong.conf` file:

    ```
    kong start [-c /path/to/kong/conf]
    ```

3. Choose one of the following options:

    * If you created a super admin via database migration, log in to Kong
    Manager with the username `kong_admin` and the password
    set in the [environment variable](/gateway/{{page.kong_version}}/production/access-control/start-securely/).

    * If you created a super admin via the Kong Manager **Teams** tab
    as described in
    [How to Create a Super Admin](/gateway/{{page.kong_version}}/kong-manager/auth/super-admin),
    log in with the credentials you created after accepting the email
    invitation.
