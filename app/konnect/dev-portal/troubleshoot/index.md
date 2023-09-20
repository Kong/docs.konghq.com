---
title: Troubleshooting
---

This document contains frequently asked questions. 


## How to find the Dev Portal URL {#locate}

Admins can find the Dev Portal URL in [cloud.konghq.com](https://cloud.konghq.com/). If you don't have admin access and want to register as a developer, ask your {{site.konnect_short_name}} admin for the Dev Portal URL.

{:.note}
> **Note**: If you are an admin planning to create applications and register services, you must also [Register as a Developer](#register-as-a-developer).

1. As an admin, log in to [cloud.konghq.com](https://cloud.konghq.com/). 

2. Use the left-side menu to navigate to **Dev Portal**, then **Published Services**.

3. Under the title heading **Published Services**, see the **Portal URL** link.


## Application registration is not enabled for this service

You may encounter the following error in the registration dialog:

```
Application registration is not enabled for this service. 
```

To resolve the error, [enable application registration for the service](/konnect/dev-portal/applications/enable-app-reg/). Contact your {{site.konnect_short_name}} admin if you do not have the access to do so.


## How to differentiate between registration plugins in decK {#deck}

If using a [declarative configuration](/konnect/gateway-manager/control-plane-groups/declarative-config/)
file to manage your service, these plugins appear in the file. **Do not**
delete or edit them through declarative configuration, as it will break your service.

To help differentiate the application registration plugins,
{{site.konnect_short_name}} automatically adds two metadata tags:
`konnect-managed-plugin` and `konnect-app-registration`.

For example, if you enable application registration from the
{{site.konnect_short_name}} web application and run `deck dump`, you should see
an entry like this for the ACL plugin:

```yaml
plugins:
- name: acl
  config:
    allow:
    - 0003237b-7e77-4ec4-8dd0-b1b587305c28
    deny: null
    hide_groups_header: false
  enabled: true
  protocols:
  - grpc
  - grpcs
  - http
  - https
  tags:
  - konnect-managed-plugin
  - konnect-app-registration
  ```
