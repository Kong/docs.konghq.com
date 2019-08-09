---
title: How to Reset Passwords and RBAC Tokens in Kong Manager
toc: false
---

### Table of contents

* [Passwords and RBAC Tokens](passwords-and-rbac-tokens)
* [How to Reset a Forgotten Password in Kong Manager](how-to-reset-a-forgotten-password-in-kong-manager)
* [How to Reset a Password from within Kong Manager](how-to-reset-a-password-from-within-kong-manager)
* [How to Reset an RBAC Token in Kong Manager](how-to-reset-an-rbac-token-in-kong-manager)

## Passwords and RBAC Tokens

For authentication, Kong uses two different credentials for **Admins**:

1. An **Admin** uses a **password** to log in to Kong Manager.
2. An **Admin** uses an **RBAC token** to make requests to the Kong Admin API.

If (and only if) using **Basic Authentication**, an Admin may reset their **password** from within Kong Manager. Since **LDAP** and **OIDC Authentication** imply that an organization stores and manages passwords outside of Kong, password reset is not possible with either type.

Since a hash of each **RBAC token** is stored in Kong, then regardless of the Authentication option selected, an **Admin** may reset their **RBAC token** from within Kong Manager. Note that to support confidentiality, **RBAC tokens** are hashed and cannot be retrieved after they are created. If a user forgets the token, the only recourse is to reset it.

## How to Reset a Forgotten Password in Kong Manager

Prerequisites: 

* `enforce_rbac = on`
* `admin_gui_auth = basic-auth`
* SMTP is configured to send emails

Steps:

1. At the login page, click **Forgot Password** beneath the login field. 

    <img src="https://doc-assets.konghq.com/0.35/kong-manager/how-to-reset-passwords-and-rbac/click-forgot-password.png">

2. Enter the email address associated with the account.

    <img src="https://doc-assets.konghq.com/0.35/kong-manager/how-to-reset-passwords-and-rbac/enter-email-address.png">

3. Click the link from the email. 

    <img src="https://doc-assets.konghq.com/0.35/kong-manager/how-to-reset-passwords-and-rbac/click-email-link.png">

4. Reset the password. Note that you will need to provide it again immediately after the reset is complete. 

    <img src="https://doc-assets.konghq.com/0.35/kong-manager/how-to-reset-passwords-and-rbac/enter-new-password.png">

5. Log in with the new password.

    <img src="https://doc-assets.konghq.com/0.35/kong-manager/how-to-reset-passwords-and-rbac/reset-successful.png">

## How to Reset a Password from within Kong Manager

Prerequisites: 

* `enforce_rbac = on`
* `admin_gui_auth = basic-auth`
* [`admin_gui_session_conf` is configured](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/). 
* Already logged in to Kong Manager

Steps:

1. At the **top right corner**, after hovering over the **account name**, select **Profile**. 

    <img src="https://doc-assets.konghq.com/0.35/kong-manager/how-to-reset-passwords-and-rbac/hover-select-profile.png">

2. In the **Reset Password** section, fill in the fields and click the **Reset Password** button.

    <img src="https://doc-assets.konghq.com/0.35/kong-manager/how-to-reset-passwords-and-rbac/reset-password.png">

## How to Reset an RBAC Token in Kong Manager

Prerequisites: 

* `enforce_rbac = on`
* [`admin_gui_auth` is set](/enterprise/{{page.kong_version}}/kong-manager/security/#authentication-with-plugins).
* [`admin_gui_session_conf` is configured](/enterprise/{{page.kong_version}}/kong-manager/authentication/sessions/).
* Already logged in to Kong Manager

Steps:

1. At the **top right corner**, after hovering over the **account name**, select **Profile**. 

    <img src="https://doc-assets.konghq.com/0.35/kong-manager/how-to-reset-passwords-and-rbac/hover-select-profile.png">

2. In the **Reset RBAC Token** section at the bottom, click **Reset Token**.

    <img src="https://doc-assets.konghq.com/0.35/kong-manager/how-to-reset-passwords-and-rbac/click-reset-token.png">
  
3. Type in a new token and click **Reset**. 

    <img src="https://doc-assets.konghq.com/0.35/kong-manager/how-to-reset-passwords-and-rbac/enter-new-token.png">
  
4. To copy the token, click the **Copy** button at the right.

    <img src="https://doc-assets.konghq.com/0.35/kong-manager/how-to-reset-passwords-and-rbac/successful-reset.png">
