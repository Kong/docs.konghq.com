# Search

The Search is powered by [DocSearch](https://docsearch.algolia.com/docs/what-is-docsearch/) v3 which is a a free and automated solution provided by Algolia.

## What gets indexed

* Non-product pages, e.g. `/contributing/`
* Plugin Hub, except for basic-example pages, i.e. `/**/how-to/basic-example/**/`
* Every product page in every available version, including `latest` and non-released versions, e.g. `dev`.
* OAS reference pages

## Implementation Details

DocSearch is split into two components:
* [Algolia Crawler](https://www.algolia.com/doc/tools/crawler/getting-started/overview/): automated web scraping program that extracts content from the site and updates the index. It runs once a week, but it can also be manually triggered from the [Dashboard](https://crawler.algolia.com/admin/crawlers).
* [Algolia Autocomplete](https://www.algolia.com/doc/ui-libraries/autocomplete/introduction/what-is-autocomplete/): frontend library that provides an immersive search experience through a modal.

The Crawler's configuration, including which URLs to crawl, how to extract data from the pages, and its schedule now live in the Crawler's Dashboard.

### Crawler

From Algolia's docs:

*The Crawler is an automated web scraping program. When given a set of start URLs, it visits and extracts content from those pages. It then visits URLs these pages link to, and the process repeats itself for all linked pages. With little configuration the Crawler can populate and maintain Algolia indices for you by periodically extracting content from your web pages.*

The Crawler comes with a [Dashboard](https://crawler.algolia.com/admin/crawlers) (credentials in 1Password - search for `Algolia - Team Docs`) in which we can edit the [Crawler's configuration](https://crawler.algolia.com/admin/crawlers/8defdcbe-b44c-4228-9af8-b276b00db5f0/configuration/edit), trigger new Crawls, test URLs and analyze results.


#### Configuration

The Crawler has a configuration file that defines a [Crawler object](https://www.algolia.com/doc/tools/crawler/apis/configuration/) which is made of top-level parameters, actions, and index settings.

Some noteworthy params:
* [startUrls](https://www.algolia.com/doc/tools/crawler/apis/configuration/start-urls/): the URLs that your Crawler starts on. Set to `https://docs.konghq.com/`.
* [schedule](https://www.algolia.com/doc/tools/crawler/apis/configuration/schedule/): How often a complete crawl should be performed, currently once a week, but it can be triggered manually when needed.
* [ignoreNoIndex](https://www.algolia.com/doc/tools/crawler/apis/configuration/ignore-no-index/) and [ignoreCanonicalTo](https://www.algolia.com/doc/tools/crawler/apis/configuration/ignore-canonical-to/): both set to `true` so we can index older version of product pages.
* [renderJavaScript](https://www.algolia.com/doc/tools/crawler/apis/configuration/render-java-script/): List of URLs that require Javascript to render. It contains the list of OAS Reference pages.
* [actions](https://www.algolia.com/doc/tools/crawler/apis/configuration/actions/): An action indicates a subset of your targeted URLs that you want to extract records from in a specific way.


#### How it works

When a crawl starts, the Crawler adds `startURLs` to its URL database, fetches all the linked pages,
and extracts their content. Pages can also be [ignored/skipped](https://www.algolia.com/doc/tools/crawler/troubleshooting/faq/#when-are-pages-skipped-or-ignored).


Pages are processed in five main steps:

1. A page is fetched.
2. Links and records are extracted from the page.
3. The extracted records are indexed to Algolia.
4. The extracted links are added to the Crawler’s URL database.
5. For each new, non-excluded page added to the database, the process is repeated.

We use different `actions` for processing pages in different ways,
based on the `pathsToMatch` attribute. It uses [micromatch](https://github.com/micromatch/micromatch) for pattern matching and supports negation, wildcards, etc. 
**Note:** URLs should match only one action, otherwise the Crawler returns an error when it attempts to parse it. We define one action for each product, one for OAS pages, and a few others for specific pages. 

Once the Crawler finds the matching `action` for a page based on its URL, it extracts records from the page using the [recordExtractor](https://www.algolia.com/doc/tools/crawler/apis/configuration/actions/#parameter-param-recordextractor). It provides a [docsearch helper](https://www.algolia.com/doc/tools/crawler/apis/configuration/actions/#parameter-param-docsearch) which automatically extracts content and formats it to be compatible with `DocSearch`. See [DocSearch docs](https://docsearch.algolia.com/docs/record-extractor/) for a detailed explanation of how to configure this parameter. 

We also set [custom variables](https://docsearch.algolia.com/docs/record-extractor/#custom-variables) to each record, so that we can use them to [filter](https://docsearch.algolia.com/docs/docsearch-v3/#filtering-your-search) the search results. For each page, we extract/set its `product` and `version`.

For example, Gateway OAS pages match the following action:
```json
    {
      indexName: "konghq",
      pathsToMatch: [
        "https://docs.konghq.com/gateway/api/admin-ee/**/",
        "https://docs.konghq.com/gateway/api/admin-oss/**/",
        "https://docs.konghq.com/gateway/api/status/**/",
      ],
      recordExtractor: ({ url, $, contentLength, fileType, helpers }) => {
        let segments = url.pathname.split("/");

        // extract the version from the URL
        let versionId = segments[segments.length - 2] || "latest";

        return helpers.docsearch({
          recordProps: {
            content: [".app-container p"],
            lvl0: {
              selectors: "header h2",
              defaultValue: "Kong",
            },
            lvl1: [".app-container h1"],
            lvl2: [".app-container h2"],
            lvl3: [".app-container h3"],
            lvl4: [".app-container h4"],
            product: {
              defaultValue: "Kong Gateway", // Manually set the product
            },
            version: {
              defaultValue: versionId,
            },
          },
          aggregateContent: true,
          recordVersion: "v3",
          indexHeadings: true,
        });
      },
    },
```

The `docsearch` helper creates a [hierarchical structure](https://docsearch.algolia.com/docs/record-extractor#usage) for every record it extracts. We use headings for levels `lvl1` to `lvl4` and multiple CSS selectors for the `content`. These CSS selectors may vary from action to action given that some pages use a different layout.

The `recordExtractor` uses a [Cheerio](https://docsearch.algolia.com/docs/record-extractor#manipulate-the-dom-with-cheerio) instance under the hood to manipulate the DOM, and custom Javascript code can be executed in the body of the `recordExtractor` function, which can be used to debug CSS selectors by using `console.log()`.


We set both [aggregateContent](https://www.algolia.com/doc/tools/crawler/apis/configuration/actions/#parameter-param-aggregatecontent) and [indexHeadings](https://www.algolia.com/doc/tools/crawler/apis/configuration/actions/#parameter-param-indexheadings) to `true`. 
This setup creates records for headings, and all the nested elements under a heading are also indexed and associated with it hierarchically.

The action for Gateway pages looks like this, note how the CSS selectors are different from the previous one (product pages share the same layout though). 

```json
{
      indexName: "konghq",
      pathsToMatch: [
        "https://docs.konghq.com/gateway/**/**/",
        // We exclude the API pages, they are handled in a different action
        "!https://docs.konghq.com/gateway/api/**/**/",
        // Exclude the changelog, handled in a different action
        "!https://docs.konghq.com/gateway/changelog/",
      ],
      recordExtractor: ({ url, $, contentLength, fileType, helpers }) => {
        // Extract the version from the dropdown
        let versionId = $("#version-list .active a").data("versionId") || "";

        // Special case for `latest` version
        if (
          url.toString().startsWith("https://docs.konghq.com/gateway/latest/")
        ) {
          versionId = "latest";
        }

        return helpers.docsearch({
          recordProps: {
            content: [".content p, .content li"],
            lvl0: {
              selectors: ".docsets-dropdown > .dropdown-button > span",
              defaultValue: "Kong",
            },
            lvl1: [".content h1"],
            lvl2: [".content h2"],
            lvl3: [".content h3"],
            lvl4: [".content h4"],
            product: {
              // Extract the product from the dropdown
              selectors: ".docsets-dropdown > .dropdown-button > span",
            },
            version: {
              defaultValue: versionId.toString(),
            },
          },
          aggregateContent: true,
          recordVersion: "v3",
          indexHeadings: true,
        });
      },
    },
```


For more information check out Algolia's [Extracting Data](https://www.algolia.com/doc/tools/crawler/guides/extracting-data/) How-To Guide.

#### Limitations

Our plan has a limit of `1_000_000` records.

## Refining results

We take the user's context into account, i.e. the product and version that the page in which the search was initiated has to provide better results.

We [refine](https://www.algolia.com/doc/guides/managing-results/refine-results/sorting/) the search results by using a combination of [facets](https://www.algolia.com/doc/guides/managing-results/refine-results/faceting/) 
and [optional filters](https://www.algolia.com/doc/api-reference/api-parameters/optionalFilters/).


The `optionalFilters` give a higher score to records belonging to specific products. The main advantage of this type of filter is that they can promote/demote certain records without filtering out records from the result set.

[Here's a map](https://github.com/Kong/docs.konghq.com/blob/87c48b4ba9486adf850ada229812bb20c1f5fd71/app/_plugins/generators/algolia/base.rb#L10-L21) indicating which products will have a higher score based on the page the search initiated.
For example, if the search initiates from any `gateway` doc, we give a higher score to records belonging to: `Kong Gateway`, `Plugin Hub`, and `deck` in that order.

A `facetFilter` filters the search results so they have the same `version` as the page from which the search initiated.

## How-tos

### Manually trigger a crawl

A new crawl can be [manually triggered](https://www.algolia.com/doc/tools/crawler/getting-started/quick-start/#start-crawling), e.g., whenever there's a new release, by clicking the `Restart crawling` button in the Crawler's Dashboard.

### Testing a URL

The Crawler's editor provides a [URL tester](https://docsearch.algolia.com/docs/manage-your-crawls#url-tester), which can be used to debug which action handles a specific URL, CSS selectors used by the extractor, custom variables and which links and records are extracted from the page.

### Releasing a new version of a product

Whenever a new version of a product is released, we need to trigger a crawl manually.

### Adding a new product

Adding a new product requires updating the Crawler's configuration file using the Editor and adding a new entry to our custom ranking (if needed).

A new action needs to be created for the product. Copying another product's action would be the best place to start, given that they share most of the logic. Make sure that the `pathsToMatch` matches the new product pages and that the `product` and `version` custom variables are setted.

### Adding a new OAS page

Adding a new OAS page requires updating the Crawler's configuration file using the Editor.
The new URL needs to be added to the `renderJavaScript` list and if an action already exists for the corresponding product, it needs to be added to the action's `pathsToMatch`. If an action doesn't exist, a new one needs to be created.

For example, if `https://docs.konghq.com/gateway/api/new-api-spec/latest/` were to be added, we add it to the end of the `renderJavaScript` list,

```json
renderJavaScript: [
    ..., 
    "https://docs.konghq.com/gateway/api/new-api-spec/**/"
]
```

and we look for an action that handles all the OAS pages for gateway, if there is one, we add the URL to the corresponding `pathsToMatch`

```json
   {
      pathsToMatch: [
        // Existing list..
        "https://docs.konghq.com/gateway/api/admin-ee/**/",
        "https://docs.konghq.com/gateway/api/admin-oss/**/",
        "https://docs.konghq.com/gateway/api/status/**/",
        "https://docs.konghq.com/gateway/api/new-api-spec/**/", // <- New URL
      ],
      ...
   }
```


### Indexing code snippets

By default, Algolia doesn't index code snippets. However, there are a few cases in which we would like to index them.
For example, code snippets in Troubleshooting sections or used to highlight error messages/codes, etc. Users should be able to copy and paste errors in the search bar and find meaningful results.

To achieve this, we need to add a specific CSS class to the code snippets we want to index (`.algolia-index-code-snippet`) so we can tell the Crawler to extract them.

