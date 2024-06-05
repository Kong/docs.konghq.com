---
title: Import Kong Gateway Entities into Konnect
content_type: how-to
---

If you are an existing {{site.base_gateway}} user looking to use {{site.konnect_short_name}}
as your cloud-hosted control plane, you can use [decK](/deck/) to import your
{{site.base_gateway}} entity configuration into a control plane in your
{{site.konnect_short_name}} organization.

You can also use this method to migrate between {{site.konnect_short_name}} organizations.

Afterward, you must manually move over:
* Dev Portal files, developer accounts, and applications
* Application registrations
* Convert roles and permissions into {{site.konnect_short_name}} teams
* Certificates
* Custom plugins

You cannot import [unsupported plugins](/konnect/servicehub/plugins/#plugin-limitations).

## Prerequisites

* [A {{site.konnect_short_name}} account](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=konnect-getting-started)
* [decK 1.28 or later](/deck/latest/installation/)
* Make sure that if you're using a `.deck.yaml` config file that it doesn't contain a {{site.konnect_short_name}} personal access token (PAT)

## Import entity configuration

Use decK to import entity configurations into a control plane.

When you provide any {{site.konnect_short_name}} flags, decK targets the `cloud.konghq.com` environment by default.

1. Generate a {{site.konnect_short_name}} personal access token (PAT) for a user account.
  
    In {{site.konnect_short_name}} in your [**Personal Access Token** account settings](https://cloud.konghq.com/global/account/tokens), click **Generate Token**.

1. Set your PAT as an environment variable and authenticate: 

    ```sh
    export DECK_KONNECT_TOKEN=PAT_02uI9CEOkYo36NlJnFVyZf8xDxfgirtgq0NvNWASfweoGMqA && deck gateway ping
    ```
    
    {:.note}
    > **Note**: Alternatively, you can pass your PAT directly into the CLI using `--konnect-token <pat>` or read it to a file using `--konnect-token-file /PATH/TO/FILE`.

1. Run [`deck gateway dump`](/deck/latest/reference/deck_gateway_dump/) to export the configuration into a file:

    ```sh
    deck gateway dump -o kong.yaml
    ```

    This command outputs {{site.base_gateway}}'s object configuration into
    to ` by default. You can also set `--output-file /path/{FILENAME}.yaml`
    to set a custom filename or location.

1. Preview the import with the [`deck gateway diff`](/deck/latest/reference/deck_gateway_diff/)
command.

    ```sh
    deck gateway diff kong.yaml
    ```

    If you're not using the default `kong.yaml` file, specify the filename and
    path with `--state /path/{FILENAME}.yaml`.

1. If you're satisfied with the preview, run [`deck gateway sync`](/deck/latest/reference/deck_gateway_sync/):

    ```sh
    deck gateway sync kong.yaml
    ```

    If you don't specify the `--konnect-control-plane-name` flag, decK targets the
    `default` control plane. If you have more than one control plane in your
    organization, we recommend always setting this flag to avoid accidentally
    pushing configuration to the wrong control plane.

1. Log in to your {{site.konnect_saas}} account and open the control plane you just migrated in [**Gateway Manager**](https://cloud.konghq.com/gateway-manager/). Look through the configuration details of any imported entities to make sure
they were migrated successfully.

## Next steps

Now that you've imported your {{site.base_gateway}} entities to {{site.konnect_short_name}}, you can migrate additional settings from {{site.base_gateway}} or continue to test {{site.konnect_short_name}}'s capabilities.

### Migrate additional settings

<div class="docs-grid-install max-4" >

  <a href="/konnect/api-products/service-documentation/" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-upload.svg" alt="">
    <div class="install-text">Migrate API specs and markdown service descriptions</div>
  </a>

  <a href="/konnect/dev-portal/dev-reg/" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-customers.svg" alt="">
    <div class="install-text">Create Dev Portal accounts for developers</div>
  </a>

  <a href="/konnect/gateway-manager/plugins/#custom-plugins" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-extensibility.svg" alt="">
    <div class="install-text">Prepare custom plugins for migration</div>
  </a>

  <a href="/konnect/org-management/teams-and-roles/" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-teams.svg" alt="">
    <div class="install-text">Review and set up teams and roles</div>
  </a>

</div>

### Test other {{site.konnect_short_name}} use cases

<div class="docs-grid-install max-3">

  <a href="/hub/kong-inc/key-auth/how-to/basic-example/?tab=konnect-api" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-key-auth.png" alt="" style="max-height:50px">
    <div class="install-text">Protect my APIs with key authentication</div>
  </a>

  <a href="/hub/kong-inc/rate-limiting/?tab=konnect-api" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-rl.png" alt="" style="max-height:50px">
    <div class="install-text">Rate limit my APIs</div>
  </a>

  <a href="/konnect/dev-portal/applications/enable-app-reg/" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-operation.svg" alt="">
    <div class="install-text">Make my APIs available to customers</div>
  </a>

</div>