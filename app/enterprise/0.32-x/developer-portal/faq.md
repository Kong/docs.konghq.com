---
title: FAQ Kong Developer Portal
book: portal
chapter: 11
---

# FAQ

## Why do I get `{"message":"not found"}` when I visit my Developer Portal?

You most likely have not configured the [`portal`][property_portal]
property correctly. Check your Kong Configuration and ensure that [`portal`][property_portal]
is set to `on`.

## Why do I see `No Files Found` when I visit my Developer Portal?

This can be caused by a few reasons:

1. Missing developer portal files. (`127.0.0.1:8001/files`)
1. Improper [Network configuration][configuration_network].

If you have confirmed that you have files and your network setup is properly
configured, please [contact support](mailto:support@konghq.com) for further assistance.

## Why do I have files with `unauthenticated/` in them?

When a user requests a particular page to access that they are not authorized to
view, the Dev Portal will check for the same filename under the `unauthenticated`
namespace to serve instead. For this reason `unauthenticated` is a reserved
namespace, and should **only** be used for portals that have Authentication
enabled.

## What file types are supported?

You can find a list of supported template types on the
[File Management][file_types] page.

## Does the developer portal support uploading images, scripts, and videos?

Currently the Kong Developer Portal only supports text based content, custom
scripts &amp; styles, can be added by leveraging `partials`.

Media like images, SVGs, and videos should be encoded and inserted inline or
hosted elsewhere and referenced.

## Can I use other API specification formats like API Blueprint?

Currently only Swagger 2 and OpenAPI 3 are supported.

## Can I modify the Header and Meta tags?

Direct modification of the `<meta>` and `<head>` tags is currently not supported,
you can accomplish this through Custom JS included as a handlebars partial.

## Can I host my API spec files outside of the File API?

Currently the Kong Developer Portal can only render API specifications that are
served by the File API.

## Can I write my content in markdown?

Currently content written in Markdown format is not supported.

## Can I change the code snippet languages displayed on my documentation?

Yes! You can change the display and languages of the code snippets by modifying
the `unauthenticated/code-snippet-languages.hbs` partial through the Portal API.
See [Updating Files][file_updating] for more information.

[file_types]: /enterprise/{{page.kong_version}}/developer-portal/file-management#file-types
[file_updating]: /enterprise/{{page.kong_version}}/developer-portal/file-management/#updating-files
[property_portal]: /enterprise/{{page.kong_version}}/developer-portal/configuration/property-reference#portal
[configuration_network]: /enterprise/{{page.kong_version}}/developer-portal/configuration/networking
