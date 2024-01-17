# Product Releases

## Latest Releases and Labels

In the file `app/_data/kong_versions.yml`, every product release and its corresponding versions are listed. Ensure that the `latest` release for each product is marked with `latest: true`. This informs the platform about the release to use for generating evergreen URLs.

Labels provide flexibility in handling releases. Specifying `label: dev` on a release, alters the URL structure from `/<product>/<release number>/**/` to `/<product>/<label>/**/`, such as `/<product>/dev/**/`. Labels are particularly useful for working on unreleased versions of products. Once a label is added to a release, the content can be edited using [conditional rendering](https://docs.konghq.com/contributing/single-sourced-versions/) and merged it into the `main` branch without the need for long-standing release branches. The content will be rendered only in `/<product>/<label>/`.


## Adding a new unreleased version

Adding a new unreleased version involves two steps:
* Add a new `release` to `app/_data/_kong_versions.yml` with a `label`, e.g. `label: dev`.
* Add the correspoding nav file, `app/_data/docs_nav_<product>_<release number>.yml`.
* `Gateway` only: ensure plugin schemas for the new release are available.

For example, if `3.0.x` is the `latest` KIC release, the `app/_data/kong_versions.yml` should look like this:

```yaml
...
- release: "3.0.x"
  version: "3.0.0"
  edition: "kubernetes-ingress-controller"
  latest: true
...
```

Adding a new unreleased version (e.g., `3.1.x`) labeled `dev` requires adding a new labeled release to `app/_data/kong_versions.yml`:

```yaml
...
- release: "3.0.x"
  version: "3.0.0"
  edition: "kubernetes-ingress-controller"
  latest: true
- release: "3.1.x"
  version: "3.1.0"
  edition: "kubernetes-ingress-controller"
  label: "dev"
...
```

and the corresponding nav file `app/_data/docs_nav_kic_3.1.x`.
The changes for 3.1.x will be rendered in `/kubernetes-ingress-controller/dev/**/`.

## Releasing a version

When a new version is ready for release:
* Remove the label from the release in `app/_data/_kong_versions.yml`
* Add `latest: true` to the release and remove it from the previous one.

## page.release

Every versioned product page has a `release` attribute available.
`page.release` is a [Liquid Drop](https://github.com/Shopify/liquid/wiki/Introduction-to-Drops) that can be used in the templates (code [here](https://github.com/Kong/jekyll-generator-single-source/blob/82966bb101a62400839d35c06c0d406d5a1439d5/lib/jekyll/generator-single-source/liquid/drops/release.rb)).


It has several methods available for use in the templates:
* `value`: the actual release, e.g. `3.4.x`.
* `label`: the name of the label.
* `latest?`: returns true if the release is marked as `latest`.
* `versions`:  returns a hash with the corresponding versions. For `gateway`, it returns the versions without the suffix, i.e.  `{ 'ee' => '3.0.0.0', 'ce' => '3.0.0'  }`, for products that only have one version it returns a has with `default` as key, e.g. `{ 'default' => '2.6.x' }`.
* `to_s`: when `page.release` is interpolated, `to_s` gets called under the hood. It returns the release's label if it has one or the actual release value.

The only time when we can't rely on the `to_s` method and need to use `page.release.value` is when it is used as key when accessing hashes, like in the [compatibility table](https://github.com/Kong/docs.konghq.com/blob/8508a4d9479b73a40390af8eeae0ba65598f73c8/app/gateway/2.6.x/compatibility.md#L12).