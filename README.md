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

The automated docs generators have now been moved to the kong/kong repo.

The Core team regenerates those docs automatically from Kong's source code.

## Listing Your Extension in the Kong Hub

We encourage developers to list their Kong plugins and integrations (which
we refer to collectively as "extensions") in the
[Kong Hub](https://docs.konghq.com/hub) with documentation hosted
on the Kong website for ready access.

See [CONTRIBUTING](https://github.com/Kong/docs.konghq.com/blob/master/CONTRIBUTING.md#contributing-to-kong-documentation-and-the-kong-hub) for more information.
