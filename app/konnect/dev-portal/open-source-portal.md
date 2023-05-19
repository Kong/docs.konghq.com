---
title: Configure an Open Source Dev Portal with _____
content_type: how-to
badge: oss
---

You can use the open source Dev Portal to display your APIs to developers on a self-hosted website. This guide shows you how to configure an example open source Dev Portal, which you can further customize by adjusting the code of the sample app and self-hosting it on a frontend application of your choice.

## Prerequisites

* [A {{site.konnect_saas}} account](/konnect/getting-started/access-account/)
* [Yarn 1.22.x installed](https://classic.yarnpkg.com/lang/en/docs/install/#mac-stable)

## Configure the example open source Dev Portal

1. Create a local .env file:
    ```sh
    cp .env.example .env
    ```
1. Set the `VITE_PORTAL_API_URL` value in your current environment. This should match either the Kong-supplied portal URL ending in `portal.konghq.com` or the [custom Dev Portal URL set in {{site.konnect_short_name}}](/konnect/dev-portal/customization/#custom-dev-portal-url).
1. Run Vite dev:
    ```sh
    yarn dev #optional --verbose
    ```
1. Run tests:
    ```sh
    yarn test:e2e
    ```

## Customize the example open source Dev Portal 

Adding additional sections can be helpful if you have to switch from working in one product to another or if you switch from one task, like installing to configuring.

1. First step.
1. Second step.

## More information

* [Analytics reports](https://docs.konghq.com/gateway/latest/kong-enterprise/analytics/reports/)
* [Service directory mapping](https://docs.konghq.com/gateway/latest/kong-manager/auth/ldap/service-directory-mapping/)
* [Custom entities](https://docs.konghq.com/gateway/latest/plugin-development/custom-entities/)