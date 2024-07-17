[![Netlify Status](https://api.netlify.com/api/v1/badges/73f0326f-bdc1-41ab-b2c9-bb17af214f6a/deploy-status)](https://app.netlify.com/sites/kongdocs/deploys)
[![](https://img.shields.io/github/license/kong/docs.konghq.com)](https://github.com/Kong/docs.konghq.com/blob/main/LICENSE)
[![](https://img.shields.io/github/contributors/kong/docs.konghq.com)]()

# Kong's Documentation Website

This repository contains the source content and code for [Kong](https://github.com/Kong/kong)'s documentation website. It's built using [Jekyll](https://jekyllrb.com/) and deployed with [Netlify](https://www.netlify.com/).

## Getting started

Here are some things you should know before getting started:

* **We're beginner-friendly**. Whether you're a Technical Writer learning about docs-as-code or an engineer practicing your documentation skills, we welcome your involvement. If you'd like to contribute and don't have something in mind already, head on over to [Issues](https://github.com/Kong/docs.konghq.com/issues). We've added `good first issue` labels on beginner-friendly issues.

* **We need more help in some areas**. We'd especially love some help with [plugin](https://github.com/Kong/docs.konghq.com/tree/main/app/_hub) documentation.

* **Community is a priority for us**. Before submitting an issue or pull request, make sure to review our [Contributing Guide](https://docs.konghq.com/contributing/). 

* **Some of our docs are [generated](docs/autodocs.md)**.

* **We are currently accepting plugin submissions** to our plugin hub from trusted technical partners, on a limited basis. For more information, see the [Kong Partners page](https://konghq.com/partners/).


### Running locally

For minor changes, use the GitHub UI via the "Edit this page" button on any docs page, or use [GitHub Codespaces]. 

For anything other than minor changes, [clone the repository onto your local machine and build locally](docs/platform-install.md). Once you've installed all of the tools required, you can use our `Makefile` to build the docs:

```bash
# Install dependencies
make install

# Create local .env file
# OAS Pages require VITE_PORTAL_API_URL to be set in your current environment, it should match the Kong supplied portal URL
cp .env.example .env

# Build the site and watch for changes
make run
```

### Generating specific products locally

Building the entire docs site can take a while. 
To speed up build times, you can generate a specific subset of products and their versions by setting the `KONG_PRODUCTS` environment variable. 
This variable takes a comma-separated list of products, each followed by a colon and a semicolon-separated list of versions. The format is:

```bash
KONG_PRODUCTS='<product>:<version>;<version>,<product>:<version>,hub'
```

For example, running

```bash
KONG_PRODUCTS='gateway:2.8.x;3.3.x,mesh:2.2.x,hub' make run
```

will generate the plugin hub, mesh version `2.2.x`, and gateway versions `2.8.x` and `3.3.x`.
Wildcard matching is supported for both products and versions: 

```bash
KONG_PRODUCTS='gateway:3.*'
```

and

```bash
KONG_PRODUCTS='*:latest'
```

The docs site will be available at [http://localhost:8888](http://localhost:8888).


### Review labels

When raising a pull request, it's useful to indicate what type of review you're looking for from the team. To help with this, we've added the following labels:

- `review:copyedit`: Request for writer review.
- `review:general`: Review for general accuracy and presentation. Does the doc work? Does it output correctly?
- `review:tech`: Request for technical review, usually internal to docs. We normally use this for docs platform work.
- `review:sme`: Request for SME review, external to the docs team.

At least one of these labels must be applied to a PR or the build will fail.

### Troubleshooting

For troubleshooting instructions, see the [troubleshooting documentation](docs/troubleshoot.md).


## Plugin contributors

If you have contributed a plugin to the Kong Plugin Hub, you can add a Kong badge to your plugin README.

Use the following, where you replace `test` with your plugin name and `link-to-docs` with a link to the Kong docs for your plugin.

```
[![](https://img.shields.io/badge/Kong-test-blue.svg?colorA=042943&colorB=00C4BB&style=flat&longCache=true&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xOdTWsmQAAAIcSURBVDhPY2DRdCYb0Vgzh46btlcCmiAEEdDMb+w9a+Xmr99/FHdM49R1R5PFp5nPyHvfifP/weDvv39LNu4SMfdHVoBPs2VY9q4jpx8+ewnRDwRHz13h1veAK8CpmdfQq6xrRt2EeS7xxc9evYVovvf4mbhlIFwNTs1JlV1///4Fajh96UZIbt2nL1+B7B8/fznGFsDVYNcsYRX04jXUtn///m3ae7SgZcrnr9/aZixBDjYsmnn0Pe2j85++fAPRDAR///6btGitWXAGu7Yrskp0zaLmAWt2HLxy+35UUcvHzyCnQsCv37/zWiaxabkgK0ZoFrMIMA3OOH/t9j+w6j3HzmbW9wE9CeaBwJdv30PyGuDqgQiqWdDU9/TlG99//IQqBHt1wbodjZMX/PnzByr0///rdx+sI3JQNAMT4ML1O6HySOD3nz+FbVOBUsAUAhUCx5aqawxCc2HbFKA9UEmwHqATgOjdx092UXmCJr57j5+DyoHBqUs3RC0CoJqRXfv795/sxol+GVVA5JJQzK3vCVQgZx92+eY9qApI5O07BtUMFQODGcs3RRY1v3zzHug9IJq4cA3QU0A1+r7JT168hir6/x/IZtVyQdF85spNYGYAOunh0xcQEWAM5TRNBKoBIo/ksi9fv0PEgdEJFAFpvnbnARBduH4Hnm+BKQkiCETAMGfTBkWviJn/3mNnIYKp1d1QzWQiTWcA1wsS5+E9q+MAAAAASUVORK5CYII=)](link-to-docs)
```

Here's how the badge looks: [![](https://img.shields.io/badge/Kong-test-blue.svg?colorA=042943&colorB=00C4BB&style=flat&longCache=true&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xOdTWsmQAAAIcSURBVDhPY2DRdCYb0Vgzh46btlcCmiAEEdDMb+w9a+Xmr99/FHdM49R1R5PFp5nPyHvfifP/weDvv39LNu4SMfdHVoBPs2VY9q4jpx8+ewnRDwRHz13h1veAK8CpmdfQq6xrRt2EeS7xxc9evYVovvf4mbhlIFwNTs1JlV1///4Fajh96UZIbt2nL1+B7B8/fznGFsDVYNcsYRX04jXUtn///m3ae7SgZcrnr9/aZixBDjYsmnn0Pe2j85++fAPRDAR///6btGitWXAGu7Yrskp0zaLmAWt2HLxy+35UUcvHzyCnQsCv37/zWiaxabkgK0ZoFrMIMA3OOH/t9j+w6j3HzmbW9wE9CeaBwJdv30PyGuDqgQiqWdDU9/TlG99//IQqBHt1wbodjZMX/PnzByr0///rdx+sI3JQNAMT4ML1O6HySOD3nz+FbVOBUsAUAhUCx5aqawxCc2HbFKA9UEmwHqATgOjdx092UXmCJr57j5+DyoHBqUs3RC0CoJqRXfv795/sxol+GVVA5JJQzK3vCVQgZx92+eY9qApI5O07BtUMFQODGcs3RRY1v3zzHug9IJq4cA3QU0A1+r7JT168hir6/x/IZtVyQdF85spNYGYAOunh0xcQEWAM5TRNBKoBIo/ksi9fv0PEgdEJFAFpvnbnARBduH4Hnm+BKQkiCETAMGfTBkWviJn/3mNnIYKp1d1QzWQiTWcA1wsS5+E9q+MAAAAASUVORK5CYII=)](link-to-docs)

See [Issue #908](https://github.com/Kong/docs.konghq.com/issues/908) for more information. Note that we're not currently hosting assets for badges.


## Testing

We use `fetch`, `cheerio`, and `jest` for testing. To run tests, first build the site, then run: 
`make build` followed by  `make smoke`.

For more information, review the [Testing documentation](docs/testing.md).


## Continuous integration

We run various checks at build time. Some checks can be manually approved using labels like: 

> `ci:manual-approve:link-validation`


For more information, review the [continuous integration documentation](docs/ci-cd.md).

## Platform documentation

The following links contain information about the docs publishing platform: 

* [How to publish OAS pages](docs/oas-pages.md)
* [Running docs.konghq.com locally](docs/platform-install.md)
* [Product releases](docs/product-releases.md)
* [Search](docs/search.md)
* [SEO](docs/seo.md)
* [vale](docs/vale.md)
