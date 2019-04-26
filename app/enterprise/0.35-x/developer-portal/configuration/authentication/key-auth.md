---
title: How to Enable Key Auth in the Dev Portal
---

### Introduction

The Dev Portal can be fully or partially authenticated using API keys or **Key
Authentication**. Users provide a unique key upon registering and use this key
to log into the Dev Portal.

Key Authentication for the Dev Portal can be enabled in three ways:

- via the [Kong Manager](#enable-key-auth-via-kong-manager)
- via the [the command line](#enable-key-auth-via-the-command-line)
- via the [the Kong configuration file](#enable-key-auth-via-the-kong-conf)

### Enable Key Auth via Kong Manager

1. Navigate to the Dev Portal's **Settings** page
2. Find **Authentication plugin** under the **Authentication** tab
3. Select **Key Authentication** from the drop down
4. Click the **Save Changes** button at the bottom of the form

>**Warning** This will automatically authenticate the Dev Portal with Key 
>Auth. Anyone currently viewing the Dev Portal will lose access on the 
>next page refresh.


### Enable Key Auth via the Command Line

To patch a Dev Portal's authentication property directly run:

```
curl -X PATCH http://localhost:8001/workspaces/<WORKSPACE NAME> \
  --data "config.portal_auth=key-auth"
```

>**Warning** This will automatically authenticate the Dev Portal with Key 
>Auth. Anyone currently viewing the Dev Portal will lose access on the 
>next page refresh.

### Enable Key Auth via the Kong.conf

Kong allows for a `default authentication plugin` to be set in the Kong 
configuration file with the `portal_auth` property.

In your `kong.conf` file set the property as follows:

```
portal_auth="key-auth"
```

This will set every Dev Portal to use Key Authentication by default when 
initialized, regardless of Workspace. See 
[Setting a Default Auth Plugin](/developer-portal/configuration/default-settings/#auth-plugin) for more information.