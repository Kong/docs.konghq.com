---
title: Using the Portal Files API
---

# Portal Files API Overview

The Portal Files API can be used as an alternative to the Portal CLI to manage
dev portal content. Portal content must maintain a specific structure to render
correctly, so it is generally recommended to use the
[CLI](/enterprise/2.1.x/developer-portal/helpers/cli/)
because it enforces that structure. For this reason, using the Portal Files
API can be useful in particular for smaller tasks,
such as managing specification files outside the context of
[kong-portal-templates](https://github.com/kong/kong-portal-templates).


Parameter                       | Type   | Description                | Required | Example
-------------------------------:|:------:|:--------------------------:|:--------:|---------------
`path`                          | `string` | The path of the file.      | `yes`    | `content/example.txt`, `specs/petstore.json`, `themes/base/layouts/index.html`
`contents`                      | `string` | The contents of the file.  | `yes`    |

## Post a content file

See the [Content File Docs](/enterprise/{{page.kong_version}}/developer-portal/structure-and-file-types#content-files).

```bash
http post :8001/default/files  \
  path=content/homepage.html   \
  contents=@<file-location>.html \

```

## Post a spec file

See the [Spec File Docs](/enterprise/{{page.kong_version}}/developer-portal/structure-and-file-types#spec-files).

```bash
http post :8001/default/files  \
  path=specs/homepage.json   \
  contents=@<spec-location>.json \

```

## Post a theme file

See the [Theme File Docs](/enterprise/{{page.kong_version}}/developer-portal/structure-and-file-types#theme-files).

```bash
http post :8001/default/files  \
  path=themes/base/partials/header.html \
  contents=@<partial-location>.html \

```

## Get a file

```bash
http :8001/default/files/content/index.txt
```

## Patch a file

```bash
http patch :8001/default/files/content/index.txt
  contents=@<updated-content-file-location>.html \
```

## Delete a file

```bash
http delete :8001/default/files/content/index.txt
```
