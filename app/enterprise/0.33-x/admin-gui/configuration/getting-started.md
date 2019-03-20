---
title: Getting Started with the Kong Admin GUI
book: admin_gui
chapter: 2
toc: false
---

## Start Kong

Start Kong.

```bash
$ kong start [-c /path/to/kong.conf]
```

**Note:** the CLI accepts a configuration option (`-c /path/to/kong.conf`)
allowing you to point to [your own configuration](/0.13.x/configuration/#configuration-loading).

Visit the Admin GUI:

* Navigate your browser to `http://localhost:8002`

You should now see the dashboard of the Kong Admin GUI.

## Next Steps

### Adding Authentication
To add Authentication, head on over to [Authenticating the Kong Admin GUI](/enterprise/{{page.kong_version}}/admin-gui/configuration/authentication).

Next: [Authentication &rsaquo;]({{page.book.next}})
