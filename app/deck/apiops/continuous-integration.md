---
title: Continuous Integraion
---

decK is designed to be run in your CI/CD system. Committing your configuration to a repository (either as OpenAPI specifications or as decK files) allows you to audit all changes to your configuration and rollback easily if needed.

## GitHub Actions

To install decK on GitHub Actions, you can use the [kong/setup-deck](#) action. This installs decK to the GitHub runner tools cache and adds decK to your path.

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

`kong/setup-deck` installs the latest version of decK by default. To pin to a specific version, you can specify the `version` [input](#) in your workflow.

## Jenkins

Jenkins is a popular choice for internal CI/CD systems. To install decK in a Jenkins pipeline, use the following script:

TODO: Document Jack's script. Test it too.