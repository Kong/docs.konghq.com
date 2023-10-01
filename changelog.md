# Changelog

## Week 39

### [fix: View Organizations](https://github.com/Kong/docs.konghq.com/pull/6203) (2023-09-29)

To navigate back to the org switcher from Konnect. The button now says "View Organizations" rather than "Back to org switcher".

![image](https://github.com/Kong/docs.konghq.com/assets/1035820/463be71d-88d3-4bfd-8f1a-ed7b13dc9408)

#### Modified

- https://docs.konghq.com/konnect/org-management/org-switcher


### [fix: AWS Lambda plugin headers line](https://github.com/Kong/docs.konghq.com/pull/6200) (2023-09-29)

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


### [chore: Consistent banners/callouts across docs site](https://github.com/Kong/docs.konghq.com/pull/6190) (2023-09-28)

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
 
<!-- Include any supporting resources, e.g. link to a Jira ticket, GH issue, FTI, Slack, Aha, etc. -->
Fixes #6180

#### Modified

- https://docs.konghq.com/assets/images/diagrams/diagram-mesh-in-konnect.png


### [fix: Configuring https redirect](https://github.com/Kong/docs.konghq.com/pull/6185) (2023-09-27)

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


### [Konnect plus redux](https://github.com/Kong/docs.konghq.com/pull/6177) (2023-09-26)

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
https://deploy-preview-6099--kongdocs.netlify.app/hub/plugins/license-tiers/#kong-gateway



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


### [Revert "Konnect Plus metered billing"](https://github.com/Kong/docs.konghq.com/pull/6175) (2023-09-26)

Reverts Kong/docs.konghq.com#6099

#### Added

- https://docs.konghq.com/konnect/account-management/billing
- https://docs.konghq.com/konnect/account-management/change-plan

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
- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/dev-portal/authentication/okta-config
- https://docs.konghq.com/hub/plugins/license-tiers
- https://docs.konghq.com/konnect/account-management/
- https://docs.konghq.com/konnect/analytics/
- https://docs.konghq.com/konnect/compatibility
- https://docs.konghq.com/konnect/dev-portal/dev-reg
- https://docs.konghq.com/konnect/dev-portal/troubleshoot/
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/how-to
- https://docs.konghq.com/konnect/gateway-manager/declarative-config
- https://docs.konghq.com/konnect/gateway-manager/
- https://docs.konghq.com/konnect/gateway-manager/kic
- https://docs.konghq.com/konnect/getting-started/access-account
- https://docs.konghq.com/konnect/getting-started/import
- https://docs.konghq.com/konnect/org-management/auth
- https://docs.konghq.com/konnect/org-management/deactivation
- https://docs.konghq.com/konnect/updates


### [chore: Remove old konnect api doc](https://github.com/Kong/docs.konghq.com/pull/6168) (2023-09-25)

Removing the [old Konnect Runtime Groups Config API doc](https://docs.konghq.com/konnect/api/runtime-groups-config/overview/). It has been replaced with:

https://docs.konghq.com/konnect/api/
https://docs.konghq.com/konnect/api/control-plane-configuration/latest/



### [fix: More runtime group stragglers](https://github.com/Kong/docs.konghq.com/pull/6165) (2023-09-25)

Ran into some API examples and links to the old API docs that still use `runtime-groups`, so fixing that.

#### Modified

- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-teams
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/how-to
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/migrate
- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/custom-dp-labels
- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/renew-certificates
- https://docs.konghq.com/konnect/gateway-manager/
- https://docs.konghq.com/konnect/network
- https://docs.konghq.com/konnect/updates


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

First draft of the Kong Gateway Operator docs. Please review but do not merge

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

#### Modified

- https://docs.konghq.com/breadcrumb_titles.yml


### [fix: Expose an external application](https://github.com/Kong/docs.konghq.com/pull/6141) (2023-09-27)

tested, validated, rewrote

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

Tested, Validated, and Formatted the UDP service guide

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


### [chore(deps): update docs from repo source](https://github.com/Kong/docs.konghq.com/pull/6109) (2023-09-26)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/6296582489)

#### Modified

- https://docs.konghq.com/mesh/dev/kuma-cp.yaml


### [chore(deps): bump kumahq/kuma-website from 6d372126 to 2359791d](https://github.com/Kong/docs.konghq.com/pull/6108) (2023-09-26)

Auto upgrade PR log:

2359791dce1109e75a4dbf3fe1f1f65e98a5a78e chore(vale): add word "RFC" to allowed in vale vocabulary (kumahq/kuma-website#1470)
f84bc5293cb996f4e7cc29004ce757fa1fce5c91 chore(deps): update docs from repo source (kumahq/kuma-website#1464)
217b5f15a1387fc556ce118a7006237f9b5fb4ea fix(cni): update doc to have v2 be default (kumahq/kuma-website#1447)
936c7238baf099b677fc0e4cf2f5b22595a47f6b ci: increase rate limit and remove sync_generated.sh script (kumahq/kuma-website#1465)
aeb3f2f71e2eb5c68276fc143c3f297b8dee0398 docs(routing): add note about appProtocol (kumahq/kuma-website#1461)
5ad6c6fd742eda7cbd1a11bfb945f93707a339fa chore(deps): bump @adobe/css-tools from 4.0.1 to 4.3.1 (kumahq/kuma-website#1454)
f3a776b8cf4509d2eeed8b59099955aab5b62472 chore(deps): update docs from repo source (kumahq/kuma-website#1463)
189846c07897ef8c7e60f30f7ef49a15df66e029 chore(deps): update docs from repo source (kumahq/kuma-website#1460)
5c880f26222b979f15ab4fde15c2f8b586df6f53 ci(installer): run tests on ubuntu 22.04 (kumahq/kuma-website#1462)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/6306356095).

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


### [feat(api-requests): added api requests beta to docs](https://github.com/Kong/docs.konghq.com/pull/6104) (2023-09-26)

Added a new section under Analytics to document our upcoming API Requests feature. This feature is in beta. Please take a look at [this release](https://konghq.atlassian.net/wiki/spaces/KNN/pages/3065151570/API+Requests+Beta) minutes page to learn more about this feature.

https://konghq.atlassian.net/browse/DOCU-3264

#### Added

- https://docs.konghq.com/assets/images/docs/konnect/konnect-analytics-api-requests.png
- https://docs.konghq.com/konnect/analytics/api-requests

#### Modified

- https://docs.konghq.com/konnect/updates


### [Konnect Plus metered billing](https://github.com/Kong/docs.konghq.com/pull/6099) (2023-09-26)

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
https://deploy-preview-6099--kongdocs.netlify.app/hub/plugins/license-tiers/#kong-gateway



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
- https://docs.konghq.com/gateway-operator/1.0.x/production/upgrade/data-plane/rolling/
- https://docs.konghq.com/hub/plugins/license-tiers
- https://docs.konghq.com/konnect/account-management/
- https://docs.konghq.com/konnect/analytics/
- https://docs.konghq.com/konnect/compatibility
- https://docs.konghq.com/konnect/dev-portal/dev-reg
- https://docs.konghq.com/konnect/dev-portal/troubleshoot/
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/how-to
- https://docs.konghq.com/konnect/gateway-manager/declarative-config
- https://docs.konghq.com/konnect/gateway-manager/
- https://docs.konghq.com/konnect/gateway-manager/kic
- https://docs.konghq.com/konnect/getting-started/access-account
- https://docs.konghq.com/konnect/getting-started/import
- https://docs.konghq.com/konnect/org-management/auth
- https://docs.konghq.com/konnect/org-management/deactivation
- https://docs.konghq.com/konnect/updates


### [doc(portal): add documentation for auth0 dcr metadata TDX-3342](https://github.com/Kong/docs.konghq.com/pull/6096) (2023-09-26)

<!-- What did you change and why? -->
 
<!-- Include any supporting resources, e.g. link to a Jira ticket, GH issue, FTI, Slack, Aha, etc. -->
Adds documentation around auth0 metadata, and how to use it via an action.  https://konghq.atlassian.net/browse/TDX-3342

#### Modified

- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/auth0
- https://docs.konghq.com/konnect/updates


### [Sectioned cluster_fallback configs + added WebAssembly text to Wasm section](https://github.com/Kong/docs.konghq.com/pull/6065) (2023-09-27)

Moved the DP Resilience feature (Cluster Fallback) properties to their own section for better organization and linking. Loosely related to https://github.com/Kong/docs.konghq.com/pull/6064.

Also noticed our Wasm section had no reference to the text 'WebAssembly' which resulted in it not being found easily. Added that to the title of that section to allow for better searchability.


### Checklist 

- [x] Review label added <!-- (see below) -->
- [x] PR pointed to correct branch (`main` for immediate publishing, or a release branch: e.g. `release/gateway-3.2`, `release/deck-1.17`)

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

