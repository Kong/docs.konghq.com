[![Netlify Status](https://api.netlify.com/api/v1/badges/73f0326f-bdc1-41ab-b2c9-bb17af214f6a/deploy-status)](https://app.netlify.com/sites/kongdocs/deploys)
[![](https://img.shields.io/github/license/kong/docs.konghq.com)](https://github.com/Kong/docs.konghq.com/blob/main/LICENSE)
[![](https://img.shields.io/github/contributors/kong/docs.konghq.com)]()

# Kong's Documentation Website

This repository contains the source content and code for [Kong](https://github.com/Kong/kong)'s documentation website. It's built using [Jekyll](https://jekyllrb.com/) and deployed with [Netlify](https://www.netlify.com/).

Here are some things to know before you get started:

* **We're beginner-friendly**. Whether you're a Technical Writer learning about docs-as-code or an engineer practicing your documentation skills, we welcome your involvement. If you'd like to contribute and don't have something in mind already, head on over to [Issues](https://github.com/Kong/docs.konghq.com/issues). We've added `good first issue` labels on beginner-friendly issues.

* **We need more help in some areas**. We'd especially love some help with [plugin](https://github.com/Kong/docs.konghq.com/tree/main/app/_hub) documentation.

* **Some of our docs are generated**.
    * [Admin API](https://docs.konghq.com/gateway/latest/admin-api/)
    * [CLI reference](https://docs.konghq.com/gateway/latest/reference/cli/)
    * [OSS upgrade guide](https://docs.konghq.com/gateway/latest/install-and-run/upgrading-oss/)
    * [PDK reference](https://docs.konghq.com/gateway/latest/pdk)

All pull requests for these docs should be opened in the [Kong/kong](https://github.com/Kong/kong) repository. Fork the repository and submit PRs from your fork.

For [Gateway Enterprise configuration reference](https://docs.konghq.com/gateway/latest/reference/configuration), open an issue on this repo and we'll update the docs.

* **Community is a priority for us**. Before submitting an issue or pull request, make sure to review our [Contributing Guide](https://docs.konghq.com/contributing/) and our [documentation templates](https://github.com/Kong/docs.konghq.com/tree/main/docs/templates).

* We are currently accepting plugin submissions to our plugin hub from trusted technical partners, on a limited basis. For more information, see the [Kong Partners page](https://konghq.com/partners/).

## Run Locally

For anything other than minor changes, [clone the repository onto your local machine and build locally](docs/platform-install.md). Once you've installed all of the tools required, you can use our `Makefile` to build the docs:

```bash
# Install prerequisites
make install-prerequisites

# Install dependencies
make install

# Create local .env file
# OAS Pages require VITE_PORTAL_API_URL to be set in your current environment, it should match the Kong supplied portal URL
cp .env.example .env

# Build the site and watch for changes 
make run
```

### Troubleshooting the local build

#### Invalid byte sequence in US-ASCII 

If you encounter an error that looks like this:

```
app/_plugins/generators/utils/frontmatter_parser.rb:8:in `match': invalid byte sequence in US-ASCII (ArgumentError)

      @result = @string.match(Jekyll::Document::YAML_FRONT_MATTER_REGEXP)
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    from app/_plugins/generators/utils/frontmatter_parser.rb:8:in `match'
```

You can try setting the `LANG` or `LC_ALL` environment variable to `en_US.UTF-8`. For example:

```bash
export LANG=en_US.UTF-8
```

### Generating specific products

In order to speed up build times, it's possible to generate a specific subset of products and their corresponding versions by specifying the `KONG_PRODUCTS` env variable. It takes a comma-separated list of products and for each product, the list of versions the versions to be generated separated by semi-colons, in the following way.

```bash
KONG_PRODUCTS='<product>:<version>;<version>,<product>:<version>,hub'
```

For example, running

```bash
KONG_PRODUCTS='gateway:2.8.x;3.3.x,mesh:2.2.x,hub' make run
```

will generate the plugin hub, mesh version `2.2.x`, and gateway versions `2.8.x` and `3.3.x`.
It also supports wildcard matching for both products and versions, i.e.

```bash
KONG_PRODUCTS='gateway:3.*'
```

and 

```bash
KONG_PRODUCTS='*:latest'
```
 are also possible.

## Plugin contributors

If you have contributed a plugin, you can add a Kong badge to your plugin README.

Use the following, where you replace `test` with your plugin name and `link-to-docs` with a link to the Kong docs for your plugin.

```
[![](https://img.shields.io/badge/Kong-test-blue.svg?colorA=042943&colorB=00C4BB&style=flat&longCache=true&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xOdTWsmQAAAIcSURBVDhPY2DRdCYb0Vgzh46btlcCmiAEEdDMb+w9a+Xmr99/FHdM49R1R5PFp5nPyHvfifP/weDvv39LNu4SMfdHVoBPs2VY9q4jpx8+ewnRDwRHz13h1veAK8CpmdfQq6xrRt2EeS7xxc9evYVovvf4mbhlIFwNTs1JlV1///4Fajh96UZIbt2nL1+B7B8/fznGFsDVYNcsYRX04jXUtn///m3ae7SgZcrnr9/aZixBDjYsmnn0Pe2j85++fAPRDAR///6btGitWXAGu7Yrskp0zaLmAWt2HLxy+35UUcvHzyCnQsCv37/zWiaxabkgK0ZoFrMIMA3OOH/t9j+w6j3HzmbW9wE9CeaBwJdv30PyGuDqgQiqWdDU9/TlG99//IQqBHt1wbodjZMX/PnzByr0///rdx+sI3JQNAMT4ML1O6HySOD3nz+FbVOBUsAUAhUCx5aqawxCc2HbFKA9UEmwHqATgOjdx092UXmCJr57j5+DyoHBqUs3RC0CoJqRXfv795/sxol+GVVA5JJQzK3vCVQgZx92+eY9qApI5O07BtUMFQODGcs3RRY1v3zzHug9IJq4cA3QU0A1+r7JT168hir6/x/IZtVyQdF85spNYGYAOunh0xcQEWAM5TRNBKoBIo/ksi9fv0PEgdEJFAFpvnbnARBduH4Hnm+BKQkiCETAMGfTBkWviJn/3mNnIYKp1d1QzWQiTWcA1wsS5+E9q+MAAAAASUVORK5CYII=)](link-to-docs)
```

Here's how the badge looks: [![](https://img.shields.io/badge/Kong-test-blue.svg?colorA=042943&colorB=00C4BB&style=flat&longCache=true&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xOdTWsmQAAAIcSURBVDhPY2DRdCYb0Vgzh46btlcCmiAEEdDMb+w9a+Xmr99/FHdM49R1R5PFp5nPyHvfifP/weDvv39LNu4SMfdHVoBPs2VY9q4jpx8+ewnRDwRHz13h1veAK8CpmdfQq6xrRt2EeS7xxc9evYVovvf4mbhlIFwNTs1JlV1///4Fajh96UZIbt2nL1+B7B8/fznGFsDVYNcsYRX04jXUtn///m3ae7SgZcrnr9/aZixBDjYsmnn0Pe2j85++fAPRDAR///6btGitWXAGu7Yrskp0zaLmAWt2HLxy+35UUcvHzyCnQsCv37/zWiaxabkgK0ZoFrMIMA3OOH/t9j+w6j3HzmbW9wE9CeaBwJdv30PyGuDqgQiqWdDU9/TlG99//IQqBHt1wbodjZMX/PnzByr0///rdx+sI3JQNAMT4ML1O6HySOD3nz+FbVOBUsAUAhUCx5aqawxCc2HbFKA9UEmwHqATgOjdx092UXmCJr57j5+DyoHBqUs3RC0CoJqRXfv795/sxol+GVVA5JJQzK3vCVQgZx92+eY9qApI5O07BtUMFQODGcs3RRY1v3zzHug9IJq4cA3QU0A1+r7JT168hir6/x/IZtVyQdF85spNYGYAOunh0xcQEWAM5TRNBKoBIo/ksi9fv0PEgdEJFAFpvnbnARBduH4Hnm+BKQkiCETAMGfTBkWviJn/3mNnIYKp1d1QzWQiTWcA1wsS5+E9q+MAAAAASUVORK5CYII=)](link-to-docs)

See [Issue #908](https://github.com/Kong/docs.konghq.com/issues/908) for more information. Note that we're not currently hosting assets for badges.

## Generate the PDK, Admin API, CLI, and Configuration documentation

> This section is for Kong source code maintainers. You don't need to do anything here if you're contributing to this repo!

The PDK docs, Admin API docs, `cli.md` and `configuration.md` for each release are generated from the Kong source code.

To generate them, go to the `Kong/kong` repo and run:

```bash
scripts/autodoc <docs-folder> <kong-version>
```

For example:

```bash
cd /path/to/kong
scripts/autodoc ../docs.konghq.com 2.4.x
```

This example assumes that the `Kong/docs.konghq.com` repo is cloned into the
same directory as the `Kong/kong` repo, and that you want to generate the docs
for version `2.4.x`. Adjust the paths and version as needed.

After everything is generated, review, open a branch with the changes, send a
pull request, and review the changes.

You usually want to open a PR against a `release/*` branch. For example, in the
example above, the branch was `release/2.4`.

```bash
cd docs.konghq.com
git fetch --all
git checkout release/2.4
git checkout -b release/2.4-autodocos
git add -A .
git commit -m "docs(2.4.x) add autodocs"
git push
```

Then open a pull request against `release/2.4`.

## Testing

Tests for this site are written using `fetch`, `cheerio` and `jest`

To run the tests, you must first build the site by running `make build` before running `make smoke`.

Many of the tests are smoke tests to check for issues that occurred while adding caching to the site, such as ensuring that the side navigation isn't cached.

To add your own tests, look in the `tests` directory and use `home.test.js` as a sample. You specify which URL to visit and then a CSS selector to search for, before asserting that the contents match what you expect.

```javascript
test("has the 'Welcome to Kong' header", async () => {
  const $ = await fetchPage("/")
  expect($("#main")).toHaveText("Welcome to Kong Docs");
});
```

## Continuous Integration

We run various quality checks at build time to ensure that the documentation is maintainable.

Some of the checks can be manually marked as approved using labels:

* `ci:manual-approve:link-validation` - mark link checking as successful. Useful when Netlify returns an `HTTP 400` error and the links are validated manually.

### include-check

The `include-check.sh` script checks for any files in the `app/_includes` folder that depend on a `page.*` variable (e.g. `page.url`). This is not compatible with the `include_cached` gem that we use, and so using `page.*` in an include will fail the build.

> To run the script locally, open a terminal, navigate to the documentation
folder, and run `./include-check.sh`. If there is no output, everything is
successful.

In the following example, we can see that `admin-listen.md` uses a `page.*` variable, and that the include is used in the `docker.md` file:

```bash
❯ ./include-check.sh
Page variables must not be used in includes.
Pass them in via include_cached instead

Files that currently use page.*:
File: app/_includes/md/admin-listen.md
via:
app/_src/gateway/install/docker.md
```

Here are sample contents for those files:

In `docker.md`:

```md
{% include_cached app/_includes/md/admin-listen.md %}
```

In `deployment-options-k8s`:

```md
This is an include that uses {{ page.release }}
```

To resolve this, the two files should be updated to pass in the URL when `include_cached` is called:

In `docker.md`:

```md
{% include_cached app/_includes/md/admin-listen.md release=page.release %}
```

In `admin-listen`:

```md
This is an include that uses {{ include.release }}
```

The `include_cached` gem uses all passed parameters as the cache lookup key, and this ensures that all required permutations of an include file will be generated.

For guidelines on how to write includes and call them in target topics, see the
[Kong Docs contributing guidelines](https://docs.konghq.com/contributing/includes).

### Review Labels

When raising a pull request, it's useful to indicate what type of review you're looking for from the team. To help with this, we've added three labels that can be applied:

- `review:copyedit`: Request for writer review.
- `review:general`: Review for general accuracy and presentation. Does the doc work? Does it output correctly?
- `review:tech`: Request for technical review from an SME.

At least one of these labels must be applied to a PR or the build will fail.
