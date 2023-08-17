# How OpenAPI pages work

All the OAS definition pages are generated with Jekyll and use Vue.js, the [sdk-portal-js](https://github.com/Kong/sdk-portal-js) to make requests to Konnect and  [@kong/public-ui-components](https://github.com/Kong/public-ui-components/tree/main/packages/portal/spec-renderer#kong-ui-publicspec-renderer) to render the corresponding content.

## Pages Generation

The pages are generated based on the markdown files under `app/_api/` (one for each OpenAPI Spec) and a configuration file `app/_data/konnect_oas_data.json` containing information about the available APIs in Konnect and their versions.

### OAS configuration file

This file is generated using `tools/konnect-oas-data-generator` which makes a few API requests to Konnect to fetch the [published API products](/konnect/api/portal/v2/#/products/list-products) and [their corresponding versions](/konnect/api/portal/v2/#/versions/list-product-versions). It can be synced by manually triggering the `sync-konnect-oas-data` Github Action.


### Folder structure

The OAS pages are generated ala single-source by the `OasDefinitionPages::Generator`. Each markdown file under `app/_api/` is treated as the source and **must** have the key `konnect_product_id` in its frontmatter which should match the corresponding `Product Id` in Konnect.

For each file, we fetch its `konnect_product_id`, and based on the information present in `app/_data/konnect_oas_data.json` we generate one page for every version listed there plus an extra `latest` version based on the `latest_version` section present in the [API response](/konnect/api/portal/v2/#/products/list-products).

These pages use the `oas/spec.html` layout that sets the `product` and `version` to the `window` object, which are required for the Vue.js app to make the necessary requests to Konnect to render the OpenAPI Specification.

An index page containing links to all the latest versions of every product is generated (in a similar way to how we build the Plugin Hub index page) by iterating over the previously generated OAS pages.

#### URLs

The URL of each page follows the scheme:

```
/<namespace>/api/<product-segment>/<release>/
```
The namespace corresponds to the name of the folder at the root of `app/_api/`, the `product-segment` corresponds to the name of the folder containing the markdown file, and the `release` corresponds to the version name (as defined in Konnect), and in case it follows semver, it is converted to a release, e.g. `3.4.0` becomes `3.4.x`.

For example, for the following files:
```
app/_api/
    konnect/api-products/_index.md
    gateway/admin-oss/_index.md
    dev-portal/_index.md
```
the corresponding URLs will be:
```
/konnect/api/api-products/v2/
/gateway/api/admin-oss/3.4.x/
/dev-portal/api/v1/
```

#### Metadata

The `title` and `description` of each page match the ones defined in Konnect (defined in `app/_data/konnect_oas_data.json`) but can be overridden by adding different values on each page frontmatter. For the Index page, these can be added to the layout file (`app/_layouts/oas/index.html`).

## Syncing with Konnect

We built a tool `tools/konnect-oas-data-generator` to keep the API information (`app/_data/konnect_oas_data.json`) from Konnect synced. It can be run manually or via the `sync-konnect-oas-data` Github Action.

## How to add a new page

Once the new API product is available in Konnect, its information needs to be synced using the `tools/konnect-oas-data-generator`. To generate the new page, a new markdown file needs to be added under `app/_api/` in the corresponding folder, and the `konnect_product_id` needs to be set in its frontmatter.

For example, if the `New Product` is added in Konnect with id `0c18d126-3b63-11ee-be56-0242ac120002` and it's a gateway API, the file `app/_api/gateway/new-product/_index.md` needs to be created and in its frontmatter `konnect_product_id` is set to `0c18d126-3b63-11ee-be56-0242ac120002`. For this page, the URL will be `/gateway/api/new-product/<version>/`.
