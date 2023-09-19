# admonition-summary

This tool extracts all admonitions from the Kong documentation and allows you to view them by product or by type.

This can be useful to see at a glance what the most used admonitions are, or to find all `warning` blocks for a given product

## Usage

```bash
# Make sure you've run `make build` for the docs site first
npm ci
node run.js
```

If you're developing the tool, you can run any of the following independently:

```bash
node scrape.js
node build-site.js
node serve.js
```
