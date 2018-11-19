---
title: Getting Started with the Kong Dev Portal
book: portal
chapter: 3
toc: false
---

## Enable the Kong Dev Portal 

To enable the Dev Portal, the following properties must be set in the Kong 
configuration file (`kong.conf`):

```
portal = on
portal_gui_protocol = http
portal_gui_host = localhost:8003
portal_emails_from = <example@example.com>
portal_emails_reply_to = <example@example.com>
```

Kong must be **restarted** for these values to take effect.

- This will expose the **default Dev Portal** at [http://localhost:8003/default](http://localhost:8003/default)
- The **Dev Portal Files endpoint** can be accessed at `:8001/files`
- The **Public Dev Portal Files API** can be accessed at `:8004/files`


*Optional*

```
smtp_mock = on
portal_gui_use_subdomains = on
```
When `smtp_mock` is enabled, Kong will not attempt to send actual emails. This
is useful for testing purposes.

When `portal_gui_use_subdomains` is enabled Dev Portal workspace urls will be 
included as subdomains e.g `http://default.localhost:8003`

For more information on the Dev Portal properties available, checkout out the 
[Kong Enterprise Configuration Property Reference](/enterprise/{{page.kong_version}}/property-reference)

> Note: Not all deployments of Kong utilize a configuration file, if this describes you (or you are unsure) please reference the [Kong configuration docs](https://docs.konghq.com/0.13.x/configuration/) in order to implement this step.



<div>
 <h2>Next Steps</h2>
</div>
<div class="docs-grid">

  <div class="docs-grid-block">
    <h3><img src="/assets/images/icons/documentation/icn-window.svg" /><a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/networking">Networking</a></h3>
    <p>Review how the Dev Portal config variables are utilized within the Dev Portal.</p>
    <a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/networking">Learn More &rarr;</a>
  </div>

  <div class="docs-grid-block">
    <h3><img src="/assets/images/icons/documentation/icn-window.svg" /><a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/authentication">Authentication</a></h3>
    <p>Learn how to add authentication to the Dev Portal.</p>
    <a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/authentication">Learn More &rarr;</a>
  </div>

  <div class="docs-grid-block">
    <h3><img src="/assets/images/icons/documentation/icn-window.svg" /><a href="/enterprise/{{page.kong_version}}/configuration/developer-portal/smtp">SMTP Configuration</a></h3>
    <p>Learn how to configure the Dev Portal SMTP server.</p>
    <a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/smtp">Learn more &rarr;</a>
  </div>

  <div class="docs-grid-block">
    <h3><img src="/assets/images/icons/documentation/icn-window.svg" /><a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/workspaces">Working with Workspaces</a></h3>
    <p>Learn how to set up and configure Dev Portals within a Workspace.</p>
    <a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/workspaces">Learn More &rarr;</a>
  </div>
