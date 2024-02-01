---
title: Reset Passwords and RBAC Tokens in Kong Manager
badge: enterprise
---

For authentication, Kong uses two different credentials for admins:

1. An admin uses a **password** to log in to Kong Manager.
2. An admin uses an **RBAC token** to make requests to the Kong Admin API.

If using [basic authentication](/gateway/{{page.release}}/kong-manager/auth/basic/), an admin may reset their password from within Kong Manager. Since **LDAP** and **OIDC Authentication** imply that an organization stores and manages passwords outside of Kong, password reset is not possible with either type.

Each RBAC token is stored in Kong as a hash. Regardless of the authentication option selected, an admin may reset their RBAC token from within Kong Manager. Note that to support confidentiality, RBAC tokens are hashed and cannot be retrieved after they are created. If a user forgets the token, the only recourse is to reset it.

## Reset a forgotten password in Kong Manager

### Prerequisites

* Authentication and RBAC are [enabled](/gateway/{{page.release}}/kong-manager/auth/rbac/enable/) with [basic authentication](/gateway/{{page.release}}/kong-manager/auth/basic/)
* [SMTP](/gateway/{{page.release}}/kong-manager/configuring-to-send-email/) is configured to send emails

### Steps

1. At the login page, click **Forgot Password**.
2. Enter the email address associated with the account.
3. Click the link from the email.
4. Reset the password. Note that you will need to provide it again immediately after the reset is complete.
5. Log in with the new password.

## Change a password from within Kong Manager

### Prerequisites

* Authentication and RBAC are [enabled](/gateway/{{page.release}}/kong-manager/auth/rbac/enable/) with [basic authentication](/gateway/{{page.release}}/kong-manager/auth/basic/)
* You have [super admin permissions](/gateway/{{page.release}}/kong-manager/auth/super-admin/)
or a user that has `/admins` and `/rbac` read and write access

### Steps

1. Open the dropdown from your **account name**, then select **Profile**.
2. In the **Reset Password** section, fill in the fields and click the **Reset Password** button.

## Reset an RBAC token in Kong Manager

### Prerequisites

* Authentication and RBAC are [enabled](/gateway/{{page.release}}/kong-manager/auth/rbac/enable/)
* You have [super admin permissions](/gateway/{{page.release}}/kong-manager/auth/super-admin/)
or a user that has `/admins` and `/rbac` read and write access

### Steps

1. Open the dropdown from your **account name**, then select **Profile**.
2. In the **Reset RBAC Token** section, click **Reset Token** and confirm the reset.
3. To copy the token, click **Copy**.
