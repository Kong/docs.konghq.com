---
title: Manage System Accounts
content_type: how-to
no_version: true
---

This guide shows you how to manage system accounts in {{site.konnect_short_name}}. 

The system account can use a {{site.konnect_short_name}} personal access token (PAT) the same way a [regular {{site.konnect_short_name}} user](/org-management/users/) is able to. Unlike regular user accounts, system accounts are not associated with an email address or password and can't access the {{site.konnect_short_name}} user interface. Because of these differences, you can use the system account as part of an automation or integration that requires a user account.  

In addition, the system account can be assigned roles directly or inherit the roles of a [team](/org-management/teams-and-roles/). As such, a PAT created by a system account inherits the roles assigned to the system account.

## Manage a system account via the user interface

You can create a system account using the {{site.konnect_short_name}} user interface by navigating to **Organization > System Accounts**. You can also assign system accounts to teams and manage system account tokens from this page.

## Manage a system account via the API

### Create a system account

Create a system account by sending a `POST` request containing the `name` of your system account in the response body:

```sh
curl --request POST \
  --url https://global.api.konghq.com/v2/system-accounts
  --data '{
  "name": "Example System Account"}'
```

You will receive a `201` response code, and a response body containing information about your system account:

```
{
  "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
  "name": "Example System Account",
  "created_at": "2019-08-24T14:15:22Z",
  "updated_at": "2019-08-24T14:15:22Z"
}
```

### Generate a system account access token

The system account access token can be used for authenticating API and CLI requests.

Create a system account by sending a `POST` request containing the `accountId` of the system account:

```sh
curl --request POST \
  --url https://global.api.konghq.com/v2/system-accounts/:497f6eca-6276-4993-bfeb-53cbbbba6f08/access-tokens
```
You will receive a `201` response code, and a response body containing the access token for the system account:

```
{
  "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
  "name": "Sample Access Token",
  "created_at": "2019-08-24T14:15:22Z",
  "updated_at": "2019-08-24T14:15:22Z",
  "expires_at": "2019-08-24T14:15:22Z",
  "last_used_at": "2019-08-24T14:15:22Z",
  "token": "npat_12345678901234567890123456789012345678901234567890"
}
```

{:.important}
> **Important**: The access token is only displayed once, so make sure you save it securely. 

### Assign a role to a system account



### Assign a system account to a team

## See also <!-- Optional -->

This section should include a list of tutorials or other pages that a user can visit to extend their learning from this tutorial.

See the following examples of how-to documentation:
* [Analytics reports](https://docs.konghq.com/gateway/latest/kong-enterprise/analytics/reports/)
* [Service directory mapping](https://docs.konghq.com/gateway/latest/kong-manager/auth/ldap/service-directory-mapping/)
* [Custom entities](https://docs.konghq.com/gateway/latest/plugin-development/custom-entities/)