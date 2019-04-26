---
title: How to Enable Basic Auth in the Dev Portal
---

### Introduction

The Dev Portal can be fully or partially authenticated using HTTP protocol's Basic Authentication scheme. Requests will be sent with the Authorization header that 
contains the word `Basic` followed by the base64-encoded `username:password` string. 

Basic Authentication for the Dev Portal can be enabled in three ways:

- via the [Kong Manager](#enable-basic-auth-via-kong-manager)
- via the [the command line](#enable-basic-auth-via-the-command-line)
- via the [the Kong configuration file](#enable-basic-auth-via-the-kong-conf)

### Enable Basic Auth via Kong Manager

1. Navigate to the Dev Portal's **Settings** page
2. Find **Authentication plugin** under the **Authentication** tab
3. Select **Basic Authentication** from the drop down
4. Click the **Save Changes** button at the bottom of the form

>**Warning** This will automatically authenticate the Dev Portal with Basic 
>Auth. Anyone currently viewing the Dev Portal will lose access on the 
>next page refresh.


### Enable Basic Auth via the Command Line

To patch a Dev Portal's authentication property directly run:

```
curl -X PATCH http://localhost:8001/workspaces/<WORKSPACE NAME> \
  --data "config.portal_auth=basic-auth"
```

>**Warning** This will automatically authenticate the Dev Portal with Basic 
>Auth. Anyone currently viewing the Dev Portal will lose access on the 
>next page refresh.

### Enable Basic Auth via the Kong.conf

Kong allows for a `default authentication plugin` to be set in the Kong 
configuration file with the `portal_auth` property.

In your `kong.conf` file set the property as follows:

```
portal_auth="basic-auth"
```

This will set all Dev Portals to use Basic Authentication by default when initialized. See 
[Setting a Default Auth Plugin](/developer-portal/configuration/default-settings/#auth-plugin) for more information.
