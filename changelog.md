# Changelog

## Week 36

### [chore: Split the gateway changelogs to archive changelogs for sunset versions](https://github.com/Kong/docs.konghq.com/pull/6073) (2023-09-08)

Our Gateway changelog page is massive. This is a problem for everyone involved:
* Bad page load times/performance
* Difficult to edit
* Lots of unnecessary info
* Documenting versions that we don't support
* And the most recent discovery, a not-insignificant chunk of our Algolia records

This is yet another attempt to split some of the changelog content out. 
From now on, we will be archiving old changelogs at the same time we archive old versions of our docs. You can find the changelogs at https://legacy-gateway--kongdocs.netlify.app/enterprise/changelog/.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Post-launch tidy of Konnect API overview page + nav](https://github.com/Kong/docs.konghq.com/pull/6067) (2023-09-07)

What did you change and why?
 
update links to api specs in overview page to reference evergreen links, repeat spec description from devportal description field, update nav links to consistently refer to API spec and use evergreen links.

#### Modified

- https://docs.konghq.com/konnect/api/


### [update urls to latest and remove mention of dev portal](https://github.com/Kong/docs.konghq.com/pull/6066) (2023-09-06)

Update urls to latest for gateway apis

Remove mention of dev portal from API announcement banner.

#### Modified

- https://docs.konghq.com/konnect/api/


### [Fix(plugin scopes): Consumer groups scope and application registration plugin](https://github.com/Kong/docs.konghq.com/pull/6059) (2023-09-05)

The [scopes compatibility table](https://docs.konghq.com/hub/plugins/compatibility/#scopes) was missing a column for consumer groups. This PR enables generating the column and all entries from the plugins' schemas.

Additionally, the Application Registration plugin was listed as incompatible with all scopes, which is wrong - it's compatible with services only. Turns out we were selecting for the wrong key. Fixing this also fixes the display of the plugin's [config](https://docs.konghq.com/hub/kong-inc/application-registration/configuration/) and [basic examples](https://docs.konghq.com/hub/kong-inc/application-registration/how-to/basic-example/), which were both missing services.

#### Modified

- https://docs.konghq.com/hub/plugins/compatibility/


### [(fix) remove note about cloud launcher support ](https://github.com/Kong/docs.konghq.com/pull/6057) (2023-09-06)

What did you change and why?
 Existing note was incorrect and causing confusion. https://kongstrong.slack.com/archives/CQK8J4VN3/p1693903551408579

#### Modified

- https://docs.konghq.com/konnect/runtime-manager/runtime-instances/upgrade


### [Fix "supported-router-flavors" typos.](https://github.com/Kong/docs.konghq.com/pull/6056) (2023-09-05)

This change fixes small typos in the documentation.

#### Modified

- https://docs.konghq.com/deck/1.24.x/reference/deck_file_remove-tags/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_remove-tags/


### [Salt plugin: add konnect and update version compatibility](https://github.com/Kong/docs.konghq.com/pull/6050) (2023-09-05)

What did you change and why?
 
Updating for Konnect compatibility & Kong version support
taking colleagues work and putting into PR on main for Kong's docs repo

#### Modified

- https://docs.konghq.com/hub/salt/salt/_metadata.yml


### [feat: Split serverless plugins into their own pages](https://github.com/Kong/docs.konghq.com/pull/6047) (2023-09-08)

We currently document one entry for [Serverless Functions](https://docs.konghq.com/hub/kong-inc/serverless-functions/), but it’s actually two plugins: `pre-function` and `post-function`. When searching for docs, users look for one of those names, not for Serverless Function. The UI also has them as two separate plugins, so one docs entry doesn't make sense.

This PR aims to solve that by splitting Serverless Functions into Post-function and Pre-function plugins. 
* For the titles of the plugins, I used the names from the Konnect and Kong Manager UIs: Kong Functions (Pre-Plugins) and Kong Functions (Post-Plugins).
* You can still search for these plugins by the term "serverless" and by their real names (post- and pre-function)
* I split out the how-to guide for the pre-function plugin into its own topic
* For the post-function plugin, I wrote a how-to guide based on a KB: https://support.konghq.com/support/s/article/How-can-the-latency-and-rate-limit-plugin-header-names-be-changed
* For both plugins, I also added short guide on running the plugins in multiple phases based on yet another KB: https://support.konghq.com/support/s/article/Is-it-possible-to-run-serverless-plugins-in-phases-other-than-the-access-phase

https://konghq.atlassian.net/browse/DOCU-3434

#### Added

- https://docs.konghq.com/hub/kong-inc/post-function/
- https://docs.konghq.com/hub/kong-inc/post-function/how-to/
- https://docs.konghq.com/hub/kong-inc/post-function/how-to/
- https://docs.konghq.com/hub/kong-inc/post-function/overview/
- https://docs.konghq.com/hub/kong-inc/pre-function/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/pre-function/how-to/
- https://docs.konghq.com/hub/kong-inc/pre-function/how-to/
- https://docs.konghq.com/hub/kong-inc/pre-function/overview/
- https://docs.konghq.com/hub/kong-inc/pre-function/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_pre-function.png

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/request-transformer/overview/
- https://docs.konghq.com/gateway/3.3.x/breaking-changes/30x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/30x/
- https://docs.konghq.com/gateway/3.0.x/upgrade/
- https://docs.konghq.com/gateway/changelog
- https://docs.konghq.com/konnect/updates


### [[Fix] KIC guides](https://github.com/Kong/docs.konghq.com/pull/6043) (2023-09-06)

Update existing Kong Ingress Controller guides for consistency and readability. Audit that all guides work as intended by copy/pasting the instructions.

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/support-policy


### [fix: change go-apiops to deck file in deck_file_remove-tags.md](https://github.com/Kong/docs.konghq.com/pull/6037) (2023-09-06)

go-apiops cli is built for testing purposes. End users are encumbered to use this utility through deck file command.




What did you change and why?

I changed `go-apiops` cli example to `deck file`. As mentioned in [go-apiops repository](https://github.com/Kong/go-apiops)
> Currently, the functionality is released as a library and as part of the [decK](https://github.com/Kong/deck) CLI tool. The 
> repository also contains a CLI named go-apiops **for local testing**. For general CLI usage, prefer the decK tool [docs](https://docs.konghq.com/deck/latest/) tool.

 `go-apiops` is used for testing and deck is encouraged for general usage.

### Checklist 

- [ ] Review label added <!-- (see below) -->
- [ ] PR pointed to correct branch (`main` for immediate publishing, or a release branch: e.g. `release/gateway-3.2`, `release/deck-1.17`)

#### Modified

- https://docs.konghq.com/deck/1.24.x/reference/deck_file_remove-tags/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_remove-tags/


### [Feat: Plugin hub nested overviews](https://github.com/Kong/docs.konghq.com/pull/6027) (2023-09-05)

What did you change and why?
 
Add the ability to nest overview pages to plugins, they work in the same way as the `how-tos`.
Add redirects, so that existing URLs redirect to `/overview/`.
Add `nav_title: Introduction` to existing pages.

#### Modified

- https://docs.konghq.com/hub/kong-inc/acl/how-to/
- https://docs.konghq.com/hub/kong-inc/acme/how-to/
- https://docs.konghq.com/hub/kong-inc/acme/how-to/
- https://docs.konghq.com/hub/kong-inc/acme/how-to/
- https://docs.konghq.com/hub/kong-inc/application-registration/how-to/
- https://docs.konghq.com/hub/kong-inc/graphql-proxy-cache-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/grpc-gateway/how-to/
- https://docs.konghq.com/hub/kong-inc/grpc-web/how-to/
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer/how-to/


### [Adds documentation for the Filter Chain entity available in Kong Gateway 3.4 ](https://github.com/Kong/docs.konghq.com/pull/6011) (2023-09-05)

Adds documentation for the Filter Chain entity available in Kong Gateway 3.4 when WebAssembly support is enabled.

### Checklist 

- [ ] Review label added <!-- (see below) -->
- [x] PR pointed to correct branch (`main` for immediate publishing, or a release branch: e.g. `release/gateway-3.2`, `release/deck-1.17`)


<!-- !!! Only Kong employees can add labels due to a GitHub limitation. If you're an OSS contributor, thank you! The maintainers will label this PR for you !!! -->

<!-- When raising a pull request, indicate what type of review you need with one of the following labels:

    review:copyedit: Request for writer review.
    review:general: Review for general accuracy and presentation. Does the doc work? Does it output correctly?
    review:tech: Request for technical review for a docs platform change.
    review:sme: Request for review from an SME (engineer, PM, etc).

At least one of these labels must be applied to a PR or the build will fail.
-->

#### Modified

- https://docs.konghq.com/gateway/3.4.x/reference/wasm

