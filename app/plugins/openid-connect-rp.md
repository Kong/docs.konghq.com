---
id: page-plugin
title: Plugins - OpenID Connect 1.0 RP
header_title: OpenID Connect 1.0 Relying Party
header_icon: /assets/images/icons/plugins/openid-connect-rp.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Requesting Access
---

OpenID Connect 1.0 RP is actually a suite of several Kong plugins related to
[OpenID Connect][connect]. There are several use cases that the plugins try
to solve. The plugin suite consists of:

<br />

* **OpenID Connect Verification Plugin** that is used for [ID Token][idtoken]
  and access token verification, and supports automatic key rotation based on
  [OpenID Connect Discovery][discovery], and caching. We also support dynamic
  rate-limiting based on the claims provided.
  
* **OpenID Connect Authentication Plugin** implements [OpenID Connect][connect]
  authentication flow within the Kong. It manages the access and [id tokens][idtoken]
  for the client, including caching and refreshing them, and provides the client
  a session.
  
* **OpenID Connect Protection Plugin** is used with the authentication plugin
  to protect specific API services.

* **OpenID Connect Revocation Plugin** allows the tokens to be revoked, and
  black-listed for usage.
  
* **OpenID Connect Dereferencing Plugin** enables the Kong act as a central
  place where the opaque tokens are dereferenced and other information
  (e.g. [OpenID Connect User Info][userinfo]) is gathered before the request
  is proxied to the API Service. This plugin also implements the caching to
  ease the burden on external sources.
  

We look forward expanding the plugin suite with a new plugins as the need for
them arises. For that we especially want to get feedback from the
[Mashape Enterprise](/enterprise) customers. 
  
<br />

<div class="alert alert-warning">
  <strong>Enteprise-Only</strong> This plugin is only available with an
  Enterprise Subscription. 
</div>

----

## Requesting Access

This plugin is only available with a [Mashape Enterprise](/enterprise) 
subscription.

If you are already a Mashape Enteprise customer, you can request access to the
plugin by opening an official support ticket using our Enteprise support 
channels.

If you are not a Mashape Enterprise customer, you can inquire about our
Enterprise offering by [contacting us](/enterprise).


[connect]: http://openid.net/specs/openid-connect-core-1_0.html
[discovery]: http://openid.net/specs/openid-connect-discovery-1_0.html
[idtoken]: http://openid.net/specs/openid-connect-core-1_0.html#IDToken
[userinfo]: http://openid.net/specs/openid-connect-core-1_0.html#UserInfo

