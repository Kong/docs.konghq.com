# Changelog

<!--vale off-->

## Week 15

### [Release: Gateway 3.8.1.1](https://github.com/Kong/docs.konghq.com/pull/8698) (2025-04-11)

Changelog and version bump for 3.8.1.1.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.7.1.5](https://github.com/Kong/docs.konghq.com/pull/8697) (2025-04-11)

Changelog and version bump for 3.7.1.5.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Update geo.md](https://github.com/Kong/docs.konghq.com/pull/8692) (2025-04-09)

Updated regions for Azure, added Google tab

#### Modified

- https://docs.konghq.com/konnect/geo


### [Added a note in changelog for ai-rate-limiting-advanced plugin](https://github.com/Kong/docs.konghq.com/pull/8689) (2025-04-09)

A note is added to describe how to transform a deck yaml config that is exported from a previous version to the latest version where huggingface is supported as the llm_providers in ai-rate-limiting-advanced plugin

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-rate-limiting-advanced/


### [Update cluster_type](https://github.com/Kong/docs.konghq.com/pull/8688) (2025-04-09)

In the Konnect API `CLUSTER_TYPE_HYBRID` was deprecated some time ago and no longer exists (see [Control Plane schema](https://docs.konghq.com/konnect/api/control-planes/latest/#/schemas/ControlPlane)). The Terraform provider only still supports `CLUSTER_TYPE_HYBRID` to prevent state recreation. Moving forward `CLUSTER_TYPE_CONTROL_PLANE` should be used.

See also: https://kongstrong.slack.com/archives/C04RXLGNB6K/p1727707794692459

#### Modified

- https://docs.konghq.com/konnect/reference/terraform


### [fix: fix ai-proxy-advanced balancer doc link typo](https://github.com/Kong/docs.konghq.com/pull/8686) (2025-04-09)

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/overview/


### [Fix: Consume plugins tiers](https://github.com/Kong/docs.konghq.com/pull/8680) (2025-04-08)

This is an enterprise plugin.

#### Modified

- https://docs.konghq.com/hub/kong-inc/confluent-consume/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/kafka-consume/_metadata/_index.yml


### [Fix: Update geos list for DCGWs](https://github.com/Kong/docs.konghq.com/pull/8675) (2025-04-08)

Updating the geos list to accurately reflect what's currently available.

#### Modified

- https://docs.konghq.com/konnect/geo


### [Fix: Remove `labels` from konnect search query for teams](https://github.com/Kong/docs.konghq.com/pull/8673) (2025-04-07)

Teams don't support labels, so this sample query is invalid. Removing the `labels` portion leaves the example as a valid logical AND example.

Issue reported on slack.

#### Modified

- https://docs.konghq.com/konnect/reference/search


### [Fix: Missing Auth Headers & Request Body in Token Creation API Call](https://github.com/Kong/docs.konghq.com/pull/8671) (2025-04-07)

Fix system account token creation process

- Add required authentication header with bearer token
- Include proper request body in the API call
- Set correct content-type header

ref: https://docs.konghq.com/konnect/api/identity-management/latest/#/operations/post-system-accounts-id-access-tokens

#### Modified

- https://docs.konghq.com/konnect/org-management/system-accounts


### [Remove outdated Runtime groups parameter ](https://github.com/Kong/docs.konghq.com/pull/8669) (2025-04-07)

CLUSTER_TYPE_COMPOSITE  -> CLUSTER_TYPE_CONTROL_PLANE_GROUP

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/migrate


### [[AI RAG Injector] How to - Update title of step 2](https://github.com/Kong/docs.konghq.com/pull/8668) (2025-04-07)

Fix misleading title for step 2

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-rag-injector/how-to/

## Week 14

### [Added the memory requirement for the PII service docker image](https://github.com/Kong/docs.konghq.com/pull/8660) (2025-04-03)

The memory requirement is added to the ai-sanitizer plugin's document page as a note, so users can successfully run the image

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-sanitizer/overview/


### [fix(docs): Add missing bracket in URL link](https://github.com/Kong/docs.konghq.com/pull/8659) (2025-04-03)

- Fixed broken markdown link from `templates](/hub/...)` to `[templates](/hub/...)`

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-callout/overview/


### [Service Catalog feedback](https://github.com/Kong/docs.konghq.com/pull/8657) (2025-04-02)



#### Modified

- https://docs.konghq.com/konnect/service-catalog/
- https://docs.konghq.com/konnect/service-catalog/integrations/datadog
- https://docs.konghq.com/konnect/service-catalog/integrations/
- https://docs.konghq.com/konnect/service-catalog/integrations/pagerduty
- https://docs.konghq.com/konnect/service-catalog/integrations/swaggerhub
- https://docs.konghq.com/konnect/service-catalog/integrations/traceable
- https://docs.konghq.com/konnect/service-catalog/scorecards/


### [Fix: Priority load balancing example](https://github.com/Kong/docs.konghq.com/pull/8656) (2025-04-02)

Fix algorithm field in priority load balancing example for AI Proxy Advanced

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/


### [Fix: spelling](https://github.com/Kong/docs.konghq.com/pull/8654) (2025-04-02)



#### Modified

- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/upgrade


### [Fix: Update config-store.md for decK tab steps](https://github.com/Kong/docs.konghq.com/pull/8648) (2025-04-02)

Added missing steps from the decK tab for creating and linking the config store to the vault before referencing it in the decK YAML config file.

This was creating confusion for customers wanting to use decK with the Konnect Config Store.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/configuration/config-store


### [fix: Centralized consumers parameter descriptions](https://github.com/Kong/docs.konghq.com/pull/8647) (2025-04-04)

Improved consumer group (and eventually allowed control plane) descriptions and added links to API endpoints.

https://kongstrong.slack.com/archives/C074KG8NX1B/p1743518122340309

#### Modified

- https://docs.konghq.com/hub/kong-inc/key-auth/how-to/
- https://docs.konghq.com/konnect/centralized-consumer-management


### [chore(custom-pages): add notice about the 1000000 char limit](https://github.com/Kong/docs.konghq.com/pull/8646) (2025-04-01)

I added a notice about the limitations of custom pages. [Slack thread](https://kongstrong.slack.com/archives/C02D0BPQC85/p1743516809805849?thread_ts=1743446463.368109&cid=C02D0BPQC85)

#### Modified

- https://docs.konghq.com/dev-portal/portals/customization/custom-pages


### [Fix: Add note about private Docker image](https://github.com/Kong/docs.konghq.com/pull/8639) (2025-03-31)

Added note to tell users to reach out to support to get access to the private AI PII Service Docker image

https://kongstrong.slack.com/archives/C06GB3KM155/p1743148798458789

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-sanitizer/how-to/
- https://docs.konghq.com/hub/kong-inc/ai-sanitizer/overview/


### [Add AI RAG Injector Admin api usage](https://github.com/Kong/docs.konghq.com/pull/8636) (2025-04-02)

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-rag-injector/how-to/


### [kgo: add KGO 1.5 docs](https://github.com/Kong/docs.konghq.com/pull/8588) (2025-04-02)

Add [KGO 1.5](https://github.com/Kong/gateway-operator/releases/tag/v1.5.0) docs

Depends on 
- https://github.com/Kong/gateway-operator/issues/1231

Related:
- #8560
- #8576

Closes https://github.com/Kong/gateway-operator/issues/1202

#### Modified

- https://docs.konghq.com/gateway-operator/changelog

## Week 13

### [Fix: title AI RAG INJECTOR](https://github.com/Kong/docs.konghq.com/pull/8629) (2025-03-28)

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-rag-injector/how-to/


### [docs(plugins/request-callout): warn about `forward` behavior](https://github.com/Kong/docs.konghq.com/pull/8625) (2025-03-27)

Warn about request-callout `forward` behavior.

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-callout/overview/


### [docs(portal): additional idp configuration](https://github.com/Kong/docs.konghq.com/pull/8624) (2025-03-27)

Provide additional IdP configuration information specifically related to the new Dev Portal and Konnect Portal Editor experience.

Based on this internal doc: https://docs.google.com/document/d/1_h2rsg4x77EnedPaILYKV1ce93IHHTPcqIVALCFw9lU/edit?tab=t.0

#### Modified

- https://docs.konghq.com/dev-portal/access-and-approvals/sso


### [Chore: Move Gateway 2.8 into sunset support](https://github.com/Kong/docs.konghq.com/pull/8616) (2025-03-26)

Gateway 2.8 moves into sunset support tomorrow (march 26).

We hadn't updated the 2.8 non-single-sourced support policy for a while (oversight), so making the tables match the latest version.

#### Modified

- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.8.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/
- https://docs.konghq.com/gateway/2.8.x/support-policy


### [Fix: Expressions route limitation on mTLS and TLS Handshake Modifier](https://github.com/Kong/docs.konghq.com/pull/8611) (2025-03-27)

Add note about limitation on expressions routes to the mTLS and TLS handshake modifier plugins.

https://konghq.atlassian.net/browse/FTI-6227

#### Modified

- https://docs.konghq.com/hub/kong-inc/mtls-auth/overview/
- https://docs.konghq.com/hub/kong-inc/tls-handshake-modifier/overview/


### [feat: add ai-rag-injector plugin](https://github.com/Kong/docs.konghq.com/pull/8607) (2025-03-27)

Fixes https://konghq.atlassian.net/browse/DOCU-4196

#### Added

- https://docs.konghq.com/hub/kong-inc/ai-rag-injector/
- https://docs.konghq.com/hub/kong-inc/ai-rag-injector/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-rag-injector/how-to/
- https://docs.konghq.com/hub/kong-inc/ai-rag-injector/overview/
- https://docs.konghq.com/hub/kong-inc/ai-rag-injector/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_ai-rag-injector.png


### [Chore: remove tiers](https://github.com/Kong/docs.konghq.com/pull/8542) (2025-03-27)

https://konghq.atlassian.net/browse/DOCU-4189

#### Modified

- https://docs.konghq.com/gateway/3.10.x/get-started/
- https://docs.konghq.com/gateway/3.3.x/get-started/
- https://docs.konghq.com/gateway/3.4.x/get-started/
- https://docs.konghq.com/gateway/3.5.x/get-started/
- https://docs.konghq.com/gateway/3.6.x/get-started/
- https://docs.konghq.com/gateway/3.7.x/get-started/
- https://docs.konghq.com/gateway/3.8.x/get-started/
- https://docs.konghq.com/gateway/3.9.x/get-started/
- https://docs.konghq.com/gateway/3.10.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/gateway/3.5.x/
- https://docs.konghq.com/gateway/3.6.x/
- https://docs.konghq.com/gateway/3.7.x/
- https://docs.konghq.com/gateway/3.8.x/
- https://docs.konghq.com/gateway/3.9.x/
- https://docs.konghq.com/gateway/3.10.x/install/
- https://docs.konghq.com/gateway/3.3.x/install/
- https://docs.konghq.com/gateway/3.4.x/install/
- https://docs.konghq.com/gateway/3.5.x/install/
- https://docs.konghq.com/gateway/3.6.x/install/
- https://docs.konghq.com/gateway/3.7.x/install/
- https://docs.konghq.com/gateway/3.8.x/install/
- https://docs.konghq.com/gateway/3.9.x/install/
- https://docs.konghq.com/gateway/3.10.x/kong-manager/
- https://docs.konghq.com/gateway/3.3.x/kong-manager/
- https://docs.konghq.com/gateway/3.4.x/kong-manager/
- https://docs.konghq.com/gateway/3.5.x/kong-manager/
- https://docs.konghq.com/gateway/3.6.x/kong-manager/
- https://docs.konghq.com/gateway/3.7.x/kong-manager/
- https://docs.konghq.com/gateway/3.8.x/kong-manager/
- https://docs.konghq.com/gateway/3.9.x/kong-manager/
- https://docs.konghq.com/gateway/3.10.x/licenses/
- https://docs.konghq.com/gateway/3.3.x/licenses/
- https://docs.konghq.com/gateway/3.4.x/licenses/
- https://docs.konghq.com/gateway/3.5.x/licenses/
- https://docs.konghq.com/gateway/3.6.x/licenses/
- https://docs.konghq.com/gateway/3.7.x/licenses/
- https://docs.konghq.com/gateway/3.8.x/licenses/
- https://docs.konghq.com/gateway/3.9.x/licenses/
- https://docs.konghq.com/gateway/changelog
- https://docs.konghq.com/hub/index.html
- https://docs.konghq.com/hub/plugins/compatibility/
- https://docs.konghq.com/konnect/gateway-manager/plugins/


### [Release: Gateway 3.4.3.17](https://github.com/Kong/docs.konghq.com/pull/8541) (2025-03-26)

Changelog and version bump for 3.4.3.17

#### Modified

- https://docs.konghq.com/gateway/changelog

## Week 12

### [Add AI pricing disclaimer](https://github.com/Kong/docs.konghq.com/pull/8597) (2025-03-20)

Add a note that AI plugins require additional licensing

#### Modified

- https://docs.konghq.com/hub/plugins/license-tiers


### [CSRE-3763 Added documentation for 2 new edge gateway regions](https://github.com/Kong/docs.konghq.com/pull/8595) (2025-03-20)

Added new AWS Private Link regions
 
https://konghq.atlassian.net/browse/CSRE-3763

#### Modified

- https://docs.konghq.com/konnect/private-connections/aws-privatelink


### [Fix links to api reference operations](https://github.com/Kong/docs.konghq.com/pull/8594) (2025-03-20)

Regexp used: \/gateway\/api\/admin-ee\/latest\/#(\/(?!operations)([^\/]+)\/)(.*)/?
Replaced with: /gateway/api/admin-ee/latest/#/operations/$3

#### Modified

- https://docs.konghq.com/hub/kong-inc/acl/how-to/
- https://docs.konghq.com/hub/kong-inc/basic-auth/overview/
- https://docs.konghq.com/hub/kong-inc/bot-detection/overview/
- https://docs.konghq.com/hub/kong-inc/canary/overview/
- https://docs.konghq.com/hub/kong-inc/hmac-auth/overview/
- https://docs.konghq.com/hub/kong-inc/jwt/overview/
- https://docs.konghq.com/hub/kong-inc/kafka-log/overview/
- https://docs.konghq.com/hub/kong-inc/kafka-upstream/overview/
- https://docs.konghq.com/hub/kong-inc/key-auth-enc/overview/
- https://docs.konghq.com/hub/kong-inc/key-auth/overview/
- https://docs.konghq.com/hub/kong-inc/ldap-auth-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/ldap-auth/overview/
- https://docs.konghq.com/hub/kong-inc/oauth2/overview/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/
- https://docs.konghq.com/hub/kong-inc/prometheus/overview/
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/rate-limiting/
- https://docs.konghq.com/hub/kong-inc/response-ratelimiting/overview/
- https://docs.konghq.com/hub/kong-inc/response-transformer-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/response-transformer/overview/
- https://docs.konghq.com/hub/kong-inc/statsd/overview/
- https://docs.konghq.com/hub/kong-inc/vault-auth/
- https://docs.konghq.com/gateway/3.10.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/gateway/3.5.x/
- https://docs.konghq.com/gateway/3.6.x/
- https://docs.konghq.com/gateway/3.7.x/
- https://docs.konghq.com/gateway/3.8.x/
- https://docs.konghq.com/gateway/3.9.x/
- https://docs.konghq.com/gateway/unreleased/kong-enterprise/consumer-groups
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/consumer-groups
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/consumer-groups
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/consumer-groups
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/consumer-groups
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/consumer-groups
- https://docs.konghq.com/gateway/3.8.x/kong-enterprise/consumer-groups
- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/consumer-groups
- https://docs.konghq.com/gateway/unreleased/kong-enterprise/event-hooks
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/event-hooks
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/event-hooks
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/event-hooks
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/event-hooks
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/event-hooks
- https://docs.konghq.com/gateway/3.8.x/kong-enterprise/event-hooks
- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/event-hooks
- https://docs.konghq.com/gateway/unreleased/kong-enterprise/
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.8.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/
- https://docs.konghq.com/deck/gateway/defaults
- https://docs.konghq.com/gateway/changelog


### [fix: s/consumer/consume/g](https://github.com/Kong/docs.konghq.com/pull/8593) (2025-03-19)

Followup of https://github.com/Kong/docs.konghq.com/pull/8506

Mainly fixes to plugin naming and some enumeration corrections

#### Modified

- https://docs.konghq.com/hub/kong-inc/confluent-consume/overview/
- https://docs.konghq.com/hub/kong-inc/kafka-consume/overview/


### [Release: Gateway 3.9.1.1](https://github.com/Kong/docs.konghq.com/pull/8591) (2025-03-21)

Changelog and version bump for 3.9.1.1

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Fix APIOps introduction](https://github.com/Kong/docs.konghq.com/pull/8590) (2025-03-19)

"X, Y and Z" was a placeholder that snuck through

#### Modified

- https://docs.konghq.com/deck/apiops/


### [docs(ai-semantic-cache): add note on cache control behaviour](https://github.com/Kong/docs.konghq.com/pull/8584) (2025-03-18)

Add clarification of the cache_control config and explain the behaviour if being set with common AI services.
 
#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-semantic-cache/overview/


### [docs(ai-proxy-advanced): add new feature description for ai-proxy-advanced in 3.10](https://github.com/Kong/docs.konghq.com/pull/8583) (2025-03-20)

Add following features:

- ai-proxy-advanced: new priority algorithm
- ai-proxy-advanced: failover creteria
- ai-proxy-advanced: cost as tokens_count_strategy (mention log_statistics must be on)

Fixes:
https://konghq.atlassian.net/browse/DOCU-4194
https://konghq.atlassian.net/browse/DOCU-4193

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/overview/


### [JWE: Update supported algorithms](https://github.com/Kong/docs.konghq.com/pull/8581) (2025-03-18)

The JWE plugin now supports more algorithms: https://github.com/Kong/kong-ee/pull/11074

Found in changelog.

#### Modified

- https://docs.konghq.com/hub/kong-inc/jwe-decrypt/overview/


### [fix(konnect): update Azure SAML claim attributes](https://github.com/Kong/docs.konghq.com/pull/8580) (2025-03-17)

I'm modifying the referenced email claim for Azure SAML applications, updating from `user.email` to. `user.mail`.

I'm also including a note in the Azure navtab that states "ensure the `Namespace` value is empty".

Screenshots are attached for additional Azure/SAML context and verification.


* Default claims: ![Screenshot 2025-03-17 at 15 14 31](https://github.com/user-attachments/assets/e9025332-70c9-4f58-b27d-b2d0a279e3da)
* Claim edit window (showing `Namespace`): 
![Screenshot 2025-03-17 at 15 15 29](https://github.com/user-attachments/assets/a134fca7-e787-4df0-86f5-34cb8783d47a)


#### Modified

- https://docs.konghq.com/konnect/reference/saml-idp-mappings


### [fix: Dynatrace deployment options](https://github.com/Kong/docs.konghq.com/pull/8579) (2025-03-20)

Setting `network_config_opts: All` as a temp solution to avoid the incorrect entries in this table: https://docs.konghq.com/hub/plugins/compatibility/#analytics-monitoring

Issue came up on Slack.

#### Modified

- https://docs.konghq.com/hub/kong-inc/dynatrace/_metadata/_index.yml


### [feat: AppDynamics agent ARM support](https://github.com/Kong/docs.konghq.com/pull/8555) (2025-03-18)
 
KAG-4034

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/overview/


### [AI RLA: Support for multiple limits and window sizes](https://github.com/Kong/docs.konghq.com/pull/8530) (2025-03-18)



#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-rate-limiting-advanced/how-to/

## Week 10

### [docs(portal): reserved paths](https://github.com/Kong/docs.konghq.com/pull/8527) (2025-03-07)

Document the new Dev Portal reserved paths.
 
#### Modified

- https://docs.konghq.com/dev-portal/portals/customization/custom-pages


### [Rename title in transit-gateways.md](https://github.com/Kong/docs.konghq.com/pull/8524) (2025-03-07)

Issue reported at [https://github.com/Kong/docs.konghq.com/issues/8296](https://github.com/Kong/docs.konghq.com/issues/8296)

Change title from "How to configure Transit Gateway" to "How to configure AWS Transit Gateway", so it clearly states this is an AWS product.

In the "Configure AWS Transit Gateway" section, replace "Create Transit Gateway" with "Create transit gateway", in lowercase, as this is the term appearing in AWS.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/dedicated-cloud-gateways/transit-gateways


### [Update index.md](https://github.com/Kong/docs.konghq.com/pull/8522) (2025-03-07)

Added Other limits for Serverless


#### Modified

- https://docs.konghq.com/konnect/gateway-manager/serverless-gateways/


### [fix(deck): docker on Windows](https://github.com/Kong/docs.konghq.com/pull/8500) (2025-03-05)


#### Modified

- https://docs.konghq.com/deck/install/docker


### [Add link to Vacuum to deck file lint](https://github.com/Kong/docs.konghq.com/pull/8499) (2025-03-04)

Link to all available `deck file lint` rules

#### Modified

- https://docs.konghq.com/deck/file/lint


### [Add v3 API Builder API, insomnia fixes for other portal v3 APIs](https://github.com/Kong/docs.konghq.com/pull/8497) (2025-03-04)

Added required files for docs portal to list new API Builder v3, and added YAML versions of specs to potentially fix Insomnia links.

#### Modified

- https://docs.konghq.com/dev-portal/portals/


### [Dev Portal v3 docs](https://github.com/Kong/docs.konghq.com/pull/8401) (2025-03-03)

Preview app for the internal teams. Do not merge.

#### Added

- https://docs.konghq.com/assets/images/products/konnect/dev-portal-v3/azure-group-claim.png
- https://docs.konghq.com/assets/images/products/konnect/dev-portal-v3/create-portal.png
- https://docs.konghq.com/assets/images/products/konnect/dev-portal-v3/dcr-bearer-tokens.png
- https://docs.konghq.com/assets/images/products/konnect/dev-portal-v3/kongair-example.png
- https://docs.konghq.com/assets/images/products/konnect/dev-portal-v3/visibility-access-combinations.png
- https://docs.konghq.com/dev-portal/access-and-approvals/developers
- https://docs.konghq.com/dev-portal/access-and-approvals/
- https://docs.konghq.com/dev-portal/access-and-approvals/sso
- https://docs.konghq.com/dev-portal/access-and-approvals/teams
- https://docs.konghq.com/dev-portal/apis/docs
- https://docs.konghq.com/dev-portal/apis/gateway-service-link
- https://docs.konghq.com/dev-portal/apis/
- https://docs.konghq.com/dev-portal/apis/versioning
- https://docs.konghq.com/dev-portal/app-reg/auth-strategies/key-auth/
- https://docs.konghq.com/dev-portal/app-reg/auth-strategies/oidc/dcr/auth0
- https://docs.konghq.com/dev-portal/app-reg/auth-strategies/oidc/dcr/azure
- https://docs.konghq.com/dev-portal/app-reg/auth-strategies/oidc/dcr/curity
- https://docs.konghq.com/dev-portal/app-reg/auth-strategies/oidc/dcr/custom
- https://docs.konghq.com/dev-portal/app-reg/auth-strategies/oidc/dcr/
- https://docs.konghq.com/dev-portal/app-reg/auth-strategies/oidc/dcr/okta
- https://docs.konghq.com/dev-portal/app-reg/auth-strategies/oidc/
- https://docs.konghq.com/dev-portal/app-reg/
- https://docs.konghq.com/dev-portal/
- https://docs.konghq.com/dev-portal/portals/audit-logs/
- https://docs.konghq.com/dev-portal/portals/audit-logs/replay-job
- https://docs.konghq.com/dev-portal/portals/audit-logs/webhook
- https://docs.konghq.com/dev-portal/portals/customization/appearance
- https://docs.konghq.com/dev-portal/portals/customization/custom-pages
- https://docs.konghq.com/dev-portal/portals/customization/customization
- https://docs.konghq.com/dev-portal/portals/customization/portal-editor
- https://docs.konghq.com/dev-portal/portals/
- https://docs.konghq.com/dev-portal/portals/publishing
- https://docs.konghq.com/dev-portal/portals/settings/custom-domains
- https://docs.konghq.com/dev-portal/portals/settings/general
- https://docs.konghq.com/dev-portal/portals/settings/security
- https://docs.konghq.com/dev-portal/portals/settings/team-mapping

## Week 9

### [Fix Konnect cluster and telemetry hostnames](https://github.com/Kong/docs.konghq.com/pull/8478) (2025-02-27)

Changed the existing cluster and telemetry hostnames to `CONTROL_PLANE_DNS_PREFIX` to match feedback I got here: https://kongstrong.slack.com/archives/C04RXLGNB6K/p1740607033227059

#### Modified

- https://docs.konghq.com/konnect/network


### [Fix: Loggly plugin description update](https://github.com/Kong/docs.konghq.com/pull/8462) (2025-02-26)

Remove unrelated description of Syslog in Loggly page.

#### Modified

- https://docs.konghq.com/hub/kong-inc/loggly/overview/


### [docs(json-threat-protection): add a description for the supported HTTP methods](https://github.com/Kong/docs.konghq.com/pull/8459) (2025-02-28)

Please merge this PR after the PR https://github.com/Kong/kong-ee/pull/11437 is merged.

#### Modified

- https://docs.konghq.com/hub/kong-inc/json-threat-protection/overview/


### [Fix: transit gateways](https://github.com/Kong/docs.konghq.com/pull/8456) (2025-02-24)

Updated steps to ensure a customer has Tgw attachment for their own VPCs also.


#### Modified

- https://docs.konghq.com/konnect/gateway-manager/dedicated-cloud-gateways/transit-gateways


### [Release: Gateway 3.7.1.4 ](https://github.com/Kong/docs.konghq.com/pull/8454) (2025-02-27)

Changelog and version bump for 3.7.1.4

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Update request-transformer-advanced examples to include replace.uri](https://github.com/Kong/docs.konghq.com/pull/8447) (2025-02-25)

Update request-transformer-advanced examples to include replace.uri
- Added examples for replace.uri using static values and capturing groups.
- Improved documentation to clarify usage.

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/how-to/


### [Feat: service catalog score cards](https://github.com/Kong/docs.konghq.com/pull/8410) (2025-02-28)

https://konghq.atlassian.net/browse/DOCU-4184

## Preview Links
- https://deploy-preview-8410--kongdocs.netlify.app/konnect/service-catalog/scorecards/
- https://deploy-preview-8410--kongdocs.netlify.app/konnect/service-catalog/#service-catalog-use-cases (added scorecards to table)
- https://deploy-preview-8410--kongdocs.netlify.app/konnect/service-catalog/#service-catalog-terminology (added scorecards to table)

#### Added

- https://docs.konghq.com/assets/images/products/konnect/konnect-service-catalog-scorecards.png
- https://docs.konghq.com/konnect/service-catalog/scorecards/

#### Modified

- https://docs.konghq.com/konnect/service-catalog/


### [docs(mesh): moved k8s section of kumactl configuration](https://github.com/Kong/docs.konghq.com/pull/8404) (2025-02-25)

The instruction is a bit confusing and might suggest that user can access Konnect cluster with kubectl. I tried to moved it to the tip.

#### Modified

- https://docs.konghq.com/konnect/mesh-manager/service-mesh

## Week 8

### [Fix: route priority info](https://github.com/Kong/docs.konghq.com/pull/8457) (2025-02-22)

#### Modified

- https://docs.konghq.com/gateway/3.1.x/key-concepts/routes
- https://docs.konghq.com/gateway/unreleased/key-concepts/routes
- https://docs.konghq.com/gateway/3.2.x/key-concepts/routes
- https://docs.konghq.com/gateway/3.3.x/key-concepts/routes
- https://docs.konghq.com/gateway/3.4.x/key-concepts/routes
- https://docs.konghq.com/gateway/3.5.x/key-concepts/routes
- https://docs.konghq.com/gateway/3.6.x/key-concepts/routes
- https://docs.konghq.com/gateway/3.7.x/key-concepts/routes
- https://docs.konghq.com/gateway/3.8.x/key-concepts/routes
- https://docs.konghq.com/gateway/3.9.x/key-concepts/routes


### [Update diff.md](https://github.com/Kong/docs.konghq.com/pull/8455) (2025-02-20)

Minor fix in deck gateway diff documentation

#### Modified

- https://docs.konghq.com/deck/gateway/diff

## Week 6

### [extra space between period ](https://github.com/Kong/docs.konghq.com/pull/8406) (2025-02-05)



#### Modified

- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/fips-support


### [Update the Dynatrace integration description](https://github.com/Kong/docs.konghq.com/pull/8403) (2025-02-03)

Updating the description of our Dynatrace implementation to provide more context, per request.

#### Modified

- https://docs.konghq.com/hub/kong-inc/dynatrace/overview/
- https://docs.konghq.com/hub/kong-inc/opentelemetry/how-to/

## Week 5

### [Update custom-dns.md](https://github.com/Kong/docs.konghq.com/pull/8400) (2025-01-31)

Updating Serverless for CAA instructions

Updated the Serverless custom domains doc to include instructions on adding CAA to prevent CAA errors with Serverless GWs. 

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/serverless-gateways/custom-dns


### [Update custom-dns.md](https://github.com/Kong/docs.konghq.com/pull/8399) (2025-01-31)

Updated to include instructions for CAA Records

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/dedicated-cloud-gateways/custom-dns


### [Fix: Add missing queue parameter to table](https://github.com/Kong/docs.konghq.com/pull/8397) (2025-01-31)

We missed documenting the `concurrency_limit` queue parameter in 3.8.
Removed the link to kong.conf from the changelog; these params aren't in kong.conf, they're in plugins.

Fixes https://github.com/Kong/docs.konghq.com/issues/8291.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Fix SSO Instructions](https://github.com/Kong/docs.konghq.com/pull/8383) (2025-01-29)

Improved the SSO Instructions, specifically the Okta instructions to be correct and more helpful for onboarding users.

#### Modified

- https://docs.konghq.com/konnect/dev-portal/access-and-approval/okta-idp
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/sso
- https://docs.konghq.com/konnect/org-management/auth
- https://docs.konghq.com/konnect/org-management/okta-idp
- https://docs.konghq.com/konnect/org-management/sso


### [docs(opentelemetry): better description of OTel logs](https://github.com/Kong/docs.konghq.com/pull/8381) (2025-01-29)

this commit follows up to https://github.com/Kong/kong/issues/14068 and tries to make the OTel logs description more clear / less open for interpretation.

#### Modified

- https://docs.konghq.com/hub/kong-inc/opentelemetry/overview/


### [Feat: Dedicated Cloud Gateways logs](https://github.com/Kong/docs.konghq.com/pull/8380) (2025-01-31)

https://deploy-preview-8380--kongdocs.netlify.app/konnect/gateway-manager/dedicated-cloud-gateways/data-plane-logs/

#### Added

- https://docs.konghq.com/konnect/gateway-manager/dedicated-cloud-gateways/data-plane-logs

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/dedicated-cloud-gateways/


### [Feat: Empty states and new dimensions](https://github.com/Kong/docs.konghq.com/pull/8379) (2025-01-30)

For the release of Empty states in Explorer.

#### Modified

- https://docs.konghq.com/konnect/analytics/explorer


### [docs(kgo): update references for 1.4.x](https://github.com/Kong/docs.konghq.com/pull/8367) (2025-01-28)

Adjusts the CRD references after releasing KGO v1.4.2.

#### Modified

- https://docs.konghq.com/gateway-operator/changelog


### [chore: Adjust messaging around Vitals sustaining mode](https://github.com/Kong/docs.konghq.com/pull/8365) (2025-01-29)

Vitals is supported indefinitely for existing customer that have purchased it in the past, same as Dev Portal. Adjusting the docs to reflect this.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.9.0.1](https://github.com/Kong/docs.konghq.com/pull/8358) (2025-01-29)

Changelog and version bump for 3.9.0.1

#### Modified

- https://docs.konghq.com/gateway/changelog


### [feat(ai): Community LLM libraries documentation and demonstrations](https://github.com/Kong/docs.konghq.com/pull/8340) (2025-01-30)

First phase of adding supported "LLM Library and Framework" tutorials, for our AI community to use, to demonstrate compatibility with Kong AI Gateway.

#### Added

- https://docs.konghq.com/assets/images/guides/llm-libraries/kong-analytics.png
- https://docs.konghq.com/assets/images/guides/llm-libraries/kong-logs.png

## Week 4

### [Feat: Secure back end traffic](https://github.com/Kong/docs.konghq.com/pull/8339) (2025-01-24)



#### Added

- https://docs.konghq.com/konnect/gateway-manager/dedicated-cloud-gateways/securing-backend-traffic

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/serverless-gateways/


### [feat: Service Catalog GitLab integration ](https://github.com/Kong/docs.konghq.com/pull/8329) (2025-01-24)

<!-- What did you change and why? -->
Added GitLab as the newest Service Catalog integration.
 
<!-- Include any supporting resources, e.g. link to a Jira ticket, GH issue, FTI, Slack, Aha, etc. -->
DOCU-4140

#### Added

- https://docs.konghq.com/assets/images/icons/third-party/gitlab.svg
- https://docs.konghq.com/konnect/service-catalog/integrations/gitlab

#### Modified

- https://docs.konghq.com/konnect/service-catalog/integrations/datadog
- https://docs.konghq.com/konnect/service-catalog/integrations/github
- https://docs.konghq.com/konnect/service-catalog/integrations/pagerduty
- https://docs.konghq.com/konnect/service-catalog/integrations/swaggerhub
- https://docs.konghq.com/konnect/service-catalog/integrations/traceable

## Week 3

### [Fix: OIDC plugin params listed as strings instead of arrays](https://github.com/Kong/docs.konghq.com/pull/8347) (2025-01-17)

In the OIDC plugin, `client_id`, `client_secret`, and` client_auth` must be arrays. See the config schema to verify:  https://docs.konghq.com/hub/kong-inc/openid-connect/configuration/

Fixes #8343

#### Modified

- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authorization/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authorization/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authorization/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/client-authentication/


### [Release: Gateway 3.4.3.16](https://github.com/Kong/docs.konghq.com/pull/8346) (2025-01-17)

Version bump and changelog for 3.4.3.16

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.4.3.15](https://github.com/Kong/docs.konghq.com/pull/8334) (2025-01-13)

Changelog and version bump for Gateway 3.4.3.15.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Fix: Update decK compatible version with Konnect](https://github.com/Kong/docs.konghq.com/pull/8331) (2025-01-13)

Versions of decK before 1.4 have some inconsistency issues when used with Konnect. We need to tell our users to use 1.40 with Konnect at a minimum.

issue reported on slack: https://kongstrong.slack.com/archives/C03NRECFJPM/p1734711282132209

#### Modified

- https://docs.konghq.com/konnect/compatibility
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/migrate
- https://docs.konghq.com/konnect/gateway-manager/declarative-config

## Week 2

### [fix: workspace collision](https://github.com/Kong/docs.konghq.com/pull/8332) (2025-01-10)

#### Modified

- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/unreleased/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.8.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/workspaces


### [fix: we do not support uploading the custom schema via decK.](https://github.com/Kong/docs.konghq.com/pull/8324) (2025-01-08)

Clarify that when using decK with custom plugins, the schema must be uploaded to Konnect first. After that, custom plugins can be managed like any other entity. We do not support uploading the custom schema via decK.

(https://kongstrong.slack.com/archives/C04349E4KRC/p1736269545150239)

#### Modified

- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/unreleased/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.8.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/workspaces


### [Fix: RHEL7 deprecation version](https://github.com/Kong/docs.konghq.com/pull/8320) (2025-01-07)

The deprecation notice for rhel7 mentions the wrong kong version.
Checked all the other version entries (2.8 onward), all the rest are correct.

Issue reported on slack: https://kongstrong.slack.com/archives/CDSTDSG9J/p1736248819331859

#### Modified

- https://docs.konghq.com/gateway/changelog


### [docs: update the key calculation expression of proxy cache](https://github.com/Kong/docs.konghq.com/pull/8316) (2025-01-08)

In [the description of Proxy Cache](https://docs.konghq.com/hub/kong-inc/proxy-cache/), it is explained that the cache key is calculated using the following expression.

```
key = md5(UUID | method | request)
```

However, in the source code of Proxy Cache (3.9.0), the cache key is calculated from the following five elements.

https://github.com/Kong/kong/blob/3.9.0/kong/plugins/proxy-cache/cache_key.lua#L111-L112

Because of that, I have updated the expression in the documentation to match it with the one of source code.

#### Modified

- https://docs.konghq.com/hub/kong-inc/proxy-cache/overview/


### [Update _index.md](https://github.com/Kong/docs.konghq.com/pull/8315) (2025-01-06)

Updating some issues with the text in this plugin description

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-prompt-template/overview/


### [Fix: typos in plugin development](https://github.com/Kong/docs.konghq.com/pull/8311) (2025-01-06)

Fixed several small typos in plugin development pages.
 
#### Modified

- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/unreleased/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.8.x/kong-enterprise/workspaces
- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/workspaces

## Week 50

### [Fix: clarify license propagation in Konnect](https://github.com/Kong/docs.konghq.com/pull/8262) (2024-12-13)

We were missing info about KIC licenses in Konnect, so adding that.

https://konghq.atlassian.net/browse/DOCU-4144

#### Modified

- https://docs.konghq.com/konnect/account-management/
- https://docs.konghq.com/konnect/gateway-manager/kic


### [kic: drop 'beta' from feature gates toc heading](https://github.com/Kong/docs.konghq.com/pull/8259) (2024-12-13)

Drop 'beta' from feature gates toc heading

#### Modified

- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/datakit/


### [Fix: Consumer groups docs](https://github.com/Kong/docs.konghq.com/pull/8257) (2024-12-13)

Addressing feedback we’ve received on consumer groups docs, where some of the docs are outdated (kong manager), one is missing from the nav but findable via search (Konnect), and links for how-to guides go to the Rate Limiting plugin, which is only one of the plugins that supports consumer groups. 
* The Kong Manager topic is very short and doesn't need to exist, but doesn't hurt to leave it for now
* The Konnect topic is a condensed version of upcoming how-to guides
* As part of this, splitting out the Personal Access Token info into its own doc, as we link to it a bunch (I needed to from the consumer groups doc), but its buried in a decK page.

Fixes https://github.com/Kong/docs.konghq.com/issues/6465 and https://konghq.atlassian.net/browse/DOCU-3593

#### Modified

- https://docs.konghq.com/konnect/api/
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-teams
- https://docs.konghq.com/konnect/gateway-manager/configuration/consumer-groups
- https://docs.konghq.com/konnect/gateway-manager/declarative-config


### [Fix: Add missing vault config link](https://github.com/Kong/docs.konghq.com/pull/8245) (2024-12-10)

Add link to environment variable vault config options.

Issue reported on Slack.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/configuration/vaults/how-to


### [chore: Changelog for Gateway 3.9](https://github.com/Kong/docs.konghq.com/pull/8243) (2024-12-12)

Changelog and breaking changes page for 3.9.

https://konghq.atlassian.net/browse/DOCU-4164
https://konghq.atlassian.net/browse/DOCU-4154

#### Added

- https://docs.konghq.com/hub/kong-inc/exit-transformer/
- https://docs.konghq.com/hub/kong-inc/jwe-decrypt/

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-prompt-guard/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/
- https://docs.konghq.com/hub/kong-inc/ai-proxy/
- https://docs.konghq.com/hub/kong-inc/ai-rate-limiting-advanced/
- https://docs.konghq.com/hub/kong-inc/ai-request-transformer/
- https://docs.konghq.com/hub/kong-inc/ai-response-transformer/
- https://docs.konghq.com/hub/kong-inc/ai-semantic-cache/
- https://docs.konghq.com/hub/kong-inc/ai-semantic-prompt-guard/
- https://docs.konghq.com/hub/kong-inc/app-dynamics/changelog.md
- https://docs.konghq.com/hub/kong-inc/aws-lambda/
- https://docs.konghq.com/hub/kong-inc/correlation-id/
- https://docs.konghq.com/hub/kong-inc/degraphql/
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/
- https://docs.konghq.com/hub/kong-inc/json-threat-protection/
- https://docs.konghq.com/hub/kong-inc/jwt-signer/
- https://docs.konghq.com/hub/kong-inc/jwt/
- https://docs.konghq.com/hub/kong-inc/kafka-log/
- https://docs.konghq.com/hub/kong-inc/key-auth/
- https://docs.konghq.com/hub/kong-inc/loggly/
- https://docs.konghq.com/hub/kong-inc/oas-validation/
- https://docs.konghq.com/hub/kong-inc/openid-connect/
- https://docs.konghq.com/hub/kong-inc/prometheus/
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/
- https://docs.konghq.com/hub/kong-inc/rate-limiting/
- https://docs.konghq.com/hub/kong-inc/request-validator/
- https://docs.konghq.com/gateway/changelog


### [Automated submodule update (app/_src/.repos/kong-plugins)](https://github.com/Kong/docs.konghq.com/pull/8238) (2024-12-11)



#### Modified

- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/datakit/


### [Update performance-testing.md for 3.9 rc4](https://github.com/Kong/docs.konghq.com/pull/8237) (2024-12-09)

The raw results could be found [here](https://docs.google.com/spreadsheets/d/1knu87tczpuTQ4a5si3WSkOoFHWf0pS8vqNpC44-Oxmw/edit?gid=131097464#gid=131097464)

#### Modified

- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/datakit/


### [chore: Remove deprecated APIs](https://github.com/Kong/docs.konghq.com/pull/8229) (2024-12-09)

Clean out deprecated Konnect APIs in prep for migration.

https://konghq.atlassian.net/browse/DOCU-4176

Need to merge this before unpublishing specs in the Konnect Org + running the sync action to update the `konnect_oas_data.json` file properly.

#### Modified

- https://docs.konghq.com/konnect/dev-portal/customization/
- https://docs.konghq.com/konnect/dev-portal/customization/netlify
- https://docs.konghq.com/konnect/dev-portal/customization/self-hosted-portal
- https://docs.konghq.com/konnect/updates


### [feat: serverless custom domains docs](https://github.com/Kong/docs.konghq.com/pull/8213) (2024-12-09)

Add specific serverless docs for custom domains.

#### Added

- https://docs.konghq.com/konnect/gateway-manager/dedicated-cloud-gateways/custom-dns
- https://docs.konghq.com/konnect/gateway-manager/serverless-gateways/custom-dns

#### Modified

- https://docs.konghq.com/konnect/dev-portal/customization/
- https://docs.konghq.com/konnect/gateway-manager/dedicated-cloud-gateways/
- https://docs.konghq.com/konnect/gateway-manager/serverless-gateways/


### [feat: Datakit](https://github.com/Kong/docs.konghq.com/pull/8189) (2024-12-12)

Adds documentation about the Datakit feature for 3.9.

DOCU-4170

#### Added

- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/datakit/


### [Feat: Add Hugging Face as LLM provider](https://github.com/Kong/docs.konghq.com/pull/8182) (2024-12-09)

Add docs for AI Proxy and AI Proxy Advanced configuration with Hugging Face.

[DOCU-4166](https://konghq.atlassian.net/browse/DOCU-4166)

#### Added

- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/ai-proxy/overview/


### [Fix: Inaccurate OS support for AppD C SDK agent](https://github.com/Kong/docs.konghq.com/pull/8178) (2024-12-13)

Removed the mention of Alpine from AppD docs.

Although the AppD agent does [support Alpine as of May 2022](https://docs.appdynamics.com/appd/23.x/latest/en/product-and-release-announcements/past-releases/past-agent-releases#PastAgentReleases-Version22.3.1-March15,2022), Kong stopped supporting Alpine in 3.3.x, so the older versions get a mention of Alpine, while it's completely removed from the newest ones.

https://konghq.atlassian.net/browse/DOCU-4121

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/overview/


### [feat: Injection Protection plugin for 3.9](https://github.com/Kong/docs.konghq.com/pull/8177) (2024-12-12)

 Adding the new Injection Protection plugin docs.

DOCU-4148

#### Added

- https://docs.konghq.com/hub/kong-inc/injection-protection/
- https://docs.konghq.com/hub/kong-inc/injection-protection/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/injection-protection/overview/
- https://docs.konghq.com/hub/kong-inc/injection-protection/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_injection-protection.png


### [feat: Konnect IN geo](https://github.com/Kong/docs.konghq.com/pull/8169) (2024-12-13)

This PR splits the IN geo information into a separate PR (from the original #8126 , which will be edited to just contain ME info)

DOCU-4147

#### Modified

- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/datakit/
- https://docs.konghq.com/konnect/geo
- https://docs.konghq.com/konnect/network


### [feat: Service Protection plugin](https://github.com/Kong/docs.konghq.com/pull/8152) (2024-12-09)

DOCU-4149

#### Added

- https://docs.konghq.com/hub/kong-inc/service-protection/
- https://docs.konghq.com/hub/kong-inc/service-protection/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/service-protection/how-to/
- https://docs.konghq.com/hub/kong-inc/service-protection/overview/
- https://docs.konghq.com/hub/kong-inc/service-protection/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_service-protection.png

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-rate-limiting-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/rate-limiting/overview/


### [docs(kic): fix ingress to gateway migration plugins conversion](https://github.com/Kong/docs.konghq.com/pull/8138) (2024-12-13)

Changed the conversion from `konghq.com/plugins` in the Ingress to the Gateway API migration. The conversion should be placed under `httpRoute.spec.rules[*].filters` in the HTTPRoute resource.

Following the [ingress2gateway](https://github.com/kubernetes-sigs/ingress2gateway/blob/main/pkg/i2gw/providers/kong/plugins.go) tool and the [Gateway API](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io%2fv1.HTTPRouteFilter) documentation, the plugins annotation should be filters rather than headers.

#### Modified

- https://docs.konghq.com/gateway/3.9.x/kong-enterprise/datakit/


### [feat: Dev Portal SAML SSO](https://github.com/Kong/docs.konghq.com/pull/8118) (2024-12-12)

SAML SSO is being added to Dev Portal. This PR adds instructions for it and creates SSO includes so that org SSO and Dev Portal SSO content can be shared.

This PR also fixes some outdated Okta SSO language, see DOCU-4120 for more information.

DOCU-4135

#### Added

- https://docs.konghq.com/konnect/dev-portal/access-and-approval/okta-idp
- https://docs.konghq.com/konnect/reference/saml-idp-mappings

#### Modified

- https://docs.konghq.com/konnect/dev-portal/access-and-approval/sso
- https://docs.konghq.com/konnect/org-management/okta-idp
- https://docs.konghq.com/konnect/org-management/sso

## Week 49

### [Update opentelemetry  _changelog.md to include deprecation of config.endpoint in 3.8](https://github.com/Kong/docs.konghq.com/pull/8228) (2024-12-05)

- Update _changelog.md to include deprecation of config.endpoint
- Fix typo in config.batch_flush_delay deprecation
 
```
2024/12/05 15:16:04 [warn] 2533#0: *1692 [kong] init.lua:910 OpenTelemetry: config.endpoint is deprecated, please use config.traces_endpoint instead (deprecated after 4.0), client: 172.19.0.1, server: kong_admin, request: "PUT /plugins/924e591e-5544-4ee8-8327-32625f0034f0 HTTP/1.1", host: "localhost:8001"
```

#### Modified

- https://docs.konghq.com/hub/kong-inc/opentelemetry/


### [Feat: Redirect plugin](https://github.com/Kong/docs.konghq.com/pull/8218) (2024-12-06)

Docs for the new Redirect plugin in 3.9.

https://konghq.atlassian.net/browse/DOCU-4175

#### Added

- https://docs.konghq.com/hub/kong-inc/redirect/
- https://docs.konghq.com/hub/kong-inc/redirect/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/redirect/overview/
- https://docs.konghq.com/hub/kong-inc/redirect/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_redirect.png


### [Header Cert Auth plugin: cert format FAQ](https://github.com/Kong/docs.konghq.com/pull/8214) (2024-12-03)

Updated the FAQ to include a note about how the certificate should  be passed. The docs were not entirely clear that base64 and url encoding require different data to be passed (one including the being/end certificate delimiters). 

#### Modified

- https://docs.konghq.com/hub/kong-inc/header-cert-auth/overview/


### [chore: Update 3.9 support tables](https://github.com/Kong/docs.konghq.com/pull/8210) (2024-12-03)

Add tabs for 3.9 support tables + add ubuntu 24.04 to the data file (it's already in 39.yml, was just missing from here).

#### Modified

- https://docs.konghq.com/gateway/3.1.x/upgrade/
- https://docs.konghq.com/gateway/3.2.x/upgrade/
- https://docs.konghq.com/gateway/3.3.x/upgrade/
- https://docs.konghq.com/gateway/3.4.x/upgrade/
- https://docs.konghq.com/gateway/3.5.x/upgrade/
- https://docs.konghq.com/gateway/3.6.x/upgrade/
- https://docs.konghq.com/gateway/3.7.x/upgrade/
- https://docs.konghq.com/gateway/3.8.x/upgrade/
- https://docs.konghq.com/gateway/unreleased/upgrade/


### [Fix: missing changelog entry for dependency bump](https://github.com/Kong/docs.konghq.com/pull/8190) (2024-12-02)

Add missing dependency bump changelong entry to 3.8.1.0 ([eng PR here](https://github.com/Kong/kong-ee/pull/10599)) and add detail to capture the customer issue. Support was unable to find the fix in the changelog, since the initial issue wasn't mentioned.

Issue reported on slack: https://kongstrong.slack.com/archives/CDSTDSG9J/p1732724038244199

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Update: Guardrail for Bedrock](https://github.com/Kong/docs.konghq.com/pull/8184) (2024-12-03)

Updated the AI Proxy and AI Proxy Advanced docs to add a request example with guardrails for Bedrock.
 
[DOCU-4167](https://konghq.atlassian.net/browse/DOCU-4167)

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/ai-proxy/overview/


### [chore(gateway): add notice for unsupported AWS credential provider](https://github.com/Kong/docs.konghq.com/pull/8181) (2024-12-02)

#### Modified

- https://docs.konghq.com/hub/kong-inc/aws-lambda/overview/
- https://docs.konghq.com/gateway/3.1.x/upgrade/
- https://docs.konghq.com/gateway/3.2.x/upgrade/
- https://docs.konghq.com/gateway/3.3.x/upgrade/
- https://docs.konghq.com/gateway/3.4.x/upgrade/
- https://docs.konghq.com/gateway/3.5.x/upgrade/
- https://docs.konghq.com/gateway/3.6.x/upgrade/
- https://docs.konghq.com/gateway/3.7.x/upgrade/
- https://docs.konghq.com/gateway/3.8.x/upgrade/
- https://docs.konghq.com/gateway/unreleased/upgrade/


### [Update config-store.md for referencing the secret in Konnect](https://github.com/Kong/docs.konghq.com/pull/8128) (2024-12-05)

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/configuration/config-store


## Week 48

### [feat: Service Catalog Datadog integration ](https://github.com/Kong/docs.konghq.com/pull/8154) (2024-12-01)

Adding Datadog as a new Service Catalog integration.
 
DOCU-4109

#### Added

- https://docs.konghq.com/konnect/service-catalog/integrations/datadog

## Week 48

### [cleanup(mesh): remove old versions](https://github.com/Kong/docs.konghq.com/pull/8197) (2024-11-29)

The mesh docs experienced a lot of changes before 2.2.x
Maintaining all this is very combursome and all these versions
are now deprecated.

This simply removes old versions and makes the Mesh docs easier to
manage

We will still need to remove some of the conditional rendering but I'll
do this as a follow up PR

Part of https://github.com/kumahq/kuma-website/issues/2072
Replaces https://github.com/Kong/docs.konghq.com/pull/8195


Signed-off-by: Charly Molter [charly.molter@konghq.com](mailto:charly.molter@konghq.com)



### [chore(kgo): bump to 1.4.1](https://github.com/Kong/docs.konghq.com/pull/8193) (2024-11-28)

Bump KGO to 1.4.1

OSS release: https://github.com/Kong/gateway-operator/releases/tag/v1.4.1
EE release https://github.com/Kong/gateway-operator-enterprise/releases/tag/v1.4.1

#### Modified

- https://docs.konghq.com/gateway-operator/changelog


### [fix: step formatting in Secure Comms](https://github.com/Kong/docs.konghq.com/pull/8186) (2024-11-27)

Fixed the formatting of the certificate steps, it was messed up.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/secure-communications


### [Release: Gateway 3.7.1.3](https://github.com/Kong/docs.konghq.com/pull/8170) (2024-11-27)

Changelog and version bump for Gateway 3.7.1.3.

Also merge https://github.com/Kong/docs-plugin-toolkit/pull/74 when this goes in.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Update secure-communications.md](https://github.com/Kong/docs.konghq.com/pull/8165) (2024-11-27)

 Updated documentation to reflect current behavior. Changes explain what is happening behind the scene so users can understand the flow and what the workflows accomplish

There is no jira. However there are discussions on slack. All are linked below

https://kongstrong.slack.com/archives/C03LRB400TC/p1730253689774879
https://kongstrong.slack.com/archives/C03LRB400TC/p1731604458601139?thread_ts=1730253689.774879&cid=C03LRB400TC
https://kongstrong.slack.com/archives/C02KEASTTRC/p1731688031878609

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/secure-communications


### [feat: serverless provisioning clarification](https://github.com/Kong/docs.konghq.com/pull/8161) (2024-11-26)

Quick clarification change to ensure users know that Serverless Gateways may not be provisioned in their current Konnect region.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/serverless-gateways/
- https://docs.konghq.com/konnect/gateway-manager/serverless-gateways/provision-serverless-gateway


### [Feat: PrivateLink connection](https://github.com/Kong/docs.konghq.com/pull/8149) (2024-11-27)

Add docs page for PrivateLink.

[DOCU-3871](https://konghq.atlassian.net/browse/DOCU-3871)
[CSRE-2806](https://konghq.atlassian.net/browse/CSRE-2806)

Replaces Kong/docs.konghq.com#7771

[DOCU-3871]: https://konghq.atlassian.net/browse/DOCU-3871?atlOrigin=eyJpIjoiNWRkNTljNzYxNjVmNDY3MDlhMDU5Y2ZhYzA5YTRkZjUiLCJwIjoiZ2l0aHViLWNvbS1KU1cifQ
[CSRE-2806]: https://konghq.atlassian.net/browse/CSRE-2806?atlOrigin=eyJpIjoiNWRkNTljNzYxNjVmNDY3MDlhMDU5Y2ZhYzA5YTRkZjUiLCJwIjoiZ2l0aHViLWNvbS1KU1cifQ

#### Added

- https://docs.konghq.com/konnect/private-connections/aws-privatelink


### [feat: Konnect ME geos](https://github.com/Kong/docs.konghq.com/pull/8126) (2024-11-26)

DOCU-4147

#### Modified

- https://docs.konghq.com/konnect/geo
- https://docs.konghq.com/konnect/network


### [fix: Request Validator incorrectly refers to Kong format schema](https://github.com/Kong/docs.konghq.com/pull/8111) (2024-11-25)

The doc says the the Kong `format` schema validation is supported, which is incorrect. JSON Schema `format` validation is actually what's supported.

Fixes https://konghq.atlassian.net/browse/FTI-6196.

Note to reviewers: I fixed the title of the section referring to the "Kong format schema" and some minor cleanup to the page, including removing unnecessary output examples. 
However, I couldn't actually get these examples to work as documented in the example. The last step, validation, always fails for me- though this is probably out of scope of this PR and is a separate issue.

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-validator/overview/

## Week 47

### [Fix: extra sentence](https://github.com/Kong/docs.konghq.com/pull/8155) (2024-11-21)



#### Modified

- https://docs.konghq.com/konnect/dev-portal/


### [Fix: network requirements](https://github.com/Kong/docs.konghq.com/pull/8151) (2024-11-20)

the [CONTROL_PLANE_ID.eu.cp0.konghq.com](http://control_plane_id.eu.cp0.konghq.com/) in the documentation is wrong, since it should actually be [CONTROL_PLANE_DNS_PREFIX.eu.cp0.konghq.com](http://control_plane_dns_prefix.eu.cp0.konghq.com/)

#### Modified

- https://docs.konghq.com/konnect/network


### [fix: correct config store queries](https://github.com/Kong/docs.konghq.com/pull/8144) (2024-11-20)

Correct config store queries and references.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/configuration/config-store


### [Release: Gateway 3.8.1.0](https://github.com/Kong/docs.konghq.com/pull/8094) (2024-11-18)

Changelog and version bump for gateway 3.8.1.0.

#### Modified

- https://docs.konghq.com/gateway/changelog

## Week 45

### [Update title to Impart Security](https://github.com/Kong/docs.konghq.com/pull/8112) (2024-11-04)

Incorrectly labeled title as overview, corrected it to Impart Security.  Link to page https://docs.konghq.com/hub/impart-security/kong-plugin-impart/

<img width="346" alt="Screenshot 2024-10-31 at 1 11 52 PM" src="https://github.com/user-attachments/assets/ba9bbcdc-c49f-40ec-a305-74c8c5f8e69e">

#### Modified

- https://docs.konghq.com/hub/impart-security/kong-plugin-impart/overview/


### [Mesh CVE policy](https://github.com/Kong/docs.konghq.com/pull/8100) (2024-11-05)

fixes #6156 

Adds a CVE policy for Kong Mesh


#### Modified

- https://docs.konghq.com/mesh/2.0.x/features/
- https://docs.konghq.com/mesh/2.1.x/features/

## Week 43

### [Fix: Konnect roles reference](https://github.com/Kong/docs.konghq.com/pull/8065) (2024-10-21)

Update the Konnect roles reference to the most recent actual state of Konnect.
Includes the new serverless roles.

Entries pulled from UI text with very light editing. Eventually, I expect we'll be generating this, so we won't want to manually edit.

Issue reported on Slack.

#### Modified

- https://docs.konghq.com/konnect/org-management/teams-and-roles/roles-reference

## Week 42

### [Update request-validator content-type validation](https://github.com/Kong/docs.konghq.com/pull/8057) (2024-10-16)

crated from Jira: https://konghq.atlassian.net/browse/FTI-6269?focusedCommentId=144703

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-validator/overview/


### [Update: Rewrite AI Gateway Getting Started guide](https://github.com/Kong/docs.konghq.com/pull/8056) (2024-10-17)

We've gotten feedback that the AI getting started script is difficult to use as it obfuscates what's actually happening in the setup. 
This changes the getting started guide to set up a service, route, and plugin manually, then test that the plugin is working. 

Tested this locally, still need to test the Konnect instructions.

I left the AI quickstart script in at the bottom of the page with a bit of info on how to use it, for those people that are still interested. 
This script is very useful for demos and testing and we don't want to lose it.

#### Modified

- https://docs.konghq.com/gateway/3.6.x/ai-gateway/
- https://docs.konghq.com/gateway/3.7.x/ai-gateway/
- https://docs.konghq.com/gateway/3.8.x/ai-gateway/
- https://docs.konghq.com/gateway/unreleased/ai-gateway/


### [feat: serverless gateways](https://github.com/Kong/docs.konghq.com/pull/8054) (2024-10-17)

Relates to 
https://github.com/Kong/docs.konghq.com/pull/7947

Add initial docs for Serverless Gateways


#### Added

- https://docs.konghq.com/assets/images/products/konnect/gateway-manager/konnect-control-plane-serverless-gateway-overview.png
- https://docs.konghq.com/assets/images/products/konnect/gateway-manager/konnect-control-plane-serverless-gateway-proxy.png
- https://docs.konghq.com/konnect/gateway-manager/serverless-gateways/
- https://docs.konghq.com/konnect/gateway-manager/serverless-gateways/provision-serverless-gateway
- https://docs.konghq.com/konnect/gateway-manager/serverless-gateways/securing-backend-traffic

#### Modified

- https://docs.konghq.com/hub/kong-inc/acme/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-rate-limiting-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/app-dynamics/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/file-log/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/graphql-proxy-cache-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/mtls-auth/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/openid-connect/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/prometheus/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/proxy-cache-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/rate-limiting/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/response-ratelimiting/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/saml/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/syslog/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/tls-handshake-modifier/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/tls-metadata-headers/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/upstream-oauth/_metadata/_index.yml
- https://docs.konghq.com/hub/plugins/compatibility/


### [Release: Gateway 3.6.1.8](https://github.com/Kong/docs.konghq.com/pull/8051) (2024-10-15)

Changelog and version bump for  Gateway 3.6.1.8.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [feat: swaggerhub integration ](https://github.com/Kong/docs.konghq.com/pull/8038) (2024-10-18)

Service Catalog SwaggerHub integration doc.

I added a section on how to add/find the API specs tab to link specs to services, because it took me some poking around to find it. It's not standard for these integration pages yet, but I think it makes sense to add it here.

https://konghq.atlassian.net/browse/DOCU-4092

#### Added

- https://docs.konghq.com/assets/images/icons/third-party/swaggerhub.svg
- https://docs.konghq.com/konnect/service-catalog/integrations/swaggerhub

#### Modified

- https://docs.konghq.com/konnect/service-catalog/integrations/github
- https://docs.konghq.com/konnect/service-catalog/integrations/pagerduty
- https://docs.konghq.com/konnect/service-catalog/integrations/traceable


### [chore: Archive Gateway 2.6 and 2.7](https://github.com/Kong/docs.konghq.com/pull/8036) (2024-10-14)

Gateway versions 2.6 and 2.7 have reached the end of sunset support, so we are archiving the docs as no longer maintained. 

PR for https://legacy-gateway--kongdocs.netlify.app/: https://github.com/Kong/docs.konghq.com/pull/8037

https://konghq.atlassian.net/browse/DOCU-4090

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Update: AI proxy advanced load balancing](https://github.com/Kong/docs.konghq.com/pull/7971) (2024-10-17)

- Added link to AI proxy advanced load balancing in navigation under AI Gateway
- Updated AI proxy advanced overview to add missing load balancing algorithms and a section about retry/fallback
- Removed the semantic routing section and included the info in the load balancer algorithms section
- Added config example for each load balancer type

[DOCU-4076](https://konghq.atlassian.net/browse/DOCU-4076)

#### Added

- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/overview/

## Week 41

### [Fix: broken table in AI RLA plugin](https://github.com/Kong/docs.konghq.com/pull/8045) (2024-10-11)

Issue reported on slack.

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-rate-limiting-advanced/overview/


### [fix: fix capitalization of GitHub](https://github.com/Kong/docs.konghq.com/pull/8041) (2024-10-11)

Fixes capitalization of GitHub.

#### Modified

- https://docs.konghq.com/konnect/service-catalog/
- https://docs.konghq.com/konnect/service-catalog/integrations/github


### [fix: fix the quickstart help command](https://github.com/Kong/docs.konghq.com/pull/8031) (2024-10-09)

We have to pass the `-s` command to the bash script in order to pass additional arguments to the quickstart script.

The original help command gives the following error:
```
$ curl -Ls https://get.konghq.com/quickstart | bash -- -h
bash: -h: No such file or directory
```


#### Modified

- https://docs.konghq.com/gateway/3.1.x/get-started/
- https://docs.konghq.com/gateway/3.2.x/get-started/
- https://docs.konghq.com/gateway/3.3.x/get-started/
- https://docs.konghq.com/gateway/3.4.x/get-started/
- https://docs.konghq.com/gateway/3.5.x/get-started/
- https://docs.konghq.com/gateway/3.6.x/get-started/
- https://docs.konghq.com/gateway/3.7.x/get-started/
- https://docs.konghq.com/gateway/3.8.x/get-started/
- https://docs.konghq.com/gateway/unreleased/get-started/


### [Bug bash: Logging correlation IDs doc does not specify the nginx context ](https://github.com/Kong/docs.konghq.com/pull/8006) (2024-10-07)

Fixes https://github.com/Kong/docs.konghq.com/issues/5123

Preview: https://deploy-preview-8006--kongdocs.netlify.app/hub/kong-inc/correlation-id/

#### Modified

- https://docs.konghq.com/hub/kong-inc/correlation-id/overview/

## Week 40

### [chore: update konnect compatibility](https://github.com/Kong/docs.konghq.com/pull/8020) (2024-10-04)

#### Modified

- https://docs.konghq.com/konnect/compatibility


### [Adjust Request Transformer Advanced plugin link text](https://github.com/Kong/docs.konghq.com/pull/8011) (2024-10-03)

Adjusting the link text in the plugin overview to be more descriptive.

Fixes https://github.com/Kong/docs.konghq.com/issues/5593.

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/overview/


### [OAS Validation: headers](https://github.com/Kong/docs.konghq.com/pull/8009) (2024-10-04)

Adding a troubleshooting entry for the OAS Validation plugin about header validation. 
Fixes https://konghq.atlassian.net/browse/DOCU-4013

#### Modified

- https://docs.konghq.com/hub/kong-inc/oas-validation/overview/


### [Change the demo app used in the mesh manager example](https://github.com/Kong/docs.konghq.com/pull/8008) (2024-10-02)

I updated our Mesh Manager tutorial so that it uses the same demo app as what they're using in the Kong Mesh docs. 

I also verified that my changes worked by testing the full tutorial end-to-end.

Fixes #6625

#### Modified

- https://docs.konghq.com/konnect/mesh-manager/service-mesh


### [fix: Change Gateway changelog dates to ISO 8601 format](https://github.com/Kong/docs.konghq.com/pull/8003) (2024-10-02)

Some dates weren't in the ISO 8601 format, this fixes that.
 
DOCU-3877

#### Modified

- https://docs.konghq.com/gateway/changelog


### [fix: Add notes about OpenAPI spec version compatibility](https://github.com/Kong/docs.konghq.com/pull/8000) (2024-10-02)

I updated our Dev Portal docs to state which versions of Swagger and OpenAPI are supported for uploaded API specs. 

I tested this by trying to upload example OpenAPI specs created by ChatGPT:

- 1.1 ❌ 
- 2.0 ✅ 
- 3.0 ✅ 
- 3.2 ✅ 

DOCU-3594

#### Modified

- https://docs.konghq.com/konnect/api-products/service-documentation
- https://docs.konghq.com/konnect/dev-portal/publish-service


### [ACME plugin storage types](https://github.com/Kong/docs.konghq.com/pull/7996) (2024-10-02)

* Added a table comparing the types of storage, what they are (info from [lua-resty-acme](https://github.com/fffonion/lua-resty-acme#storage-adapters)), and where they're available
* Minor adjustments to the ACME overview page for better flow with the table
* Tested the local storage guide and fixed it up to make it work + made the curl formatting consistent

Fixes https://github.com/Kong/docs.konghq.com/issues/7966 and https://konghq.atlassian.net/browse/DOCU-2910.

#### Modified

- https://docs.konghq.com/hub/kong-inc/acme/how-to/
- https://docs.konghq.com/hub/kong-inc/acme/how-to/
- https://docs.konghq.com/hub/kong-inc/acme/overview/


### [Fix: Protobuf structure issue](https://github.com/Kong/docs.konghq.com/pull/7993) (2024-10-02)

Issue reported through docs feedback

#### Modified

- https://docs.konghq.com/hub/kong-inc/grpc-gateway/how-to/


### [Fix: AI rate limiting advanced example](https://github.com/Kong/docs.konghq.com/pull/7992) (2024-10-04)

Fixes [Issue #7867](https://github.com/Kong/docs.konghq.com/issues/7867)

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-rate-limiting-advanced/how-to/


### [Fix: Replace httpbin.org with httpbin.konghq.com](https://github.com/Kong/docs.konghq.com/pull/7991) (2024-10-02)

[DOCU-4088](https://konghq.atlassian.net/browse/DOCU-4088)


#### Modified

- https://docs.konghq.com/hub/kong-inc/acme/how-to/
- https://docs.konghq.com/hub/kong-inc/exit-transformer/overview/
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/jwt/overview/
- https://docs.konghq.com/hub/kong-inc/mocking/overview/
- https://docs.konghq.com/hub/kong-inc/oauth2/how-to/
- https://docs.konghq.com/hub/kong-inc/opa/overview/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/
- https://docs.konghq.com/hub/kong-inc/openid-connect/overview/
- https://docs.konghq.com/hub/kong-inc/post-function/how-to/
- https://docs.konghq.com/hub/kong-inc/pre-function/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer/how-to/
- https://docs.konghq.com/hub/kong-inc/request-validator/overview/
- https://docs.konghq.com/hub/kong-inc/saml/overview/
- https://docs.konghq.com/hub/kong-inc/session/overview/
- https://docs.konghq.com/gateway/3.0.x/install/docker
- https://docs.konghq.com/gateway/3.1.x/install/docker
- https://docs.konghq.com/gateway/3.2.x/install/docker
- https://docs.konghq.com/gateway/3.3.x/install/docker
- https://docs.konghq.com/gateway/3.4.x/install/docker
- https://docs.konghq.com/gateway/3.5.x/install/docker
- https://docs.konghq.com/gateway/3.6.x/install/docker
- https://docs.konghq.com/gateway/3.7.x/install/docker
- https://docs.konghq.com/gateway/3.8.x/install/docker
- https://docs.konghq.com/gateway/unreleased/install/docker
- https://docs.konghq.com/gateway/2.6.x/admin-api/rbac/examples
- https://docs.konghq.com/gateway/2.6.x/configure/auth/
- https://docs.konghq.com/gateway/2.6.x/configure/auth/oidc-curity
- https://docs.konghq.com/gateway/2.6.x/developer-portal/administration/application-registration/azure-oidc-config
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/expose-services
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/improve-performance
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/load-balancing
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/protect-services
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/secure-services
- https://docs.konghq.com/gateway/2.6.x/get-started/quickstart/configuring-a-service
- https://docs.konghq.com/gateway/2.6.x/install-and-run/docker
- https://docs.konghq.com/gateway/2.6.x/plugin-development/access-the-datastore
- https://docs.konghq.com/gateway/2.6.x/plugin-development/tests
- https://docs.konghq.com/gateway/2.6.x/reference/db-less-and-declarative-config
- https://docs.konghq.com/gateway/2.7.x/admin-api/rbac/examples
- https://docs.konghq.com/gateway/2.7.x/configure/auth/
- https://docs.konghq.com/gateway/2.7.x/configure/auth/oidc-curity
- https://docs.konghq.com/gateway/2.7.x/developer-portal/administration/application-registration/azure-oidc-config
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/expose-services
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/improve-performance
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/load-balancing
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/protect-services
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/secure-services
- https://docs.konghq.com/gateway/2.7.x/get-started/quickstart/configuring-a-service
- https://docs.konghq.com/gateway/2.7.x/install-and-run/docker
- https://docs.konghq.com/gateway/2.7.x/plugin-development/access-the-datastore
- https://docs.konghq.com/gateway/2.7.x/plugin-development/tests
- https://docs.konghq.com/gateway/2.7.x/reference/db-less-and-declarative-config
- https://docs.konghq.com/gateway/2.8.x/admin-api/developers/reference
- https://docs.konghq.com/gateway/2.8.x/admin-api/rbac/examples
- https://docs.konghq.com/gateway/2.8.x/configure/auth/
- https://docs.konghq.com/gateway/2.8.x/configure/auth/oidc-curity
- https://docs.konghq.com/gateway/2.8.x/developer-portal/administration/application-registration/azure-oidc-config
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/expose-services
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/improve-performance
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/load-balancing
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/protect-services
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/secure-services
- https://docs.konghq.com/gateway/2.8.x/get-started/quickstart/configuring-a-service
- https://docs.konghq.com/gateway/2.8.x/install-and-run/docker
- https://docs.konghq.com/gateway/2.8.x/plugin-development/access-the-datastore
- https://docs.konghq.com/gateway/2.8.x/plugin-development/tests
- https://docs.konghq.com/gateway/2.8.x/reference/db-less-and-declarative-config
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-teams
- https://docs.konghq.com/konnect/gateway-manager/backup-restore
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/how-to
- https://docs.konghq.com/konnect/gateway-manager/declarative-config
- https://docs.konghq.com/konnect/getting-started/add-api
- https://docs.konghq.com/konnect/reference/terraform


### [Fix: Broken link in Konnect KIC page](https://github.com/Kong/docs.konghq.com/pull/7990) (2024-10-04)

The link in the note on the Konnect KIC page redirects to the KIC landing page: https://docs.konghq.com/konnect/gateway-manager/kic/#kic-in-konnect-association 

Replacing it with the latest real link.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/kic


### [Fix: update konnect predefined teams](https://github.com/Kong/docs.konghq.com/pull/7986) (2024-10-01)

The Data Plane Node Admin and Service Admin roles no longer exist.  Looks like that's been the case for at least a year: https://github.com/Kong/kong-api-tests/blob/main/fixtures/kauth/kauth_teams.ts

Removed non-existent roles and added Control Plane Admin. Verified via UI and link above.

Issue reported on Slack.

#### Modified

- https://docs.konghq.com/konnect/org-management/teams-and-roles/teams-reference


### [fix(plugins): ai semantic prompt guard is EE-only](https://github.com/Kong/docs.konghq.com/pull/7983) (2024-09-30)

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-semantic-prompt-guard/_metadata/_index.yml

## Week 39

### [Fix: Mention Azure in last table entry](https://github.com/Kong/docs.konghq.com/pull/7974) (2024-09-27)

Azure has now launched as a CGW region (see first row in the same table), so this note should say "other than AWS or Azure" instead of just AWS.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/


### [Chore: Move CGW docs ](https://github.com/Kong/docs.konghq.com/pull/7962) (2024-09-23)

Moves Cloud Gateways docs into their own dedicated cloud gateways section

#### Modified

- https://docs.konghq.com/contributing/style-guide
- https://docs.konghq.com/konnect/getting-started/


### [Release: Gateway 2.8.4.13](https://github.com/Kong/docs.konghq.com/pull/7942) (2024-09-23)

Changelog and version bump for 2.8.4.13.

See https://kongstrong.slack.com/archives/C02GZ0CGJNT/p1726668953815289 for release status.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Fix: mention format keyword only supported in draft4 version](https://github.com/Kong/docs.konghq.com/pull/7928) (2024-09-27)

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-validator/overview/


### [Feat: add introduction of --disable-consumer-sync in konnect KIC section](https://github.com/Kong/docs.konghq.com/pull/7898) (2024-09-26)

Add introduction of `--disable-consumer-sync` CLI argument to speedup KIC's synchronization of configurations to Konnect when there are a lot of consumers.
Fixes https://github.com/Kong/kubernetes-ingress-controller/issues/6319.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/kic

## Week 38

### [Fix: Logging plugins log format + descriptions](https://github.com/Kong/docs.konghq.com/pull/7948) (2024-09-20)

The log format example and descriptions were missing some changes from 3.6, and had incorrectly tagged versions. 
Tested this out via the File Log plugin and compared the output to any log serializer [changelog entries](https://docs.konghq.com/gateway/changelog/). 

"JSON object considerations" was also a strange title that didn't describe the contents, which are just descriptions of each log item, so updated that to be clearer.

Issue reported on Slack.

#### Modified

- https://docs.konghq.com/hub/kong-inc/file-log/overview/
- https://docs.konghq.com/hub/kong-inc/kafka-log/overview/
- https://docs.konghq.com/hub/kong-inc/loggly/overview/
- https://docs.konghq.com/hub/kong-inc/syslog/overview/
- https://docs.konghq.com/hub/kong-inc/tcp-log/overview/
- https://docs.konghq.com/hub/kong-inc/udp-log/overview/


### [Fix: Add missing `_APPD` to env variables](https://github.com/Kong/docs.konghq.com/pull/7945) (2024-09-20)

Some of the newer parameters for the AppDynamics plugin are missing the `_APPD` section of the prefix. They should all be `KONG_APPD_*`.

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/overview/


### [fix: Convert to AI Semantic Cache LLM examples to `plugin_example`](https://github.com/Kong/docs.konghq.com/pull/7932) (2024-09-19)

Converting the LLM examples to use `plugin_example` instead for better consistency.
 
DOCU-4060

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-semantic-cache/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-semantic-cache/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/contributing/kong-plugins


### [Fix: AppD plugin missing info + broken collapsible note](https://github.com/Kong/docs.konghq.com/pull/7921) (2024-09-16)

* Documenting the ARM64 limitation for the C/C++ AppD SDK
* Fixing the collapsible note

https://konghq.atlassian.net/browse/DOCU-4061

Collapsible note with broken styling: https://docs.konghq.com/hub/kong-inc/app-dynamics/

![Screenshot 2024-09-12 at 1 35 15 PM](https://github.com/user-attachments/assets/7bb1e367-76eb-4ae8-ba36-fcc54b4954a4)

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/overview/

## Week 37

### [Update: 3.8 known issue for JSON threat protection plugin](https://github.com/Kong/docs.konghq.com/pull/7924) (2024-09-13)

Document a known issue for the JSON threat protection plugin.

Issue reported in https://konghq.atlassian.net/browse/KAG-5398.

#### Modified

- https://docs.konghq.com/hub/kong-inc/json-threat-protection/
- https://docs.konghq.com/gateway/changelog


### [Fix: correct the Konnect compatibility of the JSON-Threat-Protection Plugin](https://github.com/Kong/docs.konghq.com/pull/7919) (2024-09-12)

The JSON-Threat-Protection IS compatible with Konnect, this PR is to fix it.

#### Modified

- https://docs.konghq.com/hub/kong-inc/json-threat-protection/_metadata/_index.yml


### [feat: Bedrock docs for AI Proxy and AI Proxy Advanced](https://github.com/Kong/docs.konghq.com/pull/7913) (2024-09-11)

<!-- What did you change and why? -->
 
<!-- Include any supporting resources, e.g. link to a Jira ticket, GH issue, FTI, Slack, Aha, etc. -->
DOCU-3863

#### Added

- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/machine-learning-platform-integrations/bedrock.md
- https://docs.konghq.com/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/bedrock.md


### [Fix: OTEL + dynatrace feedback](https://github.com/Kong/docs.konghq.com/pull/7907) (2024-09-11)

* more accurate endpoints
* blurb on metrics

#### Modified

- https://docs.konghq.com/hub/kong-inc/opentelemetry/how-to/
- https://docs.konghq.com/hub/kong-inc/opentelemetry/overview/


### [Chore: Konnect changelog update](https://github.com/Kong/docs.konghq.com/pull/7903) (2024-09-11)

Update changelogs to new format, and announce that beamer is released.

#### Modified

- https://docs.konghq.com/konnect/updates


### [Fix: Add missing prerequisites to AI semantic prompt guard plugin](https://github.com/Kong/docs.konghq.com/pull/7901) (2024-09-11)

Added Redis in the prerequisites since it is needed to use the plugin

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-semantic-prompt-guard/how-to/


### [Fix: Traceable overview title](https://github.com/Kong/docs.konghq.com/pull/7900) (2024-09-11)

Traceable overview page had "Overview" as title instead of "Traceable.io" because of the title element in the frontmatter.

#### Modified

- https://docs.konghq.com/hub/traceableai/traceableai/overview/


### [Feat: Documentation for new deck command kong2tf](https://github.com/Kong/docs.konghq.com/pull/7899) (2024-09-13)

Reference documentation for the new deck command kong2tf expected to be release as part of deck 1.40.0.

### Checklist 

- [ X] Review label added 
- [ X] [Conditional version tags](https://docs.konghq.com/contributing/conditional-rendering/#conditionally-render-content-by-version) added, if applicable.

#### Modified

- https://docs.konghq.com/gateway/3.6.x/ai-gateway/
- https://docs.konghq.com/gateway/3.7.x/ai-gateway/
- https://docs.konghq.com/gateway/3.8.x/ai-gateway/
- https://docs.konghq.com/gateway/unreleased/ai-gateway/


### [Update: Konnect plugin pricing tiers](https://github.com/Kong/docs.konghq.com/pull/7896) (2024-09-11)

Removing all instances of `paid` and `premium` plugin badges and categorization.
Adding a "konnect compatible" badge instead.

https://konghq.atlassian.net/browse/DOCU-4018

#### Modified

- https://docs.konghq.com/hub/kong-inc/acl/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/acme/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-azure-content-safety/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-prompt-decorator/_metadata/_3.6.x.yml
- https://docs.konghq.com/hub/kong-inc/ai-prompt-decorator/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-prompt-guard/_metadata/_3.6.x.yml
- https://docs.konghq.com/hub/kong-inc/ai-prompt-guard/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-prompt-template/_metadata/_3.6.x.yml
- https://docs.konghq.com/hub/kong-inc/ai-prompt-template/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-proxy/_metadata/_3.6.x.yml
- https://docs.konghq.com/hub/kong-inc/ai-proxy/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-rate-limiting-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-request-transformer/_metadata/_3.6.x.yml
- https://docs.konghq.com/hub/kong-inc/ai-request-transformer/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-response-transformer/_metadata/_3.6.x.yml
- https://docs.konghq.com/hub/kong-inc/ai-response-transformer/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-semantic-cache/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/app-dynamics/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/aws-lambda/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/azure-functions/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/basic-auth/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/bot-detection/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/canary/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/confluent/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/degraphql/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/exit-transformer/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/forward-proxy/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/graphql-proxy-cache-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/jq/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/jwe-decrypt/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/kafka-log/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/kafka-upstream/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/key-auth/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ldap-auth-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/mocking/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/mtls-auth/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/oas-validation/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/oauth2-introspection/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/opa/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/openid-connect/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/prometheus/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/proxy-cache-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/request-validator/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/response-transformer-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/route-by-header/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/route-transformer-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/saml/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/statsd-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/upstream-timeout/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/websocket-size-limit/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/websocket-validator/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/xml-threat-protection/_metadata/_index.yml
- https://docs.konghq.com/contributing/markdown-rules
- https://docs.konghq.com/hub/plugins/license-tiers
- https://docs.konghq.com/konnect/compatibility
- https://docs.konghq.com/konnect/gateway-manager/dedicated-cloud-gateways
- https://docs.konghq.com/konnect/updates


### [feat: Service Catalog](https://github.com/Kong/docs.konghq.com/pull/7889) (2024-09-11)

Contains: 
https://github.com/Kong/docs.konghq.com/pull/7739
https://github.com/Kong/docs.konghq.com/pull/7849
https://github.com/Kong/docs.konghq.com/pull/7862

Previews:

https://deploy-preview-7889--kongdocs.netlify.app/konnect/service-catalog/
https://deploy-preview-7889--kongdocs.netlify.app/konnect/service-catalog/integrations/

#### Added

- https://docs.konghq.com/assets/images/icons/third-party/github.svg
- https://docs.konghq.com/assets/images/icons/third-party/pagerduty.svg
- https://docs.konghq.com/assets/images/icons/third-party/traceable.svg
- https://docs.konghq.com/konnect/service-catalog/integrations/github
- https://docs.konghq.com/konnect/service-catalog/integrations/
- https://docs.konghq.com/konnect/service-catalog/integrations/pagerduty
- https://docs.konghq.com/konnect/service-catalog/integrations/traceable

#### Modified

- https://docs.konghq.com/konnect/org-management/teams-and-roles/roles-reference
- https://docs.konghq.com/konnect/org-management/teams-and-roles/teams-reference
- https://docs.konghq.com/konnect/service-catalog/


### [Update: Add info about Header Cert Auth size limits](https://github.com/Kong/docs.konghq.com/pull/7884) (2024-09-10)

Adding a section on how to increase the header size limit so that certs aren't blocked or truncated.

Info provided on Slack: https://kongstrong.slack.com/archives/CDSTDSG9J/p1725983347871329?thread_ts=1725973425.599459&cid=CDSTDSG9J

#### Modified

- https://docs.konghq.com/hub/kong-inc/header-cert-auth/overview/


### [Feat: OTEL with Dynatrace + plugin doc refactor](https://github.com/Kong/docs.konghq.com/pull/7881) (2024-09-11)

New page for Dynatrace.

Also split the very long main page into multiple how-to guides.

❗ Note to reviewers: The dynatrace page is the only new page. I didn't edit or rewrite any of the other content, I only split it into pages. You can copyedit them if you have time, but that's not the priority here.

https://konghq.atlassian.net/browse/DOCU-3879

#### Added

- https://docs.konghq.com/hub/kong-inc/opentelemetry/how-to/
- https://docs.konghq.com/hub/kong-inc/opentelemetry/how-to/
- https://docs.konghq.com/hub/kong-inc/opentelemetry/how-to/

#### Modified

- https://docs.konghq.com/hub/kong-inc/opentelemetry/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/opentelemetry/overview/


### [Update: Konnect resource limits note](https://github.com/Kong/docs.konghq.com/pull/7877) (2024-09-09)

Add note about contacting support to increase resource limits.

Requested on Slack, as customers have run into these limits and didn't know what to do about them: https://kongstrong.slack.com/archives/C07JN2D8RAS/p1725722454208289?thread_ts=1725652540.259969&cid=C07JN2D8RAS

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/configuration/


### [Feat: Azure Vnet peering for Cloud Gateways](https://github.com/Kong/docs.konghq.com/pull/7870) (2024-09-11)

https://konghq.atlassian.net/browse/DOCU-4041

#### Added

- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/azure-peering


### [Update: Add docker copy command to move cert and key into container before restarting the gateway](https://github.com/Kong/docs.konghq.com/pull/7859) (2024-09-12)

added docker copy command to move cert and key ointo container before restarting the gateway

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/renew-certificates


### [Feat: Advanced AI Analytics](https://github.com/Kong/docs.konghq.com/pull/7847) (2024-09-12)

https://konghq.atlassian.net/browse/DOCU-4055
https://konghq.atlassian.net/browse/DOCU-4050

#### Modified

- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/api-usage-by-application.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/kong-vs-upstream-latency.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/latency-payments-api-30.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/total-api-requests.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/total-usage-accounts-api-30.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/konnect-analytics-api-requests.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/konnect-api-usage-summary.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/konnect-explorer-dashboard.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/konnect-summary-dashboard.png
- https://docs.konghq.com/konnect/analytics/explorer
- https://docs.konghq.com/konnect/analytics/
- https://docs.konghq.com/konnect/analytics/use-cases
- https://docs.konghq.com/konnect/updates


### [feat: Gemini and Bedrock for AI Proxy ](https://github.com/Kong/docs.konghq.com/pull/7831) (2024-09-11)

 - Added support for Gemini and Bedrock to tables
 - Added rough draft tutorials for Gemini and Bedrock

DOCU-3863

#### Added

- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/machine-learning-platform-integrations/gemini.md
- https://docs.konghq.com/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/gemini.md

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/ai-proxy/overview/


### [Feat: AI proxy advanced](https://github.com/Kong/docs.konghq.com/pull/7817) (2024-09-11)

AI Proxy Advanced plugin.

Schema (config reference) and basic example added via https://github.com/Kong/docs-plugin-toolkit/pull/47.

https://konghq.atlassian.net/browse/DOCU-3884

Questions for @fffonion @AntoineJac:
* How many of the currently existing [AI Proxy docs](https://docs.konghq.com/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/anthropic/), especially the LLM integration guides, do we want to reuse for this plugin? How many of them apply?
* Is there somewhere that I can find info on the load balancing and semantic routing capabilities of this plugin?
  * Is the plugin's `lowest-usage` algorithm analogous to the Gateway `least-connections` algorithm defined here: https://docs.konghq.com/gateway/latest/how-kong-works/load-balancing/#least-connections
  * Are the `consistent-hashing` and `round-robin` algorithms that we already use in the Gateway exactly the same as we already define on that same page?

#### Added

- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/ai-proxy-advanced/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_ai-proxy-advanced.png

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/gateway/3.6.x/ai-gateway/
- https://docs.konghq.com/gateway/3.7.x/ai-gateway/
- https://docs.konghq.com/gateway/3.8.x/ai-gateway/
- https://docs.konghq.com/gateway/unreleased/ai-gateway/


### [Feat: Upstream Oauth plugin](https://github.com/Kong/docs.konghq.com/pull/7814) (2024-09-10)

Upstream OAuth plugin.

To do:
* Short "how to use this" - or is the ["basic examples"](https://deploy-preview-7814--kongdocs.netlify.app/hub/kong-inc/upstream-oauth/unreleased/how-to/basic-examples) page enough?
* Is this plugin supported in DB-less, hybrid, and Konnect?

Config reference and example added via https://github.com/Kong/docs-plugin-toolkit/pull/53
https://konghq.atlassian.net/browse/DOCU-4024

#### Added

- https://docs.konghq.com/hub/kong-inc/upstream-oauth/
- https://docs.konghq.com/hub/kong-inc/upstream-oauth/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/upstream-oauth/overview/
- https://docs.konghq.com/hub/kong-inc/upstream-oauth/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_upstream-oauth.png


### [Feat: Standard Webhooks plugin](https://github.com/Kong/docs.konghq.com/pull/7808) (2024-09-10)

Standard webhooks plugin.

Schema and example added via https://github.com/Kong/docs-plugin-toolkit/pull/50. 

https://konghq.atlassian.net/browse/DOCU-3844

#### Added

- https://docs.konghq.com/hub/kong-inc/standard-webhooks/
- https://docs.konghq.com/hub/kong-inc/standard-webhooks/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/standard-webhooks/overview/
- https://docs.konghq.com/hub/kong-inc/standard-webhooks/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_standard-webhooks.png


### [Feat: Header Cert Auth plugin](https://github.com/Kong/docs.konghq.com/pull/7775) (2024-09-09)

Doc for new Header Cert Auth plugin.
https://konghq.atlassian.net/browse/DOCU-4005

Schema and basic example added in https://github.com/Kong/docs-plugin-toolkit/pull/46.
Based on https://github.com/Kong/kong-ee/pull/9723.

#### Added

- https://docs.konghq.com/hub/kong-inc/header-cert-auth/
- https://docs.konghq.com/hub/kong-inc/header-cert-auth/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/header-cert-auth/how-to/
- https://docs.konghq.com/hub/kong-inc/header-cert-auth/how-to/
- https://docs.konghq.com/hub/kong-inc/header-cert-auth/how-to/
- https://docs.konghq.com/hub/kong-inc/header-cert-auth/overview/
- https://docs.konghq.com/hub/kong-inc/header-cert-auth/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_header-cert-auth.png


### [Feat: semantic prompt guard plugin ](https://github.com/Kong/docs.konghq.com/pull/7770) (2024-09-11)

https://konghq.atlassian.net/browse/DOCU-4008

Base for documentation


https://deploy-preview-7770--kongdocs.netlify.app/hub/kong-inc/ai-semantic-prompt-guard/unreleased/

#### Added

- https://docs.konghq.com/hub/kong-inc/ai-semantic-prompt-guard/
- https://docs.konghq.com/hub/kong-inc/ai-semantic-prompt-guard/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-semantic-prompt-guard/how-to/
- https://docs.konghq.com/hub/kong-inc/ai-semantic-prompt-guard/overview/
- https://docs.konghq.com/hub/kong-inc/ai-semantic-prompt-guard/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_ai-semantic-prompt-guard.png

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-prompt-guard/overview/


### [Feat: add custom sts endpoint configuration field for various aws features in kong gateway](https://github.com/Kong/docs.konghq.com/pull/7762) (2024-09-09)

This is a new feature in kong gateway 3.8. The original PR is here: https://github.com/Kong/kong-ee/pull/9654

The feature covers the update for three parts of the AWS-related features inside Kong gateway: the aws-lambda plugin, the aws vault backend, and the IAM authentication for RDS database.

KAG-4599

#### Modified

- https://docs.konghq.com/gateway/3.6.x/ai-gateway/
- https://docs.konghq.com/gateway/3.7.x/ai-gateway/
- https://docs.konghq.com/gateway/3.8.x/ai-gateway/
- https://docs.konghq.com/gateway/unreleased/ai-gateway/


### [Feat: add ai semantic caching plugin](https://github.com/Kong/docs.konghq.com/pull/7713) (2024-09-10)

Feat/add ai semantic caching plugin
 
<!-- Include any supporting resources, e.g. link to a Jira ticket, GH issue, FTI, Slack, Aha, etc. -->
DOCU-3852

#### Added

- https://docs.konghq.com/hub/kong-inc/ai-semantic-cache/
- https://docs.konghq.com/hub/kong-inc/ai-semantic-cache/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-semantic-cache/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-semantic-cache/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-semantic-cache/overview/
- https://docs.konghq.com/hub/kong-inc/ai-semantic-cache/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_ai-semantic-cache.png

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-rate-limiting-advanced/overview/

## Week 36

### [Feat: AppD analytics_enable](https://github.com/Kong/docs.konghq.com/pull/7861) (2024-09-06)

Adding ANALYTICS_ENABLE env variable to the AppDynamics env variables table.

Discovered via changelog entry.

@oowl what kind of analytics get logged via this variable, and _is_ it sending the data to AppD?

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/overview/


### [Fix: Add a third option to close your Plus or Enterprise account](https://github.com/Kong/docs.konghq.com/pull/7860) (2024-09-05)

Add a third option to close your Plus or Enterprise account

#### Modified

- https://docs.konghq.com/konnect/org-management/deactivation


### [Fix: updates rbac's docs in DB-less mode.](https://github.com/Kong/docs.konghq.com/pull/7852) (2024-09-05)

#### Modified

- https://docs.konghq.com/gateway/3.0.x/kong-manager/auth/rbac
- https://docs.konghq.com/gateway/3.1.x/kong-manager/auth/rbac
- https://docs.konghq.com/gateway/3.2.x/kong-manager/auth/rbac
- https://docs.konghq.com/gateway/3.3.x/kong-manager/auth/rbac
- https://docs.konghq.com/gateway/3.4.x/kong-manager/auth/rbac
- https://docs.konghq.com/gateway/3.5.x/kong-manager/auth/rbac
- https://docs.konghq.com/gateway/3.6.x/kong-manager/auth/rbac
- https://docs.konghq.com/gateway/3.7.x/kong-manager/auth/rbac
- https://docs.konghq.com/gateway/unreleased/kong-manager/auth/rbac


### [Fix: AWS Lambda plugin changelog entry for base64_encode_body](https://github.com/Kong/docs.konghq.com/pull/7850) (2024-09-05)

Adding a missing changelog entry for `base64_encode_body` (tracked down via blame in https://github.com/Kong/kong/commit/5853f9d0c0bb6afce4b6d3165cacbd86bb46b8d2). 
Since we no longer have specific docs for version 2.5.x, we don't need to update the config reference.

Fixes https://github.com/Kong/docs.konghq.com/issues/5544.

#### Modified

- https://docs.konghq.com/hub/kong-inc/aws-lambda/


### [Fix: Exit Transformer plugin handle_unknown description](https://github.com/Kong/docs.konghq.com/pull/7848) (2024-09-05)

Correcting the description of `handle_unknown`, which is currently misleading and doesn't provide enough context.

Fixes https://konghq.atlassian.net/browse/FTI-6080

#### Modified

- https://docs.konghq.com/hub/kong-inc/exit-transformer/overview/


### [Fix: Remove AI RLA plugin from traffic control category on plugin hub](https://github.com/Kong/docs.konghq.com/pull/7845) (2024-09-04)

The plugin currently appears twice because it's listed under two categories, and it should only be under AI: 

<img src="https://github.com/user-attachments/assets/d7b0fca6-16a6-40a0-b637-58bc75caf7a1" width="300px"/>

Issue reported by on Slack by Marco.

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-rate-limiting-advanced/_metadata/_index.yml


### [Fix: Links to Konnect APIs](https://github.com/Kong/docs.konghq.com/pull/7844) (2024-09-04)

The links on this page currently point to the on-prem EE Admin API, where they should be pointing to the Konnect Control Plane Config API.

Fixes https://github.com/Kong/docs.konghq.com/issues/7812.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/configuration/


### [Fix: HMAC signing string in plugin example](https://github.com/Kong/docs.konghq.com/pull/7841) (2024-09-04)

Fixes https://konghq.atlassian.net/browse/FTI-6211.

#### Modified

- https://docs.konghq.com/hub/kong-inc/hmac-auth/overview/


### [Fix: Errors in mTLS Auth examples](https://github.com/Kong/docs.konghq.com/pull/7830) (2024-09-03)

Fixing mTLS auth examples:
* Incorrect URL in Konnect example
* Split response out from Admin API example to reduce confusion

#### Modified

- https://docs.konghq.com/hub/kong-inc/mtls-auth/how-to/


### [Fix: Konnect example in mtls plugin](https://github.com/Kong/docs.konghq.com/pull/7829) (2024-09-03)

The mTLS plugin doc contains an example of using the Konnect API with a generated cookie, which hasn't been possible for a long time. Fixing the example to reference a PAT instead.

#### Modified

- https://docs.konghq.com/hub/kong-inc/mtls-auth/how-to/


### [Feat: add docs for new confluent plugin](https://github.com/Kong/docs.konghq.com/pull/7773) (2024-09-04)

This is a DRAFT PR that needs fill-in from @silvolu.

#### Added

- https://docs.konghq.com/hub/kong-inc/confluent/
- https://docs.konghq.com/hub/kong-inc/confluent/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/confluent/overview/
- https://docs.konghq.com/hub/kong-inc/confluent/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_confluent.png


### [Feat: add docs for json-threat-protection plugin](https://github.com/Kong/docs.konghq.com/pull/7747) (2024-09-03)

#### Added

- https://docs.konghq.com/hub/kong-inc/json-threat-protection/
- https://docs.konghq.com/hub/kong-inc/json-threat-protection/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/json-threat-protection/overview/
- https://docs.konghq.com/hub/kong-inc/json-threat-protection/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_json-threat-protection.png

## Week 35

### [Fix: Add timeout config, specify konnect compatibility, add kong versions](https://github.com/Kong/docs.konghq.com/pull/7760) (2024-08-26)

- Add timeout config for latest version of our plugin
- Specify konnect compatibility
- Add kong support versions

#### Modified

- https://docs.konghq.com/hub/traceableai/traceableai/_metadata/_index.yml
- https://docs.konghq.com/hub/traceableai/traceableai/schemas/_index.json

## Week 34

### [Fix: Add changelog entry for deprecated OTEL parameters in 3.7](https://github.com/Kong/docs.konghq.com/pull/7774) (2024-08-23)

Issue reported on slack: certain parameters in the OTEL plugin are marked deprecated, but there is no changelog entry noting when the deprecation happened.

#### Modified

- https://docs.konghq.com/hub/kong-inc/opentelemetry/


### [Feat: add ai metrics docs](https://github.com/Kong/docs.konghq.com/pull/7691) (2024-08-23)

Doc on AI metrics and Prometheus

#### Modified

- https://docs.konghq.com/hub/kong-inc/prometheus/overview/
- https://docs.konghq.com/gateway/3.0.x/production/tracing/
- https://docs.konghq.com/gateway/3.1.x/production/tracing/
- https://docs.konghq.com/gateway/3.2.x/production/tracing/
- https://docs.konghq.com/gateway/3.3.x/production/tracing/
- https://docs.konghq.com/gateway/3.4.x/production/tracing/
- https://docs.konghq.com/gateway/3.5.x/production/tracing/
- https://docs.konghq.com/gateway/3.6.x/production/tracing/
- https://docs.konghq.com/gateway/3.7.x/production/tracing/
- https://docs.konghq.com/gateway/unreleased/production/tracing/

## Week 33

### [Feat: Document shared variables](https://github.com/Kong/docs.konghq.com/pull/7750) (2024-08-13)

Update the template documentation to add details for using shared variables: 
https://docs.konghq.com/gateway/latest/plugin-development/pdk/kong.ctx/#kongctxshared


This looks to have been added here, https://github.com/Kong/kong-plugin-request-transformer/pull/7, but we lack documentation on how to reference it. Using the documented convention, kong.ctx.shared.foo,  results in errors with "kong" being a nil value.

Tests have shown it successful  using this with the request transformer plugin and route transformer advanced, i.e:

x-name:$((function()     return shared["gruber"] end)())

Where "gruber" has been previously defined as
kong.ctx.shared.gruber = "myHeader"

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/how-to/

## Week 32

### [Fix: Update key-auth request behaviour matrix](https://github.com/Kong/docs.konghq.com/pull/7737) (2024-08-09)

I've read and re-read this section a few times - and I'm pretty sure there's a typo! But my apologies in advance if I've misunderstood the situation.

Kong will return a 401 when the API key is **not** known.

#### Modified

- https://docs.konghq.com/hub/kong-inc/key-auth/overview/


### [Fix: decK select tag examples](https://github.com/Kong/docs.konghq.com/pull/7735) (2024-08-08)

Fixing the select-tag examples in the decK docs to match real behavior. 

https://konghq.atlassian.net/browse/DOCU-4012

#### Modified

- https://docs.konghq.com/gateway/3.0.x/get-started/
- https://docs.konghq.com/gateway/3.1.x/get-started/
- https://docs.konghq.com/gateway/3.2.x/get-started/
- https://docs.konghq.com/gateway/3.3.x/get-started/
- https://docs.konghq.com/gateway/3.4.x/get-started/
- https://docs.konghq.com/gateway/3.5.x/get-started/
- https://docs.konghq.com/gateway/3.6.x/get-started/
- https://docs.konghq.com/gateway/3.7.x/get-started/
- https://docs.konghq.com/gateway/unreleased/get-started/


### [chore: add more explanations about aws secret with slash in kong gateway](https://github.com/Kong/docs.konghq.com/pull/7728) (2024-08-09)

This PR adds a note to show a correct way of referencing secrets that has special slash symbols.

https://konghq.atlassian.net/browse/KAG-5054

#### Modified

- https://docs.konghq.com/gateway/3.0.x/get-started/
- https://docs.konghq.com/gateway/3.1.x/get-started/
- https://docs.konghq.com/gateway/3.2.x/get-started/
- https://docs.konghq.com/gateway/3.3.x/get-started/
- https://docs.konghq.com/gateway/3.4.x/get-started/
- https://docs.konghq.com/gateway/3.5.x/get-started/
- https://docs.konghq.com/gateway/3.6.x/get-started/
- https://docs.konghq.com/gateway/3.7.x/get-started/
- https://docs.konghq.com/gateway/unreleased/get-started/


### [Release: Gateway 3.4.3.12](https://github.com/Kong/docs.konghq.com/pull/7727) (2024-08-09)

Changelog and version bump for 3.4.3.12

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Feat: document caCert for cert-manager](https://github.com/Kong/docs.konghq.com/pull/7718) (2024-08-06)

Missing docs for existing feature

#### Modified

- https://docs.konghq.com/gateway/3.0.x/get-started/
- https://docs.konghq.com/gateway/3.1.x/get-started/
- https://docs.konghq.com/gateway/3.2.x/get-started/
- https://docs.konghq.com/gateway/3.3.x/get-started/
- https://docs.konghq.com/gateway/3.4.x/get-started/
- https://docs.konghq.com/gateway/3.5.x/get-started/
- https://docs.konghq.com/gateway/3.6.x/get-started/
- https://docs.konghq.com/gateway/3.7.x/get-started/
- https://docs.konghq.com/gateway/unreleased/get-started/

## Week 31

### [Fix: Add clarifying statement about private dev portals](https://github.com/Kong/docs.konghq.com/pull/7708) (2024-07-31)

The prior sentence states that `and are discoverable on the internet` for Public Dev Portals. It seems like it would be good to  explicit that private are not (which is just an assumption I made)

#### Modified

- https://docs.konghq.com/konnect/dev-portal/create-dev-portal


### [Fix: Hardcode gateway version in centos doc](https://github.com/Kong/docs.konghq.com/pull/7703) (2024-07-31)

As of 2.8.4.12, we are no longer building Centos packages for Gateway 2.8. Changing the variables on the 2.8 page to hardcoded so that they don't pick up a version of a package that doesn't exist. The version no longer needs to change dynamically with releases.

#### Modified

- https://docs.konghq.com/gateway/2.8.x/install-and-run/centos


### [Feat: added release notes for new refresh button](https://github.com/Kong/docs.konghq.com/pull/7701) (2024-07-30)

API Requests and Explorer now have a refresh button that allows users to manually refresh/fetch data without a full page site reload. It also preserves all filters.

![image](https://github.com/user-attachments/assets/cd96d91b-1c24-4a86-89c2-072e10243085)

![image](https://github.com/user-attachments/assets/b1ee98fb-83f5-425f-b3d7-1f4eb685b71f)

Aha ticket: https://konghq.aha.io/features/KP-506

#### Modified

- https://docs.konghq.com/konnect/updates


### [Release: Gateway 2.8.4.12](https://github.com/Kong/docs.konghq.com/pull/7693) (2024-07-30)

Changelog and version bump for 2.8.4.12.

Do not merge until the patch goes out.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Feat: Brotli support](https://github.com/Kong/docs.konghq.com/pull/7692) (2024-07-31)

We added Brotli compression support in 3.6 but it was never documented. Adding a short doc on how to enable it.

Notes:
* I considered adding it to the Nginx directives doc, but there's nothing in there about configuring specific groups of directives for a goal - that topic is a more general thing. 
* I'm also not sure about putting this under "reference", but honestly, we don't really have a place for content like this at the moment.

Addresses https://konghq.atlassian.net/browse/DOCU-3911.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Feat: Add Cost strategy to Ai Rate Limiting plugin ](https://github.com/Kong/docs.konghq.com/pull/7690) (2024-08-02)

Add Cost strategy to Ai Rate Limiting plugin 

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-rate-limiting-advanced/overview/

## Week 30

### [Update: Add API instructions for finding Konnect hostnames](https://github.com/Kong/docs.konghq.com/pull/7681) (2024-07-25)

Adding API instructions to find control plane and telemetry hostnames for Konnect control planes. Tested both regular and KIC control planes.

The headings on this page were also broken and didn't work as anchor links, as they were nested inside navtabs. This doesn't work, so I turned them into regular headings.

Fixes https://github.com/Kong/docs.konghq.com/issues/6869.

#### Modified

- https://docs.konghq.com/konnect/network


### [Fix: AI Proxy plugin: incorrect format in example](https://github.com/Kong/docs.konghq.com/pull/7677) (2024-07-25)

The description of the example and the example itself don't refer to the same format: the description says `ollama` but the example uses `openai`. The correct format is `openai`, as the example also uses an Authorization header, which is required for `openai`.

Fixes https://github.com/Kong/docs.konghq.com/issues/7609. 

### Checklist 

- [x] Review label added <!-- (see below) -->
- [x] [Conditional version tags](https://docs.konghq.com/contributing/conditional-rendering/#conditionally-render-content-by-version) added, if applicable.


#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/


### [Provide link to limitations of dynamic plugin ordering](https://github.com/Kong/docs.konghq.com/pull/7656) (2024-07-22)

Users are not warned about the limitations of Dynamic plugin ordering, particularly in relation to consumer scoped plugins.  This change informs of the limitation and provides a link to the details.


 Users are not warned about the limitations of Dynamic plugin ordering in this page, particularly in relation to consumer scoped plugins. This change informs of the limitation and provides a link to the details. There have been cases of customers implementing dynamic ordering and then realise it is incompatible with consumer scoped plugins.

#### Modified

- https://docs.konghq.com/konnect/reference/plugins


## Week 29

### [Feat: Azure support in dedicated cloud gateways](https://github.com/Kong/docs.konghq.com/pull/7634) (2024-07-15)

Updating docs to introduce Azure support in Konnect Dedicated Cloud Gateways.

Minor adjustments to the Konnect changelog to make it consistent.

https://konghq.atlassian.net/browse/DOCU-3870

#### Added

- https://docs.konghq.com/assets/images/products/konnect/gateway-manager/konnect-azure-cgw.png

#### Modified

- https://docs.konghq.com/assets/images/products/konnect/gateway-manager/konnect-control-plane-cloud-gateway-wizard.png
- https://docs.konghq.com/konnect/gateway-manager/dedicated-cloud-gateways
- https://docs.konghq.com/konnect/gateway-manager/
- https://docs.konghq.com/konnect/updates

## Week 28

### [Fix: Key Auth Encrypted note and "not applicable" konnect labels](https://github.com/Kong/docs.konghq.com/pull/7635) (2024-07-12)

* Fixing[ misleading/confusing note for Key Auth Enc](https://docs.konghq.com/hub/plugins/compatibility/#authentication:~:text=Key%20Authentication%20%2D%20Encrypted-,The%20time%2Dto%2Dlive%20(ttl)%20does%20not%20work%20in%20Konnect%20or%20hybrid%20mode.%20This%20setting%20determines%20the%20length%20of%20time%20a%20credential%20remains%20valid.,-LDAP%20Authentication), which was not providing enough info about why the plugin doesn't run in Konnect. 
* Rephrasing the "Not applicable" table entries in the konnect compatibility table to say "Not available in Konnect" to make it clearer

Issue reported on Slack.

#### Modified

- https://docs.konghq.com/hub/kong-inc/key-auth-enc/_metadata/_index.yml
- https://docs.konghq.com/hub/plugins/compatibility/
- https://docs.konghq.com/konnect/compatibility


### [fix description about the execution order of the ai-request-transformer plugin](https://github.com/Kong/docs.konghq.com/pull/7628) (2024-07-11)

This PR is to fix the description about the execution order of the ai-request-transformer plugin

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-request-transformer/overview/


### [Chore: Documenting third-party tools instructions](https://github.com/Kong/docs.konghq.com/pull/7623) (2024-07-10)

https://konghq.atlassian.net/browse/DOCU-3817
Document expectations for writing about third-party things.

#### Modified

- https://docs.konghq.com/contributing/style-guide


### [Release: Gateway 3.5.0.7](https://github.com/Kong/docs.konghq.com/pull/7603) (2024-07-10)

Changelog and version bump for 3.5.0.7

Will need a plugin schema update but there's no RC yet, so will generate that when it's available.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.6.1.7](https://github.com/Kong/docs.konghq.com/pull/7602) (2024-07-10)

changelog and version bump for 3.6.1.7

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.7.1.2](https://github.com/Kong/docs.konghq.com/pull/7601) (2024-07-10)

Changelog and version bump for 3.7.1.2

#### Modified

- https://docs.konghq.com/gateway/changelog


### [feat: Multi Dev Portal](https://github.com/Kong/docs.konghq.com/pull/7561) (2024-07-10)

<!-- What did you change and why? -->
 This PR documents the new multi-portal functionality and also does some docs cleanup in the Dev Portal section to make the user flow a bit clearer.
<!-- Include any supporting resources, e.g. link to a Jira ticket, GH issue, FTI, Slack, Aha, etc. -->
DOCU-3864

#### Added

- https://docs.konghq.com/konnect/dev-portal/create-dev-portal

#### Modified

- https://docs.konghq.com/konnect/api-products/productize-service
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-app-reg-requests
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-teams
- https://docs.konghq.com/konnect/dev-portal/applications/enable-app-reg
- https://docs.konghq.com/konnect/dev-portal/customization/
- https://docs.konghq.com/konnect/dev-portal/
- https://docs.konghq.com/konnect/dev-portal/publish-service
- https://docs.konghq.com/konnect/updates

## Week 27

### [chore(rate-limiting): clarify rate-limiting accuracy](https://github.com/Kong/docs.konghq.com/pull/7607) (2024-07-03)

Both rate-limiting and rate-limiting-advanced plugins documentation specify that various policies are possible and states that `cluster` and `redis` are "Accurate". However it's possible to configure a `sync_rate` option for these plugins and set it to a value that does not offer synchronous behaviour allowing for some slippage in favor of performance.

This commit clarifies that `sync_rate` affects mentioned accuracy.

KAG-2896

https://github.com/Kong/kong/issues/11846

#### Modified

- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/rate-limiting/overview/


### [Feat: Konnect analytics ingestion toggle ](https://github.com/Kong/docs.konghq.com/pull/7600) (2024-07-03)

Konnect analytics ingestion toggle.

#### Modified

- https://docs.konghq.com/konnect/analytics/
- https://docs.konghq.com/konnect/updates


### [fix(ai-proxy): clarify model support](https://github.com/Kong/docs.konghq.com/pull/7596) (2024-07-01)

Clarified a number of model supports, added GPT-4o / LLAMA3.

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy/overview/


### [Fix: GraphQL RLA example needs a warning to not run in prod](https://github.com/Kong/docs.konghq.com/pull/7590) (2024-07-02)

Adding a disclaimer to plugin basic examples about not using the examples in prod, and adding some extra language for the GraphQL RLA examples to caution against `sync_rate = -1` with the `cluster` strategy.

We can use this same templating to add extra example descriptions to any of the plugins in the future.

https://konghq.atlassian.net/browse/DOCU-3489

#### Modified

- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/_metadata/_index.yml


### [Update: DeGraphQL diagram](https://github.com/Kong/docs.konghq.com/pull/7588) (2024-07-01)

Mermaid diagram for DeGraphQL plugin.

https://konghq.atlassian.net/browse/DOCU-110

#### Added

- https://docs.konghq.com/assets/images/icons/third-party/graphql-logo.svg

#### Modified

- https://docs.konghq.com/hub/kong-inc/degraphql/overview/

## Week 26

### [Feat: decK gateway CLI](https://github.com/Kong/docs.konghq.com/pull/7585) (2024-06-27)

The decK gateway interaction commands were moved into a `gateway` subcommand in decK version 1.28.0, which also included some refactoring in how they function. At the time, we avoided updating the docs as users were unlikely to have a version of decK that uses those commands, and they were not yet stable. 
They are now ready to be updated, and the docs are causing more confusion by not using `deck gateway` in examples.

Took two different approaches re: versioning these commands:
* In the decK documentation (docs.konghq.com/deck), I version-tagged the commands whenever they were used in code blocks. If they were mentioned in text, I removed the `deck` portion.
  * Duplicated one file (docker run reference), as the whole page would've needed version tagging otherwise.
* In the rest of the site, I didn't version the commands, as there's no clear way to know what version of decK someone is using with a specific version of Gateway. All of the Gateway, Konnect, and plugin docs just use the `deck gateway` commands.

https://konghq.atlassian.net/browse/DOCU-3565
https://konghq.atlassian.net/browse/DOCU-3545

#### Modified

- https://docs.konghq.com/hub/kong-inc/pre-function/how-to/
- https://docs.konghq.com/konnect/dev-portal/troubleshoot/
- https://docs.konghq.com/konnect/gateway-manager/backup-restore
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/conflicts
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/migrate
- https://docs.konghq.com/konnect/gateway-manager/declarative-config


### [chore(release): docs for KGO 1.3.0](https://github.com/Kong/docs.konghq.com/pull/7576) (2024-06-25)

Changes needed for the release 

- https://github.com/Kong/gateway-operator-enterprise/issues/199

**please double-check compatibility matrixes, cli&crd docs and changelog.**

#### Modified

- https://docs.konghq.com/gateway-operator/changelog


### [Fix: GW changelog heading levels](https://github.com/Kong/docs.konghq.com/pull/7575) (2024-06-24)

`## Fixes` should be `### Fixes`

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 2.8.4.11](https://github.com/Kong/docs.konghq.com/pull/7574) (2024-06-24)

changelog and version bump for 2.8.4.11

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.4.3.11](https://github.com/Kong/docs.konghq.com/pull/7573) (2024-06-24)

changelog and version bump for 3.4.3.11

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.5.0.6](https://github.com/Kong/docs.konghq.com/pull/7572) (2024-06-24)

changelog and version bump for 3.5.0.6

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.6.1.6](https://github.com/Kong/docs.konghq.com/pull/7571) (2024-06-24)

changelog and version bump for 3.6.1.6

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.7.1.1](https://github.com/Kong/docs.konghq.com/pull/7570) (2024-06-24)

changelog and version bump for 3.7.1.1

#### Modified

- https://docs.konghq.com/gateway/changelog


### [fix(ai-proxy): fix several configs in docs](https://github.com/Kong/docs.konghq.com/pull/7550) (2024-06-25)
 
Fields other than name and provider should live under `options` field.

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/
- https://docs.konghq.com/assets/hub/kong-inc/ai-proxy/llama2.yaml
- https://docs.konghq.com/assets/hub/kong-inc/ai-proxy/mistral.yaml
- https://docs.konghq.com/assets/hub/kong-inc/ai-proxy/openai.yaml


### [doc on ai metrics](https://github.com/Kong/docs.konghq.com/pull/7487) (2024-06-26)

This PR is providing info on how to to expose and visualize AI metrics through Prometheus and Grafana. These metrics include the number of AI requests, the cost associated with AI services, and the token usage per provider and model.


#### Added

- https://docs.konghq.com/assets/images/products/gateway/vitals/grafana-ai-dashboard.png

#### Modified

- https://docs.konghq.com/hub/kong-inc/prometheus/overview/

## Week 25

### [Fix: instead of Update Cluster Config should be Edit or Resize Cluster](https://github.com/Kong/docs.konghq.com/pull/7556) (2024-06-20)

Documentation does not line up with the product: instead of Update Cluster Config should be Edit or Resize Cluster


#### Modified

- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/upgrade


### [fix(dpop): ambiguity of key validation description](https://github.com/Kong/docs.konghq.com/pull/7549) (2024-06-20)


#### Modified

- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/


### [Release: Gateway 2.8.4.10](https://github.com/Kong/docs.konghq.com/pull/7530) (2024-06-20)

Changelog and version bump for 2.8.4.10

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.4.3.10](https://github.com/Kong/docs.konghq.com/pull/7529) (2024-06-20)

Changelog and version bump for 3.4.3.10

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.5.0.5](https://github.com/Kong/docs.konghq.com/pull/7528) (2024-06-20)

Changelog and version bump for 3.5.0.5.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.6.1.5](https://github.com/Kong/docs.konghq.com/pull/7527) (2024-06-20)

Changelog and version bump for 3.6.1.5

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.7.1.0](https://github.com/Kong/docs.konghq.com/pull/7525) (2024-06-20)

Changelog and version bump for 3.7.1.0.

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-validator/
- https://docs.konghq.com/gateway/changelog


### [Fix: Use consistent/accurate product name for Google Cloud/GCP secret manager and HashiCorp](https://github.com/Kong/docs.konghq.com/pull/7495) (2024-06-17)

Use consistent and accurate naming for Google Cloud Secret Manager and HashiCorp Vault.

* GCP Secret Manager and Google Cloud Secret Manager are both acceptable
* Google Secret Manager is not used
* "Secrets" plural is inaccurate, it's always "Secret"
* "HashiCorp", not "Hashicorp"

#### Modified

- https://docs.konghq.com/gateway/3.0.x/admin-api/#information-routes
- https://docs.konghq.com/gateway/3.0.x/admin-api/#health-routes
- https://docs.konghq.com/gateway/3.0.x/admin-api/#tags
- https://docs.konghq.com/gateway/3.0.x/admin-api/#service-object
- https://docs.konghq.com/gateway/3.0.x/admin-api/#route-object
- https://docs.konghq.com/gateway/3.0.x/admin-api/#consumer-object
- https://docs.konghq.com/gateway/3.0.x/admin-api/#plugin-object
- https://docs.konghq.com/gateway/3.0.x/admin-api/#certificate-object
- https://docs.konghq.com/gateway/3.0.x/admin-api/#ca-certificate-object
- https://docs.konghq.com/gateway/3.0.x/admin-api/#sni-object
- https://docs.konghq.com/gateway/3.0.x/admin-api/#upstream-object
- https://docs.konghq.com/gateway/3.0.x/admin-api/#target-object
- https://docs.konghq.com/gateway/3.0.x/admin-api/#vaults-object
- https://docs.konghq.com/gateway/3.1.x/admin-api/#information-routes
- https://docs.konghq.com/gateway/3.1.x/admin-api/#health-routes
- https://docs.konghq.com/gateway/3.1.x/admin-api/#tags
- https://docs.konghq.com/gateway/3.1.x/admin-api/#debug-routes
- https://docs.konghq.com/gateway/3.1.x/admin-api/#service-object
- https://docs.konghq.com/gateway/3.1.x/admin-api/#route-object
- https://docs.konghq.com/gateway/3.1.x/admin-api/#consumer-object
- https://docs.konghq.com/gateway/3.1.x/admin-api/#plugin-object
- https://docs.konghq.com/gateway/3.1.x/admin-api/#certificate-object
- https://docs.konghq.com/gateway/3.1.x/admin-api/#ca-certificate-object
- https://docs.konghq.com/gateway/3.1.x/admin-api/#sni-object
- https://docs.konghq.com/gateway/3.1.x/admin-api/#upstream-object
- https://docs.konghq.com/gateway/3.1.x/admin-api/#target-object
- https://docs.konghq.com/gateway/3.1.x/admin-api/#vaults-object
- https://docs.konghq.com/gateway/3.1.x/admin-api/#keys-object
- https://docs.konghq.com/gateway/3.2.x/admin-api/
- https://docs.konghq.com/gateway/3.2.x/admin-api/#information-routes
- https://docs.konghq.com/gateway/3.2.x/admin-api/#health-routes
- https://docs.konghq.com/gateway/3.2.x/admin-api/#tags
- https://docs.konghq.com/gateway/3.2.x/admin-api/#debug-routes
- https://docs.konghq.com/gateway/3.2.x/admin-api/#service-object
- https://docs.konghq.com/gateway/3.2.x/admin-api/#route-object
- https://docs.konghq.com/gateway/3.2.x/admin-api/#consumer-object
- https://docs.konghq.com/gateway/3.2.x/admin-api/#plugin-object
- https://docs.konghq.com/gateway/3.2.x/admin-api/#certificate-object
- https://docs.konghq.com/gateway/3.2.x/admin-api/#ca-certificate-object
- https://docs.konghq.com/gateway/3.2.x/admin-api/#sni-object
- https://docs.konghq.com/gateway/3.2.x/admin-api/#upstream-object
- https://docs.konghq.com/gateway/3.2.x/admin-api/#target-object
- https://docs.konghq.com/gateway/3.2.x/admin-api/#vaults-object
- https://docs.konghq.com/gateway/3.2.x/admin-api/#keys-object
- https://docs.konghq.com/gateway/3.3.x/admin-api/
- https://docs.konghq.com/gateway/3.3.x/admin-api/#information-routes
- https://docs.konghq.com/gateway/3.3.x/admin-api/#health-routes
- https://docs.konghq.com/gateway/3.3.x/admin-api/#tags
- https://docs.konghq.com/gateway/3.3.x/admin-api/#debug-routes
- https://docs.konghq.com/gateway/3.3.x/admin-api/#service-object
- https://docs.konghq.com/gateway/3.3.x/admin-api/#route-object
- https://docs.konghq.com/gateway/3.3.x/admin-api/#consumer-object
- https://docs.konghq.com/gateway/3.3.x/admin-api/#plugin-object
- https://docs.konghq.com/gateway/3.3.x/admin-api/#certificate-object
- https://docs.konghq.com/gateway/3.3.x/admin-api/#ca-certificate-object
- https://docs.konghq.com/gateway/3.3.x/admin-api/#sni-object
- https://docs.konghq.com/gateway/3.3.x/admin-api/#upstream-object
- https://docs.konghq.com/gateway/3.3.x/admin-api/#target-object
- https://docs.konghq.com/gateway/3.3.x/admin-api/#vaults-object
- https://docs.konghq.com/gateway/3.3.x/admin-api/#keys-object
- https://docs.konghq.com/gateway/3.4.x/admin-api/
- https://docs.konghq.com/gateway/3.4.x/admin-api/#information-routes
- https://docs.konghq.com/gateway/3.4.x/admin-api/#health-routes
- https://docs.konghq.com/gateway/3.4.x/admin-api/#tags
- https://docs.konghq.com/gateway/3.4.x/admin-api/#debug-routes
- https://docs.konghq.com/gateway/3.4.x/admin-api/#service-object
- https://docs.konghq.com/gateway/3.4.x/admin-api/#route-object
- https://docs.konghq.com/gateway/3.4.x/admin-api/#consumer-object
- https://docs.konghq.com/gateway/3.4.x/admin-api/#plugin-object
- https://docs.konghq.com/gateway/3.4.x/admin-api/#certificate-object
- https://docs.konghq.com/gateway/3.4.x/admin-api/#ca-certificate-object
- https://docs.konghq.com/gateway/3.4.x/admin-api/#sni-object
- https://docs.konghq.com/gateway/3.4.x/admin-api/#upstream-object
- https://docs.konghq.com/gateway/3.4.x/admin-api/#target-object
- https://docs.konghq.com/gateway/3.4.x/admin-api/#vaults-object
- https://docs.konghq.com/gateway/3.4.x/admin-api/#keys-object
- https://docs.konghq.com/gateway/3.4.x/admin-api/#filter-chain-object
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/
- https://docs.konghq.com/gateway/unreleased/kong-enterprise/
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/secrets-management/backends
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/secrets-management/backends
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/secrets-management/backends
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/secrets-management/backends
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/secrets-management/backends
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/backends
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/secrets-management/backends
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/secrets-management/backends
- https://docs.konghq.com/gateway/unreleased/kong-enterprise/secrets-management/backends
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/secrets-management/
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/secrets-management/
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/secrets-management/
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/secrets-management/
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/secrets-management/
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/secrets-management/
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/secrets-management/
- https://docs.konghq.com/gateway/unreleased/kong-enterprise/secrets-management/
- https://docs.konghq.com/gateway/2.8.x/admin-api/
- https://docs.konghq.com/gateway/2.8.x/plan-and-deploy/security/secrets-management/backends/gcp-sm
- https://docs.konghq.com/gateway/2.8.x/plan-and-deploy/security/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/2.8.x/plan-and-deploy/security/secrets-management/backends/
- https://docs.konghq.com/gateway/2.8.x/plan-and-deploy/security/secrets-management/
- https://docs.konghq.com/gateway/changelog
- https://docs.konghq.com/konnect/gateway-manager/configuration/vaults/

## Week 24


### [Add Konnect Terraform reference page](https://github.com/Kong/docs.konghq.com/pull/7500) (2024-06-13)

Add Terraform page for Konnect so that it shows up when searching for "Terraform" on the docs site.

Please run the Algolia indexer after merge

#### Added

- https://docs.konghq.com/konnect/reference/terraform


### [docs(kic): update rewrite-host guide with URLRewrite filter](https://github.com/Kong/docs.konghq.com/pull/7469) (2024-06-11)

Extends `Rewrite Host` guide with `URLRewrite` filter usage implemented in KIC 3.2.
 
Closes https://github.com/Kong/kubernetes-ingress-controller/issues/5853.

#### Modified

- https://docs.konghq.com/moved_urls.yml


### [Release: Gateway 3.4.3.9](https://github.com/Kong/docs.konghq.com/pull/7432) (2024-06-10)

Changelog and version bump for 3.4.3.9.

#### Modified

- https://docs.konghq.com/gateway/changelog

## Week 23

### [Fix: Typo in JWT mapping order and clarify behavior](https://github.com/Kong/docs.konghq.com/pull/7484) (2024-06-07)

The consumer mapping priority order for the plugin is supposed to include both access token and channel token, but instead just listed access tokens. 

Also clarifying some of the phrasing around mapping so that it doesn't appear to contradict itself

https://konghq.atlassian.net/browse/DOCU-3413

#### Modified

- https://docs.konghq.com/hub/kong-inc/jwt-signer/overview/


### [Noname fix performance benchmark url](https://github.com/Kong/docs.konghq.com/pull/7477) (2024-06-06)

Fixed a broken URL of the Noname documentation portal
 
#### Modified

- https://docs.konghq.com/hub/nonamesecurity/nonamesecurity-kongtrafficsource/overview/


### [Chore: Convert codeblock diagrams into mermaid format](https://github.com/Kong/docs.konghq.com/pull/7472) (2024-06-06)

Converting this:
<img width="808" alt="Screenshot 2024-06-05 at 4 16 10 PM" src="https://github.com/Kong/docs.konghq.com/assets/54370747/1c596492-91a3-46ee-881d-8e38729efcf1">

Into this:
<img width="740" alt="Screenshot 2024-06-05 at 4 16 36 PM" src="https://github.com/Kong/docs.konghq.com/assets/54370747/fffa64ad-8015-4877-a4e9-337930c5045d">

#### Modified

- https://docs.konghq.com/hub/kong-inc/websocket-size-limit/overview/
- https://docs.konghq.com/hub/kong-inc/websocket-validator/overview/


### [Release: decK 1.37 and 1.38](https://github.com/Kong/docs.konghq.com/pull/7466) (2024-06-05)

Bump deck versions, add new and missing cli flags.

Based on changelogs for 1.37 and and 1.38: https://github.com/Kong/deck/releases

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/tracing/
- https://docs.konghq.com/gateway/3.1.x/production/tracing/
- https://docs.konghq.com/gateway/3.2.x/production/tracing/
- https://docs.konghq.com/gateway/3.3.x/production/tracing/
- https://docs.konghq.com/gateway/3.4.x/production/tracing/
- https://docs.konghq.com/gateway/3.5.x/production/tracing/
- https://docs.konghq.com/gateway/3.6.x/production/tracing/
- https://docs.konghq.com/gateway/3.7.x/production/tracing/
- https://docs.konghq.com/gateway/unreleased/production/tracing/


### [fix(changelog): correct broken link](https://github.com/Kong/docs.konghq.com/pull/7461) (2024-06-04)

Corrects broken link to demonstrated proof-of-possession page in changelog.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [feat: Document Request ID in debugging, tracing, and logging](https://github.com/Kong/docs.konghq.com/pull/7441) (2024-06-05)

The Request ID feature was released in 3.5 and never documented. This PR adds information about it to the existing tracing, debugging, and logging docs.
DOCU-3853

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/tracing/
- https://docs.konghq.com/gateway/3.1.x/production/tracing/
- https://docs.konghq.com/gateway/3.2.x/production/tracing/
- https://docs.konghq.com/gateway/3.3.x/production/tracing/
- https://docs.konghq.com/gateway/3.4.x/production/tracing/
- https://docs.konghq.com/gateway/3.5.x/production/tracing/
- https://docs.konghq.com/gateway/3.6.x/production/tracing/
- https://docs.konghq.com/gateway/3.7.x/production/tracing/
- https://docs.konghq.com/gateway/unreleased/production/tracing/


### [Fixes reversed descriptions of post and put.](https://github.com/Kong/docs.konghq.com/pull/7428) (2024-06-04)

Fixed 'Update and insert ACL group names' and 'Update ACL groups by ID' being reversed.

#### Modified

- https://docs.konghq.com/hub/kong-inc/acl/


### [Feat: integrated markdown feature update](https://github.com/Kong/docs.konghq.com/pull/7405) (2024-06-04)

https://konghq.atlassian.net/browse/DOCU-3819
Update [Product Documentation - Kong Konnect | Kong Docs](https://docs.konghq.com/konnect/api-products/service-documentation/#interactive-markdown-renderer)  to include information about being able to start a document from the editor.

#### Modified

- https://docs.konghq.com/konnect/api-products/service-documentation
- https://docs.konghq.com/konnect/updates

## Week 22

### [Fix: remove inaccurate note about AppDynamics library](https://github.com/Kong/docs.konghq.com/pull/7443) (2024-05-30)

During testing, it was found that Kong Gateway will start without the library, and won't error out.

https://konghq.atlassian.net/browse/DOCU-3862

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/overview/


### [Update: Graphql proxy cache adv plugin API not supported in hybrid mode](https://github.com/Kong/docs.konghq.com/pull/7435) (2024-05-29)

Adding a note on API usage in hybrid mode for the graphql proxy cache plugin.

Addresses docs callout in KAG-4357.

#### Modified

- https://docs.konghq.com/hub/kong-inc/graphql-proxy-cache-advanced/
- https://docs.konghq.com/hub/kong-inc/graphql-proxy-cache-advanced/_metadata/_index.yml


### [Update: Telemetry FAQs for Konnect](https://github.com/Kong/docs.konghq.com/pull/7434) (2024-05-29)

Updating the Konnect network FAQ with Q&As about telemetry data communication between cp and dp.

https://konghq.atlassian.net/browse/DOCU-3859

#### Modified

- https://docs.konghq.com/konnect/analytics/
- https://docs.konghq.com/konnect/network-resiliency



### [chore: Convert remaining OIDC topic that uses httpie to curl](https://github.com/Kong/docs.konghq.com/pull/7422) (2024-05-29)

Converting HTTPie to curl. This topic was added in 3.6 and I ran out of time to convert it, so we just merged it.

#### Modified

- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/


### [chore: Changelog for 3.7.0.0](https://github.com/Kong/docs.konghq.com/pull/7411) (2024-05-29)

* Compile changelog for 3.7.
* Add changelogs to plugins.
* Add missing breaking change to 3.7 breaking changes doc.

https://konghq.atlassian.net/browse/DOCU-3797

#### Added

- https://docs.konghq.com/hub/kong-inc/graphql-proxy-cache-advanced/

#### Modified

- https://docs.konghq.com/hub/kong-inc/acme/
- https://docs.konghq.com/hub/kong-inc/ai-prompt-guard/
- https://docs.konghq.com/hub/kong-inc/ai-proxy/
- https://docs.konghq.com/hub/kong-inc/aws-lambda/
- https://docs.konghq.com/hub/kong-inc/degraphql/
- https://docs.konghq.com/hub/kong-inc/jwt-signer/
- https://docs.konghq.com/hub/kong-inc/jwt/
- https://docs.konghq.com/hub/kong-inc/key-auth/
- https://docs.konghq.com/hub/kong-inc/ldap-auth-advanced/
- https://docs.konghq.com/hub/kong-inc/mocking/
- https://docs.konghq.com/hub/kong-inc/mtls-auth/
- https://docs.konghq.com/hub/kong-inc/oas-validation/
- https://docs.konghq.com/hub/kong-inc/openid-connect/
- https://docs.konghq.com/hub/kong-inc/opentelemetry/
- https://docs.konghq.com/hub/kong-inc/prometheus/
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/
- https://docs.konghq.com/hub/kong-inc/rate-limiting/
- https://docs.konghq.com/hub/kong-inc/response-ratelimiting/
- https://docs.konghq.com/gateway/changelog


### [Fix: Unifiy Kong Manager and Kong Manager OSS sections in GW docs](https://github.com/Kong/docs.konghq.com/pull/7394) (2024-05-31)

Unify the two Kong Manager sections into one. 

Background request tracked on https://konghq.atlassian.net/browse/DOCU-3861

#### Modified

- https://docs.konghq.com/gateway/3.0.x/
- https://docs.konghq.com/gateway/3.1.x/
- https://docs.konghq.com/gateway/3.2.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/gateway/3.5.x/
- https://docs.konghq.com/gateway/3.6.x/
- https://docs.konghq.com/gateway/3.7.x/
- https://docs.konghq.com/gateway/3.0.x/kong-manager/
- https://docs.konghq.com/gateway/3.1.x/kong-manager/
- https://docs.konghq.com/gateway/3.2.x/kong-manager/
- https://docs.konghq.com/gateway/3.3.x/kong-manager/
- https://docs.konghq.com/gateway/3.4.x/kong-manager/
- https://docs.konghq.com/gateway/3.5.x/kong-manager/
- https://docs.konghq.com/gateway/3.6.x/kong-manager/
- https://docs.konghq.com/gateway/3.7.x/kong-manager/

## Week 21

### [chore: set version tags around table](https://github.com/Kong/docs.konghq.com/pull/7415) (2024-05-22)

Add version tags to plugin table, since streaming only appears in 3.7.

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy/overview/


### [Release: Gateway 3.5.0.4](https://github.com/Kong/docs.konghq.com/pull/7378) (2024-05-20)

Changelog, version bump, and remove 'unless' statements for 3.5

https://konghq.atlassian.net/browse/DOCU-3739

#### Modified

- https://docs.konghq.com/gateway/changelog


### [add content-type and body-validation explanation in _index.md](https://github.com/Kong/docs.konghq.com/pull/7348) (2024-05-22)

request-validation limitations are not listed anymore since 3.4 version. Adding them in the main page

https://github.com/Kong/docs.konghq.com/commit/b492d3ecb31e2335f37dfe361295c8bc545f2e85#diff-f88716a1e934cd881cb07ecb1cc41ebdcd62fd950aa0e821603755e1a8caa2d4

New feature in 3.6 to perform body validation on +json content-types.

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-validator/overview/


### [Feat: AI Azure Content Safety plugin doc](https://github.com/Kong/docs.konghq.com/pull/7326) (2024-05-21)

Docs for new AI Azure Content Safety plugin.

https://konghq.atlassian.net/browse/DOCU-3767

#### Added

- https://docs.konghq.com/hub/kong-inc/ai-azure-content-safety/
- https://docs.konghq.com/hub/kong-inc/ai-azure-content-safety/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/ai-azure-content-safety/how-to/
- https://docs.konghq.com/hub/kong-inc/ai-azure-content-safety/overview/
- https://docs.konghq.com/hub/kong-inc/ai-azure-content-safety/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_ai-azure-content-safety.png

## Week 20

### [feat(ai-proxy): added Azure native auth explanation](https://github.com/Kong/docs.konghq.com/pull/7390) (2024-05-16)

I have added an explanation on how to use [Azure Managed Identity](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/managed-identity) authentication when using the Kong AI Proxy within the Azure SaaS.

#### Added

- https://docs.konghq.com/hub/kong-inc/ai-proxy/how-to/


### [chore: Set source URLs for moved EE plugins](https://github.com/Kong/docs.konghq.com/pull/7386) (2024-05-17)

A bunch of EE plugins were moved to a new directory, breaking the "Edit this page" links on their schema config reference pages. This PR adds a source_url to each moved plugin to use as the link for editing.

https://konghq.atlassian.net/browse/DOCU-3841

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/canary/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/degraphql/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/exit-transformer/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/forward-proxy/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/graphql-proxy-cache-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/jq/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/jwe-decrypt/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/key-auth-enc/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/mocking/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/oauth2-introspection/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/response-transformer-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/route-by-header/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/route-transformer-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/statsd-advanced/_metadata/_2.6.x.yml
- https://docs.konghq.com/hub/kong-inc/statsd-advanced/_metadata/_2.7.x.yml
- https://docs.konghq.com/hub/kong-inc/statsd-advanced/_metadata/_2.8.x.yml
- https://docs.konghq.com/hub/kong-inc/statsd-advanced/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/tls-handshake-modifier/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/tls-metadata-headers/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/upstream-timeout/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/websocket-size-limit/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/websocket-validator/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/xml-threat-protection/_metadata/_index.yml


### [Release: Gateway 3.4.3.8](https://github.com/Kong/docs.konghq.com/pull/7379) (2024-05-16)

Changelog and version bump for 3.4.3.8

Schema update will come separately.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.6.1.4](https://github.com/Kong/docs.konghq.com/pull/7377) (2024-05-15)

Changelog and version bump for 3.6.1.4

https://konghq.atlassian.net/browse/DOCU-3842

#### Modified

- https://docs.konghq.com/gateway/changelog


### [request-termination and forward-proxy incompatibility](https://github.com/Kong/docs.konghq.com/pull/7358) (2024-05-15)

Clarification: the plugin won't execute if if forward-proxy is enabled (valid for all versions)
Jira: https://konghq.atlassian.net/browse/FTI-5909
Kong idea reported to review the plugin priority: https://kong-internal-portal.ideas.aha.io/ideas/GTWY-I-886

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-termination/overview/


### [docs(oidc): supporting dpop](https://github.com/Kong/docs.konghq.com/pull/7323) (2024-05-15)

KAG-4377

New feature support.

https://github.com/Kong/kong-ee/pull/8482

#### Added

- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/

#### Modified

- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/

## Week 19

### [Remove duplicated entry](https://github.com/Kong/docs.konghq.com/pull/7361) (2024-05-10)

`control_plane` was listed twice.

#### Modified

- https://docs.konghq.com/konnect/reference/search


### [(fix) Remove "enterprise" category from Datadome](https://github.com/Kong/docs.konghq.com/pull/7350) (2024-05-07)

Based on review w/ @DaniellaFreese and Eric, this plugin doesn't qualify as Enterprise based on the revised categorization set at end of last year. 

#### Modified

- https://docs.konghq.com/hub/datadome/kong-plugin-datadome/_metadata/_index.yml


### [Plugins troubleshooting](https://github.com/Kong/docs.konghq.com/pull/7290) (2024-05-07)

#### Added

- https://docs.konghq.com/assets/images/icons/hub-layout/icn-troubleshooting.svg


### [feat: add OCI plugin distribution docs](https://github.com/Kong/docs.konghq.com/pull/7245) (2024-05-07)

Added docs around using an OCI registry and OSS tooling to sign and distribute custom plugins.

#### Modified

- https://docs.konghq.com/gateway/3.1.x/plugin-development/pdk/kong.jwe
- https://docs.konghq.com/gateway/3.2.x/plugin-development/pdk/kong.jwe
- https://docs.konghq.com/gateway/3.3.x/plugin-development/pdk/kong.jwe
- https://docs.konghq.com/gateway/3.4.x/plugin-development/pdk/kong.jwe
- https://docs.konghq.com/gateway/3.5.x/plugin-development/pdk/kong.jwe
- https://docs.konghq.com/gateway/3.6.x/plugin-development/pdk/kong.jwe
- https://docs.konghq.com/gateway/unreleased/plugin-development/pdk/kong.jwe

## Week 18

### [chore: Add links to graphql paper](https://github.com/Kong/docs.konghq.com/pull/7340) (2024-05-03)

Adding links to Kong with GraphQL ebook to make it more discoverable: https://konghq.com/solutions/api-management-graphql

#### Modified

- https://docs.konghq.com/hub/kong-inc/graphql-proxy-cache-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/graphql-proxy-cache-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/overview/


### [Chore: Generate 3.7 kong.conf reference](https://github.com/Kong/docs.konghq.com/pull/7336) (2024-05-03)

https://konghq.atlassian.net/browse/DOCU-3804

#### Added

- https://docs.konghq.com/gateway-operator/1.2.x/guides/autoscaling-kong/
- https://docs.konghq.com/gateway-operator/unreleased/guides/autoscaling-kong/


### [chore: Add 3.7 support tabs/pages and fix typo](https://github.com/Kong/docs.konghq.com/pull/7333) (2024-05-03)

Update support pages for 3.7.

https://konghq.atlassian.net/browse/DOCU-3800

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/security/plugin-secrets
- https://docs.konghq.com/kubernetes-ingress-controller/3.1.x/guides/security/plugin-secrets
- https://docs.konghq.com/kubernetes-ingress-controller/unreleased/guides/security/plugin-secrets
- https://docs.konghq.com/gateway-operator/1.2.x/guides/autoscaling-kong/
- https://docs.konghq.com/gateway-operator/unreleased/guides/autoscaling-kong/


### [Add paragraph to explain queue parameter scope](https://github.com/Kong/docs.konghq.com/pull/7331) (2024-05-02)

Explicitly mention that queue parameters are scoped to one worker in the Queueing section of plugins that use queues.

#### Modified

- https://docs.konghq.com/hub/kong-inc/datadog/overview/
- https://docs.konghq.com/hub/kong-inc/http-log/overview/
- https://docs.konghq.com/hub/kong-inc/opentelemetry/overview/
- https://docs.konghq.com/hub/kong-inc/statsd/overview/
- https://docs.konghq.com/hub/kong-inc/zipkin/overview/
- https://docs.konghq.com/gateway-operator/1.2.x/guides/autoscaling-kong/
- https://docs.konghq.com/gateway-operator/unreleased/guides/autoscaling-kong/


### [Improved readability and detatched some commands from their output](https://github.com/Kong/docs.konghq.com/pull/7324) (2024-05-01)

I improved the readability of some commands separating their outputs, facilitating user copy-paste flow when trying out when trying the autoscaling setup, clarified the k6s installation is required before running the command and its javascript test.

#### Modified

- https://docs.konghq.com/gateway-operator/1.2.x/guides/autoscaling-kong/
- https://docs.konghq.com/gateway-operator/unreleased/guides/autoscaling-kong/


### [Fix guide docs about using configPatches](https://github.com/Kong/docs.konghq.com/pull/7320) (2024-04-29)

<!-- What did you change and why? -->
 
<!-- Include any supporting resources, e.g. link to a Jira ticket, GH issue, FTI, Slack, Aha, etc. -->

Fix instructions in the guide page of uing `configPatch`es in plugins.
Docs part of https://github.com/Kong/kubernetes-ingress-controller/issues/5687.

#### Modified

- https://docs.konghq.com/gateway-operator/1.2.x/guides/autoscaling-kong/
- https://docs.konghq.com/gateway-operator/unreleased/guides/autoscaling-kong/


### [Fix typos under app/](https://github.com/Kong/docs.konghq.com/pull/7317) (2024-05-01)

Fix tons of typos under `app/` directory.

Some backgrounds on how theses typos are fixed, I've wrote a (Chinese) blog about this: https://nova.moe/fast-typo-fix/ (English version: https://nova.moe/fast-typo-fix-en/) 😇

#### Modified

- https://docs.konghq.com/hub/kong-inc/post-function/how-to/
- https://docs.konghq.com/gateway-operator/1.1.x/production/monitoring/status/gateway/
- https://docs.konghq.com/gateway-operator/1.2.x/production/monitoring/status/gateway/
- https://docs.konghq.com/gateway-operator/unreleased/production/monitoring/status/gateway/
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/reference/required-permissions
- https://docs.konghq.com/kubernetes-ingress-controller/3.1.x/reference/required-permissions
- https://docs.konghq.com/kubernetes-ingress-controller/unreleased/reference/required-permissions
- https://docs.konghq.com/api/identity.yaml
- https://docs.konghq.com/assets/mesh/2.1.x/raw/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/assets/mesh/2.2.x/raw/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/assets/mesh/2.3.x/raw/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/assets/mesh/2.3.x/raw/kuma-cp.yaml
- https://docs.konghq.com/assets/mesh/2.4.x/raw/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/assets/mesh/2.4.x/raw/kuma-cp.yaml
- https://docs.konghq.com/assets/mesh/2.5.x/raw/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/assets/mesh/2.5.x/raw/kuma-cp.yaml
- https://docs.konghq.com/assets/mesh/2.6.x/raw/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/assets/mesh/2.6.x/raw/kuma-cp.yaml
- https://docs.konghq.com/assets/mesh/2.7.x/raw/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/assets/mesh/2.7.x/raw/kuma-cp.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/kuma-cp.yaml
- https://docs.konghq.com/assets/mesh/raw/CHANGELOG
- https://docs.konghq.com/gateway/2.6.x/plugin-development/custom-entities
- https://docs.konghq.com/gateway/2.6.x/reference/configuration
- https://docs.konghq.com/gateway/2.7.x/reference/configuration
- https://docs.konghq.com/gateway/2.7.x/reference/rate-limiting
- https://docs.konghq.com/gateway/2.8.x/plugin-development/custom-entities
- https://docs.konghq.com/gateway/2.8.x/reference/configuration
- https://docs.konghq.com/gateway/2.8.x/reference/rate-limiting
- https://docs.konghq.com/gateway/changelog


### [Update Konnect API links to point to latest](https://github.com/Kong/docs.konghq.com/pull/7313) (2024-04-29)

Some links in our konnect docs point explicitly to v2 of various APIs, when they should be pointing to `latest` to remain evergreen. The only API where this is currently an issue is the identity API, as the latest version is now v3. Updating all versioned links to avoid this issue in the future.

Issue reported on slack.

#### Modified

- https://docs.konghq.com/konnect/api/identity-management/identity-integration
- https://docs.konghq.com/konnect/dev-portal/customization/
- https://docs.konghq.com/konnect/dev-portal/customization/netlify
- https://docs.konghq.com/konnect/dev-portal/customization/self-hosted-portal
- https://docs.konghq.com/konnect/gateway-manager/
- https://docs.konghq.com/konnect/org-management/audit-logging/
- https://docs.konghq.com/konnect/org-management/audit-logging/reference
- https://docs.konghq.com/konnect/org-management/audit-logging/replay-job
- https://docs.konghq.com/konnect/org-management/audit-logging/webhook
- https://docs.konghq.com/konnect/org-management/system-accounts
- https://docs.konghq.com/konnect/updates


### [feat(gateway/oas-validation): OpenAPI 3.1.0 documentation](https://github.com/Kong/docs.konghq.com/pull/7310) (2024-05-03)

Update document for OAS-Validation plugin about OpenAPI 3.1.0

#### Modified

- https://docs.konghq.com/hub/kong-inc/oas-validation/overview/


### [Feat: new expressions flavor in 3.7](https://github.com/Kong/docs.konghq.com/pull/7304) (2024-04-30)

KAG-3927

#### Modified

- https://docs.konghq.com/gateway-operator/1.2.x/guides/autoscaling-kong/
- https://docs.konghq.com/gateway-operator/unreleased/guides/autoscaling-kong/


### [Chore: Split AI Gateway into its own section](https://github.com/Kong/docs.konghq.com/pull/7274) (2024-05-01)

Splitting AI gateway into its own nav section to make it more prominent. 

This is a 3.7 ticket, but it really also applies to 3.6, so making the change in both.

https://konghq.atlassian.net/browse/DOCU-3792

#### Added

- https://docs.konghq.com/assets/images/icons/documentation/icn-ai.svg

#### Modified

- https://docs.konghq.com/gateway/3.6.x/get-started/ai-gateway/
- https://docs.konghq.com/gateway/unreleased/get-started/ai-gateway/


### [feat(openid-connect): fapi docs](https://github.com/Kong/docs.konghq.com/pull/7236) (2024-05-03)

This PR adds a page to summarize/link all the FAPI-related features that the OpenID Connect plugin provides.

https://konghq.atlassian.net/browse/DOCU-3627

#### Added

- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/

## Week 17

### [Fix multiple typos under app/_src/gateway](https://github.com/Kong/docs.konghq.com/pull/7312) (2024-04-26)

Fix multiple typos under app/_src/gateway
 
#### Modified

- https://docs.konghq.com/gateway/3.1.x/breaking-changes/30x/
- https://docs.konghq.com/gateway/3.2.x/breaking-changes/30x/
- https://docs.konghq.com/gateway/3.3.x/breaking-changes/30x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/30x/
- https://docs.konghq.com/gateway/3.5.x/breaking-changes/30x/
- https://docs.konghq.com/gateway/3.6.x/breaking-changes/30x/
- https://docs.konghq.com/gateway/3.7.x/breaking-changes/30x/
- https://docs.konghq.com/gateway/3.0.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.1.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.2.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.3.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.4.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.5.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.6.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.7.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.0.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.1.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.2.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.3.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.4.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.5.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.6.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.7.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/mesh/2.0.x/install/
- https://docs.konghq.com/mesh/2.1.x/install/
- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.6.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.7.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.0.x/production/tracing/api
- https://docs.konghq.com/gateway/3.1.x/production/tracing/api
- https://docs.konghq.com/gateway/3.2.x/production/tracing/api
- https://docs.konghq.com/gateway/3.3.x/production/tracing/api
- https://docs.konghq.com/gateway/3.4.x/production/tracing/api
- https://docs.konghq.com/gateway/3.5.x/production/tracing/api
- https://docs.konghq.com/gateway/3.6.x/production/tracing/api
- https://docs.konghq.com/gateway/3.7.x/production/tracing/api
- https://docs.konghq.com/gateway/3.0.x/reference/rate-limiting/
- https://docs.konghq.com/gateway/3.1.x/reference/rate-limiting/
- https://docs.konghq.com/gateway/3.2.x/reference/rate-limiting/
- https://docs.konghq.com/gateway/3.3.x/reference/rate-limiting/
- https://docs.konghq.com/gateway/3.4.x/reference/rate-limiting/
- https://docs.konghq.com/gateway/3.5.x/reference/rate-limiting/
- https://docs.konghq.com/gateway/3.6.x/reference/rate-limiting/
- https://docs.konghq.com/gateway/3.7.x/reference/rate-limiting/
- https://docs.konghq.com/gateway/3.0.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.1.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.2.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.3.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.4.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.5.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.6.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.7.x/upgrade/backup-and-restore/


### [Fix multiple typos under app/konnect directory](https://github.com/Kong/docs.konghq.com/pull/7311) (2024-04-26)

Fixed multiple typos under app/konnect directory

* stratgies -> strategies
* trasparent -> transparent
* mutliple -> multiple

#### Modified

- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/auth0
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/azure
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/curity
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/okta
- https://docs.konghq.com/konnect/gateway-manager/troubleshoot
- https://docs.konghq.com/konnect/updates


### [Add Kong 3.6.x to the list of supported versions by the Noname Security plugin.](https://github.com/Kong/docs.konghq.com/pull/7303) (2024-04-25)

Added Kong 3.6.x to the list of supported versions by the Noname Security plugin.

#### Modified

- https://docs.konghq.com/hub/nonamesecurity/nonamesecurity-kongtrafficsource/_metadata/_index.yml


### [chore(kgo): KGO 1.2.3](https://github.com/Kong/docs.konghq.com/pull/7298) (2024-04-26)

Adding KGO 1.2.3 changelog

- https://github.com/Kong/gateway-operator/blob/main/CHANGELOG.md#v123
- https://github.com/Kong/gateway-operator-enterprise/blob/main/CHANGELOG.md#v123

Closes https://github.com/Kong/gateway-operator-enterprise/issues/124

#### Modified

- https://docs.konghq.com/gateway-operator/changelog


### [Release: Gateway 3.4.3.7](https://github.com/Kong/docs.konghq.com/pull/7287) (2024-04-23)

Changelog and version bump for Gateway 3.4.3.7.

Also merge https://github.com/Kong/docs.konghq.com/pull/7120 when this goes out.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Fix: update docker logo on Mesh docs](https://github.com/Kong/docs.konghq.com/pull/7285) (2024-04-22)

Fixing broken link test failure: https://github.com/Kong/docs.konghq.com/actions/runs/8768698057/job/24063340313

The old docker logo was deleted but the Mesh install page is still pointing to it. Changing it to use the latest docker logo instead.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.6.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.7.x/production/deployment-topologies/hybrid-mode/setup


### [Changed from: Any to from: All](https://github.com/Kong/docs.konghq.com/pull/7278) (2024-04-22)

"Any" is not a valid value, it should be "All":
spec.listeners[0].allowedRoutes.namespaces.from: Unsupported value: "Any": supported values: "All", "Selector", "Same", <nil>

Fixed an apparent mistake in the docs where it said "Any", but meant "All"
 

#### Modified

- https://docs.konghq.com/gateway/3.0.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.1.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.2.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.3.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.4.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.5.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.6.x/plugin-development/pdk/kong.tracing
- https://docs.konghq.com/gateway/3.7.x/plugin-development/pdk/kong.tracing

## Week 16

### [Chore: LTS labels](https://github.com/Kong/docs.konghq.com/pull/7269) (2024-04-19)

Label LTS versions in the navigation to make them easier to identify: 
<img width="286" alt="Screenshot 2024-04-19 at 9 45 38 AM" src="https://github.com/Kong/docs.konghq.com/assets/54370747/ae9fce57-fd58-49f7-aaff-896a524c69b3">

And adjust heading levels on the support page. The LTS section needed a heading to make it easier to find, both visually and via search; had to fix nesting to make that work.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.1.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.2.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.3.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.4.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.5.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.6.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.7.x/get-started/proxy-caching


### [fix: Add two missing OTEL images to Kong Mesh docs](https://github.com/Kong/docs.konghq.com/pull/7268) (2024-04-19)

There were two missing images from a Kuma doc that was shared in Kong Mesh. The link checker caught one (https://github.com/Kong/docs.konghq.com/actions/runs/8677190800/job/23792517751), but I added both to our site.
 
#### Added

- https://docs.konghq.com/assets/images/guides/otel-metrics/grafana-dataplane-view.png
- https://docs.konghq.com/assets/images/guides/otel-metrics/prometheus_otel_source.png


### [Fix: Broken ordered list in getting started guide](https://github.com/Kong/docs.konghq.com/pull/7260) (2024-04-18)

Fixing broken ordered list and putting the sections into tabs for better flow:

<img width="1062" alt="Screenshot 2024-04-18 at 2 02 59 PM" src="https://github.com/Kong/docs.konghq.com/assets/54370747/243a76cf-3243-4cf9-b772-6ab4a968c10a">

#### Modified

- https://docs.konghq.com/gateway/3.0.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.1.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.2.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.3.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.4.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.5.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.6.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.7.x/get-started/proxy-caching


### [Get Started: httpbin.org doesn't return a content-type charset](https://github.com/Kong/docs.konghq.com/pull/7258) (2024-04-18)

Fix proxy caching getting started guide after the move from mockbin to httpbin

#### Modified

- https://docs.konghq.com/gateway/3.0.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.1.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.2.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.3.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.4.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.5.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.6.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.7.x/get-started/proxy-caching


### [Release: Gateway 2.8.4.9](https://github.com/Kong/docs.konghq.com/pull/7257) (2024-04-19)

Version bump and changelog for 2.8.4.9.

"_Backported from 3.7.0.0_ " is commented out because that version isn't out yet.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [(fix) upload current docker logos](https://github.com/Kong/docs.konghq.com/pull/7256) (2024-04-18)

Replacing Docker logos w/ most current version from https://www.docker.com/company/newsroom/media-resources/. Changed icon is one shade of blue not multiple. 


### [docs(*): add a deprecated message to granular tracing](https://github.com/Kong/docs.konghq.com/pull/7254) (2024-04-18)

This is for `3.7.0.0` release.

The Granular Tracing is removed from `3.7.0.0` onward. Add a warning message to docs. See https://github.com/Kong/kong-ee/pull/8669 and https://konghq.atlassian.net/browse/KAG-2713.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.1.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.2.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.3.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.4.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.5.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.6.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.7.x/get-started/proxy-caching


### [Fix: Upstream URL for llama2 completion example](https://github.com/Kong/docs.konghq.com/pull/7242) (2024-04-16)

The example provided in the curl command references the ollama endpoint, http://ollama-server.local:11434/v1/chat, which returns a 404.

Per the docs (referenced earlier on this page), the correct endpoint should be /api/chat which I can confirm works.

https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-chat-completion

example:

$ curl localhost:11434/api/generate -d '{ "model": "llama2", "prompt":"Why does Kong make the best gateway?", "stream":false }' -i
HTTP/1.1 200 OK

$ curl localhost:11434/v1/generate -d '{ "model": "llama2", "prompt":"Why does Kong make the best gateway?", stream":false  }' -i
HTTP/1.1 404 Not Found
Content-Type: text/plain
Date: Tue, 16 Apr 2024 01:56:56 GMT

404 page not found

#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy/how-to/


### [Make Docker page show all available base images](https://github.com/Kong/docs.konghq.com/pull/7239) (2024-04-15)

Switch /install page to point to our Docker installation docs

#### Modified

- https://docs.konghq.com/gateway/3.0.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.1.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.2.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.3.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.4.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.5.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.6.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.7.x/get-started/proxy-caching


### [Fix: Session plugin missing links and minor cleanup](https://github.com/Kong/docs.konghq.com/pull/7227) (2024-04-16)

Fixing a couple of undefined anchor links in the Session plugin. 
Ended up cleaning up a bit of grammar/style/punctuation as well.

#### Modified

- https://docs.konghq.com/hub/kong-inc/session/overview/


### [Fix -correct conflict statement in debug-request.md](https://github.com/Kong/docs.konghq.com/pull/7225) (2024-04-16)

We found conflicting statements which need to be fixed.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.1.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.2.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.3.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.4.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.5.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.6.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.7.x/get-started/proxy-caching


### [Release: Gateway 3.4.3.6](https://github.com/Kong/docs.konghq.com/pull/7220) (2024-04-16)

Changelog and version bump for 3.4.3.6

Trying out a method to label backported items. 

https://konghq.atlassian.net/browse/DOCU-3757

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Gateway 3.6.1.3](https://github.com/Kong/docs.konghq.com/pull/7219) (2024-04-17)

Changelog and version bump for gateway 3.6.1.3.

No ticket, this is an ad hoc patch.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [feat: change path to `v1/messages` api for anthropic](https://github.com/Kong/docs.konghq.com/pull/7218) (2024-04-17)

Anthropic released a new `messages` API, we change the `chat` route_type of Anthropic to the new `messages` API correspondingly. 
This new feature is about to be released in 3.7.0.0, the doc should be updated simultaneously.
The sister [PR](https://github.com/Kong/kong-ee/pull/8747) for kong-ee has already been merged.
#### Modified

- https://docs.konghq.com/hub/kong-inc/ai-proxy/overview/


### [chore: fix request transformer changelog links](https://github.com/Kong/docs.konghq.com/pull/7201) (2024-04-16)

Fixes broken links in request transformer changelog.

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/
- https://docs.konghq.com/hub/kong-inc/request-transformer/


### [Feat: Gateway landing page layout updates](https://github.com/Kong/docs.konghq.com/pull/7187) (2024-04-17)

Updating the tiles on the gateway landing page.
https://konghq.atlassian.net/browse/DOCU-3743

#### Added

- https://docs.konghq.com/assets/images/icons/kong-gradient.svg
- https://docs.konghq.com/assets/images/icons/konnect/runtimes.svg
- https://docs.konghq.com/assets/images/icons/recommend-badge.svg
- https://docs.konghq.com/assets/images/icons/third-party/docker.svg

#### Modified

- https://docs.konghq.com/gateway/3.0.x/
- https://docs.konghq.com/gateway/3.1.x/
- https://docs.konghq.com/gateway/3.2.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/gateway/3.5.x/
- https://docs.konghq.com/gateway/3.6.x/
- https://docs.konghq.com/gateway/3.7.x/


### [feat(portal): describe developer auto approval behavior when using SSO login](https://github.com/Kong/docs.konghq.com/pull/7184) (2024-04-17)

- Describe developer auto approval behavior when using SSO login
- Change Konnect catalog to Dev Portal catalog in SSO login instructions

#### Modified

- https://docs.konghq.com/konnect/dev-portal/access-and-approval/auto-approve-devs-apps
- https://docs.konghq.com/konnect/dev-portal/dev-reg


### [feat(plugins): tracing headers propagation](https://github.com/Kong/docs.konghq.com/pull/7161) (2024-04-19)

Documentation for the new (3.7.0.0+) tracing headers propagation module, available to the OpenTelemetry and Zipkin plugins.

#### Modified

- https://docs.konghq.com/hub/kong-inc/opentelemetry/overview/
- https://docs.konghq.com/hub/kong-inc/zipkin/overview/


### [plugins(jwt): support more algorithms](https://github.com/Kong/docs.konghq.com/pull/7160) (2024-04-18)

Update docs to reflect recent changes in the JWT plugins.

Added support for:
* ES512
* PS256
* PS384
* PS512
* EdDSA

Jira: https://konghq.atlassian.net/browse/KAG-4029

#### Modified

- https://docs.konghq.com/hub/kong-inc/jwt/overview/


### [Feat: Cloud Gateways Documentation](https://github.com/Kong/docs.konghq.com/pull/7097) (2024-04-16)

Cloud Gateways: 
https://konghq.atlassian.net/browse/DOCU-3686

[Preview](https://deploy-preview-7097--kongdocs.netlify.app/konnect/)
**Ready for review**
[Overview Page](https://deploy-preview-7097--kongdocs.netlify.app/konnect/gateway-manager/dedicated-cloud-gateways/)
[Networking and Peering information](https://deploy-preview-7097--kongdocs.netlify.app/konnect/network-resiliency/#how-does-network-peering-work-with-dedicated-cloud-gateway-nodes)
[Supported regions](https://deploy-preview-7097--kongdocs.netlify.app/konnect/geo/#dedicated-cloud-gateways)
[Transit Gateways](https://deploy-preview-7097--kongdocs.netlify.app/konnect/gateway-manager/data-plane-nodes/transit-gateways/)
[How to upgrade data planes](https://deploy-preview-7097--kongdocs.netlify.app/konnect/gateway-manager/data-plane-nodes/upgrade/)
[Custom Domains](https://deploy-preview-7097--kongdocs.netlify.app/konnect/reference/custom-dns/)
[How to use CGW](https://deploy-preview-7097--kongdocs.netlify.app/konnect/gateway-manager/provision-cloud-gateway/)
[Diagrams]()
[API Spec]()


-----
- [x] [Overview Page + change log](https://github.com/Kong/docs.konghq.com/pull/7084) 
- [x] [Terminology updates](https://github.com/Kong/docs.konghq.com/pull/7093)
- [x] [Networking and Peering Information](https://github.com/Kong/docs.konghq.com/pull/7092)
- [x] [New Supported AWS regions](https://github.com/Kong/docs.konghq.com/pull/7110)
- [x] [Transit gateways](https://github.com/Kong/docs.konghq.com/pull/7151)
- [x] [Updates to getting started docs](https://github.com/Kong/docs.konghq.com/pull/7151)
- [x] [How to upgrade data plane nodes](https://github.com/Kong/docs.konghq.com/pull/7155)
- [x] [CGW Operations](https://github.com/Kong/docs.konghq.com/pull/7156)
- [x] [Custom DNS](https://github.com/Kong/docs.konghq.com/pull/7163)
- [x] Diagrams
- [x] [API Spec](https://github.com/Kong/docs.konghq.com/pull/7207)

Preview Link: https://deploy-preview-7097--kongdocs.netlify.app/konnect/

#### Added

- https://docs.konghq.com/assets/images/icons/third-party/aws-transit-gateway-attachment.svg
- https://docs.konghq.com/assets/images/icons/third-party/aws-transit-gateway.svg
- https://docs.konghq.com/assets/images/products/konnect/gateway-manager/konnect-control-plane-cloud-gateway-wizard.png
- https://docs.konghq.com/assets/images/products/konnect/gateway-manager/konnect-control-plane-cloud-gateway.png
- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/transit-gateways
- https://docs.konghq.com/konnect/gateway-manager/dedicated-cloud-gateways
- https://docs.konghq.com/konnect/gateway-manager/provision-cloud-gateway
- https://docs.konghq.com/konnect/reference/custom-dns

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/aws-lambda/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/file-log/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/prometheus/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/syslog/_metadata/_index.yml
- https://docs.konghq.com/assets/images/products/konnect/gateway-manager/konnect-control-planes-example.png
- https://docs.konghq.com/assets/images/products/konnect/konnect-intro.png
- https://docs.konghq.com/hub/plugins/compatibility/
- https://docs.konghq.com/konnect/compatibility
- https://docs.konghq.com/konnect/dev-portal/customization/
- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/
- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/upgrade
- https://docs.konghq.com/konnect/gateway-manager/
- https://docs.konghq.com/konnect/gateway-manager/plugins/add-custom-plugin
- https://docs.konghq.com/konnect/gateway-manager/plugins/
- https://docs.konghq.com/konnect/gateway-manager/troubleshoot
- https://docs.konghq.com/konnect/geo
- https://docs.konghq.com/konnect/getting-started/
- https://docs.konghq.com/konnect/
- https://docs.konghq.com/konnect/network-resiliency
- https://docs.konghq.com/konnect/updates

## Week 15

### [kic: add section about events for cluster scoped resources](https://github.com/Kong/docs.konghq.com/pull/7203) (2024-04-12)

Adds a section about Events for cluster scoped resources

Relevant KIC issue: https://github.com/Kong/kubernetes-ingress-controller/issues/5847

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/production/observability/events
- https://docs.konghq.com/kubernetes-ingress-controller/3.1.x/production/observability/events
- https://docs.konghq.com/kubernetes-ingress-controller/3.2.x/production/observability/events


### [Update: Licensing Admin API updates and Troubleshooting section links](https://github.com/Kong/docs.konghq.com/pull/7174) (2024-04-09)

* Added notes about restarting the Kong Gateway nodes/service when updating a license.
* Linked the Troubleshooting documentation from Overview page on the Deploy page.

Added because this was an occasional issue with customers after updating a license where they kept seeing warnings in the logs and Kong Manager UI about an expiring license after updating it.

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/
- https://docs.konghq.com/kubernetes-ingress-controller/3.1.x/
- https://docs.konghq.com/kubernetes-ingress-controller/3.2.x/


### [Release: Gateway 3.6.1.2](https://github.com/Kong/docs.konghq.com/pull/7170) (2024-04-08)

Changelog and version bump for Gateway 3.6.1.2.

There are no kong.conf updates.

https://konghq.atlassian.net/browse/DOCU-3756

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Update Gateway install page](https://github.com/Kong/docs.konghq.com/pull/7157) (2024-04-11)

Related [Jira ticket](https://konghq.atlassian.net/browse/DOCU-3744)

Update Gateway's install page.

Note: The `on this page` section isn't rendered because it parses the `headings` on the page and creates the list out of those which we no longer have with the table.

#### Modified

- https://docs.konghq.com/gateway/3.2.x/support/browser
- https://docs.konghq.com/gateway/3.3.x/support/browser
- https://docs.konghq.com/gateway/3.4.x/support/browser
- https://docs.konghq.com/gateway/3.5.x/support/browser
- https://docs.konghq.com/gateway/3.6.x/support/browser
- https://docs.konghq.com/gateway/3.7.x/support/browser
- https://docs.konghq.com/gateway/3.0.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.1.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.2.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.3.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.4.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.5.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.6.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.7.x/install/kubernetes/proxy/
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/install/helm
- https://docs.konghq.com/kubernetes-ingress-controller/3.1.x/install/helm
- https://docs.konghq.com/kubernetes-ingress-controller/3.2.x/install/helm


## Week 14


### [Feat: Interactive markdown renderer](https://github.com/Kong/docs.konghq.com/pull/7140) (2024-04-03)

https://konghq.atlassian.net/browse/DOCU-3620

* Adds docs for interactive markdown renderer. 
* Renames `Manage API Product Documentation` -> `Product Documentation` in navigation bar
* Updates and replaces screenshots
* Does not update shotscraper script this will be a fast follow. 
* adds changelog


https://deploy-preview-7140--kongdocs.netlify.app/

#### Added

- https://docs.konghq.com/assets/images/products/konnect/changelog/konnect-interactive-markdown.png

#### Modified

- https://docs.konghq.com/assets/images/products/konnect/api-products/konnect_service_docs_description.png
- https://docs.konghq.com/konnect/api-products/
- https://docs.konghq.com/konnect/api-products/service-documentation
- https://docs.konghq.com/konnect/dev-portal/
- https://docs.konghq.com/konnect/updates


### [Add gateway image build provenance verification docs](https://github.com/Kong/docs.konghq.com/pull/7067) (2024-04-01)

These are the customer-facing docs needed to allow customers to take full advantage of the recent changes to the Kong Enterprise build that implement SLSA build provenance and verification for only container images

Confluence: [Solutions Document](https://konghq.atlassian.net/wiki/spaces/KS/pages/3309273092/Solution+-+Container+Provenance+-+SLSA+generator)
Jira: [SEC-973](https://konghq.atlassian.net/browse/SEC-1003)
https://github.com/Kong/kong-ee/pull/7179

#### Added

- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/provenance-verification
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/provenance-verification

## Week 13

### [style(gateway/expressions-language): fix incorrect formatting](https://github.com/Kong/docs.konghq.com/pull/7143) (2024-03-27)

Bad format: 


#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/tracing/api
- https://docs.konghq.com/gateway/3.1.x/production/tracing/api
- https://docs.konghq.com/gateway/3.2.x/production/tracing/api
- https://docs.konghq.com/gateway/3.3.x/production/tracing/api
- https://docs.konghq.com/gateway/3.4.x/production/tracing/api
- https://docs.konghq.com/gateway/3.5.x/production/tracing/api
- https://docs.konghq.com/gateway/3.6.x/production/tracing/api
- https://docs.konghq.com/gateway/3.7.x/production/tracing/api


### [Release: Gateway 2.8.4.8](https://github.com/Kong/docs.konghq.com/pull/7136) (2024-03-26)

Changelog, version bump, and generating kong.conf reference.

https://konghq.atlassian.net/browse/DOCU-3738

#### Modified

- https://docs.konghq.com/gateway/2.8.x/reference/configuration
- https://docs.konghq.com/gateway/changelog



### [docs(*): fix docs related to Kong Gateway Tracing](https://github.com/Kong/docs.konghq.com/pull/7133) (2024-03-25)


The docs on Kong Tracing had incorrect information

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/tracing/api
- https://docs.konghq.com/gateway/3.1.x/production/tracing/api
- https://docs.konghq.com/gateway/3.2.x/production/tracing/api
- https://docs.konghq.com/gateway/3.3.x/production/tracing/api
- https://docs.konghq.com/gateway/3.4.x/production/tracing/api
- https://docs.konghq.com/gateway/3.5.x/production/tracing/api
- https://docs.konghq.com/gateway/3.6.x/production/tracing/api
- https://docs.konghq.com/gateway/3.7.x/production/tracing/api


### [kgo: add status field monitoring section](https://github.com/Kong/docs.konghq.com/pull/7124) (2024-03-29)

This PR adds pages to KGO's monitoring guide.

Specifically how to retrieve and use objects' `.status` field.

Part of: https://github.com/Kong/gateway-operator-archive/issues/1207

#### Added

- https://docs.konghq.com/gateway-operator/1.1.x/production/monitoring/status/controlplane/
- https://docs.konghq.com/gateway-operator/1.2.x/production/monitoring/status/controlplane/
- https://docs.konghq.com/gateway-operator/1.3.x/production/monitoring/status/controlplane/
- https://docs.konghq.com/gateway-operator/1.1.x/production/monitoring/status/dataplane/
- https://docs.konghq.com/gateway-operator/1.2.x/production/monitoring/status/dataplane/
- https://docs.konghq.com/gateway-operator/1.3.x/production/monitoring/status/dataplane/
- https://docs.konghq.com/gateway-operator/1.1.x/production/monitoring/status/gateway/
- https://docs.konghq.com/gateway-operator/1.2.x/production/monitoring/status/gateway/
- https://docs.konghq.com/gateway-operator/1.3.x/production/monitoring/status/gateway/
- https://docs.konghq.com/gateway-operator/1.1.x/production/monitoring/status/overview/
- https://docs.konghq.com/gateway-operator/1.2.x/production/monitoring/status/overview/
- https://docs.konghq.com/gateway-operator/1.3.x/production/monitoring/status/overview/


### [chore: Clarify our use of SemVer with Kong Gateway](https://github.com/Kong/docs.konghq.com/pull/7117) (2024-03-29)

Adding a note to clarify what we deliver in a version, most notably patch versions, to make it clear that it is never safe to upgrade automatically. We can break semver with backports, and it isn't always predicatable.

https://konghq.atlassian.net/browse/DOCU-3717

#### Modified

- https://docs.konghq.com/gateway-operator/1.2.x/guides/autoscaling-workloads/prometheus/
- https://docs.konghq.com/gateway-operator/1.3.x/guides/autoscaling-workloads/prometheus/
- https://docs.konghq.com/gateway-operator/1.0.x/production/monitoring/metrics
- https://docs.konghq.com/gateway-operator/1.1.x/production/monitoring/metrics
- https://docs.konghq.com/gateway-operator/1.2.x/production/monitoring/metrics
- https://docs.konghq.com/gateway-operator/1.3.x/production/monitoring/metrics/
- https://docs.konghq.com/gateway-operator/1.1.x/production/monitoring/status/controlplane/
- https://docs.konghq.com/gateway-operator/1.2.x/production/monitoring/status/controlplane/
- https://docs.konghq.com/gateway-operator/1.3.x/production/monitoring/status/controlplane/
- https://docs.konghq.com/gateway/2.6.x/
- https://docs.konghq.com/gateway/2.6.x/install-and-run/upgrade-enterprise
- https://docs.konghq.com/gateway/2.6.x/install-and-run/upgrade-oss
- https://docs.konghq.com/gateway/2.7.x/
- https://docs.konghq.com/gateway/2.7.x/install-and-run/upgrade-enterprise
- https://docs.konghq.com/gateway/2.7.x/install-and-run/upgrade-oss
- https://docs.konghq.com/gateway/2.8.x/
- https://docs.konghq.com/gateway/2.8.x/install-and-run/upgrade-enterprise
- https://docs.konghq.com/gateway/2.8.x/install-and-run/upgrade-oss
- https://docs.konghq.com/gateway/2.8.x/support-policy

## Week 12

### [fix: Update auth0 instructions to include warning on trailing forward slash in URL](https://github.com/Kong/docs.konghq.com/pull/7122) (2024-03-22)

Updated the Issuer URL information, as providing a trailing slash will cause issues.


When we have trailing slash for issuer URL, it get concatenated which will result in issuer as this https://dev-26uur0y8i4n8x3ez.us.auth0.com//api/v2/". So, informing users via docs will be valuable until if this can be gracefully handled.

#### Modified

- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/auth0


### [fix: Use consistent names in Mocking plugin example](https://github.com/Kong/docs.konghq.com/pull/7116) (2024-03-22)

Fixes https://konghq.atlassian.net/browse/DOCU-3284.

Examples were using two sets of names, Ron and Jessica, and Hao and Sasha. The latter two are carried through the rest of the topic; the first two don't appear anywhere else, and feel like they might be left over from a previous version of the example .

#### Modified

- https://docs.konghq.com/hub/kong-inc/mocking/overview/


### [Fix: Generate 3.6 Gateway kong.conf reference](https://github.com/Kong/docs.konghq.com/pull/7115) (2024-03-21)

Regenerating the configuration reference for Gateway based on latest 3.6.1.1 patch. 
We didn't generate it with the release and there were significant changes to the file in that version. 
Now that these files are split out by version, this is easier to see. 

Also making some tweaks to run.lua and data.lua to use the same text that we have in the page description, and to remove a badge that doesn't need to exist.

Fixes https://konghq.atlassian.net/browse/DOCU-2889.

Will do the same for 3.5 with upcoming patch release (should be end of next week).

#### Modified

- https://docs.konghq.com/gateway-operator/1.0.x/install/
- https://docs.konghq.com/gateway-operator/1.1.x/install/
- https://docs.konghq.com/gateway-operator/1.2.x/install/
- https://docs.konghq.com/gateway-operator/1.3.x/install/



### [Kong Gateway Operator: use helm as installation method](https://github.com/Kong/docs.konghq.com/pull/7108) (2024-03-21)

Rewrites KGO installation guides to all use helm and KGO's helm chart.

Removes the old instructions which used the manifests.

Related: https://github.com/Kong/gateway-operator-archive/issues/1594

#### Modified

- https://docs.konghq.com/gateway-operator/1.0.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.1.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.2.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.3.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.2.x/guides/ai-gateway/
- https://docs.konghq.com/gateway-operator/1.3.x/guides/ai-gateway/


### [Kong Gateway Operator: fix Prometheus query in the guide which intermittently produced 0s which caused the targeted workload to scale down to 0](https://github.com/Kong/docs.konghq.com/pull/7106) (2024-03-20)

Fix Prometheus query in KGO guide which caused it to intermittently (incorrectly) report 0 which then in turn caused the HPA to scale the workload to 0.

#### Modified

- https://docs.konghq.com/gateway-operator/1.0.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.1.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.2.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.3.x/get-started/kic/install/


### [kgo: add cli args docs and regenerate 1.2 CRD ref doc](https://github.com/Kong/docs.konghq.com/pull/7104) (2024-03-20)

Add KGO 1.2 and 1.1 CLI arguments page.

#### Added

- https://docs.konghq.com/gateway-operator/1.2.x/guides/ai-gateway/
- https://docs.konghq.com/gateway-operator/1.3.x/guides/ai-gateway/

#### Modified

- https://docs.konghq.com/gateway-operator/1.0.x/install/
- https://docs.konghq.com/gateway-operator/1.1.x/install/
- https://docs.konghq.com/gateway-operator/1.2.x/install/
- https://docs.konghq.com/gateway-operator/1.3.x/install/


### [Update: Document custom annotations for decK APIOps](https://github.com/Kong/docs.konghq.com/pull/7098) (2024-03-22)

Added documentation for the custom annotations that can be added to OpenAPI specifications to support APIOps, and specifically the ```deck file openapi2kong``` command.
 
[Example OAS](https://github.com/Kong/go-apiops/blob/main/docs/learnservice_oas.yaml)

#### Modified

- https://docs.konghq.com/gateway-operator/1.0.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.1.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.2.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.3.x/get-started/kic/install/


### [KGO: AIGateway docs](https://github.com/Kong/docs.konghq.com/pull/7078) (2024-03-18)

Add example usage for AIGateway

#### Added

- https://docs.konghq.com/gateway-operator/1.2.x/guides/ai-gateway/
- https://docs.konghq.com/gateway-operator/1.3.x/guides/ai-gateway/
- https://docs.konghq.com/assets/gateway-operator/ai-gateway-crd.yaml


### [Release: Gateway 3.4.3.5 ](https://github.com/Kong/docs.konghq.com/pull/7076) (2024-03-21)

Sourced from https://github.com/Kong/kong-ee/blob/next/3.4.x.x/changelog/3.4.3.5/3.4.3.5.md

Addresses https://konghq.atlassian.net/browse/DOCU-3719 and https://konghq.atlassian.net/browse/DOCU-3713.

#### Modified

- https://docs.konghq.com/gateway/3.5.x/breaking-changes/34x/
- https://docs.konghq.com/gateway/3.6.x/breaking-changes/34x/
- https://docs.konghq.com/gateway/3.7.x/breaking-changes/34x/
- https://docs.konghq.com/gateway/3.0.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.1.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.2.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.3.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.4.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.5.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.6.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.7.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/secrets-management/backends/azure-key-vaults
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/backends/azure-key-vaults
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/secrets-management/backends/azure-key-vaults
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/secrets-management/backends/azure-key-vaults
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.7.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.0.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.1.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.2.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.3.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.4.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.5.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.6.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.7.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.0.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.1.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.2.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.3.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.4.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.5.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.6.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.7.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/changelog

## Week 11


### [Fix: Update `get-admins` endpoint description](https://github.com/Kong/docs.konghq.com/pull/7064) (2024-03-12)

Update Admin API's `get-admins` endpoint description.
 
#### Modified

- https://docs.konghq.com/gateway/3.0.x/admin-api/admins/reference
- https://docs.konghq.com/gateway/3.1.x/admin-api/admins/reference
- https://docs.konghq.com/gateway/3.2.x/admin-api/admins/reference
- https://docs.konghq.com/gateway/3.3.x/admin-api/admins/reference
- https://docs.konghq.com/gateway/3.4.x/admin-api/admins/reference


### [kgo: guides for workloads latency based autoscaling](https://github.com/Kong/docs.konghq.com/pull/7048) (2024-03-12)

- Add `DataPlaneMetricsExtension` CRD and update CRD reference
- Add `Horizontally autoscale workloads` guide

### Related issue

Part of https://github.com/Kong/gateway-operator-enterprise/issues/71

Milestone: KGO 1.2 https://github.com/Kong/gateway-operator-enterprise/milestone/1

#### Added

- https://docs.konghq.com/gateway-operator/1.2.x/guides/autoscaling-workloads/datadog/
- https://docs.konghq.com/gateway-operator/1.2.x/guides/autoscaling-workloads/overview/
- https://docs.konghq.com/gateway-operator/1.2.x/guides/autoscaling-workloads/prometheus/
- https://docs.konghq.com/gateway-operator/1.2.x/license/
- https://docs.konghq.com/assets/gateway-operator/v1.2.0/all_controllers.yaml
- https://docs.konghq.com/assets/gateway-operator/v1.2.0/crds.yaml
- https://docs.konghq.com/assets/gateway-operator/v1.2.0/default.yaml

#### Modified

- https://docs.konghq.com/gateway-operator/1.0.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.1.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.2.x/get-started/kic/install/


## Week 10

### [Feat: Topology diagrams for gateway docs](https://github.com/Kong/docs.konghq.com/pull/7059) (2024-03-08)

Adding topology diagrams based on a couple of slide decks of similar diagrams, converted into mermaid format.

https://konghq.atlassian.net/browse/DOCU-2482

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.6.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.7.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/concepts/ingress
- https://docs.konghq.com/kubernetes-ingress-controller/3.1.x/concepts/ingress
- https://docs.konghq.com/kubernetes-ingress-controller/3.2.x/concepts/ingress
- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.6.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.7.x/production/deployment-topologies/hybrid-mode/setup


### [Fix: adjust references to `ulimit -n` in Gateway docs](https://github.com/Kong/docs.konghq.com/pull/7058) (2024-03-08)

The wording of https://github.com/Kong/docs.konghq.com/pull/6984 around `ulimit` is ambiguous; this PR changes it to specifically mention `ulimit -n`.



#### Modified

- https://docs.konghq.com/gateway/changelog



### [Chore: Update the 'No support available' plugins category and language](https://github.com/Kong/docs.konghq.com/pull/7051) (2024-03-06)

For more accuracy, we are updating the category "No support available". We've had a lot of feedback from plugin owners that this category is misleading, because support is available, it's just not done by Kong.

Summary of changes:
* Category name and banner text: "No support available" -> "Contact 3rd party for support"
* Category in filter: "No support available" -> "Support by 3rd party" ("Contact 3rd party for support" doesn't fit in the space)
* URL slugs: 
  * "third-party" -> "third-party-partner" for tech partners - changed this for clarity
  * "none" -> "community" for 3rd party plugins that aren't partners
* Updates plugin templates to reflect the changes

#### Modified

- https://docs.konghq.com/hub/TheLEGOGroup/aws-request-signing/_metadata/_index.yml
- https://docs.konghq.com/hub/amberflo/kong-plugin-amberflo/_metadata/_index.yml
- https://docs.konghq.com/hub/appsentinels/appsentinels/_metadata/_index.yml
- https://docs.konghq.com/hub/datadome/kong-plugin-datadome/_metadata/_index.yml
- https://docs.konghq.com/hub/imperva/imp-appsec-connector/_metadata/_index.yml
- https://docs.konghq.com/hub/moesif/kong-plugin-moesif/_metadata/_index.yml
- https://docs.konghq.com/hub/nonamesecurity/nonamesecurity-kongtrafficsource/_metadata/_index.yml
- https://docs.konghq.com/hub/okta/okta/_metadata/_index.yml
- https://docs.konghq.com/hub/optum/kong-response-size-limiting/_metadata/_index.yml
- https://docs.konghq.com/hub/optum/kong-service-virtualization/_metadata/_index.yml
- https://docs.konghq.com/hub/optum/kong-spec-expose/_metadata/_index.yml
- https://docs.konghq.com/hub/optum/kong-splunk-log/_metadata/_index.yml
- https://docs.konghq.com/hub/optum/kong-upstream-jwt/_metadata/_index.yml
- https://docs.konghq.com/hub/salt/salt/_metadata/_index.yml
- https://docs.konghq.com/hub/wallarm/wallarm/_metadata/_index.yml
- https://docs.konghq.com/hub/index.html


### [Update: Add note about Google ACME and DNS requirement](https://github.com/Kong/docs.konghq.com/pull/7047) (2024-03-05)

Added a couple of notes to clarify that a requirement is to also allow Google Trust Services (pki.goog) by adding a CAA DNS record in a situation where a domain is already explicitly using CAA DNS records. 

What is a little complicated by this is that if a domain doesn't include any CAA DNS records then it's all good, but if they even set one CAA DNS record then it implicitly denies all issuers that they did not define, requiring them to add a new one for `pki.goog` since that is the issuer we utilize in Konnect.

Related [Slack thread](https://kongstrong.slack.com/archives/C03NRECFJPM/p1709667853741059?thread_ts=1709667666.887609&cid=C03NRECFJPM).

#### Modified

- https://docs.konghq.com/konnect/dev-portal/customization/


### [Release: Gateway 3.6.1.1](https://github.com/Kong/docs.konghq.com/pull/7046) (2024-03-05)

Bump version and create changelog entry for Gateway 3.6.1.1.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [fix: decK file merge example](https://github.com/Kong/docs.konghq.com/pull/7045) (2024-03-05)

`deck file merge` example uses `deck file patch`, where it should be `merge`. 

Parallel PR in decK repo: https://github.com/Kong/deck/pull/1237

#### Modified

- https://docs.konghq.com/gateway/3.0.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.1.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.2.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.3.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.4.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.5.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.6.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.7.x/kong-manager/enable


### [Fix: TCL/TCP typo](https://github.com/Kong/docs.konghq.com/pull/7038) (2024-03-05)

Doc said "TCL/TLS", should be "TCP/TLS". 

Was reported in docs Slack. Ended up making this fix since it appears in old versioned files, and it's easier/cleaner to quickly search & replace.

#### Modified

- https://docs.konghq.com/gateway/2.6.x/reference/proxy
- https://docs.konghq.com/gateway/2.7.x/reference/proxy
- https://docs.konghq.com/gateway/2.8.x/reference/proxy


### [Update: Kong Gateway overview diagram](https://github.com/Kong/docs.konghq.com/pull/7037) (2024-03-06)

Updating the Kong Gateway overview diagram to 1) remove Dev Portal and Vitals, as both are deprecated, and 2) update the styling to match Konnect and Mesh.

https://konghq.atlassian.net/browse/DOCU-3679

#### Added

- https://docs.konghq.com/assets/images/products/gateway/kong-gateway-features.png


### [Fix: rephrase 'sugar parameter' into more common terms](https://github.com/Kong/docs.konghq.com/pull/7036) (2024-03-04)

Adjusting the phrasing to remove confusing term.

https://konghq.atlassian.net/browse/DOCU-3707

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/upgrade/kic
- https://docs.konghq.com/kubernetes-ingress-controller/3.1.x/upgrade/kic
- https://docs.konghq.com/kubernetes-ingress-controller/3.2.x/upgrade/kic
- https://docs.konghq.com/gateway/3.0.x/kong-manager/configuring-to-send-email
- https://docs.konghq.com/gateway/3.1.x/kong-manager/configuring-to-send-email
- https://docs.konghq.com/gateway/3.2.x/kong-manager/configuring-to-send-email
- https://docs.konghq.com/gateway/3.3.x/kong-manager/configuring-to-send-email
- https://docs.konghq.com/gateway/3.4.x/kong-manager/configuring-to-send-email
- https://docs.konghq.com/gateway/3.5.x/kong-manager/configuring-to-send-email
- https://docs.konghq.com/gateway/3.6.x/kong-manager/configuring-to-send-email
- https://docs.konghq.com/gateway/3.7.x/kong-manager/configuring-to-send-email
- https://docs.konghq.com/gateway/2.6.x/admin-api/
- https://docs.konghq.com/gateway/2.6.x/reference/proxy
- https://docs.konghq.com/gateway/2.7.x/admin-api/
- https://docs.konghq.com/gateway/2.7.x/reference/proxy
- https://docs.konghq.com/gateway/2.8.x/admin-api/
- https://docs.konghq.com/gateway/2.8.x/reference/proxy



### [Homepage rebrand](https://github.com/Kong/docs.konghq.com/pull/7033) (2024-03-05)

Mainly updating:
* Product logos
* Card styles & layouts

These styles (cards) also apply to `/api/` and `/search/`.

https://konghq.atlassian.net/browse/DOCU-3682
https://konghq.atlassian.net/browse/DOCU-1707


https://github.com/Kong/docs.konghq.com/assets/715229/dd3372a2-76e3-4c5e-add1-7902b6f664b7

#### Added

- https://docs.konghq.com/assets/images/logos/kic-logo.svg
- https://docs.konghq.com/assets/images/logos/kong-gateway-enterprise-logo.svg
- https://docs.konghq.com/assets/images/logos/kong-gateway-logo.svg
- https://docs.konghq.com/assets/images/logos/kong-mesh-logo.svg
- https://docs.konghq.com/assets/images/logos/konglogo-gradient-secondary.svg

#### Modified

- https://docs.konghq.com/search.html


### [chore(*): remove references to Dev Portal and Vitals](https://github.com/Kong/docs.konghq.com/pull/7032) (2024-03-05)

Hide references to Dev Portal and Vitals from docs for Gateway >= 3.5. The last minor release these features were included is 3.4.

#### Modified

- https://docs.konghq.com/hub/kong-inc/mocking/_metadata/_index.yml
- https://docs.konghq.com/hub/kong-inc/oauth2/how-to/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/
- https://docs.konghq.com/gateway/3.0.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.1.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.2.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.3.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.4.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.5.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.6.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.7.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.0.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.1.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.2.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.3.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.4.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.5.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.6.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.7.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.0.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.1.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.2.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.3.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.4.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.5.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.6.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.7.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.0.x/production/networking/dns-considerations
- https://docs.konghq.com/gateway/3.1.x/production/networking/dns-considerations
- https://docs.konghq.com/gateway/3.2.x/production/networking/dns-considerations
- https://docs.konghq.com/gateway/3.3.x/production/networking/dns-considerations
- https://docs.konghq.com/gateway/3.4.x/production/networking/dns-considerations
- https://docs.konghq.com/gateway/3.5.x/production/networking/dns-considerations
- https://docs.konghq.com/gateway/3.6.x/production/networking/dns-considerations
- https://docs.konghq.com/gateway/3.7.x/production/networking/dns-considerations
- https://docs.konghq.com/gateway/3.0.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.1.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.2.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.3.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.4.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.5.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.6.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.7.x/production/sizing-guidelines


### [fix: Updated HTTP method for setting targets health](https://github.com/Kong/docs.konghq.com/pull/7029) (2024-03-04)

Updated the HTTP method from POST to PUT for setting targets health. The current doc references a POST method which results in a 405 - Method not allowed error.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.1.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.2.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.3.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.4.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.5.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.6.x/kong-manager/enable
- https://docs.konghq.com/gateway/3.7.x/kong-manager/enable


### [Feat: Convert navbar to dark theme](https://github.com/Kong/docs.konghq.com/pull/7022) (2024-03-04)

Converting navbar to dark theme and using new logos. 

I left the blue headers as-is mostly, and just had them fade into the navbar - I think that looks pretty good for the in-between stage.

I have asked the design team for what they expect from the expanded menu as well - leaving it as white for now, until they respond.

@fabianrbzg there's couple of things I couldn't figure out here, if you could take a look:
* Why the hover/interact state for the search bar looks... not so great. But I don't know how to find the source of the variable it's using for the hover state - looks like we're pulling it from somewhere else?
* Some issues with the mobile nav (see video) - can't figure out why the slideout overlaps with the nav while it's sliding:

https://github.com/Kong/docs.konghq.com/assets/54370747/29846a70-9f93-47b5-ac91-15d2d094df3d

https://konghq.atlassian.net/browse/DOCU-3681

#### Added

- https://docs.konghq.com/assets/images/logos/docslogo-dark-theme.svg
- https://docs.konghq.com/assets/images/logos/konglogo-dark-theme.svg


### [docs(traceableai) - Initial docs for traceable.ai plugin](https://github.com/Kong/docs.konghq.com/pull/7020) (2024-03-06)

This adds documentation for the Traceable.ai kong plugin

#### Added

- https://docs.konghq.com/hub/traceableai/traceableai/_metadata.yml
- https://docs.konghq.com/hub/traceableai/traceableai/examples/_index.yml
- https://docs.konghq.com/hub/traceableai/traceableai/overview/
- https://docs.konghq.com/hub/traceableai/traceableai/schemas/_index.json
- https://docs.konghq.com/assets/images/icons/hub/traceableai_traceableai.png


### [DOCU-3662: improve plugin versioning](https://github.com/Kong/docs.konghq.com/pull/6999) (2024-03-05)

Related [Jira ticket](https://konghq.atlassian.net/browse/DOCU-3662)

Add support for `minimum_version` and `maximum_version` in
the frontmatter of plugin pages.

* If a page has one of these set in frontmatter, it gets generated
for that version range, similar to versions.yml
* If a page doesn’t have any minimum or maximum version,
it defaults to the setting for the whole plugin, which is set in versions.yml

The only caveat is that we had to replace `_metadata.yml` with a specific
`_metadata` folder. If a file for a specific version exists, (e.g.
`_metadata/_2.6.x.yml`) it will be used for that specific release, if
not `_metadata/_index.yml` will be used.

I also fixed a bug in the releases dropdown.
When switching to an older version for which the current page does not exist, it redirected the user to the plugin's landing page in its latest version instead of the version selected by the user.

https://github.com/Kong/docs.konghq.com/assets/715229/526c0144-2fd2-40df-b433-3769d50805e1

#### Added

- https://docs.konghq.com/hub/kong-inc/statsd-advanced/_metadata/_2.7.x.yml
- https://docs.konghq.com/hub/kong-inc/statsd-advanced/_metadata/_2.8.x.yml

#### Modified

- https://docs.konghq.com/hub/kong-inc/acl/how-to/
- https://docs.konghq.com/hub/kong-inc/acl/overview/
- https://docs.konghq.com/hub/kong-inc/acl/versions.yml
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/client-authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/versions.yml
- https://docs.konghq.com/hub/kong-inc/prometheus/overview/
- https://docs.konghq.com/hub/kong-inc/prometheus/versions.yml
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/versions.yml
- https://docs.konghq.com/hub/kong-inc/statsd-advanced/versions.yml
- https://docs.konghq.com/hub/kong-inc/vault-auth/overview/
- https://docs.konghq.com/hub/kong-inc/vault-auth/versions.yml
- https://docs.konghq.com/contributing/kong-plugins
- https://docs.konghq.com/contributing/single-sourced-plugins


### [Feat: Konnect Explorer and summary dashboard documentation](https://github.com/Kong/docs.konghq.com/pull/6961) (2024-03-07)

Todo: 

* Review w/ Christian
* New shot scraper scripts

https://konghq.atlassian.net/browse/DOCU-3665
https://konghq.atlassian.net/browse/DOCU-3601
Changelog for this here: https://github.com/Kong/docs.konghq.com/pull/6811

#### Added

- https://docs.konghq.com/assets/images/products/konnect/analytics/konnect-explorer-dashboard.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/konnect-summary-dashboard.png
- https://docs.konghq.com/assets/images/products/konnect/changelog/konnect-analytics-summary-dashboard.png
- https://docs.konghq.com/konnect/analytics/dashboard

#### Modified

- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/api-usage-by-application.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/kong-vs-upstream-latency.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/latency-payments-api-30.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/total-api-requests.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/total-usage-accounts-api-30.png
- https://docs.konghq.com/konnect/analytics/api-requests
- https://docs.konghq.com/konnect/analytics/
- https://docs.konghq.com/konnect/analytics/troubleshoot
- https://docs.konghq.com/konnect/analytics/use-cases
- https://docs.konghq.com/konnect/analytics/use-cases/latency
- https://docs.konghq.com/konnect/updates

## Week 9

### [Fix: Consumer groups links and descriptions](https://github.com/Kong/docs.konghq.com/pull/7016) (2024-02-29)

The consumer groups description is outdated on the Kong Enterprise overview, as it describes consumer groups for rate limiting only. This is no longer the case.

https://docs.konghq.com/gateway/latest/kong-enterprise/#consumer-groups

#### Modified

- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/overview/


### [chore: Add step to stop kong before uninstalling](https://github.com/Kong/docs.konghq.com/pull/7012) (2024-02-28)

Add a step to stop Kong before trying to uninstall it to prevent errors, per https://konghq.atlassian.net/browse/DOCU-253

#### Modified

- https://docs.konghq.com/gateway/3.0.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.1.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.2.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.3.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.4.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.5.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.6.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.7.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.0.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.1.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.2.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.3.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.4.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.5.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.6.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.7.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.0.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.1.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.2.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.3.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.4.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.5.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.6.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.7.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.0.x/migrate-cassandra-to-postgres/
- https://docs.konghq.com/gateway/3.1.x/migrate-cassandra-to-postgres/
- https://docs.konghq.com/gateway/3.2.x/migrate-cassandra-to-postgres/
- https://docs.konghq.com/gateway/3.3.x/migrate-cassandra-to-postgres/
- https://docs.konghq.com/gateway/3.4.x/migrate-cassandra-to-postgres/
- https://docs.konghq.com/gateway/3.5.x/migrate-cassandra-to-postgres/
- https://docs.konghq.com/gateway/3.6.x/migrate-cassandra-to-postgres/
- https://docs.konghq.com/gateway/3.7.x/migrate-cassandra-to-postgres/


### [Fix: Delete Kong prevention plugin directory and update metadata show compatibility with Konnect](https://github.com/Kong/docs.konghq.com/pull/7007) (2024-02-29)

Deleted the prevention plugin directory and updated docs and the metadata to show compatibility with kong konnect and the merging of the prevention plugin with the traffic source plugin and version compatibility with 3.5.x

#### Modified

- https://docs.konghq.com/hub/nonamesecurity/nonamesecurity-kongtrafficsource/_metadata.yml
- https://docs.konghq.com/hub/nonamesecurity/nonamesecurity-kongtrafficsource/overview/
- https://docs.konghq.com/assets/images/icons/hub/nonamesecurity_nonamesecurity-kongtrafficsource.png


### [Chore: Move Gateway 3.2 to sunset versions](https://github.com/Kong/docs.konghq.com/pull/7004) (2024-02-29)

Gateway 3.2.x enters sunset support on Feb 28th. 

Resolves [DOCU-3521](https://konghq.atlassian.net/browse/DOCU-3521).

#### Modified

- https://docs.konghq.com/mesh/2.1.x/features/meshopa
- https://docs.konghq.com/gateway/3.0.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.1.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.2.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.3.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.4.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.5.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.6.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.7.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.0.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.1.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.2.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.3.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.4.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.5.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.6.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.7.x/install/linux/ubuntu


### [Feat: Appreg v2 updates ](https://github.com/Kong/docs.konghq.com/pull/7003) (2024-02-28)

Updating DCR docs for App Reg v2 API, specifically documenting two major changes:

1. You now create auth configs independently (instead of at the Org wide level) and apply them to the API Product versions of your choice
2. If you want to use a DCR auth config, you need to independently create the DCR config and then apply it your auth config.

https://github.com/Kong/docs.konghq.com/pull/6855
https://konghq.atlassian.net/browse/DOCU-3602
https://konghq.atlassian.net/browse/DOCU-3684

#### Added

- https://docs.konghq.com/konnect/getting-started/app-registration

#### Modified

- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-app-connections
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-app-reg-requests
- https://docs.konghq.com/konnect/dev-portal/access
- https://docs.konghq.com/konnect/dev-portal/applications/application-overview
- https://docs.konghq.com/konnect/dev-portal/applications/dev-apps
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/auth0
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/azure
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/curity
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/okta
- https://docs.konghq.com/konnect/dev-portal/applications/enable-app-reg
- https://docs.konghq.com/konnect/updates

### [Add Gateway 3.6 to KIC compatibility matrix](https://github.com/Kong/docs.konghq.com/pull/6998) (2024-02-27)

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/debian
- https://docs.konghq.com/gateway/3.1.x/install/linux/debian
- https://docs.konghq.com/gateway/3.2.x/install/linux/debian
- https://docs.konghq.com/gateway/3.3.x/install/linux/debian
- https://docs.konghq.com/gateway/3.4.x/install/linux/debian
- https://docs.konghq.com/gateway/3.5.x/install/linux/debian
- https://docs.konghq.com/gateway/3.6.x/install/linux/debian
- https://docs.konghq.com/gateway/3.7.x/install/linux/debian


### [Updated example of Auth0 configuration _auth0.md](https://github.com/Kong/docs.konghq.com/pull/6996) (2024-02-27)

Auth0 configurations example is misleading in docs, updated the doc to remove properties that are not needed and added the important property that is needed.

#### Modified

- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/

### [Release: Gateway 3.6.1.0](https://github.com/Kong/docs.konghq.com/pull/6994) (2024-02-26)

Changelog and version bump for gateway 3.6.1.0

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Fix: replace benchmark redirect with moved url entry](https://github.com/Kong/docs.konghq.com/pull/6983) (2024-02-29)

This URL got flagged as 404ing at /latest/ by google console. 

#### Modified

- https://docs.konghq.com/moved_urls.yml


### [docs(mesh): update MeshGlobalRateLimit and MeshOPA targetref support table](https://github.com/Kong/docs.konghq.com/pull/6948) (2024-02-28)

Change the targetRef support table since 2.6 it has a different layout.

**Listener tags are not yet supported because the plugins need to be adjusted**
 

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/debian
- https://docs.konghq.com/gateway/3.1.x/install/linux/debian
- https://docs.konghq.com/gateway/3.2.x/install/linux/debian
- https://docs.konghq.com/gateway/3.3.x/install/linux/debian
- https://docs.konghq.com/gateway/3.4.x/install/linux/debian
- https://docs.konghq.com/gateway/3.5.x/install/linux/debian
- https://docs.konghq.com/gateway/3.6.x/install/linux/debian
- https://docs.konghq.com/gateway/3.7.x/install/linux/debian
- https://docs.konghq.com/gateway/3.0.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.1.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.2.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.3.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.4.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.5.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.6.x/install/linux/rhel
- https://docs.konghq.com/gateway/3.7.x/install/linux/rhel

## Week 8

### [fix: Remove inaccurate note in OAuth2 plugin](https://github.com/Kong/docs.konghq.com/pull/6988) (2024-02-22)

The note was added based on an old ticket that doesn't apply now. The OAuth2 plugin can be run in production.

#### Modified

- https://docs.konghq.com/hub/kong-inc/oauth2/overview/


### [Feat: Add documentation on higher ulimit requirement for 3.6.0.0](https://github.com/Kong/docs.konghq.com/pull/6984) (2024-02-21)

Document missing entry for ulimit breaking change.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.1.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.2.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.3.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.4.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.5.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.6.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.7.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/changelog


### [Fix:Add more information about cache key generation in proxy-cache-advanced](https://github.com/Kong/docs.konghq.com/pull/6982) (2024-02-21)

Adding more info about how cache key is generated based on
https://github.com/Kong/kong-ee/blob/3.6.0.0/plugins-ee/proxy-cache-advanced/kong/plugins/proxy-cache-advanced/cache_key.lua#L110-L122

Preview: https://deploy-preview-6982--kongdocs.netlify.app/hub/kong-inc/proxy-cache-advanced/#cache-key

#### Modified

- https://docs.konghq.com/hub/kong-inc/proxy-cache-advanced/overview/


### [Fix: Links to KIC cli-arguments reference](https://github.com/Kong/docs.konghq.com/pull/6979) (2024-02-21)

Flagged in https://github.com/Kong/docs.konghq.com/actions/runs/7945193457/job/21691549272. Links have no `src`, so they're not being generated properly.

Generator will need adjusting to add a space between the end of the table and `<!--vale off-->`, otherwise the table breaks and looks like this: 
![Screenshot 2024-02-20 at 10 42 57 AM](https://github.com/Kong/docs.konghq.com/assets/54370747/10d3eb74-124b-4b14-9fee-9bc5098e7489)

Ran into a couple other cross-folder issues (kic-v2 vs kubernetes-ingress-controller): 
* Why is https://github.com/Kong/docs.konghq.com/blob/main/app/_src/kic-v2/references/version-compatibility.md being maintained in `kic-v2` and not in the current folder?
* This PR was opened against kic-v2 because the same FAQ page doesn't exist in 3.x: https://github.com/Kong/docs.konghq.com/pull/6403 - should this info be in 3.x?

#### Modified

- https://docs.konghq.com/gateway/3.0.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.1.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.2.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.3.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.4.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.5.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.6.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.7.x/reference/expressions-language/language-references


### [Fix: remove if_version on the Or operator in the expressions router table](https://github.com/Kong/docs.konghq.com/pull/6975) (2024-02-20)

Remove the `if_version` on OR operator in expression language reference page to let the OR operator (`||`) displayed correctly.
fixes #6972.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.1.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.2.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.3.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.4.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.5.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.6.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.7.x/reference/expressions-language/language-references


### [fix: Add 3.6 conditional rendering for single backup nodes](https://github.com/Kong/docs.konghq.com/pull/6974) (2024-02-21)

We missed some conditional rendering for a note about single backup nodes. It should only apply to 3.6 and later? (waiting on confirmation for the correct version, so this PR might change a little)
 
https://kongstrong.slack.com/archives/CDSTDSG9J/p1708369514356029?thread_ts=1708368658.991799&cid=CDSTDSG9J

#### Modified

- https://docs.konghq.com/gateway/3.0.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.1.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.2.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.3.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.4.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.5.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.6.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.7.x/reference/expressions-language/language-references


### [fix(kong-manager): add ignored params to the OIDC migration guide](https://github.com/Kong/docs.konghq.com/pull/6971) (2024-02-20)

This pull request adds the ignored parameters to the migration guide for Kong Manager's OIDC feature.

#### Modified

- https://docs.konghq.com/gateway/3.6.x/kong-manager/auth/oidc/migrate
- https://docs.konghq.com/gateway/3.7.x/kong-manager/auth/oidc/migrate


### [Fix: docs(mesh)- in Vault docs switch to orphan tokens](https://github.com/Kong/docs.konghq.com/pull/6964) (2024-02-23)

As described in the PR changes, it's likely users want to create orphan tokens to authenticate to vault.

See also https://github.com/Kong/kong-mesh/issues/5412

#### Modified

- https://docs.konghq.com/gateway/3.0.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.1.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.2.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.3.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.4.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.5.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.6.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.7.x/reference/expressions-language/language-references


### [Fix: docs(mesh/rbac): add information how to unlock yourself](https://github.com/Kong/docs.konghq.com/pull/6944) (2024-02-23)

Added docs how to unlock yourself in case you remove default rbac

#### Modified

- https://docs.konghq.com/gateway/3.0.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.1.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.2.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.3.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.4.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.5.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.6.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.7.x/reference/expressions-language/language-references

## Week 7

### [release deck 1.34.0](https://github.com/Kong/docs.konghq.com/pull/6952) (2024-02-15)

Add deck 1.34 release information with new` deck file namespace` command
 
#### Added

- https://docs.konghq.com/gateway/3.0.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.1.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.2.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.3.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.4.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.5.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.6.x/kong-manager/auth/oidc/configure

### [Release: Gateway 3.6](https://github.com/Kong/docs.konghq.com/pull/6929) (2024-02-14)

Releasing the docs for for Gateway 3.6.

List of changes in this release:
https://github.com/Kong/docs.konghq.com/milestone/56?closed=1

### [kic: split CRD reference types into sections](https://github.com/Kong/docs.konghq.com/pull/6943) (2024-02-13)

Splits the top-level CRDs and the types that they rely on into separate sections to make it clear which types are meant to be used to create objects in the Kubernetes API.

Addresses @liyangau concern about the reference not signaling clearly which types are meant to be used to create objects in a cluster. 

It's propagated from the KIC repo: https://github.com/Kong/kubernetes-ingress-controller/pull/5611

#### Modified

- https://docs.konghq.com/gateway/3.0.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.1.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.2.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.3.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.4.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.5.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.6.x/kong-manager/auth/oidc/configure


### [Feat: Add new performance testing results doc for Gateway 3.6](https://github.com/Kong/docs.konghq.com/pull/6928) (2024-02-13)

Beginning in Gateway 3.6, Kong is now publishing performance testing results for several use cases. This PR adds a doc that publishes those results, covers the testing methodology, and provides info for customers to use the Kong test suite to conduct their own tests. This PR also creates a new Performance section of the docs so it's easier to find performance related docs.


#### Added

- https://docs.konghq.com/gateway/3.6.x/production/performance/performance-testing

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.1.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.2.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.3.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.4.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.5.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.6.x/production/sizing-guidelines

## Week 6

### [Release: Gateway 3.4.3.4](https://github.com/Kong/docs.konghq.com/pull/6932) (2024-02-10)

Changelog and version bump for Gateway 3.4.3.4.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [fix(rt-plugin): fix description of variables](https://github.com/Kong/docs.konghq.com/pull/6931) (2024-02-09)

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer/how-to/


### [kic: extend secrets in plugins guide with configFrom field](https://github.com/Kong/docs.konghq.com/pull/6926) (2024-02-08)

Extends `Using Kubernetes Secrets in Plugins` guide to describe the new `configPatches` fields and its usage.
 
Fixes https://github.com/Kong/kubernetes-ingress-controller/issues/5572.

#### Modified

- https://docs.konghq.com/gateway/3.4.x/reference/configuration
- https://docs.konghq.com/gateway/3.5.x/reference/configuration
- https://docs.konghq.com/gateway/3.6.x/reference/configuration


### [Fix a typo](https://github.com/Kong/docs.konghq.com/pull/6925) (2024-02-08)

Fixed a mistake in attaching json data to curl command.  
The `=`, not `:`, must be used to attach the 'body'.

>       -d, --data <data>
>              (HTTP MQTT) Sends the specified data in a POST request to the HTTP server, in the same way that a browser does when a
>              user has filled in an HTML form and presses the submit button. This makes curl pass the data to the server using the
>              content-type application/x-www-form-urlencoded. Compare to -F, --form.
>
>              --data-raw is almost the same but does not have a special interpretation of the @ character. To post data purely
>              binary, you should instead use the --data-binary option. To URL-encode the value of a form field you may use
>              --data-urlencode.
>
>              If any of these options is used more than once on the same command line, the data pieces specified are merged with a
>              separating &-symbol. Thus, using '-d name=daniel -d skill=lousy' would generate a post chunk that looks like
>              'name=daniel&skill=lousy'.
>
>              If you start the data with the letter @, the rest should be a file name to read the data from, or - if you want curl
>              to read the data from stdin. Posting data from a file named 'foobar' would thus be done with -d, --data @foobar. When
>              -d, --data is told to read from a file like that, carriage returns and newlines are stripped out. If you do not want
>              the @ character to have a special interpretation use --data-raw instead.
>
>              The data for this option is passed on to the server exactly as provided on the command line. curl does not convert,
>              change or improve it. It is up to the user to provide the data in the correct form.
>
>              -d, --data can be used several times in a command line
>
>              Examples:
>               curl -d "name=curl" https://example.com
>               curl -d "name=curl" -d "tool=cmdline" https://example.com
>               curl -d @filename https://example.com
>
>              See also --data-binary, --data-urlencode and --data-raw. This option is mutually exclusive to -F, --form and -I,
>              --head and -T, --upload-file.
>               
>man curl

#### Modified

- https://docs.konghq.com/hub/kong-inc/key-auth/overview/

### [Fix: Reference lua package path location in Exit Transformer plugin](https://github.com/Kong/docs.konghq.com/pull/6922) (2024-02-08)

Original document assumed knowledge about location for reference of .lua files. Added instruction to save file in referenced lua package path location as per https://docs.konghq.com/gateway/latest/plugin-development/distribution/#manually

#### Modified

- https://docs.konghq.com/hub/kong-inc/exit-transformer/overview/


### [kic: extend vault guide with KongVault CRD usage](https://github.com/Kong/docs.konghq.com/pull/6917) (2024-02-08)

Updates the "Kong Vault" guide with `KongVault` CRD usage.

Fixes https://github.com/Kong/kubernetes-ingress-controller/issues/5571.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/
- https://docs.konghq.com/gateway/3.1.x/
- https://docs.konghq.com/gateway/3.2.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/gateway/3.5.x/
- https://docs.konghq.com/gateway/3.6.x/


### [Update docs for KIC 3.1.0](https://github.com/Kong/docs.konghq.com/pull/6915) (2024-02-08)

Prepares documentation for KIC 3.1.0 release.

#### Added

- https://docs.konghq.com/kubernetes-ingress-controller/3.1.x/reference/cli-arguments-3.1.x
- https://docs.konghq.com/kubernetes-ingress-controller/3.2.x/reference/cli-arguments-3.1.x

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/3.1.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/3.2.x/support-policy


### [Release: Gateway 2.8.4.7](https://github.com/Kong/docs.konghq.com/pull/6911) (2024-02-09)

Version bump and changelog for Gateway 2.8.4.7.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [kic: extend license guide with KongLicense CRD](https://github.com/Kong/docs.konghq.com/pull/6910) (2024-02-08)

Adds a section describing `KongLicense` CRD usage to the license guide.

Fixes https://github.com/Kong/kubernetes-ingress-controller/issues/5570.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/
- https://docs.konghq.com/gateway/3.1.x/
- https://docs.konghq.com/gateway/3.2.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/gateway/3.5.x/
- https://docs.konghq.com/gateway/3.6.x/


### [kic: document konghq.com/tags annotation](https://github.com/Kong/docs.konghq.com/pull/6909) (2024-02-06)

Documents KIC's `konghq.com/tags` annotation.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/
- https://docs.konghq.com/gateway/3.1.x/
- https://docs.konghq.com/gateway/3.2.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/gateway/3.5.x/
- https://docs.konghq.com/gateway/3.6.x/


### [Chore: Plan and usage UI changes ](https://github.com/Kong/docs.konghq.com/pull/6904) (2024-02-07)

https://konghq.atlassian.net/browse/DOCU-3674

Update shot scraper and add new screenshots. 
**There is no script for /assets/images/products/konnect/billing/billing-and-usage.png** our environment doesn't let us generate it.

#### Modified

- https://docs.konghq.com/assets/images/products/konnect/api-products/api-products-manage.png
- https://docs.konghq.com/assets/images/products/konnect/api-products/api-products-overview.png
- https://docs.konghq.com/assets/images/products/konnect/billing/billing-and-usage.png
- https://docs.konghq.com/assets/images/products/konnect/dashboard/konnect-dashboard.png
- https://docs.konghq.com/assets/images/products/konnect/gateway-manager/konnect-control-plane-dashboard.png
- https://docs.konghq.com/assets/images/products/konnect/gateway-manager/konnect-runtime-instance-gateway.png


### [chore(deps): bump kumahq/kuma-website from 316d2427 to 9948b52a](https://github.com/Kong/docs.konghq.com/pull/6884) (2024-02-07)

Auto upgrade PR log:

9948b52a52d83b0f4b7ce7800229b3dda25e2060 feat(installer): Source Packages from Cloudsmith (kumahq/kuma-website#1625)
b64d438edaa1116ab5d398c54c0bebda168f710e chore(deps): update docs from repo source (kumahq/kuma-website#1640)
ac7644c178787d64a74d01964b5a48673bf6b72e chore(deps): update docs from repo source (kumahq/kuma-website#1636)
050de0c32b1606761518411b8db082831c4efb0c chore(blog) add release 2.6.0 blogpost (kumahq/kuma-website#1620)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/7807937407).
labels: skip-changelog,review:general

#### Modified

- https://docs.konghq.com/gateway/3.0.x/
- https://docs.konghq.com/gateway/3.1.x/
- https://docs.konghq.com/gateway/3.2.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/gateway/3.5.x/
- https://docs.konghq.com/gateway/3.6.x/


### [Run the broken links checker against the plugin hub](https://github.com/Kong/docs.konghq.com/pull/6868) (2024-02-08)

Fix all the broken links reported by the full scan.

#### Added

- https://docs.konghq.com/assets/images/docs/diagram-delegated-gateway-detailed@3x.jpg

#### Modified

- https://docs.konghq.com/hub/amberflo/kong-plugin-amberflo/overview/
- https://docs.konghq.com/hub/kong-inc/forward-proxy/
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/
- https://docs.konghq.com/hub/kong-inc/http-log/overview/
- https://docs.konghq.com/hub/kong-inc/kafka-log/
- https://docs.konghq.com/hub/kong-inc/kafka-upstream/
- https://docs.konghq.com/hub/kong-inc/ldap-auth-advanced/
- https://docs.konghq.com/hub/kong-inc/mtls-auth/overview/
- https://docs.konghq.com/hub/kong-inc/openid-connect/
- https://docs.konghq.com/hub/kong-inc/openid-connect/
- https://docs.konghq.com/hub/kong-inc/openid-connect/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/audit-log
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/audit-log
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/audit-log
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/audit-log
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/audit-log
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/audit-log
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/audit-log
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/aws-iam-auth-to-rds-database
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/aws-iam-auth-to-rds-database
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/aws-iam-auth-to-rds-database
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/aws-iam-auth-to-rds-database
- https://docs.konghq.com/gateway/3.0.x/kong-manager/auth/ldap/service-directory-mapping
- https://docs.konghq.com/gateway/3.1.x/kong-manager/auth/ldap/service-directory-mapping
- https://docs.konghq.com/gateway/3.2.x/kong-manager/auth/ldap/service-directory-mapping
- https://docs.konghq.com/gateway/3.3.x/kong-manager/auth/ldap/service-directory-mapping
- https://docs.konghq.com/gateway/3.4.x/kong-manager/auth/ldap/service-directory-mapping
- https://docs.konghq.com/gateway/3.5.x/kong-manager/auth/ldap/service-directory-mapping
- https://docs.konghq.com/gateway/3.6.x/kong-manager/auth/ldap/service-directory-mapping
- https://docs.konghq.com/gateway/3.0.x/kong-manager/auth/rbac/add-admin
- https://docs.konghq.com/gateway/3.1.x/kong-manager/auth/rbac/add-admin
- https://docs.konghq.com/gateway/3.2.x/kong-manager/auth/rbac/add-admin
- https://docs.konghq.com/gateway/3.3.x/kong-manager/auth/rbac/add-admin
- https://docs.konghq.com/gateway/3.4.x/kong-manager/auth/rbac/add-admin
- https://docs.konghq.com/gateway/3.5.x/kong-manager/auth/rbac/add-admin
- https://docs.konghq.com/gateway/3.6.x/kong-manager/auth/rbac/add-admin
- https://docs.konghq.com/gateway/3.0.x/kong-manager/auth/rbac/add-role
- https://docs.konghq.com/gateway/3.1.x/kong-manager/auth/rbac/add-role
- https://docs.konghq.com/gateway/3.2.x/kong-manager/auth/rbac/add-role
- https://docs.konghq.com/gateway/3.3.x/kong-manager/auth/rbac/add-role
- https://docs.konghq.com/gateway/3.4.x/kong-manager/auth/rbac/add-role
- https://docs.konghq.com/gateway/3.5.x/kong-manager/auth/rbac/add-role
- https://docs.konghq.com/gateway/3.6.x/kong-manager/auth/rbac/add-role
- https://docs.konghq.com/gateway/3.0.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.1.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.2.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.3.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.4.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.5.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.6.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.0.x/licenses/deploy
- https://docs.konghq.com/gateway/3.1.x/licenses/deploy
- https://docs.konghq.com/gateway/3.2.x/licenses/deploy
- https://docs.konghq.com/gateway/3.3.x/licenses/deploy
- https://docs.konghq.com/gateway/3.4.x/licenses/deploy
- https://docs.konghq.com/gateway/3.5.x/licenses/deploy
- https://docs.konghq.com/gateway/3.6.x/licenses/deploy
- https://docs.konghq.com/gateway/3.1.x/production/logging/update-log-level-dynamically
- https://docs.konghq.com/gateway/3.2.x/production/logging/update-log-level-dynamically
- https://docs.konghq.com/gateway/3.3.x/production/logging/update-log-level-dynamically
- https://docs.konghq.com/gateway/3.4.x/production/logging/update-log-level-dynamically
- https://docs.konghq.com/gateway/3.5.x/production/logging/update-log-level-dynamically
- https://docs.konghq.com/gateway/3.6.x/production/logging/update-log-level-dynamically
- https://docs.konghq.com/gateway/changelog
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-teams


### [Refactor title tag generation](https://github.com/Kong/docs.konghq.com/pull/6841) (2024-02-05)

[Jira ticket](https://konghq.atlassian.net/browse/DOCU-3405)
Automate title tag generation.

It follows the following format:
```
H1 - <product> - <optional version> | site title
```

where:
* evergreen urls (/latest/) don't include the optional version
* if H1 contains <product> don't include - <product> - so we don't repeat text

#### Modified

- https://docs.konghq.com/search.html

## Week 5

### [Update: Change dev label and banner color](https://github.com/Kong/docs.konghq.com/pull/6859) (2024-01-31)

Changing the "dev" label to "unreleased" to make it clearer what this doc version is supposed to be. 

Also changing the banner colour to red, as the previous banner looked too similar to the "outdated version" banner.

Some minor version/conditionals cleanup here as well.

#### Modified

- https://docs.konghq.com/contributing/conditional-rendering


### [Fix: kic - add explanation for Gateway's publish service](https://github.com/Kong/docs.konghq.com/pull/6853) (2024-01-30)

Adds an explanation of `--publish-service` vs. `konghq.com/publish-service` Gateway's annotation relation.

Part of https://github.com/Kong/kubernetes-ingress-controller/issues/5328.
 


#### Modified

- https://docs.konghq.com/gateway/3.2.x/support/browser
- https://docs.konghq.com/gateway/3.3.x/support/browser
- https://docs.konghq.com/gateway/3.4.x/support/browser
- https://docs.konghq.com/gateway/3.5.x/support/browser
- https://docs.konghq.com/gateway/3.6.x/support/browser

## Week 4

### [Fix: kic - Use standard repository in Helm example instructions](https://github.com/Kong/docs.konghq.com/pull/6842) (2024-01-26)

The KIC Helm install docs showed how to customise the image by using the nightly KIC image. This confused some users who actually tried to use the nightly image in a non-test environment.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.6.x/production/deployment-topologies/db-less-and-declarative-config


### [Fix: Incorrect request format in DB-less and declarative config doc](https://github.com/Kong/docs.konghq.com/pull/6837) (2024-01-26)

Corrected the command to send the config to the Gateway. It was using a GET instead of POST and when using form-urlencoded data (--data) it throws a 400 error.  

{"message":"declarative config is invalid: {error=\"failed parsing declarative configuration: 1:1: found character that cannot start any token\"}","name":"invalid declarative configuration","code":14,"fields":{"error":"failed parsing declarative configuration: 1:1: found character that cannot start any token"}}

This was changed to use multipart/form-data (--form)

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.1.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.2.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.3.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.4.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.5.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.6.x/production/monitoring/prometheus


### [chore: add notice for trusting vault backend's ssl certificate](https://github.com/Kong/docs.konghq.com/pull/6831) (2024-01-26)

This PR adds a notice in the AWS/GCP vault backend doc page, to remind user to trust system ca-certificates store so that SSL certificate returned by those cloud providers are being trusted by kong.



#### Modified

- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.6.x/kong-enterprise/secrets-management/backends/aws-sm


### [Fix: Use config.scopes instead of config.scopes_required in OIDC okta guide](https://github.com/Kong/docs.konghq.com/pull/6821) (2024-01-24)

The OIDC Okta guide incorrectly references `config.scopes_required` when it's actually configuring `config.scopes`.
Fixing that + some broken/outdated links + Dev Portal info that should be behind a conditional tag.
Also fixing the same links in the rest of the OIDC 3rd party guides.

https://konghq.atlassian.net/browse/DOCU-2277

#### Modified

- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/third-party/


### [Fix: Incorrect value listed for OIDC consumer claim field](https://github.com/Kong/docs.konghq.com/pull/6819) (2024-01-24)

Fix okta config doc bug, where the consumer claim field was listed as needing an application ID, but actually needs the name of the field that _contains_ the application ID.

https://konghq.atlassian.net/browse/DOCU-1456

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.6.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/2.6.x/developer-portal/administration/application-registration/okta-config
- https://docs.konghq.com/gateway/2.7.x/developer-portal/administration/application-registration/okta-config
- https://docs.konghq.com/gateway/2.8.x/developer-portal/administration/application-registration/okta-config


### [Update: Fix broken link](https://github.com/Kong/docs.konghq.com/pull/6818) (2024-01-23)

Fixed the broken link for the refresh grant type, previously pointing at
 /hub/kong-inc/openid-connect/how-to/authentication/refresh-token-grant 
but should be
/hub/kong-inc/openid-connect/how-to/authentication/refresh-token/

#### Modified

- https://docs.konghq.com/hub/kong-inc/openid-connect/overview/


### [Release: Gateway 3.5.0.3](https://github.com/Kong/docs.konghq.com/pull/6813) (2024-01-26)

Changelog and version bump for Gateway 3.5.0.3.

https://konghq.atlassian.net/browse/DOCU-3654

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Fix: update azure vault variable names](https://github.com/Kong/docs.konghq.com/pull/6810) (2024-01-25)

Updating the Azure Vault variable names as with the existing naming the Vault configuration doesn't work.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.6.x/production/deployment-topologies/db-less-and-declarative-config


### [Chore: fixes for a minor change in the Quickstart script output](https://github.com/Kong/docs.konghq.com/pull/6803) (2024-01-22)

Where the quickstart is used, the output changed slightly to indicate the gateway was ready.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.6.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.0.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.1.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.2.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.3.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.4.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.5.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.6.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.0.x/production/monitoring/statsd
- https://docs.konghq.com/gateway/3.1.x/production/monitoring/statsd
- https://docs.konghq.com/gateway/3.2.x/production/monitoring/statsd
- https://docs.konghq.com/gateway/3.3.x/production/monitoring/statsd
- https://docs.konghq.com/gateway/3.4.x/production/monitoring/statsd
- https://docs.konghq.com/gateway/3.5.x/production/monitoring/statsd
- https://docs.konghq.com/gateway/3.6.x/production/monitoring/statsd


### [chore(deps): bump kumahq/kuma-website from 79481f3c to e2f955bb](https://github.com/Kong/docs.konghq.com/pull/6802) (2024-01-22)

Auto upgrade PR log:

e2f955bb34bbb0ea6d34c798055fd240c06560bd fix(policies): update /policies page to /features (kumahq/kuma-website#1595)
df6130cd578a74487a7d5b15aab4d3c77d02d207 feat(dns): add instructions for customizing DNS configuration template (kumahq/kuma-website#1576)
42ee81041b9ef710d52400ba0f00ad40caeedd69 docs(policy): improve targetRef table (kumahq/kuma-website#1579)
e76bc74e24f3f3a7ce78fe18bcae8d062da553d1 chore(deps): update docs from repo source (kumahq/kuma-website#1586)
dc13a6856c94acf46d542f49b048ed15ef289422 docs(website): change button order (kumahq/kuma-website#1596)
37c87e64c8731cd3130e850bb016df2435ff5747 chore(policies): move all non targetRef policies in a subsection (kumahq/kuma-website#1592)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/7617451539).
labels: skip-changelog,review:general

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.6.x/production/deployment-topologies/db-less-and-declarative-config


### [Feat: Add ARM support to install-instructions-test](https://github.com/Kong/docs.konghq.com/pull/6795) (2024-01-23)

Use `qemu` to add arm64 tests for the install pages using GH Actions.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/amazon-linux
- https://docs.konghq.com/gateway/3.1.x/install/linux/amazon-linux
- https://docs.konghq.com/gateway/3.2.x/install/linux/amazon-linux
- https://docs.konghq.com/gateway/3.3.x/install/linux/amazon-linux
- https://docs.konghq.com/gateway/3.4.x/install/linux/amazon-linux
- https://docs.konghq.com/gateway/3.5.x/install/linux/amazon-linux
- https://docs.konghq.com/gateway/3.6.x/install/linux/amazon-linux
- https://docs.konghq.com/gateway-operator/1.2.x/production/horizontal-autoscaling/
- https://docs.konghq.com/gateway/3.0.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.1.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.2.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.3.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.4.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.5.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.6.x/key-concepts/routes/expressions


### [DOCU-3511: Refactor version is](https://github.com/Kong/docs.konghq.com/pull/6733) (2024-01-23)

Related [Jira ticket](https://konghq.atlassian.net/browse/DOCU-3511)

* Point jekyll-generator-single-source to the feature branch
* Set `latest: true` to the corresponding versions in `kong_versions.yml`
* Refactor Versions generators, we now have specific classes that handle
  setting the releases and versions information.
* Rename `app/_data/docs_nav_mesh_dev.yml` to
  `app/_data/docs_nav_mesh_2.6.x.yml`.
* Refactor Versions dropdown, we no longer need to maintain the routes
  and version info in the template.
* Don't include URLs from versions that are labeled to the sitemap
* Add `label: dev` to the unreleased version of mesh

### How it works

* We need to explicitly set `latest: true` to the corresponding versions in `app/_data/kong_versions.yml`
* For adding a new unreleased version, we need to add a new entry in `app/_data/kong_versions.yml`  with a label (it could be any string, e.g. `dev`, `next`, etc) and a new nav file, e.g. for gateway 

In `app/_data/kong_versions.yml`
```yaml 
- release: "3.5.x"
  ee-version: "3.5.0.2"
  ce-version: "3.5.0"
  edition: "gateway"
  latest: true # <- Set latest to the right version
  ...
- release: "3.6.x"
  ee-version: "3.6.0.0"
  ce-version: "3.6.0"
  edition: "gateway"
  label: dev # <- label the new unreleased version 
  ...
```
and we need to create the file `app/_data/docs_nav_gateway_3.6.x.yml`
The URLs generated for this version would be: `/gateway/dev/.../`, i.e. `/<edition>/<label or release>/...`.

Note that the file includes the actual release name in its name and not the label. 
This simplifies the release process. We just need to remove the `label` and set `latest: true` to it. 


### `page.release`

`page.release` is a [Liquid Drop](https://github.com/Shopify/liquid/wiki/Introduction-to-Drops) which is essentially an object that can be used in the templates (code [here](https://github.com/Kong/jekyll-generator-single-source/blob/82966bb101a62400839d35c06c0d406d5a1439d5/lib/jekyll/generator-single-source/liquid/drops/release.rb)). 

It's a replacement for `page.kong_version`, and whenever it is used in a template the [to_s](https://github.com/Kong/jekyll-generator-single-source/blob/82966bb101a62400839d35c06c0d406d5a1439d5/lib/jekyll/generator-single-source/product/release.rb#L45-L52) method gets called. It returns the release's label if it has one, or the release's value, e.g `3.4.x`.

It has a few other methods defined that should be useful:
* `value`: the actual release defined in `kong_versions.yml`, e.g. `3.4.x`.
* `label`: the name of the label.
* `latest?`: returns true if the release is marked as `latest` in `kong_versions.yml`.
* `versions`:  returns a hash with the corresponding versions defined in `kong_versions.yml`. For `gateway` it returns the versions without the suffix, i.e.  `{ 'ee' => '3.0.0.0', 'ce' => '3.0.0'  }`, for products that only have one version it returns a has with `default` as key, e.g. `{ 'default' => '2.6.x' }`.

The only time when we can't rely on the `to_s` method and we need to use `page.release.value` is when it is used as key when accessing hashes, like the [compatibility table](https://github.com/Kong/docs.konghq.com/blob/8508a4d9479b73a40390af8eeae0ba65598f73c8/app/gateway/2.6.x/compatibility.md#L12).

#### Modified

Nearly every page. See:
- https://docs.konghq.com/deck/
- https://docs.konghq.com/gateway/unreleased/
- https://docs.konghq.com/gateway-operator/unreleased/
- https://docs.konghq.com/kubernetes-ingress-controller/unreleased/
- https://docs.konghq.com/mesh/dev/
- https://docs.konghq.com/hub/

## Week 3

### [Release: decK 1.30.0](https://github.com/Kong/docs.konghq.com/pull/6785) (2024-01-19)

Version bump for decK 1.30 + any relevant updates to decK CLI docs. 
Mainly, this update softens the language of the warnings to make it clear that the old decK commands will still work.

#### Modified

- https://docs.konghq.com/deck/1.30.x/reference/deck_convert/
- https://docs.konghq.com/deck/1.30.x/reference/deck_diff/
- https://docs.konghq.com/deck/1.30.x/reference/deck_gateway_diff/
- https://docs.konghq.com/deck/1.30.x/reference/deck_gateway_dump/
- https://docs.konghq.com/deck/1.30.x/reference/deck_gateway_ping/
- https://docs.konghq.com/deck/1.30.x/reference/deck_gateway_reset/
- https://docs.konghq.com/deck/1.30.x/reference/deck_gateway_sync/
- https://docs.konghq.com/deck/1.30.x/reference/deck_gateway_validate/
- https://docs.konghq.com/deck/1.30.x/reference/deck_ping/
- https://docs.konghq.com/deck/1.30.x/reference/deck_reset/
- https://docs.konghq.com/deck/1.30.x/reference/deck_sync/
- https://docs.konghq.com/deck/1.30.x/reference/deck_validate/

### [Feat: AppDynamics certificate env variables](https://github.com/Kong/docs.konghq.com/pull/6784) (2024-01-19)

Document missing certificate environment variables for AppDynamics, [added in 3.4.3.3.](https://docs.konghq.com/gateway/changelog/#plugins-4)

Values only appear in the 3.4.x version table. Will add to 3.5 when the patch is released as well.

Also adding a conditional for 3.6, which will remain hidden until we have a 3.6 version.

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/overview/


### [Fix 2.8.4.6  changelog.md](https://github.com/Kong/docs.konghq.com/pull/6777) (2024-01-18)

Fix version number in changelog.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Changelog and version bump for Gateway 2.8.4.6](https://github.com/Kong/docs.konghq.com/pull/6762) (2024-01-17)

Changelog and version bump for upcoming 2.8.4.6 patch.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [docs(mesh): update docs and changelog](https://github.com/Kong/docs.konghq.com/pull/6760) (2024-01-16)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/7540542509)

#### Modified

- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_circuitbreakers.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_containerpatches.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_dataplaneinsights.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_dataplanes.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_externalservices.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_faultinjections.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_healthchecks.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshaccesslogs.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshcircuitbreakers.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshes.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshfaultinjections.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshgatewayconfigs.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshgatewayinstances.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshgatewayroutes.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshgateways.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshglobalratelimits.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshhealthchecks.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshhttproutes.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshinsights.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshloadbalancingstrategies.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshmetrics.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshopas.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshproxypatches.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshretries.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshtcproutes.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshtimeouts.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshtraces.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_meshtrafficpermissions.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_proxytemplates.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_ratelimits.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_retries.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_serviceinsights.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_timeouts.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_trafficlogs.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_trafficpermissions.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_trafficroutes.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_traffictraces.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_virtualoutbounds.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_zoneegresses.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_zoneegressinsights.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_zoneingresses.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_zoneingressinsights.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_zoneinsights.yaml
- https://docs.konghq.com/assets/mesh/dev/raw/crds/kuma.io_zones.yaml


### [Fix linked to `Verify signatures for Signed Images`](https://github.com/Kong/docs.konghq.com/pull/6757) (2024-01-16)

Fix the broken link that came up in the last [scheduled broken link action](https://github.com/Kong/docs.konghq.com/actions/runs/7515703424/job/20459932899) run.

#### Modified

- https://docs.konghq.com/deck/1.28.x/reference/deck_gateway_diff/
- https://docs.konghq.com/deck/1.29.x/reference/deck_gateway_diff/
- https://docs.konghq.com/deck/1.30.x/reference/deck_gateway_diff/


### [Release: Gateway version 3.4.3.3](https://github.com/Kong/docs.konghq.com/pull/6750) (2024-01-17)

EE changelog here: https://github.com/Kong/kong-ee/pull/7816

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Feat: Split+consolidate OIDC plugin docs into many guides](https://github.com/Kong/docs.konghq.com/pull/6747) (2024-01-16)

#### Summary
Big OpenID Connect doc consolidation + split out how-to guides + cleanup.
https://konghq.atlassian.net/browse/DOCU-3384

Changes in this PR:
* Moving the OpenID Connect guides that are buried in Gateway into the OIDC plugin doc
* Splitting out all the flow guides into their own pages for better discoverability/navigation
* Keycloak + gateway setup are now collapsible prereq sections that we can reuse in every OIDC demo
* Cross-linking to all the other OIDC content that's scattered all over our docs, for all the bits where OIDC is used internally
* Remade all the diagrams with mermaid.js; deleted all the images that are no longer in use

The scope of the work is scaled back here somewhat to get this project moving. Not doing yet:
* Use opinionated examples in how-to guides
* Convert everything httpie into curl
* All the testing
* All the cleanup

#### Added

- https://docs.konghq.com/hub/kong-inc/openid-connect/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authentication/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authorization/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authorization/
- https://docs.konghq.com/hub/kong-inc/openid-connect/how-to/authorization/
- https://docs.konghq.com/hub/kong-inc/openid-connect/overview/
- https://docs.konghq.com/hub/kong-inc/openid-connect/overview/

#### Modified

- https://docs.konghq.com/hub/kong-inc/openid-connect/overview/
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/dev-portal/authentication/oidc
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/dev-portal/authentication/oidc
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/dev-portal/authentication/oidc
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/dev-portal/authentication/oidc
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/dev-portal/authentication/oidc
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/plugins/oidc
- https://docs.konghq.com/breadcrumb_titles.yml

## Week 2


### [Update: Prerequisite to review version compatibility before Gateway upgrade](https://github.com/Kong/docs.konghq.com/pull/6740) (2024-01-10)

Customer noted that the instructions to review OS compatibility are buried too deeply within the upgrade guide, and they missed them on their first read through the guide.

Adding the links/instructions to review compatibility as the first step, as no upgrade can be performed if your system doesn't support it.

#### Modified

- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/signed-images
- https://docs.konghq.com/gateway/3.0.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.1.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.2.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.3.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.4.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.5.x/upgrade/lts-upgrade/


### [Add enterprise image signing verification docs](https://github.com/Kong/docs.konghq.com/pull/6730) (2024-01-12)

These are the customer-facing docs needed to allow customers to take full advantage of the recent changes to the Kong Enterprise build that implement `cosign`-based image signing.

- Confluence: [Solutions Document](https://konghq.atlassian.net/wiki/spaces/KS/pages/3261333515/Solution+-+Image+Container+Signing+-+Cosign#Verifying-the-EE-GW-image-integrity)
- Jira: [SEC-973](https://konghq.atlassian.net/browse/SEC-973)
- https://github.com/Kong/kong-ee/pull/6797

#### Added

- https://docs.konghq.com/gateway/3.0.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.1.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.2.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.3.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.4.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.5.x/upgrade/lts-upgrade/


### [Update: Rework style guide and add guidelines for writing recommendations](https://github.com/Kong/docs.konghq.com/pull/6717) (2024-01-08)

The Kong docs style guide was missing info on writing recommendations. I ran into some phrasing during a review and wanted to reference our guide, and realized that we never documented it (even though [we did discuss it and decided on a style](https://konghq.atlassian.net/wiki/spaces/KD/pages/2797568009/Standards+and+guidelines#:~:text=Standardize%20recommendations)).

Also took this opportunity to split up the "best practices" table into separate sections and add more info. 
* One of the main benefits of having a style guide is being able to link to specific guidelines, and that table made it difficult to do that + didn't have room to add more explanation. 
* As well, when you scrolled past a certain point, you couldn't tell which column was "Do" and which was "Do not" anymore.
* Removed the "Not british english" phrase from the language section. Seemed strange that we were singling out just British English, and there's no sense in trying to exhaustively list all varieties of English that are docs are not.
* Did some reorganization.

#### Modified

- https://docs.konghq.com/contributing/style-guide


### [Add internal/external traffic KIC guide](https://github.com/Kong/docs.konghq.com/pull/6715) (2024-01-08)

Add a guide that explains how to run internal/external ingresses using KIC

#### Added

- https://docs.konghq.com/gateway/3.0.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.1.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.2.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.3.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.4.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.5.x/upgrade/lts-upgrade/


### [Revamped Gateway on Kubernetes install guide](https://github.com/Kong/docs.konghq.com/pull/6695) (2024-01-11)

Rework the Kubernetes installation guide for Kong Gateway

#### Added

- https://docs.konghq.com/gateway/3.0.x/install/kubernetes/admin/
- https://docs.konghq.com/gateway/3.1.x/install/kubernetes/admin/
- https://docs.konghq.com/gateway/3.2.x/install/kubernetes/admin/
- https://docs.konghq.com/gateway/3.3.x/install/kubernetes/admin/
- https://docs.konghq.com/gateway/3.4.x/install/kubernetes/admin/
- https://docs.konghq.com/gateway/3.5.x/install/kubernetes/admin/
- https://docs.konghq.com/gateway/3.0.x/install/kubernetes/manager/
- https://docs.konghq.com/gateway/3.1.x/install/kubernetes/manager/
- https://docs.konghq.com/gateway/3.2.x/install/kubernetes/manager/
- https://docs.konghq.com/gateway/3.3.x/install/kubernetes/manager/
- https://docs.konghq.com/gateway/3.4.x/install/kubernetes/manager/
- https://docs.konghq.com/gateway/3.5.x/install/kubernetes/manager/
- https://docs.konghq.com/gateway/3.0.x/install/kubernetes/portal/
- https://docs.konghq.com/gateway/3.1.x/install/kubernetes/portal/
- https://docs.konghq.com/gateway/3.2.x/install/kubernetes/portal/
- https://docs.konghq.com/gateway/3.3.x/install/kubernetes/portal/
- https://docs.konghq.com/gateway/3.4.x/install/kubernetes/portal/
- https://docs.konghq.com/gateway/3.0.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.1.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.2.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.3.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.4.x/install/kubernetes/proxy/
- https://docs.konghq.com/gateway/3.5.x/install/kubernetes/proxy/

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/support-policy
- https://docs.konghq.com/moved_urls.yml


### [feat(acl): add consumer-group support and examples](https://github.com/Kong/docs.konghq.com/pull/6694) (2024-01-12)

For: https://github.com/Kong/kong-ee/pull/7603
Add support for the ACL plugin to understand consumer-groups. This allows to use (core) consumer-groups to be used in the "allow|deny" fields.


#### Added

- https://docs.konghq.com/hub/kong-inc/acl/how-to/

#### Modified

- https://docs.konghq.com/hub/kong-inc/acl/overview/


### [doc(kic) add reference grant guide](https://github.com/Kong/docs.konghq.com/pull/6677) (2024-01-08)

For https://github.com/Kong/kubernetes-ingress-controller/issues/5154
 
Add a guide that covers using Gateway API resources with KIC across namespaces, including references to a Gateway from another namespace using listener allowedRoutes and references from an HTTPRoute to a Service in another namespace using a ReferenceGrant.

#### Added

- https://docs.konghq.com/gateway/3.0.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.1.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.2.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.3.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.4.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.5.x/upgrade/lts-upgrade/


### [feat(new-consumer): release notes and reference updates](https://github.com/Kong/docs.konghq.com/pull/6663) (2024-01-11)

For the [new Consumer dimension](https://konghq.aha.io/features/KP-277) coming next week, I added release notes and also updated our reference doc.

#### Modified

- https://docs.konghq.com/konnect/analytics/reference
- https://docs.konghq.com/konnect/updates


## Week 1



### [fix: typo in ingress redirect docs](https://github.com/Kong/docs.konghq.com/pull/6714) (2024-01-03)

Fix type in redirect docs

#### Modified

- https://docs.konghq.com/gateway/3.5.x/production/debug-request


### [Fix: Spacing on gateway overview page](https://github.com/Kong/docs.konghq.com/pull/6711) (2024-01-02)

`if_version` tags aren't spaced out correctly, so they're causing the following issues:

3.5:
![Screenshot 2024-01-02 at 9 46 10 AM](https://github.com/Kong/docs.konghq.com/assets/54370747/538c4d26-510e-4b07-ba39-f4321d7c33e7)

3.4 and earlier:
![Screenshot 2024-01-02 at 9 45 55 AM](https://github.com/Kong/docs.konghq.com/assets/54370747/eaa019ac-e6bf-4242-8686-8701161a7be5)

Fixing by splitting out `if_version` tags, so that they don't encompass part of a still-existing section. The previous approach is harder to maintain + causes these spacing issues.

#### Modified

- https://docs.konghq.com/gateway/3.5.x/production/debug-request


### [fix: use more informative example for request-debug docs](https://github.com/Kong/docs.konghq.com/pull/6702) (2024-01-02)



Currently, the example output of request-debug in docs is too simple, so I replace it with a more better one.

#### Modified

- https://docs.konghq.com/gateway/3.5.x/production/debug-request


### [rewrite the loadbalancing document](https://github.com/Kong/docs.konghq.com/pull/6689) (2024-01-05)


Rewrite of the outdated page on loadbalancing
 


#### Modified

- https://docs.konghq.com/gateway/3.0.x/how-kong-works/load-balancing
- https://docs.konghq.com/gateway/3.1.x/how-kong-works/load-balancing
- https://docs.konghq.com/gateway/3.2.x/how-kong-works/load-balancing
- https://docs.konghq.com/gateway/3.3.x/how-kong-works/load-balancing
- https://docs.konghq.com/gateway/3.4.x/how-kong-works/load-balancing
- https://docs.konghq.com/gateway/3.5.x/how-kong-works/load-balancing
- https://docs.konghq.com/gateway/3.0.x/production/blue-green
- https://docs.konghq.com/gateway/3.1.x/production/blue-green
- https://docs.konghq.com/gateway/3.2.x/production/blue-green
- https://docs.konghq.com/gateway/3.3.x/production/blue-green
- https://docs.konghq.com/gateway/3.4.x/production/blue-green
- https://docs.konghq.com/gateway/3.5.x/production/blue-green
- https://docs.konghq.com/gateway/3.0.x/production/canary
- https://docs.konghq.com/gateway/3.1.x/production/canary
- https://docs.konghq.com/gateway/3.2.x/production/canary
- https://docs.konghq.com/gateway/3.3.x/production/canary
- https://docs.konghq.com/gateway/3.4.x/production/canary
- https://docs.konghq.com/gateway/3.5.x/production/canary


### [feat: Add KIC configFrom guide](https://github.com/Kong/docs.konghq.com/pull/6680) (2024-01-03)

Add a guide that shows how to use `configFrom` when configuring a plugin config from k8s secrets

#### Added

- https://docs.konghq.com/gateway/3.5.x/production/debug-request


### [feat: Plugin guide to rate limit requests based on peak and off-peak times](https://github.com/Kong/docs.konghq.com/pull/6634) (2024-01-05)

Created a how to guide based on https://konghq.atlassian.net/browse/DOCU-3546 for “How to rate limit Kong Gateway based on peak/non-peak time”.

Uses the pre-function and rate limiting advanced plugins together.

#### Added

- https://docs.konghq.com/hub/kong-inc/pre-function/how-to/
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/how-to/

#### Modified

- https://docs.konghq.com/hub/kong-inc/pre-function/overview/


### [feat: Create Benchmark Guide for Kong Gateway](https://github.com/Kong/docs.konghq.com/pull/6630) (2024-01-05)

Convert internal benchmark performance KB into documentation. 


#### Added

- https://docs.konghq.com/gateway/3.0.x/how-kong-works/load-balancing
- https://docs.konghq.com/gateway/3.1.x/how-kong-works/load-balancing
- https://docs.konghq.com/gateway/3.2.x/how-kong-works/load-balancing
- https://docs.konghq.com/gateway/3.3.x/how-kong-works/load-balancing
- https://docs.konghq.com/gateway/3.4.x/how-kong-works/load-balancing
- https://docs.konghq.com/gateway/3.5.x/how-kong-works/load-balancing


### [(feat) how to guides for mTLS-auth plugin ](https://github.com/Kong/docs.konghq.com/pull/6626) (2024-01-04)

Split out content from the mTLS-auth landing page into a how-to section + some cleanup.
 

#### Added

- https://docs.konghq.com/hub/kong-inc/mtls-auth/how-to/
- https://docs.konghq.com/hub/kong-inc/mtls-auth/how-to/

#### Modified

- https://docs.konghq.com/hub/kong-inc/mtls-auth/overview/

## Week 50

### [Make port 8100 consistent in all examples](https://github.com/Kong/docs.konghq.com/pull/6666) (2023-12-15)

Port 8001 is used in the example curl command, but port 8100 is the one used in the rest of the documentation. Changing curl port to 8100.

#### Modified

- https://docs.konghq.com/gateway/3.3.x/production/monitoring/readiness-check
- https://docs.konghq.com/gateway/3.4.x/production/monitoring/readiness-check
- https://docs.konghq.com/gateway/3.5.x/production/monitoring/readiness-check


### [(chore) remove 3.1 from supported versions](https://github.com/Kong/docs.konghq.com/pull/6659) (2023-12-14)

3.1 is moving into sunset support, 12 months after the initial release. 
 
#### Modified

- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/dev-portal/customize/alternate-openapi-renderer
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/dev-portal/customize/alternate-openapi-renderer
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/dev-portal/customize/alternate-openapi-renderer
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/dev-portal/customize/alternate-openapi-renderer
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/dev-portal/customize/alternate-openapi-renderer
- https://docs.konghq.com/gateway/3.2.x/support/third-party
- https://docs.konghq.com/gateway/3.3.x/support/third-party
- https://docs.konghq.com/gateway/3.4.x/support/third-party
- https://docs.konghq.com/gateway/3.5.x/support/third-party


### [docs(mesh): update docs and changelog](https://github.com/Kong/docs.konghq.com/pull/6658) (2023-12-14)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/7206065291)

#### Added

- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshmetrics.yaml

#### Modified

- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshfaultinjections.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshloadbalancingstrategies.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshretries.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshtraces.yaml
- https://docs.konghq.com/mesh/dev/kuma-cp.yaml


### [(feat) 3.4.3.1 changelog](https://github.com/Kong/docs.konghq.com/pull/6651) (2023-12-16)

Changelog for CE/EE release of 3.4.3.1

Source file  https://github.com/Kong/kong-ee/pull/7567/files

#### Modified

- https://docs.konghq.com/gateway/changelog


### [docs(mesh): update docs and changelog](https://github.com/Kong/docs.konghq.com/pull/6648) (2023-12-12)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/7181558457)

#### Modified

- https://docs.konghq.com/mesh/raw/CHANGELOG


### [Fix some SEO issues](https://github.com/Kong/docs.konghq.com/pull/6647) (2023-12-12)

Fix some of the issues listed in the latest SEO audit.
* Add trailing `/` to plugin categories in the main nav
* Add non-single-sourced plugin pages to the sitemap
* Remove `nofollow` from Kong's logo and community link
* Downcase URLs in the sitemap: By default, Netlify downcases all the URLs segments and adds redirects
to those. See https://answers.netlify.com/t/my-url-paths-are-forced-into-lowercase/1659/
* Prevent `code-snippets/spec-renderer.html` from being rendered and update all its references to point to github. Added redirects to github too.

#### Modified

- https://docs.konghq.com/gateway/3.2.x/support/third-party
- https://docs.konghq.com/gateway/3.3.x/support/third-party
- https://docs.konghq.com/gateway/3.4.x/support/third-party
- https://docs.konghq.com/gateway/3.5.x/support/third-party
- https://docs.konghq.com/gateway/2.7.x/developer-portal/theme-customization/alternate-openapi-renderer
- https://docs.konghq.com/gateway/2.8.x/developer-portal/theme-customization/alternate-openapi-renderer


### [Update debug-request.md](https://github.com/Kong/docs.konghq.com/pull/6645) (2023-12-12)

The previous wording is confusing as it mentioned client.  This feature is for admins or internal teams monitoring gateway performance. It is not for a enduser who is making API calls. The usage of `client` in the previous statement may cause confusion as to who this feature is meant for.

#### Modified

- https://docs.konghq.com/gateway/3.5.x/production/debug-request


### [docs(gateway-upgrade): fix an argument error](https://github.com/Kong/docs.konghq.com/pull/6639) (2023-12-11)

Fix an error from https://github.com/Kong/docs.konghq.com/pull/6534.

#### Modified

- https://docs.konghq.com/gateway/3.2.x/support/third-party
- https://docs.konghq.com/gateway/3.3.x/support/third-party
- https://docs.konghq.com/gateway/3.4.x/support/third-party
- https://docs.konghq.com/gateway/3.5.x/support/third-party


### [Feat: Add some basic docs for making diagrams with mermaid](https://github.com/Kong/docs.konghq.com/pull/6637) (2023-12-12)

Instructions on using mermaid.js to make diagrams in the docs.

#### Added

- https://docs.konghq.com/contributing/diagrams


### [chore(deps): bump kumahq/kuma-website from 6c4168f4 to 58bbbaca](https://github.com/Kong/docs.konghq.com/pull/6611) (2023-12-11)

Auto upgrade PR log:

58bbbacaac6aa63bf9241a3e98495cfa99378122 chore(deps): update docs from repo source (kumahq/kuma-website#1544)
a8b0a77ab74eefb3030f497a47d9929d28fe76da chore(deps): update docs from repo source (kumahq/kuma-website#1543)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/7161247872).
labels: skip-changelog,review:general

#### Modified

- https://docs.konghq.com/gateway/3.2.x/support/third-party
- https://docs.konghq.com/gateway/3.3.x/support/third-party
- https://docs.konghq.com/gateway/3.4.x/support/third-party
- https://docs.konghq.com/gateway/3.5.x/support/third-party

## Week 49

### [Fix: Remove inaccurate note and links about decK in db-less mode doc](https://github.com/Kong/docs.konghq.com/pull/6633) (2023-12-08)

decK is not meant for DB-less mode, since it uses the Admin API to manage configs. There was some inaccurate info in the docs about this, suggesting that decK _can_ be used for DB-less. Removing that and adding a note on the difference between declarative and decK config.

Issue reported on Slack.

#### Modified

- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/backends/azure-key-vaults
- https://docs.konghq.com/deck/1.12.x/guides/konnect
- https://docs.konghq.com/deck/1.13.x/guides/konnect
- https://docs.konghq.com/deck/1.14.x/guides/konnect
- https://docs.konghq.com/deck/1.15.x/guides/konnect
- https://docs.konghq.com/deck/1.16.x/guides/konnect
- https://docs.konghq.com/deck/1.17.x/guides/konnect
- https://docs.konghq.com/deck/1.18.x/guides/konnect
- https://docs.konghq.com/deck/1.19.x/guides/konnect
- https://docs.konghq.com/deck/1.20.x/guides/konnect
- https://docs.konghq.com/deck/1.21.x/guides/konnect
- https://docs.konghq.com/deck/1.22.x/guides/konnect
- https://docs.konghq.com/deck/1.23.x/guides/konnect
- https://docs.konghq.com/deck/1.24.x/guides/konnect/
- https://docs.konghq.com/deck/1.25.x/guides/konnect/
- https://docs.konghq.com/deck/1.26.x/guides/konnect/
- https://docs.konghq.com/deck/1.27.x/guides/konnect/
- https://docs.konghq.com/deck/1.28.x/guides/konnect/
- https://docs.konghq.com/deck/1.29.x/guides/konnect/


### [Fix: Add cross-links between kong.conf guides and reference](https://github.com/Kong/docs.konghq.com/pull/6631) (2023-12-07)

There are no links to the kong.conf reference from the kong.conf guides, so users are having trouble finding the reference.
Adding links to fix that.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/deck/1.12.x/guides/konnect
- https://docs.konghq.com/deck/1.13.x/guides/konnect
- https://docs.konghq.com/deck/1.14.x/guides/konnect
- https://docs.konghq.com/deck/1.15.x/guides/konnect
- https://docs.konghq.com/deck/1.16.x/guides/konnect
- https://docs.konghq.com/deck/1.17.x/guides/konnect
- https://docs.konghq.com/deck/1.18.x/guides/konnect
- https://docs.konghq.com/deck/1.19.x/guides/konnect
- https://docs.konghq.com/deck/1.20.x/guides/konnect
- https://docs.konghq.com/deck/1.21.x/guides/konnect
- https://docs.konghq.com/deck/1.22.x/guides/konnect
- https://docs.konghq.com/deck/1.23.x/guides/konnect
- https://docs.konghq.com/deck/1.24.x/guides/konnect/
- https://docs.konghq.com/deck/1.25.x/guides/konnect/
- https://docs.konghq.com/deck/1.26.x/guides/konnect/
- https://docs.konghq.com/deck/1.27.x/guides/konnect/
- https://docs.konghq.com/deck/1.28.x/guides/konnect/
- https://docs.konghq.com/deck/1.29.x/guides/konnect/
- https://docs.konghq.com/gateway/3.4.x/reference/configuration
- https://docs.konghq.com/gateway/3.5.x/reference/configuration


### [doc(decK): Update authentication instructions](https://github.com/Kong/docs.konghq.com/pull/6629) (2023-12-08)

Remove references to username/password auth for latest versions of decK in order to promote usage of tokens instead of passwords for authentication.

#### Modified

- https://docs.konghq.com/gateway/3.4.x/reference/configuration
- https://docs.konghq.com/gateway/3.5.x/reference/configuration


### [Add a step to publish API Product and version docs](https://github.com/Kong/docs.konghq.com/pull/6620) (2023-12-07)

The step-by-step process is clear; however, one critical step was missing - guiding users on how to publish the API documentation and a dynamic API reference to the public portal. To address this issue, I am adding an extra step that instructs users on how to publish their API Product and version documentation.

#### Modified

- https://docs.konghq.com/konnect/getting-started/publish-service


### [tls-handshake-modifier is compatible with Konnect](https://github.com/Kong/docs.konghq.com/pull/6618) (2023-12-06)

Reported by @hbagdi; this plugin is compatible with Konnect.

#### Modified

- https://docs.konghq.com/hub/kong-inc/tls-handshake-modifier/_metadata.yml


### [fix: add missing references to Azure Key Vault](https://github.com/Kong/docs.konghq.com/pull/6614) (2023-12-07)

Support for Azure Key Vault as a secrets backend was added in Gateway 3.5. This PR adds references to this support in the 3rd party tools page and Gateway Enterprise index.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/environment-variables
- https://docs.konghq.com/gateway/3.1.x/production/environment-variables
- https://docs.konghq.com/gateway/3.2.x/production/environment-variables
- https://docs.konghq.com/gateway/3.3.x/production/environment-variables
- https://docs.konghq.com/gateway/3.4.x/production/environment-variables
- https://docs.konghq.com/gateway/3.5.x/production/environment-variables


### [docs(mesh): update docs and changelog](https://github.com/Kong/docs.konghq.com/pull/6613) (2023-12-06)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/7111781984)

#### Modified

- https://docs.konghq.com/mesh/2.5.x/kuma-cp.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshaccesslogs.yaml
- https://docs.konghq.com/mesh/dev/kuma-cp.yaml


### [Update:JWT plugin overview section](https://github.com/Kong/docs.konghq.com/pull/6612) (2023-12-08)

Fixes: https://konghq.atlassian.net/browse/DOCU-2347
updated the incorrect examples section.
No validation done.

#### Modified

- https://docs.konghq.com/hub/kong-inc/jwt/overview/


### [tls-metadata-headers is compatible with Konnect](https://github.com/Kong/docs.konghq.com/pull/6607) (2023-12-05)

Reported by Fero. This is a DP only plugin which _is_ compatible with Konnect

#### Modified

- https://docs.konghq.com/hub/kong-inc/tls-metadata-headers/_metadata.yml


### [fix: Mermaid rubocop fail ](https://github.com/Kong/docs.konghq.com/pull/6602) (2023-12-04)

hopefully addressing the issue related to method length

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/environment-variables
- https://docs.konghq.com/gateway/3.1.x/production/environment-variables
- https://docs.konghq.com/gateway/3.2.x/production/environment-variables
- https://docs.konghq.com/gateway/3.3.x/production/environment-variables
- https://docs.konghq.com/gateway/3.4.x/production/environment-variables
- https://docs.konghq.com/gateway/3.5.x/production/environment-variables


### [update: OAuth 2.0 Authentication](https://github.com/Kong/docs.konghq.com/pull/6600) (2023-12-04)

Add a note about not recommended for Production environment.
Fixes: https://konghq.atlassian.net/browse/DOCU-2310
 
#### Modified

- https://docs.konghq.com/hub/kong-inc/oauth2/overview/


### [docs(mesh): update docs and changelog](https://github.com/Kong/docs.konghq.com/pull/6599) (2023-12-04)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/7087328167)

#### Modified

- https://docs.konghq.com/mesh/dev/kuma-cp.yaml


### [chore(deps): bump kumahq/kuma-website from 74af1337 to 609a37e9](https://github.com/Kong/docs.konghq.com/pull/6598) (2023-12-04)

Auto upgrade PR log:

609a37e902fe7d2691df3e9c7830f5ad220de450 chore(deps): bump @adobe/css-tools from 4.3.1 to 4.3.2 (kumahq/kuma-website#1540)
2e440e044271ca41d4619b194783836c1c067dfe chore(deps): update docs from repo source (kumahq/kuma-website#1541)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/7080323180).
labels: skip-changelog,review:general

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/environment-variables
- https://docs.konghq.com/gateway/3.1.x/production/environment-variables
- https://docs.konghq.com/gateway/3.2.x/production/environment-variables
- https://docs.konghq.com/gateway/3.3.x/production/environment-variables
- https://docs.konghq.com/gateway/3.4.x/production/environment-variables
- https://docs.konghq.com/gateway/3.5.x/production/environment-variables


### [Fix: Azure vault env variables](https://github.com/Kong/docs.konghq.com/pull/6595) (2023-12-04)

To set any environment variables to configure Kong Gateway (kong.conf), each env variable must be prefixed with `KONG_`. These prefixes, along with the `VAULT` portion of each config parameter, are missing from the example codeblocks in the Azure Vaults doc.

See https://docs.konghq.com/gateway/latest/reference/configuration/#vault_azure_vault_uri for the relevant parameter names, which all start with `vault`.

#### Modified

- https://docs.konghq.com/deck/1.12.x/guides/konnect
- https://docs.konghq.com/deck/1.13.x/guides/konnect
- https://docs.konghq.com/deck/1.14.x/guides/konnect
- https://docs.konghq.com/deck/1.15.x/guides/konnect
- https://docs.konghq.com/deck/1.16.x/guides/konnect
- https://docs.konghq.com/deck/1.17.x/guides/konnect
- https://docs.konghq.com/deck/1.18.x/guides/konnect
- https://docs.konghq.com/deck/1.19.x/guides/konnect
- https://docs.konghq.com/deck/1.20.x/guides/konnect
- https://docs.konghq.com/deck/1.21.x/guides/konnect
- https://docs.konghq.com/deck/1.22.x/guides/konnect
- https://docs.konghq.com/deck/1.23.x/guides/konnect
- https://docs.konghq.com/deck/1.24.x/guides/konnect/
- https://docs.konghq.com/deck/1.25.x/guides/konnect/
- https://docs.konghq.com/deck/1.26.x/guides/konnect/
- https://docs.konghq.com/deck/1.27.x/guides/konnect/
- https://docs.konghq.com/deck/1.28.x/guides/konnect/
- https://docs.konghq.com/deck/1.29.x/guides/konnect/


### [feat(plugin): Rate Limiting Advanced window types explanation](https://github.com/Kong/docs.konghq.com/pull/6586) (2023-12-08)

https://konghq.atlassian.net/browse/DOCU-3397
Turn KB into doc: https://support.konghq.com/support/s/article/What-is-the-expected-behaviour-for-the-Rate-Limiting-Advanced-plugin-with-sliding-window-strategy

#### Modified

- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/overview/


### [kic: update and extend gRPC how-to](https://github.com/Kong/docs.konghq.com/pull/6567) (2023-12-04)

closes https://github.com/Kong/kubernetes-ingress-controller/issues/5134

For HTTPRoute (support was added in https://github.com/Kong/kubernetes-ingress-controller/pull/5128, so KIC >= 3.1.0 wii support it). For ingress, it works for older versions too

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/environment-variables
- https://docs.konghq.com/gateway/3.1.x/production/environment-variables
- https://docs.konghq.com/gateway/3.2.x/production/environment-variables
- https://docs.konghq.com/gateway/3.3.x/production/environment-variables
- https://docs.konghq.com/gateway/3.4.x/production/environment-variables
- https://docs.konghq.com/gateway/3.5.x/production/environment-variables


### [Update auth0.md to include developer managed scopes UI steps](https://github.com/Kong/docs.konghq.com/pull/6550) (2023-12-08)

#### Modified

- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/auth0
- https://docs.konghq.com/konnect/updates


### [Feat: Gateway Upgrade Refactoring + LTS upgrade guide](https://github.com/Kong/docs.konghq.com/pull/6534) (2023-12-08)

This PR add general Gateway upgrade docs and an LTS 2.8 > LTS 3.4 upgrade guide. These two pieces of content are extremely interdependent, so they have to be published together.

https://konghq.atlassian.net/browse/DOCU-3244
https://konghq.atlassian.net/browse/DOCU-3193

#### Added

- https://docs.konghq.com/gateway/3.0.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.1.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.2.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.3.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.4.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.5.x/upgrade/backup-and-restore/
- https://docs.konghq.com/gateway/3.0.x/upgrade/blue-green/
- https://docs.konghq.com/gateway/3.1.x/upgrade/blue-green/
- https://docs.konghq.com/gateway/3.2.x/upgrade/blue-green/
- https://docs.konghq.com/gateway/3.3.x/upgrade/blue-green/
- https://docs.konghq.com/gateway/3.4.x/upgrade/blue-green/
- https://docs.konghq.com/gateway/3.5.x/upgrade/blue-green/
- https://docs.konghq.com/gateway/3.0.x/upgrade/dual-cluster/
- https://docs.konghq.com/gateway/3.1.x/upgrade/dual-cluster/
- https://docs.konghq.com/gateway/3.2.x/upgrade/dual-cluster/
- https://docs.konghq.com/gateway/3.3.x/upgrade/dual-cluster/
- https://docs.konghq.com/gateway/3.4.x/upgrade/dual-cluster/
- https://docs.konghq.com/gateway/3.5.x/upgrade/dual-cluster/
- https://docs.konghq.com/gateway/3.0.x/upgrade/in-place/
- https://docs.konghq.com/gateway/3.1.x/upgrade/in-place/
- https://docs.konghq.com/gateway/3.2.x/upgrade/in-place/
- https://docs.konghq.com/gateway/3.3.x/upgrade/in-place/
- https://docs.konghq.com/gateway/3.4.x/upgrade/in-place/
- https://docs.konghq.com/gateway/3.5.x/upgrade/in-place/
- https://docs.konghq.com/gateway/3.0.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.1.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.2.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.3.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.4.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.5.x/upgrade/lts-upgrade/
- https://docs.konghq.com/gateway/3.0.x/upgrade/rolling-upgrade/
- https://docs.konghq.com/gateway/3.1.x/upgrade/rolling-upgrade/
- https://docs.konghq.com/gateway/3.2.x/upgrade/rolling-upgrade/
- https://docs.konghq.com/gateway/3.3.x/upgrade/rolling-upgrade/
- https://docs.konghq.com/gateway/3.4.x/upgrade/rolling-upgrade/
- https://docs.konghq.com/gateway/3.5.x/upgrade/rolling-upgrade/

#### Modified

- https://docs.konghq.com/deck/1.10.x/installation
- https://docs.konghq.com/deck/1.11.x/installation
- https://docs.konghq.com/deck/1.12.x/installation
- https://docs.konghq.com/deck/1.13.x/installation
- https://docs.konghq.com/deck/1.14.x/installation
- https://docs.konghq.com/deck/1.15.x/installation
- https://docs.konghq.com/deck/1.16.x/installation
- https://docs.konghq.com/deck/1.17.x/installation
- https://docs.konghq.com/deck/1.18.x/installation
- https://docs.konghq.com/deck/1.19.x/installation
- https://docs.konghq.com/deck/1.20.x/installation
- https://docs.konghq.com/deck/1.21.x/installation
- https://docs.konghq.com/deck/1.22.x/installation
- https://docs.konghq.com/deck/1.23.x/installation
- https://docs.konghq.com/deck/1.24.x/installation
- https://docs.konghq.com/deck/1.25.x/installation
- https://docs.konghq.com/deck/1.26.x/installation
- https://docs.konghq.com/deck/1.27.x/installation
- https://docs.konghq.com/deck/1.28.x/installation
- https://docs.konghq.com/deck/1.29.x/installation
- https://docs.konghq.com/deck/1.7.x/installation
- https://docs.konghq.com/deck/1.8.x/installation
- https://docs.konghq.com/deck/1.9.x/installation
- https://docs.konghq.com/gateway/3.0.x/breaking-changes/28x/
- https://docs.konghq.com/gateway/3.1.x/breaking-changes/28x/
- https://docs.konghq.com/gateway/3.2.x/breaking-changes/28x/
- https://docs.konghq.com/gateway/3.3.x/breaking-changes/28x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/28x/
- https://docs.konghq.com/gateway/3.5.x/breaking-changes/28x/
- https://docs.konghq.com/gateway/3.1.x/breaking-changes/30x/
- https://docs.konghq.com/gateway/3.2.x/breaking-changes/30x/
- https://docs.konghq.com/gateway/3.3.x/breaking-changes/30x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/30x/
- https://docs.konghq.com/gateway/3.5.x/breaking-changes/30x/
- https://docs.konghq.com/gateway/3.2.x/breaking-changes/31x/
- https://docs.konghq.com/gateway/3.3.x/breaking-changes/31x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/31x/
- https://docs.konghq.com/gateway/3.5.x/breaking-changes/31x/
- https://docs.konghq.com/gateway/3.3.x/breaking-changes/32x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/32x/
- https://docs.konghq.com/gateway/3.5.x/breaking-changes/32x/
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/33x/
- https://docs.konghq.com/gateway/3.5.x/breaking-changes/33x/
- https://docs.konghq.com/gateway/3.5.x/breaking-changes/34x/

## Week 48

### [fix: Broken links to APIOps guide](https://github.com/Kong/docs.konghq.com/pull/6583) (2023-11-30)

Set `if_version` on links to the APIOps decK guide, as it was added with 1.24.x.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/kubernetes/openshift
- https://docs.konghq.com/gateway/3.1.x/install/kubernetes/openshift
- https://docs.konghq.com/gateway/3.2.x/install/kubernetes/openshift
- https://docs.konghq.com/gateway/3.3.x/install/kubernetes/openshift
- https://docs.konghq.com/gateway/3.4.x/install/kubernetes/openshift
- https://docs.konghq.com/gateway/3.5.x/install/kubernetes/openshift


### [Update: Gateway Manager filtering release note](https://github.com/Kong/docs.konghq.com/pull/6578) (2023-11-30)

Added to changelog for gateway manager filtering

#### Modified

- https://docs.konghq.com/konnect/updates


### [chore: Add missing search aliases and supported versions for 3rd party plugins](https://github.com/Kong/docs.konghq.com/pull/6576) (2023-11-29)

Keep expecting to find third-party plugins by filtering on publisher name, but that doesn't work. 

Adding 3rd party plugin publisher names as search aliases, as well as literal plugin names (eg `aws-request-signing`). 

Also updating the supported versions for Optum plugins. Versions are based on the plugins' source code repos.

#### Modified

- https://docs.konghq.com/hub/TheLEGOGroup/aws-request-signing/_metadata.yml
- https://docs.konghq.com/hub/amberflo/kong-plugin-amberflo/_metadata.yml
- https://docs.konghq.com/hub/datadome/kong-plugin-datadome/_metadata.yml
- https://docs.konghq.com/hub/imperva/imp-appsec-connector/_metadata.yml
- https://docs.konghq.com/hub/moesif/kong-plugin-moesif/_metadata.yml
- https://docs.konghq.com/hub/nonamesecurity/nonamesecurity-kongprevention/_metadata.yml
- https://docs.konghq.com/hub/nonamesecurity/nonamesecurity-kongtrafficsource/_metadata.yml
- https://docs.konghq.com/hub/optum/kong-response-size-limiting/_metadata.yml
- https://docs.konghq.com/hub/optum/kong-service-virtualization/_metadata.yml
- https://docs.konghq.com/hub/optum/kong-spec-expose/_metadata.yml
- https://docs.konghq.com/hub/optum/kong-splunk-log/_metadata.yml
- https://docs.konghq.com/hub/optum/kong-upstream-jwt/_metadata.yml
- https://docs.konghq.com/hub/salt/salt/_metadata.yml


### [fix: update deck schema URL](https://github.com/Kong/docs.konghq.com/pull/6565) (2023-11-27)

Updated the URL of the deck JSON schema. This now resides in another repository.

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/plugins/acl


### [docs(mesh): try to clarify what an AccessRole type is](https://github.com/Kong/docs.konghq.com/pull/6563) (2023-11-27)

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config


### [chore(deps): bump kumahq/kuma-website from 31bc302b to 74af1337](https://github.com/Kong/docs.konghq.com/pull/6557) (2023-11-28)

Auto upgrade PR log:

74af13372ca829dbdc9ee75f554ed3887043f1b6 ci(.github): automatic sync of files in kumahq/.github (kumahq/kuma-website#1536)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/7012347070).
labels: skip-changelog,review:general

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config


### [Fix broken links](https://github.com/Kong/docs.konghq.com/pull/6553) (2023-11-27)

Just ran it locally and got this:
```json
[
  {
    "page": "http://localhost:8888/konnect/gateway-manager/kic/",
    "text": "Kong Ingress Controller Deployment",
    "target": "http://localhost:8888/kubernetes-ingress-controller/latest/concepts/deployment/",
    "reason": "HTTP_404"
  },
  {
    "page": "http://localhost:8888/konnect/gateway-manager/kic/",
    "text": "Using Kong Gateway Enterprise",
    "target": "http://localhost:8888/kubernetes-ingress-controller/latest/guides/choose-gateway-image/",
    "reason": "HTTP_404"
  },
  {
    "page": "http://localhost:8888/gateway/latest/how-kong-works/routing-traffic/",
    "text": "Router Expressions language",
    "target": "http://localhost:8888/gateway/latest/reference/router-expressions-language/",
    "reason": "HTTP_404"
  },
  {
    "page": "http://localhost:8888/gateway/latest/production/monitoring/readiness-check/",
    "text": "Get Started with Kong Ingress Controller",
    "target": "http://localhost:8888/kubernetes-ingress-controller/latest/deployment/overview/",
    "reason": "HTTP_404"
  },
  {
    "page": "http://localhost:8888/gateway/3.5.x/how-kong-works/routing-traffic/",
    "text": "Router Expressions language",
    "target": "http://localhost:8888/gateway/latest/reference/router-expressions-language/",
    "reason": "HTTP_404"
  },
  {
    "page": "http://localhost:8888/gateway/3.5.x/production/monitoring/readiness-check/",
    "text": "Get Started with Kong Ingress Controller",
    "target": "http://localhost:8888/kubernetes-ingress-controller/latest/deployment/overview/",
    "reason": "HTTP_404"
  }
]
```

I'm not 💯 sure about these changes though, so please review them carefully.

*
   ```json
    {
      "page": "http://localhost:8888/konnect/gateway-manager/kic/",
      "text": "Kong Ingress Controller Deployment",
      "target": "http://localhost:8888/kubernetes-ingress-controller/latest/concepts/deployment/",
      "reason": "HTTP_404"
    }
  ```
   [prod URL](https://docs.konghq.com/konnect/gateway-manager/kic/)
    <img width="1185" alt="Screenshot 2023-11-23 at 13 52 17" src="https://github.com/Kong/docs.konghq.com/assets/715229/ccf30331-bf62-43c1-8ffd-0ab5877c3d4d">
  I don't think that `/kubernetes-ingress-controller/VERSION/concepts/deployment/: /kubernetes-ingress-controller/VERSION/production/deployment-topologies/` is the right call here, I couldn't find anything remotely similar to it though. We might want to update the `Note` though.

*
  ``` json
  {
    "page": "http://localhost:8888/konnect/gateway-manager/kic/",
    "text": "Using Kong Gateway Enterprise",
    "target": "http://localhost:8888/kubernetes-ingress-controller/latest/guides/choose-gateway-image/",
    "reason": "HTTP_404"
  }
  ```
  This guide no longer exists in KIC v3.

* 
  ```json
  {
    "page": "http://localhost:8888/gateway/latest/how-kong-works/routing-traffic/",
    "text": "Router Expressions language",
    "target": "http://localhost:8888/gateway/latest/reference/router-expressions-language/",
    "reason": "HTTP_404"
  }
  ```
  `reference/router-expressions-language` was removed in [this PR](https://github.com/Kong/docs.konghq.com/pull/6437/files#diff-6a9b955367a5ba2f6c4ad05d0a6feb8ad5980ef1aa26806e074a53c5437c7cba) and most of the references were updated but not all.

* 
  ```json
    {
      "page": "http://localhost:8888/gateway/latest/production/monitoring/readiness-check/",
      "text": "Get Started with Kong Ingress Controller",
      "target": "http://localhost:8888/kubernetes-ingress-controller/latest/deployment/overview/",
      "reason": "HTTP_404"
    }
  ```
  In KIC v3 there's no `deployment/overview`. I couldn't find a similar page though.

This also ignores `linux.die.net`, for some reason it returns `HTTP_403` in the CI - not locally though.

#### Modified

- https://docs.konghq.com/moved_urls.yml


### [fix: add the missing part of kong gateway vault's secrets versioning description](https://github.com/Kong/docs.konghq.com/pull/6551) (2023-11-30)

The PR adds the missing part of Kong Gateway Vault's secrets versioning description.

Gateway's vault supports accessing versioning secrets by specifying version number as a fragment in the vault reference URL.

Note that this is not a new feature added recently, it exists long time ago, only the doc part is missing.

https://konghq.atlassian.net/browse/FTI-5168

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/plugins/acl
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/secrets-management/reference-format
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/secrets-management/reference-format
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/secrets-management/reference-format
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/secrets-management/reference-format
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/secrets-management/reference-format
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/reference-format


### [Update: Listing a license requires license added via Admin API to begin with](https://github.com/Kong/docs.konghq.com/pull/6547) (2023-11-27)

We've had a few customer support cases where customers are confused by a null response from the /licenses endpoint when they're not actually using the Admin API to load the license in the first place which is a requirement for this to work properly. When using an environment variable to set the license instead, the /licenses endpoint will not work for listing licenses. This PR is to make this clearer in the documentation.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config


### [remove Kubernetes requirements and put the OpenShift requirements](https://github.com/Kong/docs.konghq.com/pull/6546) (2023-11-27)

https://github.com/Kong/docs.konghq.com/issues/5688

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config


### [KGO: v1.1.0 docs](https://github.com/Kong/docs.konghq.com/pull/6544) (2023-12-01)

Includes 1.1.0 changelog and assets:

**BLOCKED** by https://github.com/Kong/docs.konghq.com/pull/6518

#### Added

- https://docs.konghq.com/gateway-operator/1.0.x/reference/version-compatibility
- https://docs.konghq.com/gateway-operator/1.1.x/reference/version-compatibility
- https://docs.konghq.com/assets/gateway-operator/v1.1.0/all_controllers.yaml
- https://docs.konghq.com/assets/gateway-operator/v1.1.0/crds.yaml
- https://docs.konghq.com/assets/gateway-operator/v1.1.0/default.yaml

#### Modified

- https://docs.konghq.com/gateway-operator/changelog


### [docs(KIC): improved KIC ingress to gateway migration guide](https://github.com/Kong/docs.konghq.com/pull/6542) (2023-11-29)

The guide to migrate from Ingress API to Gateway API has been improved under the following aspects:
- it is no longer necessary to build the i2gw tool. We have a release with binary that can be directly downloaded
- further information about the types of resources converted has been added
 
#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config


### [Add reference page for required permissions to install KIC](https://github.com/Kong/docs.konghq.com/pull/6524) (2023-11-30)

Add a reference page to list the permissions required to install KIC when user do not have the super admin permission.
Fixes https://github.com/Kong/kubernetes-ingress-controller/issues/5166. 

#### Added

- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/backends/hashicorp-vault


### [feat: Portal Management API documentation](https://github.com/Kong/docs.konghq.com/pull/6519) (2023-11-28)

For Reviewers this needs: 

* Testing
* Copy Edit
* Narrative structure review

Questions: 
* The original draft has another section, I have some of it commented out, I felt like what I had ended pretty nicely and in combination with a blog and a spec could make a complete package but let me know if you don't agree. 
* I tried to write a purpose statement, does it answer it?

AC: 
This doc helps portal administrators and developers understand how to integrate the API into their workflow for tasks like automating approvals, assigning permissions, and monitoring developer activity. 

https://konghq.atlassian.net/browse/DOCU-3527

#### Added

- https://docs.konghq.com/konnect/dev-portal/konnect-portal-management-automation


### [docs: clarify on rate-limit redis cluster support](https://github.com/Kong/docs.konghq.com/pull/6511) (2023-11-30)

Adds clarification that the basic rate-limiting plugin does not support Redis Cluster mode.
 
[Context](https://github.com/Kong/kong/issues/11846#issuecomment-1810350623)

#### Modified

- https://docs.konghq.com/hub/kong-inc/rate-limiting/overview/


### [fix: mention required secret field for JWT plugin in KIC how to](https://github.com/Kong/docs.konghq.com/pull/6502) (2023-11-30)

Fix how to guide, it was reported by the user in the discussion

https://github.com/Kong/kubernetes-ingress-controller/discussions/5146

indeed field `secret` is missing you can read about this requirement at https://docs.konghq.com/hub/kong-inc/jwt/#create-a-jwt-credential see
![image](https://github.com/Kong/docs.konghq.com/assets/9593424/a864abca-4a63-4d7b-ac09-83e8f396fe55)

This PR adds it in the required places.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/backends/hashicorp-vault
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/secrets-management/reference-format
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/secrets-management/reference-format
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/secrets-management/reference-format
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/secrets-management/reference-format
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/secrets-management/reference-format
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/reference-format
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/guides/configure-acl-plugin

## Week 47

### [style(expressions): fix typo in `performance.md`](https://github.com/Kong/docs.konghq.com/pull/6549) (2023-11-22)

#### Modified

- https://docs.konghq.com/gateway-operator/1.0.x/version-compatibility
- https://docs.konghq.com/gateway/3.0.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.1.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.2.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.3.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.4.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.5.x/reference/expressions-language/performance


### [Chore: Update Changelog for Gateway Milestone updates](https://github.com/Kong/docs.konghq.com/pull/6540) (2023-11-20)

https://konghq.atlassian.net/browse/DOCU-3533
https://konghq.aha.io/epics/KP-E-320

Changelog update for this feature update.

#### Modified

- https://docs.konghq.com/konnect/updates


### [chore(deps): bump kumahq/kuma-website from 80fb6b2a to b3eeb1bc](https://github.com/Kong/docs.konghq.com/pull/6533) (2023-11-22)

Auto upgrade PR log:

b3eeb1bcc7bc398eab666dd1cfe94e960294906b chore(deps): update docs from repo source (kumahq/kuma-website#1534)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/6951132041).
labels: skip-changelog,review:general

#### Modified

- https://docs.konghq.com/gateway/3.0.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.1.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.2.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.3.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.4.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.5.x/reference/expressions-language/performance


### [kgo: add kgo version compatibility matrix](https://github.com/Kong/docs.konghq.com/pull/6518) (2023-11-20)

Add KGO version compat matrix for 
- Kubernetes versions
- KIC versions
- GW API versions

#### Added

- https://docs.konghq.com/gateway/3.0.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.1.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.2.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.3.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.4.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.5.x/reference/expressions-language/performance


### [feat: Multi-geo GA](https://github.com/Kong/docs.konghq.com/pull/6499) (2023-11-21)

Multi-geo is going GA, so we needed to pull in the current beta docs from the `konnect` branch, as well as add information about the newly added geo, AU. 

DOCU-2593

#### Added

- https://docs.konghq.com/konnect/geo

#### Modified

- https://docs.konghq.com/deck/1.12.x/guides/konnect
- https://docs.konghq.com/deck/1.13.x/guides/konnect
- https://docs.konghq.com/deck/1.14.x/guides/konnect
- https://docs.konghq.com/deck/1.15.x/guides/konnect
- https://docs.konghq.com/deck/1.16.x/guides/konnect
- https://docs.konghq.com/deck/1.17.x/guides/konnect
- https://docs.konghq.com/deck/1.18.x/guides/konnect
- https://docs.konghq.com/deck/1.19.x/guides/konnect
- https://docs.konghq.com/deck/1.20.x/guides/konnect
- https://docs.konghq.com/deck/1.21.x/guides/konnect
- https://docs.konghq.com/deck/1.22.x/guides/konnect
- https://docs.konghq.com/deck/1.23.x/guides/konnect
- https://docs.konghq.com/deck/1.24.x/guides/konnect/
- https://docs.konghq.com/deck/1.25.x/guides/konnect/
- https://docs.konghq.com/deck/1.26.x/guides/konnect/
- https://docs.konghq.com/deck/1.27.x/guides/konnect/
- https://docs.konghq.com/deck/1.28.x/guides/konnect/
- https://docs.konghq.com/deck/1.29.x/guides/konnect/
- https://docs.konghq.com/konnect/account-management/
- https://docs.konghq.com/konnect/api-products/service-documentation
- https://docs.konghq.com/konnect/api/
- https://docs.konghq.com/konnect/dev-portal/access
- https://docs.konghq.com/konnect/dev-portal/applications/enable-app-reg
- https://docs.konghq.com/konnect/dev-portal/dev-reg
- https://docs.konghq.com/konnect/gateway-manager/configuration/
- https://docs.konghq.com/konnect/getting-started/access-account
- https://docs.konghq.com/konnect/getting-started/productize-service
- https://docs.konghq.com/konnect/
- https://docs.konghq.com/konnect/network
- https://docs.konghq.com/konnect/org-management/teams-and-roles/
- https://docs.konghq.com/konnect/org-management/teams-and-roles/manage
- https://docs.konghq.com/konnect/org-management/teams-and-roles/roles-reference
- https://docs.konghq.com/konnect/org-management/teams-and-roles/teams-reference
- https://docs.konghq.com/konnect/updates


### [update: Rewrite the expressions router Gateway doc](https://github.com/Kong/docs.konghq.com/pull/6437) (2023-11-21)

This is a complete rewrite of the Expressions router doc to make it easier to understand and more comprehensive.

![KAG-2288]

[KAG-2288]: https://konghq.atlassian.net/browse/KAG-2288?atlOrigin=eyJpIjoiNWRkNTljNzYxNjVmNDY3MDlhMDU5Y2ZhYzA5YTRkZjUiLCJwIjoiZ2l0aHViLWNvbS1KU1cifQ

#### Added

- https://docs.konghq.com/gateway/3.0.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.1.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.2.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.3.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.4.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.5.x/reference/expressions-language/language-references
- https://docs.konghq.com/gateway/3.0.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.1.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.2.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.3.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.4.x/reference/expressions-language/performance
- https://docs.konghq.com/gateway/3.5.x/reference/expressions-language/performance
- https://docs.konghq.com/assets/images/products/gateway/reference/expressions-language/predicate.png
- https://docs.konghq.com/assets/images/products/gateway/reference/expressions-language/router-matching-flow.png

#### Modified

- https://docs.konghq.com/gateway/3.0.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.1.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.2.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.3.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.4.x/key-concepts/routes/expressions
- https://docs.konghq.com/gateway/3.5.x/key-concepts/routes/expressions

## Week 46


### [(chore) Konnect + 3.5 support](https://github.com/Kong/docs.konghq.com/pull/6527) (2023-11-16)

Adding statements of Konnect support for 3.5 to changelog + compatibility table, including Azure Key Vault support.

#### Modified

- https://docs.konghq.com/konnect/compatibility
- https://docs.konghq.com/konnect/updates


### [Feat: Azure Key Vault docs for Konnect](https://github.com/Kong/docs.konghq.com/pull/6526) (2023-11-16)


 Added Azure Key Vault as a supported secret manager for Konnect docs


https://konghq.aha.io/features/KP-391
This was hidden behind a feature flag from back in March. It is now ready to be turned on and released.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/configuration/vaults/how-to
- https://docs.konghq.com/konnect/gateway-manager/configuration/vaults/


### [Fix: custom Docker build instructions](https://github.com/Kong/docs.konghq.com/pull/6525) (2023-11-16)

Fix custom Docker build instructions. `openresty` is now symlinked in the package, which caused the `Dockerfile` provided to fail.

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/install/cloud/eks


### [feat(dbless): add compatibility warning for Kong Manager](https://github.com/Kong/docs.konghq.com/pull/6522) (2023-11-17)

Adding a section for the compatibility warning while using Kong Manager with Kong under DB-less mode.

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/install/cloud/eks



### [docs(mesh): update docs and changelog](https://github.com/Kong/docs.konghq.com/pull/6513) (2023-11-16)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/6887845559)

#### Modified

- https://docs.konghq.com/mesh/2.5.x/kuma-cp.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshloadbalancingstrategies.yaml
- https://docs.konghq.com/mesh/dev/kuma-cp.yaml
- https://docs.konghq.com/mesh/raw/CHANGELOG


### [(chore) Add end off support dates to Konnect/GW compatibility table](https://github.com/Kong/docs.konghq.com/pull/6512) (2023-11-16)

Adding end of support column to Konnect's compatibility w/ Gateway matrix. Dates will match Gateway's dates starting with 3.2, prior versions will end support in Feb 2024.

#### Modified

- https://docs.konghq.com/konnect/compatibility


### [Update Konnect curl request in renew-certificates.md](https://github.com/Kong/docs.konghq.com/pull/6510) (2023-11-17)

Modified curl example for Konnect:

- needed to add double-quotes to properly expand $CERT envvar (curl was giving an error)
https://superuser.com/questions/835587/how-to-include-environment-variable-in-bash-line-curl#:~:text=Inside%20single%2Dquotes%2C%20the%20shell,completed%22'.%22%7D'

- Included the Authorization header in the Konnect request

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/renew-certificates


### [Update gw manager docs](https://github.com/Kong/docs.konghq.com/pull/6509) (2023-11-14)

Updating gateway manager doc page since Plus and Enterprise users can create multiple control planes. This was new as part of KOD1 for API Summit.


#### Modified

- https://docs.konghq.com/konnect/gateway-manager/


### [(chore) 3.5.0.1 changelog](https://github.com/Kong/docs.konghq.com/pull/6508) (2023-11-16)

Build changelog for 3.5.0.1 based on source from https://github.com/Kong/kong-ee/blob/next/3.5.x.x/changelog/3.5.0.1/3.5.0.1.md

#### Modified

- https://docs.konghq.com/gateway/changelog


### [docs(changelog): consolidate the lua-resty-aws version bump changelog](https://github.com/Kong/docs.konghq.com/pull/6507) (2023-11-14)

Consolidate the lua-resty-aws version bump entries into one as both entries happened in the same release.

This is for Gateway Enterprise 3.5.0.0 changelog.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [chore: improve docs about support of gRPC in KIC](https://github.com/Kong/docs.konghq.com/pull/6497) (2023-11-15)

Improve documentation for gRPC support in KIC
- as long as https://github.com/Kong/kubernetes-ingress-controller/issues/4273 is not resolved only gRPC over HTTPS is supported, so mention it
- remove the redundant annotation `konghq.com/protocol: grpcs` from the service, because in [examples/gateway-grpcroute.yaml](https://github.com/Kong/kubernetes-ingress-controller/blob/314951c3279dcd38cb7de7e53f71969379a0340a/examples/gateway-grpcroute.yaml#L5-L17) it's not specified and that configuration is tested in KIC CI so it works


#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/install/cloud/eks


### [kic: fix the description of kic's leader election permission](https://github.com/Kong/docs.konghq.com/pull/6485) (2023-11-16)

fixes: https://github.com/Kong/docs.konghq.com/issues/6410


#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/docker/build-custom-images/
- https://docs.konghq.com/gateway/3.1.x/install/docker/build-custom-images/
- https://docs.konghq.com/gateway/3.2.x/install/docker/build-custom-images/
- https://docs.konghq.com/gateway/3.3.x/install/docker/build-custom-images/
- https://docs.konghq.com/gateway/3.4.x/install/docker/build-custom-images/
- https://docs.konghq.com/gateway/3.5.x/install/docker/build-custom-images/
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/install/cloud/eks

## Week 45


### [Release Gateway 3.4.2.0](https://github.com/Kong/docs.konghq.com/pull/6490) (2023-11-10)

Update changelog for the Gateway 3.4.2.0 release

https://github.com/Kong/kong-ee/blob/next/3.4.x.x/changelog/3.4.2.0/3.4.2.0.md

https://konghq.atlassian.net/browse/DOCU-3563

#### Modified

- https://docs.konghq.com/gateway/changelog



### [docs: add KIC 3.0 missing docs updates](https://github.com/Kong/docs.konghq.com/pull/6487) (2023-11-08)

Adds missing KIC 3.0 docs:
- updates compatibility matrices (drops Kubernetes 1.23 and 1.24 support)
- adds `konghq.com/upstream-policy` annotation to annotations reference
- updates support policy table (not sure if we should also update [Supported versions table](https://deploy-preview-6486--kongdocs.netlify.app/kubernetes-ingress-controller/latest/support-policy/#supported-versions) - so far we've been recommending LTS releases so I didn't change that to recommend 3.0 @mheap). 

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/gateway-api
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/services/grpc


### [fix: remove unnecessary brackets from proxy config](https://github.com/Kong/docs.konghq.com/pull/6486) (2023-11-08)

Removes unnecessary brackets from example helm values proxy configuration that break it.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/plugin-development/pdk/kong.websocket.upstream
- https://docs.konghq.com/gateway/3.1.x/plugin-development/pdk/kong.websocket.upstream
- https://docs.konghq.com/gateway/3.2.x/plugin-development/pdk/kong.websocket.upstream
- https://docs.konghq.com/gateway/3.3.x/plugin-development/pdk/kong.websocket.upstream
- https://docs.konghq.com/gateway/3.4.x/plugin-development/pdk/kong.websocket.upstream
- https://docs.konghq.com/gateway/3.5.x/plugin-development/pdk/kong.websocket.upstream




### [removing warning about the websocket pdk](https://github.com/Kong/docs.konghq.com/pull/6477) (2023-11-07)

This removes the unstable warning from the gateway's WebSocket client/upstream Lua PDKs.

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/concepts/ingress


### [KIC: Fix GRPC Guide](https://github.com/Kong/docs.konghq.com/pull/6473) (2023-11-08)

Add GRPC guide to KIC 3.0 docs

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/production/deployment-topologies/db-backed


### [Release: KIC 3.0](https://github.com/Kong/docs.konghq.com/pull/6467) (2023-11-06)

Merge the long-lived KIC 3.0 branch in to `main`

#### Added

- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/concepts/admission-webhook
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/concepts/annotations
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/concepts/architecture
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/concepts/custom-resources
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/concepts/gateway-api
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/concepts/ingress
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/gateway-api
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/get-started/key-authentication
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/get-started/proxy-caching
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/get-started/rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/get-started/services-and-routes
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/high-availability/health-checks
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/high-availability/kic
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/migrate/credential-kongcredtype-label
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/migrate/ingress-to-gateway
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/migrate/kongingress
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/requests/customizing-load-balancing
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/requests/rewrite-annotation
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/requests/rewrite-host
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/security/client-ip
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/security/kong-vault
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/security/workspaces
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/services/external
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/services/grpc
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/services/http
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/services/https-redirect
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/services/multiple-backends
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/services/tcp
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/services/tls
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/guides/services/udp
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/install/cloud/aks
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/install/cloud/eks
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/install/cloud/gke
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/install/gateway-operator
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/install/helm
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/license
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/plugins/acl
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/plugins/authentication
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/plugins/custom
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/plugins/mtls
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/plugins/oidc
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/plugins/rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/production/deployment-topologies/db-backed
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/production/deployment-topologies/gateway-discovery
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/production/deployment-topologies/sidecar
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/production/observability/events
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/production/observability/prometheus-grafana
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/production/observability/prometheus
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/reference/annotations
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/reference/cli-arguments
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/reference/faq/nginx.conf
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/reference/faq/router
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/reference/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/reference/ingress-to-gateway-migration
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/reference/troubleshooting
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/upgrade/gateway
- https://docs.konghq.com/kubernetes-ingress-controller/3.0.x/upgrade/kic
- https://docs.konghq.com/assets/images/products/kubernetes-ingress-controller/kic-gateway-arch.png
- https://docs.konghq.com/assets/images/products/kubernetes-ingress-controller/topology/db-backed-hybrid.png
- https://docs.konghq.com/assets/images/products/kubernetes-ingress-controller/topology/db-backed-traditional.png
- https://docs.konghq.com/assets/images/products/kubernetes-ingress-controller/topology/gateway-discovery.png
- https://docs.konghq.com/assets/images/products/kubernetes-ingress-controller/topology/sidecar.png
- https://docs.konghq.com/assets/kubernetes-ingress-controller/examples/httpbin-service.yaml

#### Modified

- https://docs.konghq.com/gateway-operator/1.0.x/get-started/kic/install/
- https://docs.konghq.com/assets/kubernetes-ingress-controller/examples/tcp-echo-service.yaml
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/deployment/install-gateway-apis


### [Update: Link to IETF Draft](https://github.com/Kong/docs.konghq.com/pull/6464) (2023-11-06)

RateLimit header fields for HTTP -> https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/

#### Modified

- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/rate-limiting/overview/



### [Release: Gateway 3.5](https://github.com/Kong/docs.konghq.com/pull/6433) (2023-11-08)

## Description

Release roll-up PR for Gateway 3.5 release.

#### Added

- https://docs.konghq.com/hub/kong-inc/cors/
- https://docs.konghq.com/hub/kong-inc/oas-validation/
- https://docs.konghq.com/hub/kong-inc/response-transformer/
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/backends/azure-key-vaults
- https://docs.konghq.com/gateway/3.5.x/plugin-development/wasm/filter-configuration
- https://docs.konghq.com/gateway/3.5.x/production/debug-request
- https://docs.konghq.com/assets/images/products/gateway/km_workspace_3.5.png
- https://docs.konghq.com/assets/images/products/plugins/openid-connect/keycloak-client-cert-bound-settings.png

#### Modified

- https://docs.konghq.com/hub/kong-inc/acme/
- https://docs.konghq.com/hub/kong-inc/acme/how-to/
- https://docs.konghq.com/hub/kong-inc/aws-lambda/
- https://docs.konghq.com/hub/kong-inc/aws-lambda/overview/
- https://docs.konghq.com/hub/kong-inc/canary/
- https://docs.konghq.com/hub/kong-inc/exit-transformer/overview/
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/grpc-gateway/
- https://docs.konghq.com/hub/kong-inc/kafka-log/
- https://docs.konghq.com/hub/kong-inc/mocking/
- https://docs.konghq.com/hub/kong-inc/mocking/overview/
- https://docs.konghq.com/hub/kong-inc/mtls-auth/
- https://docs.konghq.com/hub/kong-inc/oauth2-introspection/
- https://docs.konghq.com/hub/kong-inc/openid-connect/
- https://docs.konghq.com/hub/kong-inc/openid-connect/overview/
- https://docs.konghq.com/hub/kong-inc/opentelemetry/
- https://docs.konghq.com/hub/kong-inc/opentelemetry/overview/
- https://docs.konghq.com/hub/kong-inc/prometheus/
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/
- https://docs.konghq.com/hub/kong-inc/rate-limiting/overview/
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer/how-to/
- https://docs.konghq.com/hub/kong-inc/request-validator/
- https://docs.konghq.com/hub/kong-inc/response-ratelimiting/
- https://docs.konghq.com/hub/kong-inc/saml/
- https://docs.konghq.com/hub/kong-inc/session/
- https://docs.konghq.com/hub/kong-inc/session/overview/
- https://docs.konghq.com/hub/kong-inc/tcp-log/
- https://docs.konghq.com/hub/kong-inc/zipkin/
- https://docs.konghq.com/hub/kong-inc/zipkin/overview/
- https://docs.konghq.com/deck/1.24.x/guides/apiops/
- https://docs.konghq.com/deck/1.25.x/guides/apiops/
- https://docs.konghq.com/deck/1.26.x/guides/apiops/
- https://docs.konghq.com/deck/1.27.x/guides/apiops/
- https://docs.konghq.com/deck/1.28.x/guides/apiops/
- https://docs.konghq.com/deck/1.29.x/guides/apiops/
- https://docs.konghq.com/deck/1.11.x/guides/defaults
- https://docs.konghq.com/deck/1.12.x/guides/defaults
- https://docs.konghq.com/deck/1.13.x/guides/defaults
- https://docs.konghq.com/deck/1.14.x/guides/defaults
- https://docs.konghq.com/deck/1.15.x/guides/defaults
- https://docs.konghq.com/deck/1.16.x/guides/defaults
- https://docs.konghq.com/deck/1.17.x/guides/defaults
- https://docs.konghq.com/deck/1.18.x/guides/defaults
- https://docs.konghq.com/deck/1.19.x/guides/defaults
- https://docs.konghq.com/deck/1.20.x/guides/defaults
- https://docs.konghq.com/deck/1.21.x/guides/defaults
- https://docs.konghq.com/deck/1.22.x/guides/defaults
- https://docs.konghq.com/deck/1.23.x/guides/defaults
- https://docs.konghq.com/deck/1.24.x/guides/defaults/
- https://docs.konghq.com/deck/1.25.x/guides/defaults/
- https://docs.konghq.com/deck/1.26.x/guides/defaults/
- https://docs.konghq.com/deck/1.27.x/guides/defaults/
- https://docs.konghq.com/deck/1.28.x/guides/defaults/
- https://docs.konghq.com/deck/1.29.x/guides/defaults/
- https://docs.konghq.com/deck/1.16.x/guides/security
- https://docs.konghq.com/deck/1.17.x/guides/security
- https://docs.konghq.com/deck/1.18.x/guides/security
- https://docs.konghq.com/deck/1.19.x/guides/security
- https://docs.konghq.com/deck/1.20.x/guides/security
- https://docs.konghq.com/deck/1.21.x/guides/security
- https://docs.konghq.com/deck/1.22.x/guides/security
- https://docs.konghq.com/deck/1.23.x/guides/security
- https://docs.konghq.com/deck/1.24.x/guides/security/
- https://docs.konghq.com/deck/1.25.x/guides/security/
- https://docs.konghq.com/deck/1.26.x/guides/security/
- https://docs.konghq.com/deck/1.27.x/guides/security/
- https://docs.konghq.com/deck/1.28.x/guides/security/
- https://docs.konghq.com/deck/1.29.x/guides/security/
- https://docs.konghq.com/gateway-operator/1.0.x/faq
- https://docs.konghq.com/gateway-operator/1.0.x/get-started/konnect/create-route/
- https://docs.konghq.com/gateway-operator/1.0.x/topologies/dbless/
- https://docs.konghq.com/gateway/3.0.x/admin-api/developers/reference
- https://docs.konghq.com/gateway/3.1.x/admin-api/developers/reference
- https://docs.konghq.com/gateway/3.2.x/admin-api/developers/reference
- https://docs.konghq.com/gateway/3.3.x/admin-api/developers/reference
- https://docs.konghq.com/gateway/3.4.x/admin-api/developers/reference
- https://docs.konghq.com/gateway/3.0.x/get-started/key-authentication
- https://docs.konghq.com/gateway/3.1.x/get-started/key-authentication
- https://docs.konghq.com/gateway/3.2.x/get-started/key-authentication
- https://docs.konghq.com/gateway/3.3.x/get-started/key-authentication
- https://docs.konghq.com/gateway/3.4.x/get-started/key-authentication
- https://docs.konghq.com/gateway/3.5.x/get-started/key-authentication
- https://docs.konghq.com/gateway/3.0.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.1.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.2.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.3.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.4.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.5.x/get-started/load-balancing
- https://docs.konghq.com/gateway/3.0.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.1.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.2.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.3.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.4.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.5.x/get-started/proxy-caching
- https://docs.konghq.com/gateway/3.0.x/get-started/rate-limiting
- https://docs.konghq.com/gateway/3.1.x/get-started/rate-limiting
- https://docs.konghq.com/gateway/3.2.x/get-started/rate-limiting
- https://docs.konghq.com/gateway/3.3.x/get-started/rate-limiting
- https://docs.konghq.com/gateway/3.4.x/get-started/rate-limiting
- https://docs.konghq.com/gateway/3.5.x/get-started/rate-limiting
- https://docs.konghq.com/gateway/3.0.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.1.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.2.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.3.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.4.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.5.x/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.0.x/how-kong-works/performance-testing
- https://docs.konghq.com/gateway/3.1.x/how-kong-works/performance-testing
- https://docs.konghq.com/gateway/3.2.x/how-kong-works/performance-testing
- https://docs.konghq.com/gateway/3.3.x/how-kong-works/performance-testing
- https://docs.konghq.com/gateway/3.4.x/how-kong-works/performance-testing
- https://docs.konghq.com/gateway/3.0.x/
- https://docs.konghq.com/gateway/3.1.x/
- https://docs.konghq.com/gateway/3.2.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/gateway/3.5.x/
- https://docs.konghq.com/gateway/3.0.x/install/kubernetes/deployment-options
- https://docs.konghq.com/gateway/3.1.x/install/kubernetes/deployment-options
- https://docs.konghq.com/gateway/3.2.x/install/kubernetes/deployment-options
- https://docs.konghq.com/gateway/3.3.x/install/kubernetes/deployment-options
- https://docs.konghq.com/gateway/3.4.x/install/kubernetes/deployment-options
- https://docs.konghq.com/gateway/3.5.x/install/kubernetes/deployment-options
- https://docs.konghq.com/gateway/3.0.x/install/kubernetes/helm-quickstart
- https://docs.konghq.com/gateway/3.1.x/install/kubernetes/helm-quickstart
- https://docs.konghq.com/gateway/3.2.x/install/kubernetes/helm-quickstart
- https://docs.konghq.com/gateway/3.3.x/install/kubernetes/helm-quickstart
- https://docs.konghq.com/gateway/3.4.x/install/kubernetes/helm-quickstart
- https://docs.konghq.com/gateway/3.5.x/install/kubernetes/helm-quickstart
- https://docs.konghq.com/gateway/3.0.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.1.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.2.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.3.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.4.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.5.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.0.x/key-concepts/upstreams
- https://docs.konghq.com/gateway/3.1.x/key-concepts/upstreams
- https://docs.konghq.com/gateway/3.2.x/key-concepts/upstreams
- https://docs.konghq.com/gateway/3.3.x/key-concepts/upstreams
- https://docs.konghq.com/gateway/3.4.x/key-concepts/upstreams
- https://docs.konghq.com/gateway/3.5.x/key-concepts/upstreams
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/plugin-ordering/get-started
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/plugin-ordering/get-started
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/plugin-ordering/get-started
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/plugin-ordering/get-started
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/plugin-ordering/get-started
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/plugin-ordering/get-started
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/backends/aws-sm
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/secrets-management/how-to/aws-secrets-manager
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/secrets-management/how-to/aws-secrets-manager
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/secrets-management/how-to/aws-secrets-manager
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/secrets-management/how-to/aws-secrets-manager
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/secrets-management/how-to/aws-secrets-manager
- https://docs.konghq.com/gateway/3.5.x/kong-enterprise/secrets-management/how-to/aws-secrets-manager
- https://docs.konghq.com/gateway/3.0.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.1.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.2.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.3.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.4.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.5.x/kong-manager/auth/oidc/configure
- https://docs.konghq.com/gateway/3.0.x/kong-manager/auth/rbac/enable
- https://docs.konghq.com/gateway/3.1.x/kong-manager/auth/rbac/enable
- https://docs.konghq.com/gateway/3.2.x/kong-manager/auth/rbac/enable
- https://docs.konghq.com/gateway/3.3.x/kong-manager/auth/rbac/enable
- https://docs.konghq.com/gateway/3.4.x/kong-manager/auth/rbac/enable
- https://docs.konghq.com/gateway/3.5.x/kong-manager/auth/rbac/enable
- https://docs.konghq.com/gateway/3.0.x/kong-manager/get-started/load-balancing
- https://docs.konghq.com/gateway/3.1.x/kong-manager/get-started/load-balancing
- https://docs.konghq.com/gateway/3.2.x/kong-manager/get-started/load-balancing
- https://docs.konghq.com/gateway/3.3.x/kong-manager/get-started/load-balancing
- https://docs.konghq.com/gateway/3.4.x/kong-manager/get-started/load-balancing
- https://docs.konghq.com/gateway/3.5.x/kong-manager/get-started/load-balancing
- https://docs.konghq.com/gateway/3.0.x/kong-manager/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.1.x/kong-manager/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.2.x/kong-manager/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.3.x/kong-manager/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.4.x/kong-manager/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.5.x/kong-manager/get-started/services-and-routes
- https://docs.konghq.com/gateway/3.0.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.1.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.2.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.3.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.4.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.5.x/kong-manager/workspaces
- https://docs.konghq.com/gateway/3.0.x/kong-plugins/authentication/oidc/azure-ad
- https://docs.konghq.com/gateway/3.1.x/kong-plugins/authentication/oidc/azure-ad
- https://docs.konghq.com/gateway/3.2.x/kong-plugins/authentication/oidc/azure-ad
- https://docs.konghq.com/gateway/3.3.x/kong-plugins/authentication/oidc/azure-ad
- https://docs.konghq.com/gateway/3.4.x/kong-plugins/authentication/oidc/azure-ad
- https://docs.konghq.com/gateway/3.5.x/kong-plugins/authentication/oidc/azure-ad
- https://docs.konghq.com/gateway/3.0.x/kong-plugins/authentication/oidc/curity
- https://docs.konghq.com/gateway/3.1.x/kong-plugins/authentication/oidc/curity
- https://docs.konghq.com/gateway/3.2.x/kong-plugins/authentication/oidc/curity
- https://docs.konghq.com/gateway/3.3.x/kong-plugins/authentication/oidc/curity
- https://docs.konghq.com/gateway/3.4.x/kong-plugins/authentication/oidc/curity
- https://docs.konghq.com/gateway/3.5.x/kong-plugins/authentication/oidc/curity
- https://docs.konghq.com/gateway/3.0.x/kong-plugins/authentication/oidc/okta
- https://docs.konghq.com/gateway/3.1.x/kong-plugins/authentication/oidc/okta
- https://docs.konghq.com/gateway/3.2.x/kong-plugins/authentication/oidc/okta
- https://docs.konghq.com/gateway/3.3.x/kong-plugins/authentication/oidc/okta
- https://docs.konghq.com/gateway/3.4.x/kong-plugins/authentication/oidc/okta
- https://docs.konghq.com/gateway/3.5.x/kong-plugins/authentication/oidc/okta
- https://docs.konghq.com/gateway/3.0.x/kong-plugins/authentication/reference
- https://docs.konghq.com/gateway/3.1.x/kong-plugins/authentication/reference
- https://docs.konghq.com/gateway/3.2.x/kong-plugins/authentication/reference
- https://docs.konghq.com/gateway/3.3.x/kong-plugins/authentication/reference
- https://docs.konghq.com/gateway/3.4.x/kong-plugins/authentication/reference
- https://docs.konghq.com/gateway/3.5.x/kong-plugins/authentication/reference
- https://docs.konghq.com/gateway/3.0.x/licenses/report
- https://docs.konghq.com/gateway/3.1.x/licenses/report
- https://docs.konghq.com/gateway/3.2.x/licenses/report
- https://docs.konghq.com/gateway/3.3.x/licenses/report
- https://docs.konghq.com/gateway/3.0.x/migrate-ce-to-ke/
- https://docs.konghq.com/gateway/3.1.x/migrate-ce-to-ke/
- https://docs.konghq.com/gateway/3.2.x/migrate-ce-to-ke/
- https://docs.konghq.com/gateway/3.3.x/migrate-ce-to-ke/
- https://docs.konghq.com/gateway/3.4.x/migrate-ce-to-ke/
- https://docs.konghq.com/gateway/3.5.x/migrate-ce-to-ke/
- https://docs.konghq.com/gateway/3.0.x/plugin-development/access-the-datastore
- https://docs.konghq.com/gateway/3.1.x/plugin-development/access-the-datastore
- https://docs.konghq.com/gateway/3.2.x/plugin-development/access-the-datastore
- https://docs.konghq.com/gateway/3.3.x/plugin-development/access-the-datastore
- https://docs.konghq.com/gateway/3.4.x/plugin-development/access-the-datastore
- https://docs.konghq.com/gateway/3.5.x/plugin-development/access-the-datastore
- https://docs.konghq.com/gateway/3.0.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.1.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.2.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.3.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.4.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.5.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.0.x/plugin-development/entities-cache
- https://docs.konghq.com/gateway/3.1.x/plugin-development/entities-cache
- https://docs.konghq.com/gateway/3.2.x/plugin-development/entities-cache
- https://docs.konghq.com/gateway/3.3.x/plugin-development/entities-cache
- https://docs.konghq.com/gateway/3.4.x/plugin-development/entities-cache
- https://docs.konghq.com/gateway/3.5.x/plugin-development/entities-cache
- https://docs.konghq.com/gateway/3.0.x/plugin-development/pdk/kong.client
- https://docs.konghq.com/gateway/3.1.x/plugin-development/pdk/kong.client
- https://docs.konghq.com/gateway/3.2.x/plugin-development/pdk/kong.client
- https://docs.konghq.com/gateway/3.3.x/plugin-development/pdk/kong.client
- https://docs.konghq.com/gateway/3.4.x/plugin-development/pdk/kong.client
- https://docs.konghq.com/gateway/3.5.x/plugin-development/pdk/kong.client
- https://docs.konghq.com/gateway/3.0.x/plugin-development/pdk/kong.log
- https://docs.konghq.com/gateway/3.1.x/plugin-development/pdk/kong.log
- https://docs.konghq.com/gateway/3.2.x/plugin-development/pdk/kong.log
- https://docs.konghq.com/gateway/3.3.x/plugin-development/pdk/kong.log
- https://docs.konghq.com/gateway/3.4.x/plugin-development/pdk/kong.log
- https://docs.konghq.com/gateway/3.5.x/plugin-development/pdk/kong.log
- https://docs.konghq.com/gateway/3.0.x/plugin-development/pdk/kong.request
- https://docs.konghq.com/gateway/3.1.x/plugin-development/pdk/kong.request
- https://docs.konghq.com/gateway/3.2.x/plugin-development/pdk/kong.request
- https://docs.konghq.com/gateway/3.3.x/plugin-development/pdk/kong.request
- https://docs.konghq.com/gateway/3.4.x/plugin-development/pdk/kong.request
- https://docs.konghq.com/gateway/3.5.x/plugin-development/pdk/kong.request
- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/db-less-and-declarative-config
- https://docs.konghq.com/gateway/3.0.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.2.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.3.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.4.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.5.x/production/deployment-topologies/hybrid-mode/setup
- https://docs.konghq.com/gateway/3.0.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.1.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.2.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.3.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.4.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.5.x/production/monitoring/prometheus
- https://docs.konghq.com/gateway/3.0.x/production/monitoring/statsd
- https://docs.konghq.com/gateway/3.1.x/production/monitoring/statsd
- https://docs.konghq.com/gateway/3.2.x/production/monitoring/statsd
- https://docs.konghq.com/gateway/3.3.x/production/monitoring/statsd
- https://docs.konghq.com/gateway/3.4.x/production/monitoring/statsd
- https://docs.konghq.com/gateway/3.5.x/production/monitoring/statsd
- https://docs.konghq.com/gateway/3.0.x/production/networking/default-ports
- https://docs.konghq.com/gateway/3.1.x/production/networking/default-ports
- https://docs.konghq.com/gateway/3.2.x/production/networking/default-ports
- https://docs.konghq.com/gateway/3.3.x/production/networking/default-ports
- https://docs.konghq.com/gateway/3.4.x/production/networking/default-ports
- https://docs.konghq.com/gateway/3.5.x/production/networking/default-ports
- https://docs.konghq.com/gateway/3.0.x/production/running-kong/systemd
- https://docs.konghq.com/gateway/3.1.x/production/running-kong/systemd
- https://docs.konghq.com/gateway/3.2.x/production/running-kong/systemd
- https://docs.konghq.com/gateway/3.3.x/production/running-kong/systemd
- https://docs.konghq.com/gateway/3.4.x/production/running-kong/systemd
- https://docs.konghq.com/gateway/3.5.x/production/running-kong/systemd
- https://docs.konghq.com/gateway/3.0.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.1.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.2.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.3.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.4.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.5.x/production/sizing-guidelines
- https://docs.konghq.com/gateway/3.0.x/reference/cli
- https://docs.konghq.com/gateway/3.1.x/reference/cli
- https://docs.konghq.com/gateway/3.2.x/reference/cli
- https://docs.konghq.com/gateway/3.3.x/reference/cli
- https://docs.konghq.com/gateway/3.4.x/reference/cli
- https://docs.konghq.com/gateway/3.5.x/reference/cli
- https://docs.konghq.com/gateway/3.4.x/reference/configuration
- https://docs.konghq.com/gateway/3.5.x/reference/configuration
- https://docs.konghq.com/gateway/3.0.x/reference/performance-testing-framework
- https://docs.konghq.com/gateway/3.1.x/reference/performance-testing-framework
- https://docs.konghq.com/gateway/3.2.x/reference/performance-testing-framework
- https://docs.konghq.com/gateway/3.3.x/reference/performance-testing-framework
- https://docs.konghq.com/gateway/3.4.x/reference/performance-testing-framework
- https://docs.konghq.com/gateway/3.4.x/reference/wasm
- https://docs.konghq.com/gateway/3.5.x/reference/wasm
- https://docs.konghq.com/gateway/3.2.x/support/browser
- https://docs.konghq.com/gateway/3.3.x/support/browser
- https://docs.konghq.com/gateway/3.4.x/support/browser
- https://docs.konghq.com/gateway/3.5.x/support/browser
- https://docs.konghq.com/gateway/3.3.x/support/sbom
- https://docs.konghq.com/gateway/3.4.x/support/sbom
- https://docs.konghq.com/gateway/3.5.x/support/sbom
- https://docs.konghq.com/gateway/3.2.x/support/third-party
- https://docs.konghq.com/gateway/3.3.x/support/third-party
- https://docs.konghq.com/gateway/3.4.x/support/third-party
- https://docs.konghq.com/gateway/3.5.x/support/third-party
- https://docs.konghq.com/gateway/3.0.x/upgrade/
- https://docs.konghq.com/assets/images/products/plugins/openid-connect/keycloak.json
- https://docs.konghq.com/contributing/variables
- https://docs.konghq.com/contributing/word-choice
- https://docs.konghq.com/deck/pre-1.7/commands
- https://docs.konghq.com/deck/pre-1.7/design-architecture
- https://docs.konghq.com/deck/pre-1.7/faqs
- https://docs.konghq.com/deck/pre-1.7/guides/kong-enterprise
- https://docs.konghq.com/gateway/2.6.x/configure/auth/
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/expose-services
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/improve-performance
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/load-balancing
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/protect-services
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/secure-services
- https://docs.konghq.com/gateway/2.6.x/get-started/quickstart/configuring-a-service
- https://docs.konghq.com/gateway/2.6.x/install-and-run/docker
- https://docs.konghq.com/gateway/2.6.x/plan-and-deploy/default-ports
- https://docs.konghq.com/gateway/2.6.x/plugin-development/access-the-datastore
- https://docs.konghq.com/gateway/2.6.x/reference/db-less-and-declarative-config
- https://docs.konghq.com/gateway/2.7.x/configure/auth/
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/expose-services
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/improve-performance
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/load-balancing
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/protect-services
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/secure-services
- https://docs.konghq.com/gateway/2.7.x/get-started/quickstart/configuring-a-service
- https://docs.konghq.com/gateway/2.7.x/install-and-run/docker
- https://docs.konghq.com/gateway/2.7.x/plan-and-deploy/default-ports
- https://docs.konghq.com/gateway/2.7.x/plugin-development/access-the-datastore
- https://docs.konghq.com/gateway/2.7.x/reference/db-less-and-declarative-config
- https://docs.konghq.com/gateway/2.8.x/admin-api/developers/reference
- https://docs.konghq.com/gateway/2.8.x/configure/auth/
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/expose-services
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/improve-performance
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/load-balancing
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/protect-services
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/secure-services
- https://docs.konghq.com/gateway/2.8.x/get-started/quickstart/configuring-a-service
- https://docs.konghq.com/gateway/2.8.x/install-and-run/centos
- https://docs.konghq.com/gateway/2.8.x/install-and-run/docker
- https://docs.konghq.com/gateway/2.8.x/install-and-run/helm-quickstart-enterprise
- https://docs.konghq.com/gateway/2.8.x/install-and-run/
- https://docs.konghq.com/gateway/2.8.x/plan-and-deploy/default-ports
- https://docs.konghq.com/gateway/2.8.x/plugin-development/access-the-datastore
- https://docs.konghq.com/gateway/2.8.x/reference/db-less-and-declarative-config
- https://docs.konghq.com/gateway/2.8.x/support-policy
- https://docs.konghq.com/gateway/changelog
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-teams
- https://docs.konghq.com/konnect/gateway-manager/backup-restore
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/how-to
- https://docs.konghq.com/konnect/gateway-manager/declarative-config
- https://docs.konghq.com/konnect/gateway-manager/kic
- https://docs.konghq.com/konnect/getting-started/deploy-service
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/concepts/k4k8s-with-kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/concepts/security
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/deployment/kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/deployment/overview
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/guides/using-oidc-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/references/cli-arguments
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/references/plugin-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/references/version-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/concepts/k4k8s-with-kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/concepts/security
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/deployment/kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/deployment/overview
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/guides/using-oidc-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/references/cli-arguments
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/references/plugin-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/references/version-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/concepts/k4k8s-with-kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/concepts/security
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/deployment/kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/deployment/overview
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/guides/using-oidc-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/references/cli-arguments
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/references/plugin-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/references/version-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/concepts/k4k8s-with-kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/concepts/security
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/deployment/kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/deployment/overview
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/guides/using-oidc-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/references/cli-arguments
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/references/plugin-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/references/version-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/concepts/k4k8s-with-kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/concepts/security
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/deployment/kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/deployment/overview
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/guides/using-oidc-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/references/cli-arguments
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/references/plugin-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/references/version-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/concepts/k4k8s-with-kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/concepts/security
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/deployment/kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/deployment/overview
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/guides/using-oidc-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/references/cli-arguments
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/references/plugin-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/references/version-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/concepts/k4k8s-with-kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/concepts/security
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/deployment/kong-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/deployment/overview
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/guides/using-oidc-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/references/cli-arguments
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/references/plugin-compatibility
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/references/version-compatibility

## Week 44

### [Fix: 2.8.1.3 changelog entry for aws-lambda plugin changes to match 3.0.0.0](https://github.com/Kong/docs.konghq.com/pull/6440) (2023-11-02)

Copied the text written in 3.0.0.0 changelog entry for the aws-lambda plugin to when it was introduced in 2.8.1.3 for consistency. Makes it easier to find the versions in which those properties were added for `aws_assume_role_arn` for example.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Fix: Align wording of 2.8.1.3 update for `aws_assume_role_arn` property](https://github.com/Kong/docs.konghq.com/pull/6439) (2023-11-02)

Extending the wording from the Gateway changelog in 3.0.0.0 and 2.8.1.3 to the plugin changelog for aws-lambda for 2.8.1.3 for consistency.

#### Modified

- https://docs.konghq.com/hub/kong-inc/aws-lambda/


### [Update resource limit language](https://github.com/Kong/docs.konghq.com/pull/6431) (2023-11-01)

Update resource limit language from entity resource limit to Default entity resource limit.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/configuration/


### [Topnav tweaks](https://github.com/Kong/docs.konghq.com/pull/6429) (2023-11-01)

Add a few tweaks based on the feedback we received.

* Remove "We are hiring"
* Move "API Specs" into the "Docs" dropdown

Note: I added a "Documentation" title to the section for consistency

#### Added

- https://docs.konghq.com/assets/images/landing-page/view-all-api-specs.png


### [Release: decK 1.28](https://github.com/Kong/docs.konghq.com/pull/6420) (2023-11-03)

Release 1.28.x decK docs MVP. CLI reference updates only.
Guides to follow.

#### Added

- https://docs.konghq.com/deck/1.28.x/reference/deck_file_convert/
- https://docs.konghq.com/deck/1.28.x/reference/deck_file_lint/
- https://docs.konghq.com/deck/1.28.x/reference/deck_file_validate/
- https://docs.konghq.com/deck/1.28.x/reference/deck_gateway_diff/
- https://docs.konghq.com/deck/1.28.x/reference/deck_gateway_dump/
- https://docs.konghq.com/deck/1.28.x/reference/deck_gateway_ping/
- https://docs.konghq.com/deck/1.28.x/reference/deck_gateway_reset/
- https://docs.konghq.com/deck/1.28.x/reference/deck_gateway_sync/
- https://docs.konghq.com/deck/1.28.x/reference/deck_gateway_validate/

#### Modified

- https://docs.konghq.com/deck/1.24.x/reference/deck/
- https://docs.konghq.com/deck/1.25.x/reference/deck/
- https://docs.konghq.com/deck/1.26.x/reference/deck/
- https://docs.konghq.com/deck/1.27.x/reference/deck/
- https://docs.konghq.com/deck/1.28.x/reference/deck/
- https://docs.konghq.com/deck/1.28.x/reference/deck_completion/
- https://docs.konghq.com/deck/1.28.x/reference/deck_convert/
- https://docs.konghq.com/deck/1.28.x/reference/deck_diff/
- https://docs.konghq.com/deck/1.28.x/reference/deck_dump/
- https://docs.konghq.com/deck/1.28.x/reference/deck_file_add-plugins/
- https://docs.konghq.com/deck/1.28.x/reference/deck_file_add-tags/
- https://docs.konghq.com/deck/1.28.x/reference/deck_file_list-tags/
- https://docs.konghq.com/deck/1.28.x/reference/deck_file_openapi2kong/
- https://docs.konghq.com/deck/1.28.x/reference/deck_file_remove-tags/
- https://docs.konghq.com/deck/1.28.x/reference/deck_file_render/
- https://docs.konghq.com/deck/1.28.x/reference/deck_ping/
- https://docs.konghq.com/deck/1.28.x/reference/deck_reset/
- https://docs.konghq.com/deck/1.28.x/reference/deck_sync/
- https://docs.konghq.com/deck/1.28.x/reference/deck_validate/
- https://docs.konghq.com/deck/1.28.x/reference/deck_version/

### [Fix mistake in auth0 markdown](https://github.com/Kong/docs.konghq.com/pull/6417) (2023-10-31)

Fix description for the `konnect_org_id` field.

#### Modified

- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/auth0


### [Fix: App registration doc lists hybrid mode as not supported](https://github.com/Kong/docs.konghq.com/pull/6416) (2023-11-02)

We've had the same wrong info in the app registration docs since 2.1.x: that when using Kong Gateway as the system of record, app reg can't be used in hybrid mode. This issue recently resurfaced as a customer ran into it. 

Changes made:
* Removing the inaccurate info and making it clear that the limitation is for the OAuth2 plugin only. 
* Added a column to the table in the App Reg plugin overview with info about supported topologies, to make it very clear up front.
* Cleaning up the app reg auth provider strategy docs to remove all the duplicate info and cut the content down to what the user needs to know. We have the same info repeated three times in one topic, making it very difficult to actually follow along with any instructions. 
* Removed outdated images from the edited topics.

Backported it back through 2.6 since it was just a matter of copy & paste.

#### Modified

- https://docs.konghq.com/hub/kong-inc/application-registration/how-to/
- https://docs.konghq.com/hub/kong-inc/application-registration/overview/
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/dev-portal/applications/auth-provider-strategy
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/dev-portal/applications/auth-provider-strategy
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/dev-portal/applications/auth-provider-strategy
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/dev-portal/applications/auth-provider-strategy
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/dev-portal/applications/auth-provider-strategy
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/dev-portal/applications/enable-application-registration
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/dev-portal/applications/enable-application-registration
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/dev-portal/applications/enable-application-registration
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/dev-portal/applications/enable-application-registration
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/dev-portal/applications/enable-application-registration
- https://docs.konghq.com/gateway/2.6.x/developer-portal/administration/application-registration/auth-provider-strategy
- https://docs.konghq.com/gateway/2.6.x/developer-portal/administration/application-registration/enable-application-registration
- https://docs.konghq.com/gateway/2.7.x/developer-portal/administration/application-registration/auth-provider-strategy
- https://docs.konghq.com/gateway/2.7.x/developer-portal/administration/application-registration/enable-application-registration
- https://docs.konghq.com/gateway/2.8.x/developer-portal/administration/application-registration/auth-provider-strategy
- https://docs.konghq.com/gateway/2.8.x/developer-portal/administration/application-registration/enable-application-registration


### [Add Kong Mesh specific policies to the migration script](https://github.com/Kong/docs.konghq.com/pull/6414) (2023-11-01)

In the recently introduced [guide](https://github.com/Kong/docs.konghq.com/pull/6320), I forgot to include Kong Mesh specific policies in the script.

#### Modified

- https://docs.konghq.com/konnect/mesh-manager/migrate-zone


### [fix(opentelemetry): address invalid request to set up plugin](https://github.com/Kong/docs.konghq.com/pull/6406) (2023-10-30)

The request documented to configure the Opentelemetry plugin is invalid because it uses a dot `.` in the name of the attribute, which is interpreted as a field separator in the curl form data.

This updates the documentation without changing the example, using JSON instead of form data to allow passing a name that includes a dot.

#### Modified

- https://docs.konghq.com/hub/kong-inc/opentelemetry/overview/


### [fix: fix changelog entry for openssl version bump](https://github.com/Kong/docs.konghq.com/pull/6404) (2023-10-30)

The PR fixes the issue that the changelog entries of OpenSSL version bumping from 1.1.1t to 3.1.1 are missing from several specific versions.

The missing version list are:
- 2.8.4.2
- 3.1.1.5
- 3.2.2.4
- 3.3.1.1

The PR adds all of them.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Feat: Portal Management API](https://github.com/Kong/docs.konghq.com/pull/6388) (2023-11-02)

Customers are able to integrate portal management operations with their automation systems (such as CI/CD pipelines) by utilizing a refactored and newly-published AIP-compliant Portal Management API.

#### Modified

- https://docs.konghq.com/konnect/updates


### [docs(mesh): update docs and changelog](https://github.com/Kong/docs.konghq.com/pull/6382) (2023-10-31)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/6703671694)

#### Modified

- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshloadbalancingstrategies.yaml
- https://docs.konghq.com/mesh/dev/kuma-cp.yaml

## Week 43

### [Minor update to Noname plugin description](https://github.com/Kong/docs.konghq.com/pull/6375) (2023-10-26)


Minor update to Noname plugin description.
 

#### Modified

- https://docs.konghq.com/hub/nonamesecurity/nonamesecurity-kongprevention/overview/


### [Update cert-manager guide to use Kuma labels](https://github.com/Kong/docs.konghq.com/pull/6371) (2023-10-25)

Kuma uses labels now instead of annotations.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/access-control/enable-rbac
- https://docs.konghq.com/gateway/3.1.x/production/access-control/enable-rbac
- https://docs.konghq.com/gateway/3.2.x/production/access-control/enable-rbac
- https://docs.konghq.com/gateway/3.3.x/production/access-control/enable-rbac
- https://docs.konghq.com/gateway/3.4.x/production/access-control/enable-rbac


### [docs(mesh): update docs and changelog](https://github.com/Kong/docs.konghq.com/pull/6361) (2023-10-27)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/6651206297)

#### Modified

- https://docs.konghq.com/mesh/dev/kuma-cp.yaml


### [fix(portal) remove examples with path in portal gui host](https://github.com/Kong/docs.konghq.com/pull/6358) (2023-10-24)

### Summary
Removes examples of adding a path when configuring `portal_gui_host`

Related: https://github.com/Kong/docs.konghq.com/pull/4179

### Reason
Adding a path to `portal_gui_host` is not supported


#### Modified

- https://docs.konghq.com/gateway/3.0.x/production/access-control/enable-rbac
- https://docs.konghq.com/gateway/3.1.x/production/access-control/enable-rbac
- https://docs.konghq.com/gateway/3.2.x/production/access-control/enable-rbac
- https://docs.konghq.com/gateway/3.3.x/production/access-control/enable-rbac
- https://docs.konghq.com/gateway/3.4.x/production/access-control/enable-rbac


### [Fix API URL in Konnect Custom Plugin docs](https://github.com/Kong/docs.konghq.com/pull/6357) (2023-10-24)

Fix the API URL for uploading custom plugin schemas

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/plugins/add-custom-plugin


### [fix(jwt): state what happens when multiple JWTs are provided](https://github.com/Kong/docs.konghq.com/pull/6353) (2023-10-24)

A user asked to clarify the docs in scenario when multiple JWTs tokens are provided: https://github.com/Kong/kong/issues/11796. With the change from some time ago: https://github.com/Kong/kong/pull/9946 - kong rejects request when multiple JWTs were provided that differ from each other. 
 
This PR explicitly states that the request will be rejected.

#### Modified

- https://docs.konghq.com/hub/kong-inc/jwt/overview/


### [Add GWAPI redirect instructions](https://github.com/Kong/docs.konghq.com/pull/6335) (2023-10-27)

Add GWAPI instructions to the KIC HTTPS redirect guide. Due to https://github.com/Kong/kubernetes-ingress-controller/issues/4890 this uses our vendor annotations.

Adds a TLS configuration include. This creates a certificate and injects configuration to use it into either an Ingress or Gateway. The certificate hostname is configurable. The Gateway and Ingress names are not and expect the standard `echo` Ingress or `kong` Gateway.

GWAPI does not easily allow adding HTTPS configuration without a TLS Listener, and these Listeners _must_ have a certificate as of GWAPI v0.8. We can't use the default Kong certificates if we don't care about the specific certificates, so we need this include for any guides that touch HTTPS-specific functionality.


### [Guide to migrate Zone CP from On-Prem Global CP to Konnect](https://github.com/Kong/docs.konghq.com/pull/6320) (2023-10-23)

Added a new guide on how to migrate Zone from on-prem Global to Konnect


#### Added

- https://docs.konghq.com/assets/images/diagrams/diagram-mesh-migration-after.png
- https://docs.konghq.com/assets/images/diagrams/diagram-mesh-migration-before.png
- https://docs.konghq.com/konnect/mesh-manager/migrate-zone



### [Update: reflect latest FIPS support status](https://github.com/Kong/docs.konghq.com/pull/6286) (2023-10-24)


From https://docs.google.com/document/d/1PJCcO_5DSTbv_08XxDlaS2Cx2-YeYfAencrFhS190AA/edit
and https://github.com/Kong/kong/pull/11725

#### Modified

- https://docs.konghq.com/gateway/3.4.x/reference/configuration

## Week 42


### [Chore: Add search aliases for plugins](https://github.com/Kong/docs.konghq.com/pull/6328) (2023-10-18)

The search field on the plugin hub homepage relies on the plugin's name and the optional `search_aliases` metadata field.
Adding shortform aliases (eg `mtls`), related terms (eg `certificates`), and plugin literal names in code (eg `mtls-auth`).

#### Modified

- https://docs.konghq.com/hub/kong-inc/acme/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/app-dynamics/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/application-registration/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/aws-lambda/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/azure-functions/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/basic-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/bot-detection/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/correlation-id/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/exit-transformer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/file-log/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/forward-proxy/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/graphql-proxy-cache-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/grpc-gateway/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/grpc-web/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/hmac-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/http-log/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/ip-restriction/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/jwe-decrypt/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/jwt-signer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/jwt/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/kafka-log/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/kafka-upstream/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/key-auth-enc/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/key-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/ldap-auth-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/ldap-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/mtls-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/oas-validation/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/oauth2-introspection/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/opa/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/openid-connect/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/opentelemetry/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/proxy-cache-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/proxy-cache/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/rate-limiting/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-size-limiting/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-termination/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-transformer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-validator/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/response-ratelimiting/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/response-transformer-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/response-transformer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/route-by-header/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/route-transformer-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/saml/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/session/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/statsd/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/tcp-log/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/tls-handshake-modifier/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/tls-metadata-headers/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/udp-log/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/upstream-timeout/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/vault-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/websocket-size-limit/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/websocket-validator/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/xml-threat-protection/_metadata.yml


### [Fix: Kong Gateway support matrix](https://github.com/Kong/docs.konghq.com/pull/6326) (2023-10-17)

Fixing the following issues with the [Kong Gateway support matrix](https://docs.konghq.com/gateway/latest/support-policy/):
* PostgreSQL 9 and 10 are no longer supported by upstream but our docs claim to support them. Also, PostgreSQL 11 is also going out of support in 3 weeks
* Our support policy doc incorrectly stated the EOLs of many OSes. We have this statement (adjusted for dates/versions) at the top of every version's support table:

  " Kong Gateway 2.8 LTS supports the following deployment targets until March 2025, unless otherwise noted by an earlier OS vendor end of life (EOL) date." 

  However, our support tables aren't listing the accurate "earlier OS vendor end of life (EOL) dates".

* The support table inaccurately lists available Docker images. We have many new Docker images available now that weren't listed (especially for 2.8 LTS).
  
  As I was trying to figure out which versions we have images for, I also noticed that the base OS for our convenience images changed once again in 3.2.1.0. It originally switched from Alpine to Debian in 3.0.0.0, which is already in the changelog, but we were unaware of the switch to Ubuntu later. Added a changelog entry for that.

https://konghq.atlassian.net/browse/DOCU-3541

#### Modified

- https://docs.konghq.com/gateway/changelog


### [feat(multiple-metrics): updated latency section and images](https://github.com/Kong/docs.konghq.com/pull/6319) (2023-10-19)

Updated content to support our new multiple metrics feature hopefully coming out by the end of this week. In details:
* Updated latency use case section to only cover how to compare upstream vs kong latency. Previously, we had two separate section but you don't need to create two individual reports anymore.
* Updated all images to cover UI changes.

Jira: https://konghq.atlassian.net/browse/MA-1914
Aha: https://konghq.aha.io/features/KP-299

#### Added

- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/kong-vs-upstream-latency.png

#### Modified

- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/api-usage-by-application.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/latency-payments-api-30.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/total-api-requests.png
- https://docs.konghq.com/assets/images/products/konnect/analytics/custom-reports/total-usage-accounts-api-30.png
- https://docs.konghq.com/konnect/analytics/reference
- https://docs.konghq.com/konnect/analytics/use-cases/latency
- https://docs.konghq.com/konnect/updates


### [Update: SSH access note for instances deployed using Konnect Tech Preview install platforms](https://github.com/Kong/docs.konghq.com/pull/6305) (2023-10-18)

Add a note about SSH access to Konnect data plane nodes when using the AWS, Azure, or GCP deployment styles and how it's not allowed directly but need to use the cloud provider tools.

Raised in Slack: https://kongstrong.slack.com/archives/C03NRECFJPM/p1691689181346589

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/


### [update: Portal OIDC teams mapping post-GA improvements for IdP config instructions](https://github.com/Kong/docs.konghq.com/pull/6281) (2023-10-16)


When this was first published, we weren't able to get SME confirmation on the correct steps for setting up the IdP configuration. Users still needed this information, as well as information about configuring groups claims, so I added those in.
 

#### Modified

- https://docs.konghq.com/konnect/dev-portal/access-and-approval/add-teams


### [update: Add Portal RBAC diagram to Managing Developer Team Access Page](https://github.com/Kong/docs.konghq.com/pull/6264) (2023-10-17)


We were requested to make a diagram that better visually explained how the scenario worked with the Pizza Ordering API and developer teams RBAC. I created the diagram and added it. 
 

#### Added

- https://docs.konghq.com/assets/images/diagrams/diagram-dev-portal-team-access.png

#### Modified

- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-teams



## Week 41

### [Fix: Missing `ldaps` option in Kong Manager LDAP setup. Resolves DOCU-2529.](https://github.com/Kong/docs.konghq.com/pull/6304) (2023-10-12)

Added `ldaps` to the `admin_gui_auth_conf` setting and added to the attribute table. Resolves DOCU-2529.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/kong-manager/auth/ldap/configure
- https://docs.konghq.com/gateway/3.1.x/kong-manager/auth/ldap/configure
- https://docs.konghq.com/gateway/3.2.x/kong-manager/auth/ldap/configure
- https://docs.konghq.com/gateway/3.3.x/kong-manager/auth/ldap/configure
- https://docs.konghq.com/gateway/3.4.x/kong-manager/auth/ldap/configure


### [Release: Changelog and version bump for Gateway 2.8.4.4](https://github.com/Kong/docs.konghq.com/pull/6303) (2023-10-12)

Changelog for Gateway EE 2.8.4.4 patch version.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Changelog and version bump for Gateway 3.1.1.6](https://github.com/Kong/docs.konghq.com/pull/6302) (2023-10-12)

Changelog for Gateway EE 3.1.1.6 patch version.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Changelog and version bump for Gateway 3.2.2.5](https://github.com/Kong/docs.konghq.com/pull/6301) (2023-10-12)

Changelog for Gateway EE 3.2.2.5 patch version.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Fix: Konnect OIDC sign-in & sign-out redirect URIs](https://github.com/Kong/docs.konghq.com/pull/6300) (2023-10-12)

Fixes the reported issue in Jira [DOCU-3311](https://konghq.atlassian.net/browse/DOCU-3311) which was causing confusion with the `examplepath` name in the testing section of the login URL.

#### Modified

- https://docs.konghq.com/konnect/org-management/oidc-idp


### [Release: Changelog and version bump for Gateway 3.3.1.1](https://github.com/Kong/docs.konghq.com/pull/6299) (2023-10-12)

Changelog for Gateway EE 3.3.1.1 patch version.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Release: Changelog and version bump for Gateway 3.4.1.1 and 3.4.2](https://github.com/Kong/docs.konghq.com/pull/6298) (2023-10-12)

Changelog for Gateway EE 3.4.1.1 and OSS 3.4.2 releases.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [update: Remove Gateway 3.0 from supported versions and move to older versions table](https://github.com/Kong/docs.konghq.com/pull/6297) (2023-10-12)

Support for Gateway 3.0 was removed in September, so we needed to update our support version docs to reflect that.
 
DOCU-3519

#### Modified

- https://docs.konghq.com/gateway/3.2.x/support/third-party
- https://docs.konghq.com/gateway/3.3.x/support/third-party
- https://docs.konghq.com/gateway/3.4.x/support/third-party



### [Update: Salt plugin now supports new queue in 3.3+](https://github.com/Kong/docs.konghq.com/pull/6280) (2023-10-11)

In Kong 3.3, the queue logic was updated, forcing a change to the plugin logic. This is that update.
 
background: https://konghq.com/blog/product-releases/reworked-plugin-queues-in-kong-gateway-3-3

#### Modified

- https://docs.konghq.com/hub/salt/salt/_metadata.yml


### [Fix: curl examples for custom plugins schemas in Konnect](https://github.com/Kong/docs.konghq.com/pull/6252) (2023-10-10)

Turns out that you can't pass a file directly via cURL to our Konnect CP configuration API. The contents of the file don't get escaped correctly. When testing this out originally, I used a mix of cURL and HTTPie, and HTTPie had no issues - but our default cURL instructions have problems here.

Issue was reported on [Slack](https://kongstrong.slack.com/archives/C03NRECFJPM/p1696622470557839).

Updating the doc with Fero's help, tested it all with curl this time around.

The jq instructions are in a "tip", since we can't tell them to use jq if they don't want to or don't have it.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/plugins/add-custom-plugin
- https://docs.konghq.com/konnect/gateway-manager/plugins/update-custom-plugin


### [Update: Third-party categorization](https://github.com/Kong/docs.konghq.com/pull/6236) (2023-10-11)

Third party plugins are now categorized as:
* Partner plugins: third party contributors that have a close relationship with Kong, usually meaning contracts, rigorous testing, etc.
* Unsupported community plugins: Plugins from contributors that haven't gone through the above process.

This update makes it clearer which is which by using better filtering, banners, and categorization.

https://konghq.atlassian.net/browse/DOCU-3509

#### Modified

- https://docs.konghq.com/hub/TheLEGOGroup/aws-request-signing/_metadata.yml
- https://docs.konghq.com/hub/amberflo/kong-plugin-amberflo/_metadata.yml
- https://docs.konghq.com/hub/imperva/imp-appsec-connector/_metadata.yml
- https://docs.konghq.com/hub/moesif/kong-plugin-moesif/_metadata.yml
- https://docs.konghq.com/hub/okta/okta/_metadata.yml
- https://docs.konghq.com/hub/optum/kong-response-size-limiting/_metadata.yml
- https://docs.konghq.com/hub/optum/kong-service-virtualization/_metadata.yml
- https://docs.konghq.com/hub/optum/kong-spec-expose/_metadata.yml
- https://docs.konghq.com/hub/optum/kong-splunk-log/_metadata.yml
- https://docs.konghq.com/hub/optum/kong-upstream-jwt/_metadata.yml
- https://docs.konghq.com/hub/salt/salt/_metadata.yml
- https://docs.konghq.com/hub/wallarm/wallarm/_metadata.yml
- https://docs.konghq.com/hub/index.html


### [Update: Add info on cache locations in Gateway 2.x vs 3.x](https://github.com/Kong/docs.konghq.com/pull/6192) (2023-10-11)

The latest version of the documentation refers only to the config.json.gz which is misleading as on 3.x this was moved to lmdb. It has been updated to reflect both noting the version change.
 
https://docs.konghq.com/gateway/latest/production/deployment-topologies/hybrid-mode/#data-plane-cache-configuration

#### Modified

- https://docs.konghq.com/konnect/network-resiliency

## Week 40

### [Fix: Badge alignment](https://github.com/Kong/docs.konghq.com/pull/6245) (2023-10-06)

Badges & their tooltips are currently misaligned on h2-h5s:

<img width="773" alt="Screenshot 2023-10-05 at 1 45 43 PM" src="https://github.com/Kong/docs.konghq.com/assets/54370747/5ea03aa5-02e9-4b9d-b6b1-f26bd758285b">

<img width="777" alt="Screenshot 2023-10-05 at 1 46 26 PM" src="https://github.com/Kong/docs.konghq.com/assets/54370747/68ce7939-3e58-40b2-bcdb-b0489d5ac6ca">

This PR fixes the alignment for both.

While testing out the fix, I also noticed that we had some wrong badges applied to the Konnect section of the Gateway intro page. We got rid of Plus and Enterprise badges for Konnect with the switch to consumption-based billing, since it isn't accurate to apply either tier to features in Konnect anymore.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/
- https://docs.konghq.com/gateway/3.1.x/
- https://docs.konghq.com/gateway/3.2.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/contributing/markdown-rules


### [fix: Plugin tiers for konnect-incompatible plugins](https://github.com/Kong/docs.konghq.com/pull/6235) (2023-10-05)

Some konnect-incompatible plugins were displaying Konnect Paid or Konnect Premium badges. This was happening because the metadata was incorrectly set to include either `paid: true` or `premium: true` for these plugins.

Fixing that, and adding a banner to konnect-incompatible plugin landing pages to call that out.

#### Modified

- https://docs.konghq.com/hub/kong-inc/jwt-signer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/key-auth-enc/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/openwhisk/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/vault-auth/_0.3.0/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/vault-auth/_metadata.yml


### [feat: OIDC team mapping documentation](https://github.com/Kong/docs.konghq.com/pull/6227) (2023-10-04)

The OIDC team mapping feature will be released, so we need documentation that explains the workflow for how to set it up in Konnect. This PR also made some fixes after the previous PR was reverted.

#### Added

- https://docs.konghq.com/konnect/dev-portal/access-and-approval/add-teams

#### Modified

- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-teams
- https://docs.konghq.com/konnect/updates


### [Update: Docs 404 page](https://github.com/Kong/docs.konghq.com/pull/6210) (2023-10-02)

Docs 404 page had bad alignment and outdated links. Making some adjustments to the layout and using better element hierarchy.

#### Modified

- https://docs.konghq.com/404.html


### [Update: Add cache names to mem_cache_size](https://github.com/Kong/docs.konghq.com/pull/6206) (2023-10-03)

The mem_cache_size parameter in kong.conf mentions that it controls the size of two caches, but doesn't say what the names of the caches are.
According to our [changelog](https://github.com/Kong/kong/blob/master/CHANGELOG-OLD.md#core-32), these two in-memory caches are kong_core_cache and kong_cache.

Resolves doc ticket https://konghq.atlassian.net/browse/DOCU-1878.

Parallel PR to https://github.com/Kong/kong/pull/11680.

#### Modified

- https://docs.konghq.com/gateway/2.8.x/reference/configuration


### [feat: OIDC IdP Team Mapping functionality](https://github.com/Kong/docs.konghq.com/pull/6166) (2023-10-03)

Adds new documentation about the OIDC iDP team mapping function.


#### Added

- https://docs.konghq.com/konnect/dev-portal/access-and-approval/add-teams

#### Modified

- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-teams
- https://docs.konghq.com/konnect/updates


### [Feat: PKI Certs for CP/DP authentication](https://github.com/Kong/docs.konghq.com/pull/6155) (2023-10-02)

Konnect now supports pinned PKI certs for CP/DP authentication. This means that Konnect supports digital certificates signed by a trusted CA in Konnect for CP/DP authentication.

[DOCU-3357](https://konghq.atlassian.net/browse/DOCU-3357)

#### Added

- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/secure-communications

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/renew-certificates
- https://docs.konghq.com/konnect/updates

## Week 39

### [Fix: View Organizations](https://github.com/Kong/docs.konghq.com/pull/6203) (2023-09-29)

To navigate back to the org switcher from Konnect. The button now says "View Organizations" rather than "Back to org switcher".

![image](https://github.com/Kong/docs.konghq.com/assets/1035820/463be71d-88d3-4bfd-8f1a-ed7b13dc9408)

#### Modified

- https://docs.konghq.com/konnect/org-management/org-switcher


### [Fix: AWS Lambda plugin headers line](https://github.com/Kong/docs.konghq.com/pull/6200) (2023-09-29)

Previous line wasn't clear and readers were confused. The suggested text makes it clearer what the "additional headers" are.

https://konghq.atlassian.net/browse/DOCU-1554

#### Modified

- https://docs.konghq.com/hub/kong-inc/aws-lambda/overview/


### [Update: Add info about untrusted_lua param to exit transformer plugin](https://github.com/Kong/docs.konghq.com/pull/6199) (2023-09-29)

The Exit Transformer plugin allows you to execute Lua functions. There is a setting in kong.conf that controls any plugins or other functionality that can do that. There was nothing in the plugin's doc about the setting, so I added that in.

https://konghq.atlassian.net/browse/DOCU-1046

#### Modified

- https://docs.konghq.com/hub/kong-inc/exit-transformer/overview/


### [Update: Add link to routing reference from Request Transformer Advanced](https://github.com/Kong/docs.konghq.com/pull/6198) (2023-09-29)

From ticket:

> The documentation would be more helpful if there was a link back to the using-regexes-in-paths to capture uri from the request transform doc to show how this is actually done. 
> This would provide the additional context of how to initially implement this functionality.

Adding the requested link + minor formatting edits to arrange the steps into an ordered list.

https://konghq.atlassian.net/browse/DOCU-156

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/how-to/


### [Chore: Consistent banners/callouts across docs site](https://github.com/Kong/docs.konghq.com/pull/6190) (2023-09-28)

We have a lot of different alert/callout/banner styles across the docs site. They are a mix of two styles:

* `alert` div elements and all of their classes and subclasses
* `blockquote` elements with a few different classes

The `alert` div is the old method, where we used html tags in the docs. The `blockquote` method is what we use now, where we can use markdown and apply a banner class like this:

```
{:.note}
> This is my note.


{:.note .no-icon}
> This is my note without an icon.
```

The issue is that the CSS styling for the old and new elements keeps growing wider apart, as changes are made to the blockquote and not to the alert. This became far more obvious after the site redesign, where we ended up with lot of different font sizes and spacing issues in banners:

Inconsistent styling using `alert`:
<img width="793" alt="Screenshot 2023-09-27 at 2 41 14 PM" src="https://github.com/Kong/docs.konghq.com/assets/54370747/b4cc0514-5516-4c57-b3c1-54f3f62d6c85">
<img width="798" alt="Screenshot 2023-09-27 at 2 41 32 PM" src="https://github.com/Kong/docs.konghq.com/assets/54370747/5410bfde-27c5-4095-9032-80897370c303">

Consistent styling using markdown and blockquotes:
<img width="781" alt="Screenshot 2023-09-27 at 2 41 55 PM" src="https://github.com/Kong/docs.konghq.com/assets/54370747/e02c81ac-6478-4fdc-8cb6-a21a4e71812e">

If we want to adjust styling after this, we should do so based on the blockquote element.

#### Modified

- https://docs.konghq.com/hub/kong-inc/exit-transformer/overview/
- https://docs.konghq.com/hub/kong-inc/jwt/overview/
- https://docs.konghq.com/hub/kong-inc/key-auth/overview/
- https://docs.konghq.com/hub/kong-inc/oauth2/overview/
- https://docs.konghq.com/gateway-operator/1.0.x/support
- https://docs.konghq.com/gateway-operator/1.0.x/topologies/dbless/
- https://docs.konghq.com/gateway/3.0.x/
- https://docs.konghq.com/gateway/3.1.x/
- https://docs.konghq.com/gateway/3.2.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.0.x/kong-plugins/authentication/reference
- https://docs.konghq.com/gateway/3.1.x/kong-plugins/authentication/reference
- https://docs.konghq.com/gateway/3.2.x/kong-plugins/authentication/reference
- https://docs.konghq.com/gateway/3.3.x/kong-plugins/authentication/reference
- https://docs.konghq.com/gateway/3.4.x/kong-plugins/authentication/reference
- https://docs.konghq.com/gateway/3.0.x/licenses/download
- https://docs.konghq.com/gateway/3.1.x/licenses/download
- https://docs.konghq.com/gateway/3.2.x/licenses/download
- https://docs.konghq.com/gateway/3.3.x/licenses/download
- https://docs.konghq.com/gateway/3.4.x/licenses/download
- https://docs.konghq.com/gateway/3.0.x/licenses/examples
- https://docs.konghq.com/gateway/3.1.x/licenses/examples
- https://docs.konghq.com/gateway/3.2.x/licenses/examples
- https://docs.konghq.com/gateway/3.3.x/licenses/examples
- https://docs.konghq.com/gateway/3.4.x/licenses/examples
- https://docs.konghq.com/gateway/3.0.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.1.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.2.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.3.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.4.x/plugin-development/custom-logic
- https://docs.konghq.com/gateway/3.0.x/plugin-development/pdk/kong.websocket.client
- https://docs.konghq.com/gateway/3.1.x/plugin-development/pdk/kong.websocket.client
- https://docs.konghq.com/gateway/3.2.x/plugin-development/pdk/kong.websocket.client
- https://docs.konghq.com/gateway/3.3.x/plugin-development/pdk/kong.websocket.client
- https://docs.konghq.com/gateway/3.4.x/plugin-development/pdk/kong.websocket.client
- https://docs.konghq.com/gateway/3.0.x/plugin-development/pdk/kong.websocket.upstream
- https://docs.konghq.com/gateway/3.1.x/plugin-development/pdk/kong.websocket.upstream
- https://docs.konghq.com/gateway/3.2.x/plugin-development/pdk/kong.websocket.upstream
- https://docs.konghq.com/gateway/3.3.x/plugin-development/pdk/kong.websocket.upstream
- https://docs.konghq.com/gateway/3.4.x/plugin-development/pdk/kong.websocket.upstream
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/mesh/1.7.x/
- https://docs.konghq.com/mesh/2.0.x/
- https://docs.konghq.com/mesh/2.1.x/
- https://docs.konghq.com/mesh/1.7.x/installation/amazonlinux
- https://docs.konghq.com/mesh/1.8.x/installation/amazonlinux
- https://docs.konghq.com/mesh/1.9.x/installation/amazonlinux
- https://docs.konghq.com/mesh/2.0.x/installation/amazonlinux/
- https://docs.konghq.com/mesh/2.1.x/installation/amazonlinux/
- https://docs.konghq.com/gateway/2.6.x/admin-api/audit-log
- https://docs.konghq.com/gateway/2.6.x/admin-api/
- https://docs.konghq.com/gateway/2.6.x/admin-api/licenses/examples
- https://docs.konghq.com/gateway/2.6.x/configure/auth/
- https://docs.konghq.com/gateway/2.6.x/configure/auth/oidc-mapping
- https://docs.konghq.com/gateway/2.6.x/developer-portal/administration/application-registration/auth-provider-strategy
- https://docs.konghq.com/gateway/2.6.x/developer-portal/administration/application-registration/okta-config
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/expose-services
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/manage-teams
- https://docs.konghq.com/gateway/2.6.x/get-started/comprehensive/prepare
- https://docs.konghq.com/gateway/2.6.x/plan-and-deploy/licenses/access-license
- https://docs.konghq.com/gateway/2.6.x/reference/health-checks-circuit-breakers
- https://docs.konghq.com/gateway/2.6.x/reference/proxy
- https://docs.konghq.com/gateway/2.7.x/admin-api/audit-log
- https://docs.konghq.com/gateway/2.7.x/admin-api/licenses/examples
- https://docs.konghq.com/gateway/2.7.x/configure/auth/
- https://docs.konghq.com/gateway/2.7.x/developer-portal/administration/application-registration/auth-provider-strategy
- https://docs.konghq.com/gateway/2.7.x/developer-portal/administration/application-registration/okta-config
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/expose-services
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/manage-teams
- https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/prepare
- https://docs.konghq.com/gateway/2.7.x/plan-and-deploy/licenses/access-license
- https://docs.konghq.com/gateway/2.7.x/reference/health-checks-circuit-breakers
- https://docs.konghq.com/gateway/2.7.x/reference/proxy
- https://docs.konghq.com/gateway/2.8.x/admin-api/audit-log
- https://docs.konghq.com/gateway/2.8.x/admin-api/licenses/examples
- https://docs.konghq.com/gateway/2.8.x/configure/auth/
- https://docs.konghq.com/gateway/2.8.x/developer-portal/administration/application-registration/auth-provider-strategy
- https://docs.konghq.com/gateway/2.8.x/developer-portal/administration/application-registration/okta-config
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/expose-services
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/manage-teams
- https://docs.konghq.com/gateway/2.8.x/get-started/comprehensive/prepare
- https://docs.konghq.com/gateway/2.8.x/plan-and-deploy/licenses/access-license
- https://docs.konghq.com/gateway/2.8.x/reference/health-checks-circuit-breakers
- https://docs.konghq.com/gateway/2.8.x/reference/proxy
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/concepts/ingress-versions
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/concepts/ingress-versions
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/concepts/ingress-versions
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/concepts/ingress-versions
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/concepts/ingress-versions
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/concepts/ingress-versions
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/concepts/ingress-versions
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/deployment/k4k8s-enterprise
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/deployment/k4k8s
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/guides/setting-up-custom-plugins
- https://docs.konghq.com/mesh/1.2.x/gettingstarted
- https://docs.konghq.com/mesh/1.2.x/
- https://docs.konghq.com/mesh/1.2.x/installation/amazonlinux
- https://docs.konghq.com/mesh/1.3.x/gettingstarted
- https://docs.konghq.com/mesh/1.3.x/
- https://docs.konghq.com/mesh/1.3.x/installation/amazonlinux
- https://docs.konghq.com/mesh/1.4.x/gettingstarted
- https://docs.konghq.com/mesh/1.4.x/
- https://docs.konghq.com/mesh/1.4.x/installation/amazonlinux
- https://docs.konghq.com/mesh/1.5.x/gettingstarted
- https://docs.konghq.com/mesh/1.5.x/
- https://docs.konghq.com/mesh/1.5.x/installation/amazonlinux
- https://docs.konghq.com/mesh/1.6.x/gettingstarted
- https://docs.konghq.com/mesh/1.6.x/
- https://docs.konghq.com/mesh/1.6.x/installation/amazonlinux


### [fix: MinK control plane diagram](https://github.com/Kong/docs.konghq.com/pull/6187) (2023-09-27)

The original diagram showed zones and ingress/egress as being Konnect managed, which was incorrect. This PR corrects it since only the global control plane is managed by Konnect.
 
Fixes #6180

#### Modified

- https://docs.konghq.com/assets/images/diagrams/diagram-mesh-in-konnect.png


### [Fix: Configuring https redirect](https://github.com/Kong/docs.konghq.com/pull/6185) (2023-09-27)

Tested, validated, and rewrote the guide.

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/configuring-https-redirect
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/configuring-https-redirect
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/configuring-https-redirect
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/configuring-https-redirect
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/configuring-https-redirect
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/configuring-https-redirect
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/configuring-https-redirect
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/configuring-https-redirect
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/configuring-https-redirect


### [Feat: Changelog for konnect custom plugin management](https://github.com/Kong/docs.konghq.com/pull/6178) (2023-09-26)

Changelog entry for Konnect custom plugins.

Relates to https://github.com/Kong/docs.konghq.com/pull/6164.

#### Modified

- https://docs.konghq.com/konnect/updates


### [Feat: Konnect plus metered billing](https://github.com/Kong/docs.konghq.com/pull/6177) (2023-09-26)

https://konghq.atlassian.net/browse/DOCU-3353
Changes: 
* Adds new metadata for paid and premium, deleted mentions of Plus in the metadata. 
* Navbar changes - Deletes the old UI instructions for billing
* Redirects
* Added SS of billing dashboard
* Reworked table logic across docs.
* Updates PH tiers and badges and compatibility(Thanks Lena)
![image](https://github.com/Kong/docs.konghq.com/assets/23319190/7702d53c-94ca-42d8-9255-27e1718c0c5b)


https://deploy-preview-6099--kongdocs.netlify.app/konnect/compatibility/ 
https://deploy-preview-6099--kongdocs.netlify.app/konnect/account-management/



New table looks like this: 
![image](https://github.com/Kong/docs.konghq.com/assets/23319190/8b1f3ca1-30a3-4d31-8775-6f4a99fc9bdf)

#### Added

- https://docs.konghq.com/assets/images/docs/konnect/billing/Invoices.png
- https://docs.konghq.com/assets/images/docs/konnect/billing/billing-and-usage.png

#### Modified

- https://docs.konghq.com/hub/kong-inc/acl/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/acme/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/app-dynamics/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/application-registration/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/aws-lambda/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/azure-functions/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/basic-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/bot-detection/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/canary/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/correlation-id/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/cors/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/datadog/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/degraphql/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/exit-transformer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/file-log/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/forward-proxy/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/graphql-proxy-cache-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/grpc-gateway/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/grpc-web/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/hmac-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/http-log/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/ip-restriction/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/jq/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/jwe-decrypt/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/jwt-signer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/jwt/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/kafka-log/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/kafka-upstream/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/key-auth-enc/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/key-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/ldap-auth-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/ldap-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/loggly/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/mocking/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/mtls-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/oas-validation/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/oauth2-introspection/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/opa/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/openid-connect/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/opentelemetry/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/openwhisk/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/prometheus/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/proxy-cache-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/proxy-cache/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/_v1/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/
- https://docs.konghq.com/hub/kong-inc/rate-limiting/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-size-limiting/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-termination/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-transformer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-validator/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/response-ratelimiting/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/response-transformer-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/response-transformer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/route-by-header/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/route-transformer-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/saml/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/session/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/statsd-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/statsd/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/syslog/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/tcp-log/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/udp-log/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/upstream-timeout/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/vault-auth/_0.3.0/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/vault-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/websocket-size-limit/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/websocket-validator/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/xml-threat-protection/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/zipkin/_metadata.yml
- https://docs.konghq.com/hub/plugins/license-tiers
- https://docs.konghq.com/konnect/account-management/
- https://docs.konghq.com/konnect/analytics/
- https://docs.konghq.com/konnect/compatibility
- https://docs.konghq.com/konnect/dev-portal/dev-reg
- https://docs.konghq.com/konnect/gateway-manager/declarative-config
- https://docs.konghq.com/konnect/gateway-manager/
- https://docs.konghq.com/konnect/gateway-manager/kic
- https://docs.konghq.com/konnect/getting-started/access-account
- https://docs.konghq.com/konnect/getting-started/import
- https://docs.konghq.com/konnect/org-management/auth
- https://docs.konghq.com/konnect/org-management/deactivation
- https://docs.konghq.com/konnect/updates


### [Chore: Remove old konnect api doc](https://github.com/Kong/docs.konghq.com/pull/6168) (2023-09-25)

Removing the [old Konnect Runtime Groups Config API doc](https://docs.konghq.com/konnect/api/runtime-groups-config/overview/). It has been replaced with:

https://docs.konghq.com/konnect/api/
https://docs.konghq.com/konnect/api/control-plane-configuration/latest/


### [Feat: Custom plugin management in Konnect](https://github.com/Kong/docs.konghq.com/pull/6164) (2023-09-28)

Documentation for managing custom plugins through Konnect, using either the UI or the Konnect custom plugins API.

https://konghq.atlassian.net/browse/DOCU-2596

#### Added

- https://docs.konghq.com/assets/images/docs/konnect/konnect-custom-plugins.png
- https://docs.konghq.com/assets/images/docs/konnect/konnect-plugin-list.png
- https://docs.konghq.com/konnect/gateway-manager/plugins/add-custom-plugin
- https://docs.konghq.com/konnect/gateway-manager/plugins/
- https://docs.konghq.com/konnect/gateway-manager/plugins/troubleshoot-custom-plugins
- https://docs.konghq.com/konnect/gateway-manager/plugins/update-custom-plugin

#### Modified

- https://docs.konghq.com/gateway/3.0.x/plugin-development/distribution
- https://docs.konghq.com/gateway/3.1.x/plugin-development/distribution
- https://docs.konghq.com/gateway/3.2.x/plugin-development/distribution
- https://docs.konghq.com/gateway/3.3.x/plugin-development/distribution
- https://docs.konghq.com/gateway/3.4.x/plugin-development/distribution


### [Social Login and Org Switcher](https://github.com/Kong/docs.konghq.com/pull/6161) (2023-09-25)

Docs for Social Login and Org Switcher.

Epic: https://konghq.aha.io/epics/KP-E-65

#### Added

- https://docs.konghq.com/konnect/org-management/org-switcher
- https://docs.konghq.com/konnect/org-management/social-identity-login

#### Modified

- https://docs.konghq.com/konnect/getting-started/access-account
- https://docs.konghq.com/konnect/org-management/auth
- https://docs.konghq.com/konnect/updates


### [Add Kong Gateway Operator docs](https://github.com/Kong/docs.konghq.com/pull/6144) (2023-09-27)

Kong Gateway Operator docs.

#### Added

- https://docs.konghq.com/gateway-operator/1.0.x/concepts/gateway-api
- https://docs.konghq.com/gateway-operator/1.0.x/concepts/gateway-configuration
- https://docs.konghq.com/gateway-operator/1.0.x/customization/data-plane-image/
- https://docs.konghq.com/gateway-operator/1.0.x/customization/pod-template-spec/
- https://docs.konghq.com/gateway-operator/1.0.x/customization/sidecars/
- https://docs.konghq.com/gateway-operator/1.0.x/faq
- https://docs.konghq.com/gateway-operator/1.0.x/get-started/kic/create-gateway/
- https://docs.konghq.com/gateway-operator/1.0.x/get-started/kic/create-route/
- https://docs.konghq.com/gateway-operator/1.0.x/get-started/kic/install/
- https://docs.konghq.com/gateway-operator/1.0.x/get-started/konnect/create-route/
- https://docs.konghq.com/gateway-operator/1.0.x/get-started/konnect/deploy-data-plane/
- https://docs.konghq.com/gateway-operator/1.0.x/get-started/konnect/install/
- https://docs.konghq.com/gateway-operator/1.0.x/
- https://docs.konghq.com/gateway/3.0.x/
- https://docs.konghq.com/gateway/3.1.x/
- https://docs.konghq.com/gateway/3.2.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/gateway-operator/1.0.x/production/monitoring/
- https://docs.konghq.com/gateway/3.0.x/
- https://docs.konghq.com/gateway/3.1.x/
- https://docs.konghq.com/gateway/3.2.x/
- https://docs.konghq.com/gateway/3.3.x/
- https://docs.konghq.com/gateway/3.4.x/
- https://docs.konghq.com/gateway-operator/1.0.x/production/upgrade/data-plane/rolling/
- https://docs.konghq.com/gateway-operator/1.0.x/production/upgrade/gateway-operator/
- https://docs.konghq.com/gateway/3.0.x/how-kong-works/health-checks
- https://docs.konghq.com/gateway/3.1.x/how-kong-works/health-checks
- https://docs.konghq.com/gateway/3.2.x/how-kong-works/health-checks
- https://docs.konghq.com/gateway/3.3.x/how-kong-works/health-checks
- https://docs.konghq.com/gateway/3.4.x/how-kong-works/health-checks
- https://docs.konghq.com/gateway/3.0.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.1.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.2.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.3.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.4.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/dev-portal/applications/auth-provider-strategy
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/dev-portal/applications/auth-provider-strategy
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/dev-portal/applications/auth-provider-strategy
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/dev-portal/applications/auth-provider-strategy
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/dev-portal/applications/auth-provider-strategy
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/assets/gateway-operator/v1.0.0/all_controllers.yaml
- https://docs.konghq.com/assets/gateway-operator/v1.0.0/crds.yaml
- https://docs.konghq.com/assets/gateway-operator/v1.0.0/default.yaml
- https://docs.konghq.com/gateway-operator/changelog


### [fix: Expose an external application](https://github.com/Kong/docs.konghq.com/pull/6141) (2023-09-27)

Tested, validated, rewrote the guide.

#### Modified

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


### [fix: Exposing UDP service](https://github.com/Kong/docs.konghq.com/pull/6127) (2023-09-25)

Tested, Validated, and Formatted the UDP service guide.

#### Modified

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
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/redis-rate-limiting


### [Feat: Add tool that detects broken markdown anchors](https://github.com/Kong/docs.konghq.com/pull/6111) (2023-09-28)

Add a new tool that detects output of ` [.+][.+] ` in the `dist` folder. These are markdown links where the anchor at the bottom of the file could not be found.

#6101 is a good example of where this happens

#### Modified

- https://docs.konghq.com/hub/kong-inc/vault-auth/
- https://docs.konghq.com/hub/kong-inc/vault-auth/overview/
- https://docs.konghq.com/gateway-operator/1.0.x/topologies/dbless/
- https://docs.konghq.com/gateway/3.0.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.1.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.2.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.3.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.4.x/how-kong-works/routing-traffic
- https://docs.konghq.com/gateway/3.0.x/kong-plugins/authentication/oidc/azure-ad
- https://docs.konghq.com/gateway/3.1.x/kong-plugins/authentication/oidc/azure-ad
- https://docs.konghq.com/gateway/3.2.x/kong-plugins/authentication/oidc/azure-ad
- https://docs.konghq.com/gateway/3.3.x/kong-plugins/authentication/oidc/azure-ad
- https://docs.konghq.com/gateway/3.4.x/kong-plugins/authentication/oidc/azure-ad
- https://docs.konghq.com/gateway/2.6.x/configure/auth/oidc-azuread
- https://docs.konghq.com/gateway/2.6.x/reference/proxy
- https://docs.konghq.com/gateway/2.7.x/configure/auth/oidc-azuread
- https://docs.konghq.com/gateway/2.7.x/reference/proxy
- https://docs.konghq.com/gateway/2.8.x/configure/auth/oidc-azuread
- https://docs.konghq.com/gateway/2.8.x/reference/proxy


### [fix: Using Redis for rate limiting](https://github.com/Kong/docs.konghq.com/pull/6110) (2023-09-25)

Formatting changes and curl option changes.
Used placeholders because the command varies based on the install method

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/redis-rate-limiting
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/redis-rate-limiting

### [Feat(api-requests): Added API requests beta to docs](https://github.com/Kong/docs.konghq.com/pull/6104) (2023-09-26)

Added a new section under Analytics to document our upcoming API Requests feature. This feature is in beta. Please take a look at [this release](https://konghq.atlassian.net/wiki/spaces/KNN/pages/3065151570/API+Requests+Beta) minutes page to learn more about this feature.

https://konghq.atlassian.net/browse/DOCU-3264

#### Added

- https://docs.konghq.com/assets/images/docs/konnect/konnect-analytics-api-requests.png
- https://docs.konghq.com/konnect/analytics/api-requests

#### Modified

- https://docs.konghq.com/konnect/updates


### [doc(portal): add documentation for auth0 dcr metadata TDX-3342](https://github.com/Kong/docs.konghq.com/pull/6096) (2023-09-26)

Adds documentation around auth0 metadata, and how to use it via an action.  

https://konghq.atlassian.net/browse/TDX-3342

#### Modified

- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/auth0
- https://docs.konghq.com/konnect/updates


### [Update: Sectioned cluster_fallback configs + added WebAssembly text to Wasm section](https://github.com/Kong/docs.konghq.com/pull/6065) (2023-09-27)

Moved the DP Resilience feature (Cluster Fallback) properties to their own section for better organization and linking. Loosely related to https://github.com/Kong/docs.konghq.com/pull/6064.

Also noticed our Wasm section had no reference to the text 'WebAssembly' which resulted in it not being found easily. Added that to the title of that section to allow for better searchability.

#### Modified

- https://docs.konghq.com/gateway/latest/reference/configuration/

## Week 38


### [Update: Konnect audit log webhooks only allow HTTPS](https://github.com/Kong/docs.konghq.com/pull/6142) (2023-09-20)

Konnect Audit Webhook Configurations only allow HTTPS endpoints - HTTP endpoint traffic will blocked at network level. Hence, updated docs to reflect same.

#### Modified

- https://docs.konghq.com/konnect/org-management/audit-logging/webhook


### [fix(dcr): Note about Azure DCR v1 endpoints](https://github.com/Kong/docs.konghq.com/pull/6126) (2023-09-20)

We wanted to add [a small note](https://kongstrong.slack.com/archives/C05HHGAPYJU/p1695033542245779) about Azure DCR only supporting v1 endpoints.

#### Modified

- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/azure


### [Feat: Konnect Great Rename](https://github.com/Kong/docs.konghq.com/pull/6121) (2023-09-20)

The “runtime” terminology has become overloaded and not meaningful to users. Since the conception of Konnect, users have struggled with understanding the “runtime group” and “runtime instances” terms and how they match up with the gateway topology.

With this rename, kong-ified terms such as “runtime” are replaced with more standardized terminology such as control plane and data plane. As a result, new users to Konnect should have an easier time understanding and navigating the Konnect UI and APIs.

https://konghq.atlassian.net/browse/DOCU-3151

#### Summary of changes

UI:
* Runtime Manager to Gateway Manager
* Runtime group to control plane
* Composite runtime group to control plane group
* Runtime instance to data plane node

API:
* `/v2/systems-accounts` to `/v3/system-accounts`
* `/v2/teams` to `/v3/teams`
* `/v2/users` to `/v3/users`
* `/v2/roles` to `/v3/roles`
* `/v2/runtime-groups` to `/v2/control-planes`
* `/v2/runtime-groups/{runtimeGroupId}/` to `/v2/control-planes/{controlPlaneId}/`
* `/v2/runtime-groups/{runtimeGroupId}/composite-status` to `/v2/control-planes/{controlPlaneId}/group-status`

decK:
* decK command flag: `--konnect-runtime-group-name` to `--konnect-control-plane-name`
* decK state file attribute: `_konnect.runtime_group_name`  to` _konnect.control_plane_name`

#### Added

- https://docs.konghq.com/assets/images/docs/konnect/konnect-control-plane-dashboard.png
- https://docs.konghq.com/assets/images/docs/konnect/konnect-control-plane-group.svg
- https://docs.konghq.com/assets/images/docs/konnect/konnect-control-plane.svg
- https://docs.konghq.com/assets/images/docs/konnect/konnect-control-planes-example.png
- https://docs.konghq.com/assets/images/docs/konnect/konnect-install-options.png
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/conflicts
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/migrate
- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/
- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/upgrade
- https://docs.konghq.com/konnect/gateway-manager/
- https://docs.konghq.com/konnect/gateway-manager/troubleshoot
- https://docs.konghq.com/konnect/getting-started/configure-data-plane-node

#### Modified

- https://docs.konghq.com/hub/kong-inc/mtls-auth/overview/
- https://docs.konghq.com/deck/1.15.x/3.0-upgrade
- https://docs.konghq.com/deck/1.16.x/3.0-upgrade
- https://docs.konghq.com/deck/1.17.x/3.0-upgrade
- https://docs.konghq.com/deck/1.18.x/3.0-upgrade
- https://docs.konghq.com/deck/1.19.x/3.0-upgrade
- https://docs.konghq.com/deck/1.20.x/3.0-upgrade
- https://docs.konghq.com/deck/1.21.x/3.0-upgrade
- https://docs.konghq.com/deck/1.22.x/3.0-upgrade
- https://docs.konghq.com/deck/1.23.x/3.0-upgrade
- https://docs.konghq.com/deck/1.24.x/3.0-upgrade/
- https://docs.konghq.com/deck/1.25.x/3.0-upgrade/
- https://docs.konghq.com/deck/1.26.x/3.0-upgrade/
- https://docs.konghq.com/deck/1.27.x/3.0-upgrade/
- https://docs.konghq.com/deck/1.12.x/guides/konnect
- https://docs.konghq.com/deck/1.13.x/guides/konnect
- https://docs.konghq.com/deck/1.14.x/guides/konnect
- https://docs.konghq.com/deck/1.15.x/guides/konnect
- https://docs.konghq.com/deck/1.16.x/guides/konnect
- https://docs.konghq.com/deck/1.17.x/guides/konnect
- https://docs.konghq.com/deck/1.18.x/guides/konnect
- https://docs.konghq.com/deck/1.19.x/guides/konnect
- https://docs.konghq.com/deck/1.20.x/guides/konnect
- https://docs.konghq.com/deck/1.21.x/guides/konnect
- https://docs.konghq.com/deck/1.22.x/guides/konnect
- https://docs.konghq.com/deck/1.23.x/guides/konnect
- https://docs.konghq.com/deck/1.24.x/guides/konnect/
- https://docs.konghq.com/deck/1.25.x/guides/konnect/
- https://docs.konghq.com/deck/1.26.x/guides/konnect/
- https://docs.konghq.com/deck/1.27.x/guides/konnect/
- https://docs.konghq.com/deck/1.24.x/reference/deck/
- https://docs.konghq.com/deck/1.25.x/reference/deck/
- https://docs.konghq.com/deck/1.26.x/reference/deck/
- https://docs.konghq.com/deck/1.27.x/reference/deck/
- https://docs.konghq.com/deck/1.10.x/reference/deck_completion
- https://docs.konghq.com/deck/1.11.x/reference/deck_completion
- https://docs.konghq.com/deck/1.12.x/reference/deck_completion
- https://docs.konghq.com/deck/1.13.x/reference/deck_completion
- https://docs.konghq.com/deck/1.14.x/reference/deck_completion
- https://docs.konghq.com/deck/1.15.x/reference/deck_completion
- https://docs.konghq.com/deck/1.16.x/reference/deck_completion
- https://docs.konghq.com/deck/1.17.x/reference/deck_completion
- https://docs.konghq.com/deck/1.18.x/reference/deck_completion
- https://docs.konghq.com/deck/1.19.x/reference/deck_completion
- https://docs.konghq.com/deck/1.20.x/reference/deck_completion
- https://docs.konghq.com/deck/1.21.x/reference/deck_completion
- https://docs.konghq.com/deck/1.22.x/reference/deck_completion
- https://docs.konghq.com/deck/1.23.x/reference/deck_completion
- https://docs.konghq.com/deck/1.24.x/reference/deck_completion/
- https://docs.konghq.com/deck/1.25.x/reference/deck_completion/
- https://docs.konghq.com/deck/1.26.x/reference/deck_completion/
- https://docs.konghq.com/deck/1.27.x/reference/deck_completion/
- https://docs.konghq.com/deck/1.8.x/reference/deck_completion
- https://docs.konghq.com/deck/1.9.x/reference/deck_completion
- https://docs.konghq.com/deck/1.10.x/reference/deck_convert
- https://docs.konghq.com/deck/1.11.x/reference/deck_convert
- https://docs.konghq.com/deck/1.12.x/reference/deck_convert
- https://docs.konghq.com/deck/1.13.x/reference/deck_convert
- https://docs.konghq.com/deck/1.14.x/reference/deck_convert
- https://docs.konghq.com/deck/1.15.x/reference/deck_convert
- https://docs.konghq.com/deck/1.16.x/reference/deck_convert
- https://docs.konghq.com/deck/1.17.x/reference/deck_convert
- https://docs.konghq.com/deck/1.18.x/reference/deck_convert
- https://docs.konghq.com/deck/1.19.x/reference/deck_convert
- https://docs.konghq.com/deck/1.20.x/reference/deck_convert
- https://docs.konghq.com/deck/1.21.x/reference/deck_convert
- https://docs.konghq.com/deck/1.22.x/reference/deck_convert
- https://docs.konghq.com/deck/1.23.x/reference/deck_convert
- https://docs.konghq.com/deck/1.24.x/reference/deck_convert/
- https://docs.konghq.com/deck/1.25.x/reference/deck_convert/
- https://docs.konghq.com/deck/1.26.x/reference/deck_convert/
- https://docs.konghq.com/deck/1.27.x/reference/deck_convert/
- https://docs.konghq.com/deck/1.7.x/reference/deck_convert
- https://docs.konghq.com/deck/1.8.x/reference/deck_convert
- https://docs.konghq.com/deck/1.9.x/reference/deck_convert
- https://docs.konghq.com/deck/1.10.x/reference/deck_diff
- https://docs.konghq.com/deck/1.11.x/reference/deck_diff
- https://docs.konghq.com/deck/1.12.x/reference/deck_diff
- https://docs.konghq.com/deck/1.13.x/reference/deck_diff
- https://docs.konghq.com/deck/1.14.x/reference/deck_diff
- https://docs.konghq.com/deck/1.15.x/reference/deck_diff
- https://docs.konghq.com/deck/1.16.x/reference/deck_diff
- https://docs.konghq.com/deck/1.17.x/reference/deck_diff
- https://docs.konghq.com/deck/1.18.x/reference/deck_diff
- https://docs.konghq.com/deck/1.19.x/reference/deck_diff
- https://docs.konghq.com/deck/1.20.x/reference/deck_diff
- https://docs.konghq.com/deck/1.21.x/reference/deck_diff
- https://docs.konghq.com/deck/1.22.x/reference/deck_diff
- https://docs.konghq.com/deck/1.23.x/reference/deck_diff
- https://docs.konghq.com/deck/1.24.x/reference/deck_diff/
- https://docs.konghq.com/deck/1.25.x/reference/deck_diff/
- https://docs.konghq.com/deck/1.26.x/reference/deck_diff/
- https://docs.konghq.com/deck/1.27.x/reference/deck_diff/
- https://docs.konghq.com/deck/1.7.x/reference/deck_diff
- https://docs.konghq.com/deck/1.8.x/reference/deck_diff
- https://docs.konghq.com/deck/1.9.x/reference/deck_diff
- https://docs.konghq.com/deck/1.10.x/reference/deck_dump
- https://docs.konghq.com/deck/1.11.x/reference/deck_dump
- https://docs.konghq.com/deck/1.12.x/reference/deck_dump
- https://docs.konghq.com/deck/1.13.x/reference/deck_dump
- https://docs.konghq.com/deck/1.14.x/reference/deck_dump
- https://docs.konghq.com/deck/1.15.x/reference/deck_dump
- https://docs.konghq.com/deck/1.16.x/reference/deck_dump
- https://docs.konghq.com/deck/1.17.x/reference/deck_dump
- https://docs.konghq.com/deck/1.18.x/reference/deck_dump
- https://docs.konghq.com/deck/1.19.x/reference/deck_dump
- https://docs.konghq.com/deck/1.20.x/reference/deck_dump
- https://docs.konghq.com/deck/1.21.x/reference/deck_dump
- https://docs.konghq.com/deck/1.22.x/reference/deck_dump
- https://docs.konghq.com/deck/1.23.x/reference/deck_dump
- https://docs.konghq.com/deck/1.24.x/reference/deck_dump/
- https://docs.konghq.com/deck/1.25.x/reference/deck_dump/
- https://docs.konghq.com/deck/1.26.x/reference/deck_dump/
- https://docs.konghq.com/deck/1.27.x/reference/deck_dump/
- https://docs.konghq.com/deck/1.7.x/reference/deck_dump
- https://docs.konghq.com/deck/1.8.x/reference/deck_dump
- https://docs.konghq.com/deck/1.9.x/reference/deck_dump
- https://docs.konghq.com/deck/1.24.x/reference/deck_file/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_add-plugins/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_add-plugins/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_add-plugins/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_add-plugins/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_add-tags/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_add-tags/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_add-tags/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_add-tags/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_list-tags/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_list-tags/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_list-tags/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_list-tags/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_merge/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_merge/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_merge/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_merge/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_openapi2kong/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_openapi2kong/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_openapi2kong/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_openapi2kong/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_patch/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_patch/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_patch/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_patch/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_remove-tags/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_remove-tags/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_remove-tags/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_remove-tags/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_render/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_render/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_render/
- https://docs.konghq.com/deck/1.10.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.11.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.12.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.13.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.7.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.8.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.9.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.10.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.11.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.12.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.13.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.7.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.8.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.9.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.10.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.11.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.12.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.13.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.7.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.8.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.9.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.10.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.11.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.12.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.13.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.7.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.8.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.9.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.10.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.11.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.12.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.13.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.7.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.8.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.9.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.10.x/reference/deck_ping
- https://docs.konghq.com/deck/1.11.x/reference/deck_ping
- https://docs.konghq.com/deck/1.12.x/reference/deck_ping
- https://docs.konghq.com/deck/1.13.x/reference/deck_ping
- https://docs.konghq.com/deck/1.14.x/reference/deck_ping
- https://docs.konghq.com/deck/1.15.x/reference/deck_ping
- https://docs.konghq.com/deck/1.16.x/reference/deck_ping
- https://docs.konghq.com/deck/1.17.x/reference/deck_ping
- https://docs.konghq.com/deck/1.18.x/reference/deck_ping
- https://docs.konghq.com/deck/1.19.x/reference/deck_ping
- https://docs.konghq.com/deck/1.20.x/reference/deck_ping
- https://docs.konghq.com/deck/1.21.x/reference/deck_ping
- https://docs.konghq.com/deck/1.22.x/reference/deck_ping
- https://docs.konghq.com/deck/1.23.x/reference/deck_ping
- https://docs.konghq.com/deck/1.24.x/reference/deck_ping/
- https://docs.konghq.com/deck/1.25.x/reference/deck_ping/
- https://docs.konghq.com/deck/1.26.x/reference/deck_ping/
- https://docs.konghq.com/deck/1.27.x/reference/deck_ping/
- https://docs.konghq.com/deck/1.7.x/reference/deck_ping
- https://docs.konghq.com/deck/1.8.x/reference/deck_ping
- https://docs.konghq.com/deck/1.9.x/reference/deck_ping
- https://docs.konghq.com/deck/1.10.x/reference/deck_reset
- https://docs.konghq.com/deck/1.11.x/reference/deck_reset
- https://docs.konghq.com/deck/1.12.x/reference/deck_reset
- https://docs.konghq.com/deck/1.13.x/reference/deck_reset
- https://docs.konghq.com/deck/1.14.x/reference/deck_reset
- https://docs.konghq.com/deck/1.15.x/reference/deck_reset
- https://docs.konghq.com/deck/1.16.x/reference/deck_reset
- https://docs.konghq.com/deck/1.17.x/reference/deck_reset
- https://docs.konghq.com/deck/1.18.x/reference/deck_reset
- https://docs.konghq.com/deck/1.19.x/reference/deck_reset
- https://docs.konghq.com/deck/1.20.x/reference/deck_reset
- https://docs.konghq.com/deck/1.21.x/reference/deck_reset
- https://docs.konghq.com/deck/1.22.x/reference/deck_reset
- https://docs.konghq.com/deck/1.23.x/reference/deck_reset
- https://docs.konghq.com/deck/1.24.x/reference/deck_reset/
- https://docs.konghq.com/deck/1.25.x/reference/deck_reset/
- https://docs.konghq.com/deck/1.26.x/reference/deck_reset/
- https://docs.konghq.com/deck/1.27.x/reference/deck_reset/
- https://docs.konghq.com/deck/1.7.x/reference/deck_reset
- https://docs.konghq.com/deck/1.8.x/reference/deck_reset
- https://docs.konghq.com/deck/1.9.x/reference/deck_reset
- https://docs.konghq.com/deck/1.10.x/reference/deck_sync
- https://docs.konghq.com/deck/1.11.x/reference/deck_sync
- https://docs.konghq.com/deck/1.12.x/reference/deck_sync
- https://docs.konghq.com/deck/1.13.x/reference/deck_sync
- https://docs.konghq.com/deck/1.14.x/reference/deck_sync
- https://docs.konghq.com/deck/1.15.x/reference/deck_sync
- https://docs.konghq.com/deck/1.16.x/reference/deck_sync
- https://docs.konghq.com/deck/1.17.x/reference/deck_sync
- https://docs.konghq.com/deck/1.18.x/reference/deck_sync
- https://docs.konghq.com/deck/1.19.x/reference/deck_sync
- https://docs.konghq.com/deck/1.20.x/reference/deck_sync
- https://docs.konghq.com/deck/1.21.x/reference/deck_sync
- https://docs.konghq.com/deck/1.22.x/reference/deck_sync
- https://docs.konghq.com/deck/1.23.x/reference/deck_sync
- https://docs.konghq.com/deck/1.24.x/reference/deck_sync/
- https://docs.konghq.com/deck/1.25.x/reference/deck_sync/
- https://docs.konghq.com/deck/1.26.x/reference/deck_sync/
- https://docs.konghq.com/deck/1.27.x/reference/deck_sync/
- https://docs.konghq.com/deck/1.7.x/reference/deck_sync
- https://docs.konghq.com/deck/1.8.x/reference/deck_sync
- https://docs.konghq.com/deck/1.9.x/reference/deck_sync
- https://docs.konghq.com/deck/1.10.x/reference/deck_validate
- https://docs.konghq.com/deck/1.11.x/reference/deck_validate
- https://docs.konghq.com/deck/1.12.x/reference/deck_validate
- https://docs.konghq.com/deck/1.13.x/reference/deck_validate
- https://docs.konghq.com/deck/1.14.x/reference/deck_validate
- https://docs.konghq.com/deck/1.15.x/reference/deck_validate
- https://docs.konghq.com/deck/1.16.x/reference/deck_validate
- https://docs.konghq.com/deck/1.17.x/reference/deck_validate
- https://docs.konghq.com/deck/1.18.x/reference/deck_validate
- https://docs.konghq.com/deck/1.19.x/reference/deck_validate
- https://docs.konghq.com/deck/1.20.x/reference/deck_validate
- https://docs.konghq.com/deck/1.21.x/reference/deck_validate
- https://docs.konghq.com/deck/1.22.x/reference/deck_validate
- https://docs.konghq.com/deck/1.23.x/reference/deck_validate
- https://docs.konghq.com/deck/1.24.x/reference/deck_validate/
- https://docs.konghq.com/deck/1.25.x/reference/deck_validate/
- https://docs.konghq.com/deck/1.26.x/reference/deck_validate/
- https://docs.konghq.com/deck/1.27.x/reference/deck_validate/
- https://docs.konghq.com/deck/1.7.x/reference/deck_validate
- https://docs.konghq.com/deck/1.8.x/reference/deck_validate
- https://docs.konghq.com/deck/1.9.x/reference/deck_validate
- https://docs.konghq.com/deck/1.10.x/reference/deck_version
- https://docs.konghq.com/deck/1.11.x/reference/deck_version
- https://docs.konghq.com/deck/1.12.x/reference/deck_version
- https://docs.konghq.com/deck/1.13.x/reference/deck_version
- https://docs.konghq.com/deck/1.14.x/reference/deck_version
- https://docs.konghq.com/deck/1.15.x/reference/deck_version
- https://docs.konghq.com/deck/1.16.x/reference/deck_version
- https://docs.konghq.com/deck/1.17.x/reference/deck_version
- https://docs.konghq.com/deck/1.18.x/reference/deck_version
- https://docs.konghq.com/deck/1.19.x/reference/deck_version
- https://docs.konghq.com/deck/1.20.x/reference/deck_version
- https://docs.konghq.com/deck/1.21.x/reference/deck_version
- https://docs.konghq.com/deck/1.22.x/reference/deck_version
- https://docs.konghq.com/deck/1.23.x/reference/deck_version
- https://docs.konghq.com/deck/1.24.x/reference/deck_version/
- https://docs.konghq.com/deck/1.25.x/reference/deck_version/
- https://docs.konghq.com/deck/1.26.x/reference/deck_version/
- https://docs.konghq.com/deck/1.27.x/reference/deck_version/
- https://docs.konghq.com/deck/1.7.x/reference/deck_version
- https://docs.konghq.com/deck/1.8.x/reference/deck_version
- https://docs.konghq.com/deck/1.9.x/reference/deck_version
- https://docs.konghq.com/gateway/3.0.x/install-support
- https://docs.konghq.com/gateway/3.1.x/install-support
- https://docs.konghq.com/gateway/3.1.x/reference/key-management
- https://docs.konghq.com/gateway/3.2.x/reference/key-management
- https://docs.konghq.com/gateway/3.3.x/reference/key-management
- https://docs.konghq.com/gateway/3.4.x/reference/key-management
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/concepts/deployment
- https://docs.konghq.com/assets/images/docs/konnect/api-products/api-products-overview.png
- https://docs.konghq.com/assets/images/docs/konnect/custom-reports/latency/kong-latency.png
- https://docs.konghq.com/assets/images/docs/konnect/custom-reports/latency/upstream-latency.png
- https://docs.konghq.com/assets/images/docs/konnect/dashboard/konnect-dashboard.png
- https://docs.konghq.com/assets/images/docs/konnect/konnect-intro.png
- https://docs.konghq.com/assets/images/docs/konnect/konnect-runtime-instance-kic.png
- https://docs.konghq.com/assets/images/docs/konnect/konnect-vaults.png
- https://docs.konghq.com/contributing/word-choice
- https://docs.konghq.com/konnect/account-management/
- https://docs.konghq.com/konnect/analytics/
- https://docs.konghq.com/konnect/analytics/reference
- https://docs.konghq.com/konnect/analytics/troubleshoot
- https://docs.konghq.com/konnect/analytics/use-cases/latency
- https://docs.konghq.com/konnect/api-products/
- https://docs.konghq.com/konnect/api/identity-management/identity-integration
- https://docs.konghq.com/konnect/api/
- https://docs.konghq.com/konnect/api/portal-auth/portal-rbac-guide
- https://docs.konghq.com/konnect/api/runtime-groups-config/overview
- https://docs.konghq.com/konnect/architecture
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/azure
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-app-connections
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-teams
- https://docs.konghq.com/konnect/dev-portal/applications/application-overview
- https://docs.konghq.com/konnect/dev-portal/applications/dev-reg-app-service
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/auth0
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/azure
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/curity
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/okta
- https://docs.konghq.com/konnect/dev-portal/applications/enable-app-reg
- https://docs.konghq.com/konnect/dev-portal/customization/
- https://docs.konghq.com/konnect/dev-portal/customization/self-hosted-portal
- https://docs.konghq.com/konnect/dev-portal/
- https://docs.konghq.com/konnect/dev-portal/troubleshoot/
- https://docs.konghq.com/konnect/getting-started/access-account
- https://docs.konghq.com/konnect/getting-started/app-registration
- https://docs.konghq.com/konnect/getting-started/deploy-service
- https://docs.konghq.com/konnect/getting-started/import
- https://docs.konghq.com/konnect/getting-started/
- https://docs.konghq.com/konnect/getting-started/productize-service
- https://docs.konghq.com/konnect/
- https://docs.konghq.com/konnect/network-resiliency
- https://docs.konghq.com/konnect/network
- https://docs.konghq.com/konnect/org-management/audit-logging/reference
- https://docs.konghq.com/konnect/org-management/deactivation
- https://docs.konghq.com/konnect/org-management/system-accounts
- https://docs.konghq.com/konnect/org-management/teams-and-roles/
- https://docs.konghq.com/konnect/org-management/teams-and-roles/manage
- https://docs.konghq.com/konnect/org-management/teams-and-roles/roles-reference
- https://docs.konghq.com/konnect/org-management/teams-and-roles/teams-reference
- https://docs.konghq.com/konnect/org-management/users
- https://docs.konghq.com/konnect/reference/labels
- https://docs.konghq.com/konnect/reference/plugins
- https://docs.konghq.com/konnect/servicehub/
- https://docs.konghq.com/konnect/updates
- https://docs.konghq.com/konnect/upgrade-faq


### [Update: Add note about group filtering to Konnect SSO](https://github.com/Kong/docs.konghq.com/pull/6119) (2023-09-20)

Just adding a note to the Konnect SSO doc page about group filtering as it's needed in the rare case where a user in the IdP has over ~150 groups assigned which some IdPs will then not send the groups_claim in a standard manner and prevents successful authentication as a result. Customers need to use group filtering capabilities from the IdP to work effectively in that situation.

Stems from an issue discussed in Kong Support case #00037499.

#### Modified

- https://docs.konghq.com/konnect/org-management/oidc-idp



### [fix(docs): correct the influxdb - gateway startup order](https://github.com/Kong/docs.konghq.com/pull/6103) (2023-09-19)

- Update the startup order and startup InfluxDB before starting up kong-gateway.

- From 3.4.0.0 Kong doesn't release the alpine docker image anymore thus correct the doc.


#### Modified

- https://docs.konghq.com/gateway/3.3.x/breaking-changes/28x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/28x/


### [chore: Add the 2.8.4.3 Gateway changelog](https://github.com/Kong/docs.konghq.com/pull/6029) (2023-09-18)

What did you change and why?

- Added the 2.8.4.3 Gateway changelog and the 2.8.4.3 breaking changes in preparation for the upcoming release.
- Updating AWS Lambda plugin with info related to refactor.
 


#### Modified

- https://docs.konghq.com/hub/kong-inc/aws-lambda/
- https://docs.konghq.com/hub/kong-inc/aws-lambda/overview/
- https://docs.konghq.com/gateway/3.3.x/breaking-changes/28x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/28x/
- https://docs.konghq.com/gateway/changelog



## Week 37

### [Update(plugins): GraphQL Introspection endpoint related note](https://github.com/Kong/docs.konghq.com/pull/6090) (2023-09-12)

GraphQL Introspection endpoint will only be read from the Kong service (`service = ngx.ctx.service`) instead of reading from a specific variable or ingress - local.

Documenting this behavior so consumers are aware of how to configure correctly and know about the limitation.

#### Modified

- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/overview/


### [[Fix]- KIC: Setting up Active and Passive health checks guide](https://github.com/Kong/docs.konghq.com/pull/6081) (2023-09-11)
 
Revised and rewrote the guide after validating.

#### Modified

- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/cp-outage-handling
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/cp-outage-handling
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/cp-outage-handling


### [fix missing keyword config in curl data](https://github.com/Kong/docs.konghq.com/pull/6075) (2023-09-12)

To enable grpc-web plugin via Admin API, the keywork `config` in curl data is missing.

#### Modified

- https://docs.konghq.com/hub/kong-inc/grpc-web/how-to/


### [fix: remove unsupported KIC feature](https://github.com/Kong/docs.konghq.com/pull/6068) (2023-09-11)

Remove the custom entities guide from KIC 2.x pages.

This feature was never actually supported in 2.x, and we removed the leftover flag [in 2.9](https://github.com/Kong/kubernetes-ingress-controller/pull/3262). In earlier 2.x versions, the flag was available but did not work.


## Week 36

### [chore: Split the gateway changelogs to archive changelogs for sunset versions](https://github.com/Kong/docs.konghq.com/pull/6073) (2023-09-08)

Our Gateway changelog page is massive. This is a problem for everyone involved:
* Bad page load times/performance
* Difficult to edit
* Lots of unnecessary info
* Documenting versions that we don't support
* And the most recent discovery, a not-insignificant chunk of our Algolia records

From now on, we will be archiving old changelogs at the same time we archive old versions of our docs. You can find the changelogs at https://legacy-gateway--kongdocs.netlify.app/enterprise/changelog/.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Post-launch tidy of Konnect API overview page + nav](https://github.com/Kong/docs.konghq.com/pull/6067) (2023-09-07)
 
Update links to api specs in overview page to reference evergreen links, repeat spec description from devportal description field, update nav links to consistently refer to API spec and use evergreen links.

#### Modified

- https://docs.konghq.com/konnect/api/


### [update urls to latest and remove mention of dev portal](https://github.com/Kong/docs.konghq.com/pull/6066) (2023-09-06)

Update urls to latest for gateway APIs.

Remove mention of dev portal from API announcement banner.

#### Modified

- https://docs.konghq.com/konnect/api/


### [Fix(plugin scopes): Consumer groups scope and application registration plugin](https://github.com/Kong/docs.konghq.com/pull/6059) (2023-09-05)

The [scopes compatibility table](https://docs.konghq.com/hub/plugins/compatibility/#scopes) was missing a column for consumer groups. This update enables generating the column and all entries from the plugins' schemas.

Additionally, the Application Registration plugin was listed as incompatible with all scopes, which is wrong - it's compatible with services only. Turns out we were selecting for the wrong key. Fixing this also fixes the display of the plugin's [config](https://docs.konghq.com/hub/kong-inc/application-registration/configuration/) and [basic examples](https://docs.konghq.com/hub/kong-inc/application-registration/how-to/basic-example/), which were both missing services.

#### Modified

- https://docs.konghq.com/hub/plugins/compatibility/


### [(fix) remove note about cloud launcher support ](https://github.com/Kong/docs.konghq.com/pull/6057) (2023-09-06)

Existing note was incorrect and causing confusion. 
https://kongstrong.slack.com/archives/CQK8J4VN3/p1693903551408579

#### Modified

- https://docs.konghq.com/konnect/runtime-manager/runtime-instances/upgrade


### [Fix "supported-router-flavors" typos](https://github.com/Kong/docs.konghq.com/pull/6056) (2023-09-05)

This change fixes small typos in the documentation.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.1.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.2.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.3.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.4.x/install/linux/ubuntu


### [Salt plugin: add konnect and update version compatibility](https://github.com/Kong/docs.konghq.com/pull/6050) (2023-09-05)

Updating for Konnect compatibility & Kong version support
taking colleagues work and putting into PR on main for Kong's docs repo

#### Modified

- https://docs.konghq.com/hub/salt/salt/_metadata.yml


### [feat: Split serverless plugins into their own pages](https://github.com/Kong/docs.konghq.com/pull/6047) (2023-09-08)

We currently document one entry for [Serverless Functions](https://docs.konghq.com/hub/kong-inc/serverless-functions/), but it’s actually two plugins: `pre-function` and `post-function`. When searching for docs, users look for one of those names, not for Serverless Function. The UI also has them as two separate plugins, so one docs entry doesn't make sense.

This PR aims to solve that by splitting Serverless Functions into Post-function and Pre-function plugins. 
* For the titles of the plugins, used the names from the Konnect and Kong Manager UIs: Kong Functions (Pre-Plugins) and Kong Functions (Post-Plugins).
* You can still search for these plugins by the term "serverless" and by their real names (post- and pre-function)
* Split out the how-to guide for the pre-function plugin into its own topic
* For the post-function plugin, wrote a how-to guide based on a KB: https://support.konghq.com/support/s/article/How-can-the-latency-and-rate-limit-plugin-header-names-be-changed
* For both plugins, also added short guide on running the plugins in multiple phases based on yet another KB: https://support.konghq.com/support/s/article/Is-it-possible-to-run-serverless-plugins-in-phases-other-than-the-access-phase

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

go-apiops cli is built for testing purposes. End users are encumbered to use this utility through deck file command

I changed `go-apiops` cli example to `deck file`. As mentioned in [go-apiops repository](https://github.com/Kong/go-apiops)
> Currently, the functionality is released as a library and as part of the [decK](https://github.com/Kong/deck) CLI tool. The 
> repository also contains a CLI named go-apiops **for local testing**. For general CLI usage, prefer the decK tool [docs](https://docs.konghq.com/deck/latest/) tool.

 `go-apiops` is used for testing and deck is encouraged for general usage.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.1.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.2.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.3.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.4.x/install/linux/ubuntu


### [Feat: Plugin hub nested overviews](https://github.com/Kong/docs.konghq.com/pull/6027) (2023-09-05)
 
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

#### Modified

- https://docs.konghq.com/gateway/3.4.x/kong-manager-oss/troubleshoot/
- https://docs.konghq.com/mesh/1.7.x/features/windows
- https://docs.konghq.com/mesh/1.8.x/features/windows
- https://docs.konghq.com/mesh/1.9.x/features/windows
- https://docs.konghq.com/mesh/2.0.x/features/windows
- https://docs.konghq.com/mesh/2.1.x/features/windows


## Week 35

### [Add info about how IP address is determined for IP Restriction plugin](https://github.com/Kong/docs.konghq.com/pull/6046) (2023-08-31)

Added a blurb about how the IP Address is determined when using the IP Restriction plugin, as this was confusing customers who were unaware of the appropriate settings that needed to be tweaked for their environment so the IP could be determined accurately.

#### Modified

- https://docs.konghq.com/hub/kong-inc/ip-restriction/


### [Added info about limiting by IP address](https://github.com/Kong/docs.konghq.com/pull/6045) (2023-08-31)

We were missing details about how the IP address was determined when customers want to limit by IP address. Added these details to clarify how this works and linked to other sources for the appropriate properties that need to be set.

#### Modified

- https://docs.konghq.com/hub/kong-inc/rate-limiting/


### [Updated RLA index page to share some details from RL plugin](https://github.com/Kong/docs.konghq.com/pull/6044) (2023-08-31)

There were some missing details from the RL (Rate Limiting) plugin which I pasted into the RLA (Rate Limiting Advanced) plugin index page, including extra details about the strategies that can be used and the use-cases for each.

Also added a section for how the IP address is determined as this was missing from the details and was not obvious to customers how this worked when limiting by IP address.

#### Modified

- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/


### [Update index.md](https://github.com/Kong/docs.konghq.com/pull/6042) (2023-08-31)

Fixed spelling mistake and commas

- Fixed spelling error: changed confict to conflict.
- Added commas

#### Modified

- https://docs.konghq.com/konnect/runtime-manager/composite-runtime-groups/


### [fix: Update OSS install instructions for Kong Manager](https://github.com/Kong/docs.konghq.com/pull/6040) (2023-08-31)

Our OSS install instructions (specifically Docker and I found some Linux ones as well) that still said that KM wasn't for OSS even though it is. I fixed those spots.

DOCU-3445

#### Modified

- https://docs.konghq.com/gateway/3.4.x/kong-manager-oss/troubleshoot/


### [chore(deps): update docs from repo source](https://github.com/Kong/docs.konghq.com/pull/6036) (2023-08-31)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/6034676360)

#### Modified

- https://docs.konghq.com/mesh/2.4.x/kuma-cp.yaml
- https://docs.konghq.com/mesh/dev/kuma-cp.yaml
- https://docs.konghq.com/mesh/raw/CHANGELOG


### [Update: Add link to changelog entry for Kong Manager OSS](https://github.com/Kong/docs.konghq.com/pull/6034) (2023-08-29)

Add link to https://docs.konghq.com/gateway/latest/kong-manager-oss/ in the feature annoucement

#### Modified

- https://docs.konghq.com/gateway/changelog


### [(Fix) Cross-ref CP-DP communication through forward proxy in Konnect docs](https://github.com/Kong/docs.konghq.com/pull/6028) (2023-08-29)

You can now find cross-reference to the "Control Plane and Data Plane Communication through a Forward Proxy" page in the "Konnect Ports and Networking Requirements" page.

Updated based on Slack feedback [here](https://kongstrong.slack.com/archives/C02CWN8C7DK/p1693260752247129). 

#### Modified

- https://docs.konghq.com/konnect/network


### [kic: update `CombinedServices` feature gate default for 2.11](https://github.com/Kong/docs.konghq.com/pull/6026) (2023-08-30)

Update `CombinedServices` feature gate default for 2.11 as it was made in https://github.com/Kong/kubernetes-ingress-controller/pull/4138

#### Modified

- https://docs.konghq.com/gateway/3.4.x/reference/wasm


### [chore(deps): bump kumahq/kuma-website from c530a7a4 to 045ff986](https://github.com/Kong/docs.konghq.com/pull/6024) (2023-08-30)

Auto upgrade PR log:

045ff9868acdb4b322759dde3f8053f41948100f feat: extend kubernetes perf tuning section (kumahq/kuma-website#1444)
cac5fd764b722ee64e1be31f26d9d006d9cf1574 fix(annotations): remove reference to injection annotation (kumahq/kuma-website#1450)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/6018914319).

#### Modified

- https://docs.konghq.com/gateway/3.4.x/kong-manager-oss/troubleshoot/


### [Edited the CP outage handling doc to add emphasis to environment variables](https://github.com/Kong/docs.konghq.com/pull/6022) (2023-08-28)

Corrected some wording and bolded the "import" and "export" portions in the environment variables as customers are often seeing these are the same variables without realizing they're different between export and import.

Reverted the bolding after I realized it didn't load correctly in the preview. Overall the final change is just a mild correction to a wrongly formatted sentence from earlier.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.1.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.2.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.3.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.4.x/install/linux/ubuntu


### [Add if_versions tags so windows support does not show up in KM v2.4](https://github.com/Kong/docs.konghq.com/pull/6021) (2023-08-29)

Remove Windows support from KM 2.4 onwards

#### Modified

- https://docs.konghq.com/gateway/3.4.x/reference/wasm
- https://docs.konghq.com/mesh/1.7.x/features/windows
- https://docs.konghq.com/mesh/1.8.x/features/windows
- https://docs.konghq.com/mesh/1.9.x/features/windows
- https://docs.konghq.com/mesh/2.0.x/features/windows
- https://docs.konghq.com/mesh/2.1.x/features/windows
- https://docs.konghq.com/mesh/1.7.x/gettingstarted
- https://docs.konghq.com/mesh/1.8.x/gettingstarted
- https://docs.konghq.com/mesh/1.9.x/gettingstarted
- https://docs.konghq.com/mesh/2.0.x/gettingstarted
- https://docs.konghq.com/mesh/2.1.x/gettingstarted
- https://docs.konghq.com/mesh/2.0.x/install/
- https://docs.konghq.com/mesh/2.1.x/install/
- https://docs.konghq.com/mesh/1.7.x/installation/windows
- https://docs.konghq.com/mesh/1.8.x/installation/windows
- https://docs.konghq.com/mesh/1.9.x/installation/windows
- https://docs.konghq.com/mesh/2.0.x/installation/windows
- https://docs.konghq.com/mesh/2.1.x/installation/windows


### [chore(deps): bump kumahq/kuma-website from 2064c900 to 707fb928](https://github.com/Kong/docs.konghq.com/pull/6012) (2023-08-28)

Auto upgrade PR log:

707fb928c63b3d4cc57628ecfb8f53845b4ab314 fix(MeshGateway): fix typo on example tags table (kumahq/kuma-website#1442)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/5994030906).

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/debian
- https://docs.konghq.com/gateway/3.1.x/install/linux/debian
- https://docs.konghq.com/gateway/3.2.x/install/linux/debian
- https://docs.konghq.com/gateway/3.3.x/install/linux/debian
- https://docs.konghq.com/gateway/3.4.x/install/linux/debian


### [feat(pre-built-reports): added changelog entry and an intro sentence](https://github.com/Kong/docs.konghq.com/pull/6009) (2023-08-28)

Added a changelog item to release our pre-built reports feature ([Aha ticket](https://konghq.aha.io/features/KP-204)) and an intro sentence into the Analytics section inside the Konnect intro chapter. This feature is rather small and is only for new organization. Therefore, I think we don't need a lot of docs changes.

[Here](https://docs.google.com/spreadsheets/d/1QnwrHOjR-K-H5w9FQAWltNvq_H0OF8vv-y19o-5CtD0/edit#gid=0) is a list of the pre-built reports we deploy for all new organizations.

#### Modified

- https://docs.konghq.com/konnect/
- https://docs.konghq.com/konnect/updates


### [chore(deps): update docs from repo source](https://github.com/Kong/docs.konghq.com/pull/6003) (2023-08-29)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/6009565670)

#### Added

- https://docs.konghq.com/mesh/2.4.x/crds/access-audit.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/access-role-binding.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/access-role.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_circuitbreakers.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_containerpatches.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_dataplaneinsights.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_dataplanes.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_externalservices.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_faultinjections.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_healthchecks.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshaccesslogs.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshcircuitbreakers.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshes.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshfaultinjections.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshgatewayconfigs.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshgatewayinstances.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshgatewayroutes.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshgateways.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshglobalratelimits.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshhealthchecks.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshhttproutes.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshinsights.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshloadbalancingstrategies.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshopas.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshproxypatches.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshretries.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshtcproutes.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshtimeouts.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshtraces.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshtrafficpermissions.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_proxytemplates.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_ratelimits.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_retries.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_serviceinsights.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_timeouts.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_trafficlogs.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_trafficpermissions.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_trafficroutes.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_traffictraces.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_virtualoutbounds.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_zoneegresses.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_zoneegressinsights.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_zoneingresses.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_zoneingressinsights.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_zoneinsights.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_zones.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/opa-policy.yaml
- https://docs.konghq.com/mesh/2.4.x/helm-values.yaml
- https://docs.konghq.com/mesh/2.4.x/kuma-cp.yaml
- https://docs.konghq.com/mesh/2.4.x/protos/OPAPolicy.json

#### Modified

- https://docs.konghq.com/mesh/1.7.x/features/windows
- https://docs.konghq.com/mesh/1.8.x/features/windows
- https://docs.konghq.com/mesh/1.9.x/features/windows
- https://docs.konghq.com/mesh/2.0.x/features/windows
- https://docs.konghq.com/mesh/2.1.x/features/windows
- https://docs.konghq.com/mesh/dev/crds/kuma.io_circuitbreakers.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_containerpatches.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_dataplaneinsights.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_dataplanes.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_externalservices.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_faultinjections.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_healthchecks.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshaccesslogs.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshcircuitbreakers.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshes.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshfaultinjections.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshgatewayconfigs.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshgatewayinstances.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshgatewayroutes.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshgateways.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshglobalratelimits.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshhealthchecks.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshhttproutes.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshinsights.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshloadbalancingstrategies.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshopas.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshproxypatches.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshretries.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshtcproutes.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshtimeouts.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshtraces.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshtrafficpermissions.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_proxytemplates.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_ratelimits.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_retries.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_serviceinsights.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_timeouts.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_trafficlogs.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_trafficpermissions.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_trafficroutes.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_traffictraces.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_virtualoutbounds.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_zoneegresses.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_zoneegressinsights.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_zoneingresses.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_zoneingressinsights.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_zoneinsights.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_zones.yaml


### [fix: Docker installation for Kong Gateway OSS missing port for Kong Manager OSS](https://github.com/Kong/docs.konghq.com/pull/5998) (2023-08-29)

The installation instructions for Kong Gateway OSS on Docker were missing the Kong Manager OSS port mapping.
Adding it for 3.4, along with a troubleshooting entry, in case anyone else runs into it.

#### Added

- https://docs.konghq.com/mesh/1.7.x/features/windows
- https://docs.konghq.com/mesh/1.8.x/features/windows
- https://docs.konghq.com/mesh/1.9.x/features/windows
- https://docs.konghq.com/mesh/2.0.x/features/windows
- https://docs.konghq.com/mesh/2.1.x/features/windows

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/references/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/references/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/references/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/references/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/references/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/references/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/references/feature-gates


### [Add blog post note to gateway install pages](https://github.com/Kong/docs.konghq.com/pull/5997) (2023-08-31)

This addition was requested by the marketing folks just to further cement usage of the new site.

#### Modified

- https://docs.konghq.com/gateway/3.4.x/reference/wasm


### [chore: Sunset Kong Gateway versions 2.1.x-2.5.x](https://github.com/Kong/docs.konghq.com/pull/5992) (2023-08-29)

As of August 24th, 2023, Kong Gateway OSS and Enterprise versions 2.1.x-2.5.x [end their sunset support](https://docs.konghq.com/gateway/latest/support-policy/#older-versions).

This PR removes all of the old versions from the docs site, as well as the `/archive` folder maintained on the `main` branch.
We no longer need that folder, since we have a legacy-gateway site.

You can find all of the archived versions at the following links:
https://legacy-gateway--kongdocs.netlify.app/enterprise/2.5.x/
https://legacy-gateway--kongdocs.netlify.app/gateway-oss/2.5.x/
https://legacy-gateway--kongdocs.netlify.app/getting-started-guide/2.5.x/overview/

For the additions to the archive, see https://github.com/Kong/docs.konghq.com/pull/5993.

https://konghq.atlassian.net/browse/DOCU-3347

---

Some specifics:
* Deleting everything to do with `enterprise`, `gateway-oss`, and `getting-started-guide` editions and URLs. All three of those editions were replaced with one `gateway` edition in 2.6.x. Since we're archiving everything before 2.6.x, we no longer need to maintain all of the exceptions for the old editions.
* Plugins: We will no longer build versions 2.5.x or earlier. There wasn't a lot of 2.5.x or earlier content that was unique, so I think that should be fine.
  * If we want to move the old plugin docs to the archive site, we will need to port the whole new plugin hub over there. I'm not sure that it's worth it yet.

#### Modified

- https://docs.konghq.com/hub/kong-inc/acme/
- https://docs.konghq.com/hub/kong-inc/aws-lambda/
- https://docs.konghq.com/hub/kong-inc/bot-detection/
- https://docs.konghq.com/hub/kong-inc/datadog/
- https://docs.konghq.com/hub/kong-inc/file-log/
- https://docs.konghq.com/hub/kong-inc/grpc-gateway/how-to/
- https://docs.konghq.com/hub/kong-inc/hmac-auth/
- https://docs.konghq.com/hub/kong-inc/http-log/
- https://docs.konghq.com/hub/kong-inc/ip-restriction/
- https://docs.konghq.com/hub/kong-inc/jwt-signer/versions.yml
- https://docs.konghq.com/hub/kong-inc/kafka-log/
- https://docs.konghq.com/hub/kong-inc/kafka-upstream/
- https://docs.konghq.com/hub/kong-inc/key-auth/
- https://docs.konghq.com/hub/kong-inc/ldap-auth-advanced/
- https://docs.konghq.com/hub/kong-inc/ldap-auth/
- https://docs.konghq.com/hub/kong-inc/loggly/
- https://docs.konghq.com/hub/kong-inc/prometheus/
- https://docs.konghq.com/hub/kong-inc/statsd-advanced/versions.yml
- https://docs.konghq.com/hub/kong-inc/syslog/
- https://docs.konghq.com/hub/kong-inc/tcp-log/
- https://docs.konghq.com/hub/kong-inc/udp-log/
- https://docs.konghq.com/hub/kong-inc/zipkin/
- https://docs.konghq.com/gateway/2.6.x/configure/auth/kong-manager/ldap
- https://docs.konghq.com/gateway/2.7.x/configure/auth/kong-manager/ldap
- https://docs.konghq.com/gateway/2.8.x/configure/auth/kong-manager/ldap

## Week 34

### [Fix missing icon](https://github.com/Kong/docs.konghq.com/pull/6007) (2023-08-25)
 
The OSS/Enterprise icon was missing. We changed it to a white version when we added it to the blue navigation, and forgot to change it back when we put it back in the TOC. 

Add missing `alt` text to konnect's dashboard image.

#### Modified

- https://docs.konghq.com/konnect/


### [Chore: Bump GW to version 3.1.1.5](https://github.com/Kong/docs.konghq.com/pull/6006) (2023-08-25)

https://konghq.atlassian.net/browse/DOCU-3410

* changelog

* updated `app/_data/kong_versions.yml`

#### Modified

- https://docs.konghq.com/gateway/changelog


### [chore(deps): bump kumahq/kuma-website from 643f230a to 2064c900](https://github.com/Kong/docs.konghq.com/pull/6001) (2023-08-25)

Auto upgrade PR log:

2064c9000e7605c6b057ac3e668708a45046c8aa chore(deps): update docs from repo source (kumahq/kuma-website#1443)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/5970254269).

#### Modified

- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/cp-outage-handling
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/cp-outage-handling
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/cp-outage-handling


### [fix: Add missing metadata to appdynamics and serverless functions plugins](https://github.com/Kong/docs.konghq.com/pull/5999) (2023-08-24)

The AppDynamics and Serverless functions plugins were incorrectly listed as being incompatible with all Kong Gateway deployment modes: https://docs.konghq.com/hub/plugins/compatibility/#serverless

Fixing that by adding `network_config_opts` to the metadata files for both plugins. Both plugins can be run in DB-less, traditional, and hybrid modes.

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/serverless-functions/_metadata.yml


### [chore(deps): bump kumahq/kuma-website from b49b8059 to 643f230a](https://github.com/Kong/docs.konghq.com/pull/5994) (2023-08-23)

Auto upgrade PR log:

643f230ab275957febf4c5195e83939dd8bdf16e fix(retry): correct baseDuration to baseInterval (kumahq/kuma-website#1441)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/5945388060).

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.1.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.2.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.3.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.4.x/install/linux/ubuntu


### [feat: Konnect API examples for plugins](https://github.com/Kong/docs.konghq.com/pull/5970) (2023-08-23)

For any plugin that is supported in Konnect, it’s now possible to configure it using the Konnect runtime groups API, via `core-entities`. This PR adds support for generated Konnect API examples in the plugin docs, which makes the Konnect API more visible and positions it as a parallel option to the Kong Admin API.

A simple service example for the Basic auth plugin:
![Screenshot 2023-08-17 at 1 54 20 PM](https://github.com/Kong/docs.konghq.com/assets/54370747/2168aff3-0bad-4d46-82f9-ed5964a083c2)

A global example for the Rate Limiting Advanced plugin:
![Screenshot 2023-08-17 at 2 57 19 PM](https://github.com/Kong/docs.konghq.com/assets/54370747/d71f434e-7689-4a7a-bad4-9298621e49eb)

Along with that, there were several fixes/improvements that I had to make:
* Placeholders in curl examples: after team discussion, settled on `{ }` as the placeholder characters for URLs. This format is heavily used in our API specs, and is the OpenAPI standard: https://swagger.io/docs/specification/describing-parameters/. Going forward, we should be using `{ }` to enclose variables **in specs and API examples**. 
  * Placeholders in other situations still need revisiting. Out of scope here.
 
* The global example now explains what "global" means in the context of Konnect, Kong Enterprise, and Kong OSS. This is a long-running painpoint, and it seems timely to add this as we add Konnect examples.

* Removed the duplicate `konnect_examples` and `manager_examples` metadata keys from plugin docs. We don't have Kong Manager examples, and we don't need a separate `konnect_examples` key. `konnect: false/true` already performs the same function.

https://konghq.atlassian.net/browse/DOCU-2949

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/application-registration/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/datadog/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/exit-transformer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/jq/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/key-auth-enc/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/oauth2-introspection/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/oauth2/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/opentelemetry/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/openwhisk/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-size-limiting/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-transformer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/response-transformer-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/route-by-header/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/route-transformer-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/serverless-functions/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/vault-auth/_0.3.0/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/vault-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/zipkin/_metadata.yml
- https://docs.konghq.com/contributing/conditional-rendering
- https://docs.konghq.com/contributing/markdown-rules
- https://docs.konghq.com/contributing/style-guide
