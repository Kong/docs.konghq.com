[![Netlify Status](https://api.netlify.com/api/v1/badges/ae60f2a4-488e-4771-b24a-c26badc5f45d/deploy-status)](https://app.netlify.com/sites/kongdocs/deploys)

# KONG's Documentation Website

This repository is the source code for [Kong](https://github.com/Kong/kong)'s documentation website. It is a [Jekyll](https://jekyllrb.com/) website hosted on GitHub pages.

Not sure where to start? Head on over to the `issues` tab to and look for the `good first issue` label. These are issues Kong has identified as beginner friendly. Many of these can be addressed through Github and do not require pulling the repository and building locally.


## Develop Locally With Docker

>
```bash
make develop
```

### Testing Links With Docker

>
```
make check-links
```

## Develop Locally Without Docker

### Prerequisites

- [npm](https://www.npmjs.com/)
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
docs.konghq.com and can be found [here](https://github.com/algolia/docsearch-configs/blob/master/configs/getkong.json).
To update the scraper config, you can submit a pull request to the config. To
test a config change locally, you will need to run their open source
[scraper](https://github.com/algolia/docsearch-scraper) against your own
scraper to test out config changes.

The Enterprise documentation uses paid algolia indices, which auto-update every
24 hours via a [github action here](/.github/workflows/algolia.yml)

## Generating the PDK, Admin API, CLI and Configuration Documentation

The automated docs currently require using both the kong/kong repo and this repo (kong/docs.konghq.com, kong/docs for short) in combination.

The usual release process is taken care of by the Kong Gateway team. They have a set of scripts ([example](https://github.com/Kong/kong/blob/more-scripts/scripts/make-rc1-release#L471-L589))
which run the following steps as part of the release process.

The following instructions replicate what that script does, in a more manual way.

You will need to know the **release** you are trying to generate docs for. The release looks
like `0.14.x` in kong/docs, and like `0.14.1` or `0.14.2` in kong/kong.

Prerequisites:
- Make sure that the `resty` and `luajit` executables are in your `$PATH` (installing kong should install them).
- Install Luarocks (comes with Kong).
- Several Lua rocks are needed. The easiest way to get them all is to execute `make dev` in the Kong folder
- Install `ldoc` using Luarocks: `luarocks install ldoc 1.4.6`
- Have a local clone of Kong.
- In the kong/kong repository, check out the desired branch/tag/release.

To generate the PDK docs:
- On the kong/doc repo, `KONG_PATH=path/to/your/kong/folder KONG_VERSION=0.14.x gulp pdk-docs`
- This command will attempt to:
  * Obtain an updated list of modules from your local PDK and put it inside
    your nav file.
  * Generate documentation for all the modules in your PDK (where possible) and
    put in a folder inside your version docs.
  * Note: the command used by the Kong Gateway team is different than this one (it does not use the `gulp` abstraction). But they are functionally equivalent.

To generate the Admin API docs:
- On the kong/kong repo, run `./scripts/autodoc-admin-api`
- Copy `kong/kong/autodoc/output/admin-api/admin-api.md` into `kong/docs/app/0.14.x/admin-api.md` (replace `0.14.x` with current release)
- Copy `kong/kong/autodoc/output/admin-api/db-less-admin-api.md` into `kong/docs/app/0.14.x/db-less-admin-api.md` (replace `0.14.x` with current release)
- Copy `kong/kong/autodoc/output/nav/docs_nav.yml.admin-api.in` into `kong/docs/autodoc-nav/docs_nav_0.14.x.yml.head.in`. Replace `0.14.x` with release.
- On the kong/docs repo, run `KONG_VERSION=0.14.x luajit ./autodoc-nav/run.lua` (replace `0.14.x` with current release). This will merge the navigation
  info in the right place.
- These commands generate a two big files for the admin API and a smaller file for the navigation, which needs to be inserted in a
  specific place in the navigation yaml file.

To generate the CLI docs:
- In kong/docs `KONG_PATH=path/to/your/kong/repo KONG_VERSION=0.14.x luajit autodoc-cli/run.lua` (replace `0.14.x` with current release)
- This command will:
  * Extract the output of the `--help` for every `kong` CLI subcommand
  * Generate a new `cli.md` in the path corresponding to the provided KONG_VERSION.

To generate the Configuration docs:
- In kong/docs: `KONG_PATH=path/to/your/kong/folder KONG_VERSION=0.14.x luajit autodoc-conf/run.lua` (replace `0.14.x` with current release)
- This command will:
  * Parse Kong's `kong.conf.default` file and extract sections, variable names, descriptions, and default values
  * Write those down inside a `configuration.md` file in the path matching KONG_VERSION.
  * The command will completely overwrite the file, including text before and after the list of vars.
  * The data used for the before/after parts can be found in `autodoc-conf/data.lua`

Once everything is generated, open a branch with the changes, send a pull request, and review the changes.

## Listing Your Extension in the Kong Hub

We encourage developers to list their Kong plugins and integrations (which
we refer to collectively as "extensions") in the
[Kong Hub](https://docs.konghq.com/hub) with documentation hosted
on the Kong website for ready access.

See [CONTRIBUTING](https://github.com/Kong/docs.konghq.com/blob/master/CONTRIBUTING.md#contributing-to-kong-documentation-and-the-kong-hub) for more information.
