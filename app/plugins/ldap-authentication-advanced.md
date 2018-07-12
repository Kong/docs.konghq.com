---
id: page-plugin
title: Plugins - LDAP Authentication Advanced
layout: plugin-ee
header_title: LDAP Authentication Advanced
header_icon: https://konghq.com/wp-content/uploads/2018/07/EE-ldap.png
breadcrumbs:
  Plugins: /plugins
description: |
  The LDAP Authentication Advanced plugin for Kong Enterprise Edition is an extended version of the Community Edition LDAP Authentication plugin, with enhanced configuration options and features.

---

## Enterprise Features

#### Consumer Mapping

When authenticating via Kong, it is sometimes advantageous to apply plugin behavior at the consumer level (e.g. rate-limiting); as such, the following options are provided:

field               | required | default                  | description |
--------------------|----------|--------------------------|-------------|          
`consumer_by`       |          | `{ username, custom_id }`| Find consumers by `consumer_by fields and map to ldap-auth  user This will set the authenticated consumer so that X-Consumer-{ID, USERNAME, CUSTOM_ID} headers are set and consumer functionality is available. |
`consumer_optional` |          | `false`                  | By default, the consumer mapping is NOT optional. Set this config to `true` when you do NOT want the plugin to map to a kong consumer.|
