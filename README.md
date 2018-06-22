# KONG Website

This repository is the source code for [Kong](https://github.com/Kong/kong)'s website. It is a [Jekyll](http://jekyllrb.com/) website hosted on GitHub pages.

## Requirements

- [npm](https://www.npmjs.com/)
- [Bundler](http://bundler.io/)
- [Ruby](https://www.ruby-lang.org) (>= 2.0, < 2.3)
- [Python](https://www.python.org) (>= 2.7.X, < 3)

## Install

>
```bash
gem install bundler
npm install
```

## Running locally

>
```bash
npm start
```

## Generating Public Lua API from Kong

- Have a local clone of Kong.
- Checkout the desired branch/tag/release.
- Set an env variable `KONG_PATH` to point to your local clone.
- Run: `gulp docs`
- Module docs are generated into `./lua-reference`.
- Manually move to the desired location (appropriate version folder).

## Deploying

This will deploy to GitHub pages:

>
```bash
npm run deploy
```

## Search

We are using Algolia [docsearch](https://www.algolia.com/docsearch) for our CE
documentation search. The algolia index is maintained by Algolia through their
docsearch service. Their [scraper](https://github.com/algolia/docsearch-scraper)
runs every 24 hours. The config used by the scraper is open source for
docs.konghq.com and can be found [here](https://github.com/algolia/docsearch-configs/blob/master/configs/getkong.json).
To update the scraper config, you can submit a pull request to the config. To
test a config change locally, you will need to run their open source
[scraper](https://github.com/algolia/docsearch-scraper) against your own
scraper to test out config changes.


## Writing plugin documentation

Plugins are documented under `app/plugins`. They use a YAML-based system to
generate many of the sections on each plugin page. Please look at the existing
plugins for examples. Fields are:

* `description` - text to be added in the Description section. Use YAML's
  [pipe notation](https://stackoverflow.com/questions/15540635/what-is-the-use-of-pipe-symbol-in-yaml)
  to write multi-paragraph text. Note that due to the order that data
  is generated, you may not use forward-references in links (e.g. use
  `[example](http://example.com)` and not `[example][example]` pointing to
  an index at the end).
* `params`
  * `name` - name of the plugin in Kong (not always the same spelling as the page name)
  * `api_id` - boolean - whether this plugin can be applied to an API. Affects generation of examples and config table.
  * `route_id` - boolean - whether this plugin can be applied to a Route. Affects generation of examples and config table.
  * `service_id` - boolean - whether this plugin can be applied to a Service. Affects generation of examples and config table.
  * `consumer_id` - boolean - whether this plugin can be applied to a Consumer. Affects generation of examples and config table.
  * `config` - the configuration table. Each entry is a configuration item with the following fields:
    * `name` - the field name as read by Kong
    * `required` - `true` if required, `false` if optional, `semi` if semi-required (required depending on other fields)
    * `default` - the default value. If using Markdown (e.g. to make values appear type-written), wrap it in double-quotes
    * `value_in_examples` - if the field is to appear in examples, this is the value to use. A required field with no `value_in_examples` entry will resort to the one in `default`.
    * `description` - description of the field. Use YAML's pipe notation if writing longer Markdown text.
