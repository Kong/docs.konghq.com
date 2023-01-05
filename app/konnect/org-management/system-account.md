---
title: Create System Accounts
content_type: how-to
---

This page explains what a system account is, how they vary from user accounts, and how to create a system account using the {{site.base_short_name}} API.

System accounts are a service account in {{site.base_short_name}}. Because they are not associated with an email address and a user, system accounts can be used for automation and integrations. 

System accounts offer the following benefits over regular user accounts:

* System accounts are not associated with an email address. This allows you to use the account as part of an automation or integration that isn't associated with any person’s identity.
* When you use a user account as part of an automation or integration and that user leaves the company, this would break the automations and integrations. If you use a system account instead, the automations and integrations wouldn't break.
* Because system accounts can't be assigned the same permissions as a user account, they can't access the {{site.base_short_name}} UI.

## Create a system account using the API

1. Create a system account by issuing a `POST` request:
    ```bash
    curl --request POST \
    --url https://global.api.konghq.com/v2/system-accounts
    ```
1. Copy the `id` from the response.
1. Create an system account access token by issuing a `POST` request:
    ```bash
    curl --request POST \
    --url https://global.api.konghq.com/v2/system-accounts/:accountId/access-tokens
    ```
    * `:accountID` should be replaced with the system account `id` you copied earlier.
1. Assign system account to a role: