---
title: Getting Started with the Kong Admin GUI
book: admin_gui
chapter: 2
---

# {{page.title}}

## Start Kong

Start Kong. 

`kong start -c kong.conf.default`

> Note: Not all deployments of Kong utilize a configuration file, if this describes you (or you are unsure) please reference the [Kong configuration docs](/enterprise/0.33-x/developer-portal/configuration/getting-started/) in order to implement this step.

Visit the Admin GUI:

* Navigate your browser to `http://localhost:8002`

You should now see the dashboard of the Kong Admin GUI.

## Next Steps

#### Adding Authentication
To add Authentication, head on over to [Authenticating the Kong Admin GUI](/enterprise/{{page.kong_version}}/admin-gui/configuration/authentication).

Next: [Authentication &rsaquo;]({{page.book.next}})
