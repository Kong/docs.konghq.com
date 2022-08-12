---
title: Reset Passwords and RBAC Tokens in Kong Manager
badge: enterprise
---

For authentication, Kong uses two different credentials for admins:

1. An admin uses a **password** to log in to Kong Manager.
2. An admin uses an **RBAC token** to make requests to the Kong Admin API.

If using [basic authentication](/gateway/{{page.kong_version}}/kong-manager/auth/basic), an admin may reset their password from within Kong Manager. Since **LDAP** and **OIDC Authentication** imply that an organization stores and manages passwords outside of Kong, password reset is not possible with either type.

Each RBAC token is stored in Kong as a hash. Regardless of the authentication option selected, an admin may reset their RBAC token from within Kong Manager. Note that to support confidentiality, RBAC tokens are hashed and cannot be retrieved after they are created. If a user forgets the token, the only recourse is to reset it.

## Reset a forgotten password in Kong Manager

### Prerequisites

* `enforce_rbac = on`
* `admin_gui_auth = basic-auth`
* SMTP is configured to send emails

### Steps

1. At the login page, click **Forgot Password**.
2. Enter the email address associated with the account.
3. Click the link from the email.
4. Reset the password. Note that you will need to provide it again immediately after the reset is complete.
5. Log in with the new password.

## Change a password from within Kong Manager

### Prerequisites

* `enforce_rbac = on`
* `admin_gui_auth = basic-auth`
* [`admin_gui_session_conf` is configured](/gateway/{{page.kong_version}}/configure/auth/kong-manager/sessions/).
* Already logged in to Kong Manager

### Steps

1. Open the dropdown from your **account name**, then select **Profile**.
2. In the **Reset Password** section, fill in the fields and click the **Reset Password** button.

## Reset an RBAC token in Kong Manager

### Prerequisites

* `enforce_rbac = on`
* [`admin_gui_auth` is set](/gateway/{{page.kong_version}}/configure/auth/kong-manager/).
* [`admin_gui_session_conf` is configured](/gateway/{{page.kong_version}}/configure/auth/kong-manager/sessions/).
* Already logged in to Kong Manager

### Steps

1. Open the dropdown from your **account name**, then select **Profile**.
2. In the **Reset RBAC Token** section, click **Reset Token** and confirm the reset.
3. Type in a new token and click **Reset**.
4. To copy the token, click the **Copy** button.
