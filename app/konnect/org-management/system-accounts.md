---
title: Manage System Accounts
content_type: how-to
no_version: true
---

This guide explains what a system account is, how it varies from a user account, and how to manage a system account using the [{{site.konnect_short_name}} Identity API](https://developer.konghq.com/spec/5175b87f-bfae-40f6-898d-82d224387f9b/fc735302-d8ac-4e66-a9ef-225569a75d3c). 

A system account is a service account in {{site.konnect_short_name}}. Because system accounts are not associated with an email address and a user, they can be used for automation and integrations. 

System accounts offer the following benefits over regular user accounts:

* System accounts are not associated with an email address. This allows you to use the account as part of an automation or integration that isn't associated with any person’s identity.
* When you use a user account as part of an automation or integration and that user leaves the company, automation and integrations break. If you use a system account instead, the automation and integrations wouldn't break.
* System accounts don't have sign-in credentials and therefore can't access the {{site.konnect_short_name}} UI. These accounts are intended to be used with APIs and CLIs.

The system account can use a {{site.konnect_short_name}} personal access token (PAT) the same way a [regular {{site.konnect_short_name}} user](/konnect/org-management/users/) can. In addition, the system account can be assigned roles directly or inherit the roles of a [team](/konnect/org-management/teams-and-roles/). As such, a PAT created by a system account inherits the roles assigned to the system account.

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

```json
{
  "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
  "name": "Example System Account",
  "created_at": "2019-08-24T14:15:22Z",
  "updated_at": "2019-08-24T14:15:22Z"
}
```

### Generate a system account access token

The system account access token can be used for authenticating API and CLI requests.

Create a system account token by sending a `POST` request containing the `accountId` of the system account:

```sh
curl --request POST \
  --url https://global.api.konghq.com/v2/system-accounts/:497f6eca-6276-4993-bfeb-53cbbbba6f08/access-tokens
```
You will receive a `201` response code, and a response body containing the access token for the system account:

```json
{
  "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
  "name": "Sample Access Token",
  "created_at": "2023-01-12:15:54Z",
  "expires_at": "2023-11-15T00:00:00Z",
  "updated_at": "2023-01-13T21:04:22Z",
  "last_used_at": "2023-01-18T06:45:40Z",
  "token": "spat_12345678901234567890123456789012345678901234567890"
}
```

Copy and save the access token beginning with `spat_`.

{:.important}
> **Important**: The access token is only displayed once, so make sure you save it securely. 

### Assign a role to a system account

You can assign a role to a system account so that the permissions associated with that role can be assigned to that account and their subsequent credentials.

Assign a role to a system account by sending a `POST` request containing the `accountId` and the `role_name` of the system account:

```sh
curl --request POST \
  --url https://global.api.konghq.com/v2/system-accounts/:497f6eca-6276-4993-bfeb-53cbbbba6f08/assigned-roles
  --data '{
  "role_name": "Viewer",
  "entity_id": "817d0422-45c9-4d88-8d64-45aef05c1ae7",
  "entity_type_name": "Runtime Groups",
  "entity_region": "eu"
}'
```

You will receive a `201` response code and a response body containing the role that is now assigned to the system account:

```json
{
  "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
  "role_name": "Viewer",
  "entity_id": "817d0422-45c9-4d88-8d64-45aef05c1ae7",
  "entity_type_name": "Runtime Groups",
  "entity_region": "eu"
}
```

### Assign a system account to a team

You can assign a team to a system account so that the permissions associated with that team can be assigned to that account and their subsequent credentials.

Assign a team to a system account by sending a `POST` request containing the `teamId` of the team:

```sh
curl --request POST \
  --url https://global.api.konghq.com/v2/teams/:497f6eca-6276-4993-bfeb-53cbbbba6f08/system-accounts
```

You will receive a `201` response code and a response body stating that the system account was added to the team:

```
Created
```

## See also

See the following documentation for additional information:
* [Manage Teams and Roles](/konnect/org-management/teams-and-roles/manage/)
* [Roles Reference](/konnect/org-management/teams-and-roles/roles-reference/)
* [Teams Reference](/konnect/org-management/teams-and-roles/teams-reference/)
