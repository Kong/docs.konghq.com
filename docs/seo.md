# SEO

The canonical URL for each page is automatically set by the `canonical_url_generator` plugin. It works by looking for a URL that matches the current page, but where the version is higher than the current URL. As an example:

1. `/gateway/2.3.x/configuration` would have a canonical URL of `/gateway/2.5.x/configuration`. `2.5.x` is the last version in which this URL existed.

2. In `2.6.x` the page moved to `/gateway/2.6.x/reference/configuration`, which means the canonical URL would normally be `/gateway/2.8.x/reference/configuration`.

3. _However_, we have a special `/latest/` URL which is always the latest version, so the canonical URL for the 2.6.x link above would actually be `/gateway/latest/reference/configuration`.

## Tracking file renames

It is possible to track pages through renames using the `moved_urls.yml` file. This is a key:value file that contains the old URL and the URL that it should be mapped to. e.g.

```yaml
---
/gateway-oss/VERSION/configuration/: "/gateway/VERSION/reference/configuration/" # 2.5.x
```

It is possible for a URL to be forwarded multiple times. In this instance, the final URL will be set as canonical on all pages rather than creating a canonical chain:

```yaml
---
/gateway-oss/VERSION/configuration/: "/foo/bar/" # 2.5.x
/foo/bar/: "/gateway/VERSION/reference/configuration/" # 4.2.x
```

Each line ends with a comment. This is the latest version that uses the source URL. This is useful to keep track of, as it allows us to remove entries from `moved_urls.yml` when archiving old content. In this example, when `2.5.x` is archived we can remove the `/gateway-oss/VERSION/configuration/` canonical redirect.