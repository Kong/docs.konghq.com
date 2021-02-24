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

We use Algolia [docsearch](https://www.algolia.com/docsearch) for our
documentation search. The Algolia index for Kong is maintained by Algolia through their
docsearch service. Their [scraper](https://github.com/algolia/docsearch-scraper)
runs every 24 hours. The config used by the scraper is open source for
[docs.konghq.com](docs.konghq.com) and can be found [here](https://github.com/algolia/docsearch-configs/blob/master/configs/getkong.json).
To update the scraper config, you can submit a pull request to the config. To
test a config change locally, you will need to run their open source
[scraper](https://github.com/algolia/docsearch-scraper) against your own
scraper to test out config changes.

The rest of the documentation uses paid Algolia indices, which auto-update every
24 hours via a [github action here](/.github/workflows/algolia.yml).

## Versioning the docs

The following instructions apply to the Kong Gateway OSS docs. For enterprise
docs, see the instructions on the [docs wiki](https://konghq.atlassian.net/wiki/spaces/KD/pages/1053196506/Prepping+the+Private+Repo+for+a+Release).

### Creating a new community doc release version

1. Create release branch: `release/<version>`

2. Copy the following doc folders for Kong Gateway (OSS):

    1. Copy the latest `app/gateway-oss/` version folder and all of its contents.
    Rename the folder to the new major or minor version, with `x` for the patch level.

        For example, copy `app/gateway-oss/2.3.x` and rename to
        `app/gateway-oss/2.4.x`.

    2. Copy the latest `app/getting-started-guide/` version folder and rename it
     to the new version.

    3. Copy the latest `app/_includes/md/` version folder and rename it
     to the new version.

3. Add the newest CE version to `app/_data/kong_versions.yml`:

    1. Copy the previous version section, which looks like the following:

        ```yaml
          release: "2.3.x"
          version: "2.3.2"
          edition: "gateway-oss"
          luarocks_version: "2.3.2-0"
          dependencies:
            luajit: "2.1.0-beta3"
            luarocks: "3.4.0"
            cassandra: "3.x.x"
            postgres: "9.5+"
            openresty: "1.17.8.2"
            openssl: "1.1.1i"
            libyaml: "0.2.5"
            pcre: "8.44"
        ```

    Update `release`, `version`, and any `dependencies`, if applicable.

    2. Do the same for `getting-started-guide`, copying the latest version,
    which looks like the following:

        ```yaml
          release: "2.3.x"
          version: "2.3"
          edition: "getting-started-guide"
        ```

3. Update the latest version in the full site Algolia configuration file:

    1. Open  `/algolia/config-full-docs.json`
    2. In the `start_urls`, update the `gateway-oss` URL to the latest `x`
    version:

        ```json
        "url": "https://docs.konghq.com/gateway-oss/2.3.x/"
        ```

4. Commit and push release branch to GitHub.

### Generating the PDK, Admin API, CLI and Configuration Documentation

The PDK docs, Admin API docs, `cli.md` and `configuration.md` for each release are generated from the Kong source code.

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

## Listing Your Extension in the Plugin Hub

We encourage developers to list their Kong Gateway plugins in the
[Plugin Hub](https://docs.konghq.com/hub) with documentation hosted
on the Kong docs website for ready access.

See [CONTRIBUTING](https://github.com/Kong/docs.konghq.com/blob/master/CONTRIBUTING.md#contributing-to-kong-documentation-and-the-kong-hub) for more information.
