---
title: Using the Portal Files API
---

## Portal Files API Overview

The Portal Files API can be used as an alternative to the Portal CLI to manage
dev portal content. Portal content must maintain a specific structure to render
correctly, so it is generally recommended to use the
[CLI](/enterprise/{{page.kong_version}}/developer-portal/helpers/cli/)
because it enforces that structure. The Portal Files API is useful for smaller
tasks such as managing specification, content, or theme files outside the context of
[kong-portal-templates](https://github.com/kong/kong-portal-templates).


Parameter                       | Type   | Description                | Required | Examples
-------------------------------:|:------:|:--------------------------:|:--------:|---------------
`path`                          | `string` | The path to the file.      | `yes`    | `content/example.txt`, `specs/petstore.json`, `themes/base/layouts/index.html`
`contents`                      | `string` | The contents of the file.  | `yes`    | `contents=@<file-location>.html`, `contents=@<spec-location>.json`, `contents=@<partial-location>.html`

**Note:** The `@` symbol in a command automatically reads the file on disk and places
its contents into the contents argument.

### POST a Content File

For more details about content files, see the
[Content File documentation](/enterprise/{{page.kong_version}}/developer-portal/structure-and-file-types#content-files).

{% navtabs %}
{% navtab Using cURL %}

```bash
$ curl -X POST http://<admin-hostname>:8001/default/files \
  -F "path=content/homepage.html" \
  -F "contents=@<file-location>.json"
```

{% endnavtab %}
{% navtab Using HTTPie %}

```bash
$ http post :8001/default/files  \
  path=content/homepage.html   \
  contents=@<file-location>.html
```

{% endnavtab %}
{% endnavtabs %}


### POST a Spec File

For more details about specification files, see the
[Spec File documentation](/enterprise/{{page.kong_version}}/developer-portal/structure-and-file-types#spec-files).

{% navtabs %}
{% navtab Using cURL %}

```bash
$ curl -X POST http://<admin-hostname>:8001/default/files \
  -F "path=specs/homepage.json" \
  -F "contents=@<spec-location>.json"
```

{% endnavtab %}
{% navtab Using HTTPie %}

```bash
$ http post :8001/default/files  \
  path=specs/homepage.json   \
  contents=@<spec-location>.json
```

{% endnavtab %}
{% endnavtabs %}


### POST a Theme File

For more details about theme files, see the
[Theme File documentation](/enterprise/{{page.kong_version}}/developer-portal/structure-and-file-types#theme-files).

{% navtabs %}
{% navtab Using cURL %}

```bash
$ curl -X POST http://<admin-hostname>:8001/default/files \
  -F "path=themes/base/partials/header.html" \
  -F "contents=@<partial-location>.html"
```

{% endnavtab %}
{% navtab Using HTTPie %}

```bash
$ http post :8001/default/files  \
  path=themes/base/partials/header.html \
  contents=@<partial-location>.html
```

{% endnavtab %}
{% endnavtabs %}

### GET a File

{% navtabs %}
{% navtab Using cURL %}

```bash
$ curl -X GET http://<admin-hostname>:8001/default/files/content/index.txt
```

{% endnavtab %}
{% navtab Using HTTPie %}

```bash
$ http :8001/default/files/content/index.txt
```

{% endnavtab %}
{% endnavtabs %}

### PATCH a File

{% navtabs %}
{% navtab Using cURL %}

```bash
$ curl -X PATCH http://<admin-hostname>:8001/default/files/content/index.txt \
  -F "contents=@<updated-content-file-location>.txt"
```

{% endnavtab %}
{% navtab Using HTTPie %}

```bash
$ http patch :8001/default/files/content/index.txt \
  contents=@<updated-content-file-location>.txt
```

{% endnavtab %}
{% endnavtabs %}

### DELETE a File

{% navtabs %}
{% navtab Using cURL %}

```bash
$ curl -X DELETE http://<admin-hostname>:8001/default/files/content/index.txt
```

{% endnavtab %}
{% navtab Using HTTPie %}

```bash
$ http delete :8001/default/files/content/index.txt
```
{% endnavtab %}
{% endnavtabs %}
