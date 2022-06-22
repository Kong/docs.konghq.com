---
title: Troubleshoot Account and Org Issues
no_version: true
---

## Identity Provider Errors

### Groups claim is empty when Okta is the IdP

#### Problem
In the token payload, the `groups` claim is configured correctly but still
appears empty, or it includes some groups but not all.

#### Solution
This issue might happen if the authorization server is pulling in additional
groups from third-party applications, for example, Google groups.

An Okta administrator needs to duplicate the third-party groups
and re-create them directly in Okta. They can do this by exporting the group
in CSV format, then importing the CSV file into Okta to populate the new group.

### Named cookie not present

#### Problem
If the issuer URI is incorrect or incomplete, you may get the following error
when trying to authenticate with Okta:

```
failed to get state: http: named cookie not present
```

This may happen if the wrong issuer URI was used, for example, the URI from
your application's settings. That URI is incomplete: `https://example.okta.com`.

#### Solution
The issuer URI must be in the following format, where `default` is
the name or ID of the authorization server:

```
https://example.okta.com/oauth2/default
```

You can find this URI in your Okta developer account, under **Security** > **API**.
