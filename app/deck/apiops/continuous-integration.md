---
title: Continuous Integration
---

decK is designed to be run in your CI/CD system. Committing your configuration to a repository (either as OpenAPI specifications or as decK files) allows you to audit all changes to your configuration and roll back easily if needed.

## GitHub Actions

To install decK on GitHub Actions, you can use the [kong/setup-deck](https://github.com/Kong/setup-deck) action. This installs decK to the GitHub runner tools cache and adds decK to your path.

Once `kong/setup-deck` has run, you can run any `deck` command you need.

```yaml
on:
  push:
    branches:
      - main
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: kong/setup-deck@v1
      - run: deck version
```

`kong/setup-deck` installs the latest version of decK by default. To pin to a specific version, you can specify the `version` [input](https://github.com/Kong/setup-deck?tab=readme-ov-file#sample-workflow) in your workflow.