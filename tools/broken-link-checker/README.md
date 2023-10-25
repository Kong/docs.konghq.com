## Broken links

We check the documentation for broken links using [broken-link-checker](https://github.com/stevenvachon/broken-link-checker) and some custom logic to build a list of excluded URLs.

The link checker runs in three different ways:

1. Run a check against a specific `app/_data/docs_nav*.yml` file, checking each URL in the file (this is preferred)
1. When a pull request is opened, any changed files are detected and those URLs are checked for broken links. This allows us to fix pages incrementally and ensure that we don't break any new links.
1. A full site scan, against the latest version of each product only. This allows us to check all pages for broken links. Once all broken links are fixed, we can retire this job in favour of the CI check.

To run a scan locally, you'll need to have the [`netlify` CLI](https://docs.netlify.com/cli/get-started/) installed.

Do **NOT** run the link checker against production.

To run the link checker, build the site locally and start a local Netlify dev environment. From your clone of the doc repo, run:

```bash
make build
cd dist
netlify dev
```

Then in another terminal, from the root of your clone of the docs repo:

```bash
cd broken-link-checker
npm ci
```

All of the commands below support the following flags:

* `--base_url https://example.com`
* `--verbose` (show each link being checked)

### Running a per-product scan

To scan a specific product, run the following (editing the `nav` and `ignore` options as needed):

```bash
node run.js product --nav gateway_2.8.x --ignore github.com
```

The `--ignore` option can be provided multiple times, and should be used to ignore false positives e.g. when running on a non-main branch you'll want to provide `--ignore docs.konghq.com/edit` to prevent the "Edit this page" URL from returning an error.

When running a scan, you may want to limit the number of pages scanned as you address any broken links. The `--page` and `--perPage` options can help with this. Here's how you scan 5 pages at a time:

```bash
# Scan the first five pages
node run.js product --nav gateway_2.8.x --page 0 --perPage 5

# Scan the next five pages
node run.js product --nav gateway_2.8.x --page 1 --perPage 5

# Continue until the script responds with "No URLs detected to test"
# Then run `node run.js product --nav gateway_2.8.x` as a complete check to
# ensure that you've caught all the broken links
```

The available flags are:

| Flag      | Description                                                                            | Default                                     |
| --------- | -------------------------------------------------------------------------------------- | ------------------------------------------- |
| --host    | Set the URL to run the checks against                                                  | `http://localhost:8888`                     |
| --nav     | The name of the nav file to load e.g. `gateway_2.8.x`                                  |                                             |
| --ignore  | A URL pattern to ignore when checking for broken links. May be provided multiple times |                                             |

### Running a full-site scan

The final option available is to run a full site scan. This will follow any links it detects and check links on those pages too.

In general, running a per-product scan is the better choice, but if you _really_ want to scan the whole site, use the following:

```bash
node full.js --host http://localhost:8888/
```

Finally, be patient. The run will take at least 10 minutes, and up to 60 minutes to complete.

## Checking Plugins

Links in the `_index` file of plugins will be checked automatically when a PR is raised.

To check all plugins on your local machine, run `netlify dev` then use one of the following commands:

```bash
# Check the index file of Kong plugins
node run.js plugins --pattern "kong-inc/**/_index"

# Check all versions of Kong plugins
node run.js plugins --pattern "kong-inc/**/*"

# Check ALL plugins
node run.js plugins --pattern "**/*"
```
