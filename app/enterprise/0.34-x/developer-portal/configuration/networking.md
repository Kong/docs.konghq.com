---
title: Dev Portal Networking
book: portal
chapter: 5
toc: false
---

## Dev Portal Configuration Reference


#### portal_gui_protocol

**Description**

Sets the protocol the Dev Portal will use to construct the URL.

**Valid inputs:** `http`, `https`


#### portal_gui_host

**Description:**

Sets the host name for the Dev Portal URL.

**Example:** `localhost:8003`


#### portal_gui_use_subdomains
**Description:**

Determines where the Dev Portal will expect the Workspace name to be included in the request URL.

When this option is `off` the Dev Portal will use the following URL scheme:

```
scheme://<HOSTNAME>/<WORKSPACE>/index
```

**Example:** `http://localhost:8003/default/login`


When this option is `on` the Dev Portal will follow this URL scheme:

```
scheme://<WORKSPACE>.<HOSTNAME>
```
**Example:** `http://default.localhost:8003/login`

<div>
  <h3>Next Steps</h3>
</div>
<div class="docs-grid">
  <div class="docs-grid-block">
    <h3><img src="/assets/images/icons/documentation/icn-window.svg" /><a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/authentication">Authentication</a></h3>
    <p>Learn how to add authentication to the Dev Portal.</p>
    <a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/authentication">Learn More &rarr;</a>
  </div>

  <div class="docs-grid-block">
    <h3><img src="/assets/images/icons/documentation/icn-window.svg" /><a href="/enterprise/{{page.kong_version}}/developer-portal/smtp">SMTP Configuration</a></h3>
    <p>Learn how to configure the Dev Portal SMTP server.</p>
    <a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/smtp">Learn more &rarr;</a>
  </div>

  <div class="docs-grid-block">
    <h3><img src="/assets/images/icons/documentation/icn-window.svg" /><a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/workspaces">Working with Workspaces</a></h3>
    <p>Learn how to set up and configure Dev Portals within a Workspace.</p>
    <a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/workspaces">Learn More &rarr;</a>
  </div>
</div>
