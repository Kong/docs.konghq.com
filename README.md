[![Netlify Status](https://api.netlify.com/api/v1/badges/ae60f2a4-488e-4771-b24a-c26badc5f45d/deploy-status)](https://app.netlify.com/sites/kongdocs/deploys)

# KONG's Documentation Website

This repository is the source code for [Kong](https://github.com/Kong/kong)'s documentation website. It is a [Jekyll](https://jekyllrb.com/) website hosted on GitHub pages.

Not sure where to start? Head on over to the `issues` tab to and look for the `good first issue` label. These are issues Kong has identified as beginner friendly. Many of these can be addressed through Github and do not require pulling the repository and building locally.


## Develop Locally with Docker

```
make install-prerequisites
```

>
```bash
make develop
```

### Running a Local Build with Docker

Install tools:
```
make install
```

Run the build:
```
make run
```

Check the build output at http://localhost:3000.

### Testing Links with Docker

```
make check-links
```

## Develop Locally without Docker

### Prerequisites

- [node and npm](https://www.npmjs.com/get-npm)
- [yarn](https://classic.yarnpkg.com)
- [gulp](https://gulpjs.com/docs/en/getting-started/quick-start/)
- [Bundler](https://bundler.io/) (< 2.0.0)
- [Ruby](https://www.ruby-lang.org) (>= 2.0, < 2.3)
- [Python](https://www.python.org) (>= 2.7.X, < 3)

### Install

>
```bash
gem install bundler
npm install
```

### Running

>
```bash
npm start
```

## Search

We are using Algolia [docsearch](https://www.algolia.com/docsearch) for our
documentation search. The algolia index for Kong is maintained by Algolia through their
docsearch service. Their [scraper](https://github.com/algolia/docsearch-scraper)
runs every 24 hours. The config used by the scraper is open source for
[docs.konghq.com](docs.konghq.com) and can be found [here](https://github.com/algolia/docsearch-configs/blob/master/configs/getkong.json).
To update the scraper config, you can submit a pull request to the config. To
test a config change locally, you will need to run their open source
[scraper](https://github.com/algolia/docsearch-scraper) against your own
scraper to test out config changes.

The Enterprise documentation uses paid algolia indices, which auto-update every
24 hours via a [github action here](/.github/workflows/algolia.yml)

## Generating the PDK, Admin API, CLI and Configuration Documentation

The PDK docs, Admin API docs, `cli.md` and `configuration.md` on each release are generated from the Kong source code.

In order to generate them, please switch into the `Kong/kong` repo and run:

```
scripts/autodoc <docs-folder> <kong-version>
```

For example:

```
cd /path/to/kong
scripts/autodoc ../docs.konghq.com 2.3.x
```

Assumes that the `Kong/docs.konghq.com` repo is cloned next to the `Kong/kong` repo, and that you want to
generate the docs for Kong version `2.3.x`.

Once everything is generated, review, open a branch with the changes, send a pull request, and review the changes.

You usually want to open a pr against a `release/*` branch. For example on the case above the branch was `release/2.3`.

```
cd docs.konghq.com
git fetch --all
git checkout release/2.3
git checkout -b release/2.3-autodocos
git add -A .
git commit -m "docs(2.3.x) add autodocs"
git push
```

Then open a pull request against `release/2.3`.

## Listing Your Extension in the Kong Hub

We encourage developers to list their Kong plugins and integrations (which
we refer to collectively as "extensions") in the
[Kong Hub](https://docs.konghq.com/hub) with documentation hosted
on the Kong website for ready access.

See [CONTRIBUTING](https://github.com/Kong/docs.konghq.com/blob/master/CONTRIBUTING.md#contributing-to-kong-documentation-and-the-kong-hub) for more information.
