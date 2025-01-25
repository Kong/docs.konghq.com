---
title: decK in GitHub Actions
---

If you use GitHub Actions to apply your declarative configuration to a running Gateway, you should use [Kong/setup-deck](https://github.com/kong/setup-deck).

This GitHub Action installs decK on to the GitHub Actions runner using the GitHub tools cache. 

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

`Kong/setup-deck` installs the latest decK version by default. To install a specific version, set `with.deck-version` in your workflow file.





