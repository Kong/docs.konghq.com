[![Netlify Status](https://api.netlify.com/api/v1/badges/ae60f2a4-488e-4771-b24a-c26badc5f45d/deploy-status)](https://app.netlify.com/sites/kongdocs/deploys)

# KONG's Documentation Website

This repository provides the source code and content for [Kong](https://github.com/Kong/kong)'s documentation website. It is a [Jekyll](https://jekyllrb.com/) website deployed with Netlify.

Not sure where to start? Head on over to the `issues` tab to and look for the `good first issue` label. These are issues Kong has identified as beginner friendly. Many of these can be addressed with the GitHub UI and do not require pulling the repository and building locally.

First-time contributors, check out our [contributing guide on the website](docs.konghq.com/contributing), and the linked resources there.

## Building locally

If you're making more than a small typo or grammar change, we ask that you pull down the repository and build locally.

### Develop locally with Docker

```
make install-prerequisites
```

>
```bash
make develop
```

### Running a local build with Docker

Install tools:
```
make install
```

Run the build:
```
make run
```

Check the build output at http://localhost:3000.

### Testing links with Docker

```
make check-links
```

## Develop locally without Docker

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

### Run

>
```bash
npm start
```

### Generate the PDK, Admin API, CLI, and Configuration documentation

The PDK docs, Admin API docs, `cli.md` and `configuration.md` for each release are generated from the Kong source code.

To generate them, go to the `Kong/kong` repo and run:

```
scripts/autodoc <docs-folder> <kong-version>
```

For example:

```
cd /path/to/kong
scripts/autodoc ../docs.konghq.com 2.4.x
```

This example assumes that the `Kong/docs.konghq.com` repo is cloned into the
same directory as the `Kong/kong` repo, and that you want to generate the docs
for version `2.4.x`. Adjust the paths and version as needed.

After everything is generated, review, open a branch with the changes, send a
pull request, and review the changes.

You usually want to open a PR against a `release/*` branch. For example, in the
example above the branch was `release/2.4`.

```
cd docs.konghq.com
git fetch --all
git checkout release/2.4
git checkout -b release/2.4-autodocos
git add -A .
git commit -m "docs(2.4.x) add autodocs"
git push
```

Then open a pull request against `release/2.4`.
