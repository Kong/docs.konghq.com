# Moved URLs checker

The docs site calculates a canonical URL for any page using the following logic:

1. Check if there's a page that exists with the exact same path, but a higher version number in the URL
1. Check if there's an entry in `moved_urls.yml` for the resolved path that points to a new URL

`/gateway/2.7.x/install-and-run/` will resolve to `/gateway/2.8.x/install-and-run/` automatically. 

If there is an entry in `moved_urls.yml` that says `/gateway/VERSION/install-and-run/: /gateway/VERSION/install/` then the canonical URL for `/gateway/2.7.x/install-and-run/` will resolve to `/gateway/latest/install`.

If there is no entry in `moved_urls.yml` **and** we're on the highest version available for a page, but it's not the latest version available, **this is an error**. The "latest version" URL will link to the same page that the user is on. In this instance, we need to add an entry to `moved_urls.yml` to direct them to the new, updated URL.

## Running the tool

To help prevent the error case where a page links to itself as the canonical URL, but isn't the latest version, we have a tool:

```bash
make build
netlify dev
```

Then in another terminal, from the root of your clone of the docs repo:

```bash
cd tools/moved-urls-checker
npm ci
node run.js --nav gateway_2.8.x
```

If there are errors, you'll get a list of URLs to resolve:

```
-----------------------------------------------------------------
Pages that link to themselves (no moved_urls.yml entry set):
-----------------------------------------------------------------
http://localhost:8888/gateway/2.8.x/availability-stages/
http://localhost:8888/gateway/2.8.x/install-and-run/centos/
http://localhost:8888/gateway/2.8.x/get-started/quickstart/configuring-a-service/
```