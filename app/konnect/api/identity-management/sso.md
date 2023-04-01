---
title: SSO Customization Options
content-type: how-to
---

## Overview

As an alternative to Konnect's native authentication, you can set up single sign-on (SSO) access to Konnect using
any identity provider (IdP) that uses [OpenID Connect](https://openid.net/connect/). 
This authentication method allows your users to log in to Konnect using their existing SSO credentials, without needing
a separate set of credentials unique to Konnect.


## Configuration

In order to configure SSO for your konnect organization, you can leverage the following API call:

```shell
$ https --auth "${KONNECT_PAT}" --auth-type bearer PATCH \
  'global.api.konghq.com/v2/identity-provider' \
  issuer='https://myidp.com/oauth2' \
  login_path='example' \
  client_id='example-client-id' \
  client_secret='example-client-secret'
  
{
  "issuer": "https://myidp.com/oauth2",
  "login_path": "example",
  "client_id": "example-client-id",
  "client_secret": "example-client-secret",
  "scopes": [
    "openid",
    "email",
    "profile",
  ],
  "claim_mappings": {
    "name": "name",
    "email": "email",
    "groups": "groups"
  }
}
```


## Enable OIDC

Once the SSO configuration has been set, you can enable the OIDC auth method with the authentication settings endpoint:

```shell
$ https --auth "${KONNECT_PAT}" --auth-type bearer PATCH \
  'global.api.konghq.com/v2/authentication-settings' \
  basic_auth_enabled=true
  
{
  "oidc_auth_enabled": true,
  "basic_auth_enabled": true
}
```
Once OIDC has been enabled. You can verify the configuration is valid by signing on at https://cloud.konghq.com/login/{login_path}.


### Scopes

If we'd like to customize the list of scopes sent from the Konnect identity service to your IdP, we can configure the 
`scopes` attribute of our IdP configuration.

{:.note}
> The `openid` scope is a required scope value as specified [here](https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest).

```shell
$ https --auth "${KONNECT_PAT}" --auth-type bearer PATCH \
  'global.api.konghq.com/v2/identity-provider' \
  scopes[]='openid' \
  scopes[]='email' \
  scopes[]='profile' \
  scopes[]='custom-data'

{
  "issuer": "https://myidp.com/oauth2",
  "login_path": "example",
  "client_id": "example-client-id",
  "client_secret": "example-client-secret",
  "scopes": [
    "openid",
    "email",
    "profile",
    "custom-data"
  ],
  "claim_mappings": {
    "name": "name",
    "email": "email",
    "groups": "groups"
  }
}
```

Here we have updated our `scopes` attribute to include our new `custom-data` scope.

### Claims

If we'd like to customize the mapping of required claim data to different claim values, we can update our 
`claim_mappings` attribute with our desired keys.

Given the following claim configuration:

* Name: `sub`
* Email: `distinguishedName`
* Groups: `domains`

We can achieve this with the following request:

```shell
$ https --auth "${KONNECT_PAT}" --auth-type bearer PATCH \
  'global.api.konghq.com/v2/identity-provider' \
  claim_mappings[name]='sub' \
  claim_mappings[email]='distinguishedName' \
  claim_mappings[groups]='domains'

{
  "issuer": "https://myidp.com/oauth2",
  "login_path": "example",
  "client_id": "example-client-id",
  "client_secret": "example-client-secret",
  "scopes": [
    "openid",
    "email",
    "profile",
    "custom-data"
  ],
  "claim_mappings": {
    "name": "sub",
    "email": "distinguishedName",
    "groups": "domains"
  }
}
```

Here we have updated our `claim_mappings` attribute to reflect our desired data mapping.

### Team Mapping

Konnect can automatically map IdP groups to Konnect teams using IdP team mapping.

For now, we can configure our admins to be mapped automatically to the `Organization Admin` Konnect team.

First we'll fetch the admin team from Konnect.

```shell
$ https --auth "${KONNECT_PAT}" --auth-type bearer GET \
  'global.api.konghq.com/v2/teams?filter[name]=organization-admin'

{
    "data": [
        {
            "created_at": "2023-02-17T17:10:14Z",
            "description": "Allow managing all objects, users and roles in the organization.",
            "id": "06ad9adc-4b57-4c44-a64d-86547a39435b",
            "name": "organization-admin",
            "system_team": true,
            "updated_at": "2023-02-17T17:10:14Z"
        }
    ],
    "meta": {
        "...": {
            "number": 1,
            "size": 10,
            "total": 1
        }
    }
}
```

Then we can update our IdP group to Konnect team mappings.

```shell
$ https --auth "${KONNECT_PAT}" --auth-type bearer PUT  \
  'global.api.konghq.com/v2/identity-provider/team-mappings' \
  mappings:='[{"group":"company.konnect.admins","team_ids":["06ad9adc-4b57-4c44-a64d-86547a39435b"]}]'

{
    "mappings": [
        {
            "group": "company.konnect.admins",
            "team_ids": [
                "06ad9adc-4b57-4c44-a64d-86547a39435b"
            ]
        }
    ]
}
```

Here we have updated our `claim_mappings` attribute to reflect our desired data mapping of the `company.konnect.admins`
group to the `organization-admin` Konnect team.
