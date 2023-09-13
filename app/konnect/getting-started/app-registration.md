---
title: Register an Application to a Service
---

Along with hosting API documentation, the Dev Portal can let your developers
register applications against API products. Your applications can then
consume those services using application-level authentication.

For example, the application can represent a mobile banking app and the
services registered to the application can be a billing API, a users API, and a
legal agreements API.

## Prerequisites

* You have an API product with at least one version.

* You have [productized the API product to the Dev Portal](/konnect/getting-started/productize-service/).

  * To use app registration, the Dev Portal must be protected by
  some sort of authentication. That means you can't have a public portal for this step.
  If you set your Dev Portal to public, [disable the setting and create a developer account](/konnect/getting-started/publish-service/).

## Enable app registration

1. From the {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/api-products/),
open an API product version.

1. Under **App Registration** select the **Disabled** From the **Actions** dropdown menu.

1. Accept the `key-auth` setting, toggle **Auto-Approve** to enable it,
 then click **Enable**.

    Application registration uses key authentication (`key-auth`) by default.
    If you have integrated the Dev Portal with an IdP, you can also select
    `openid-connect`. For the purpose of this example, we're using the simpler
    `key-auth` option, which doesn't required any external services.

    With Auto Approve enabled, any developers trying to register their applications
    against this service will be approved automatically. If you leave it off,
    you have to approve each registration request manually.

    With app registration enabled, all versions of this service now include
    read-only entries for the `acl` and `key-auth` plugins, and the service is now
    available for registration from the Dev Portal.

## Create an application

Link an application to a published service.

1. Log into the {{site.konnect_short_name}} Dev Portal.

    You can always find your Dev Portal URL under the [Dev Portal menu](https://cloud.konghq.com/portal).

    Remember, the Dev Portal doesn't share credentials with your {{site.konnect_short_name}}
    account.

1. In the {{site.konnect_short_name}} Dev Portal, click **My Apps** from the
dropdown menu in the upper right.

1. On the **My Apps** page, click the **New App** button.

1. Fill out the form with your application name,
reference ID, and description. The reference ID must be unique.

1. Click **Create** to save and see your new application's detail page.

## Register the application

1. From your Dev Portal account, open the **Catalog** from the top menu and click on a service tile.

1. Choose the version of the API product you want to use and click **Register**.

    If you don't see the registration button, that means this version doesn't
    have application registration enabled.

1. Select the application you want to register from the list.

1. Click **Request Access**.

    This opens the application's details page. If auto approval is enabled,
    it appears with the status `Approved`.

## Generate a key auth credential

1. In the **Authentication** pane of the application detail page, click **Generate Credential**.

1. Test the generated credential by making a call to the service the
   [application is registered with](/konnect/dev-portal/applications/dev-reg-app-service/)
   using your generated API key:

   ```sh
   curl -i -X GET http://localhost:8000/mock \
    -H 'apikey: {API_KEY}'
   ```

   Use this key in any applications that need to access this product.

## Summary and next steps

In this topic, you:
* Enabled application registration for the the API product version.
* Created an application through the Dev Portal and registered it against your API product version.
* Generated an API key for the application and made a call using this key

You can learn more about [application registration](/konnect/dev-portal/applications/enable-app-reg/) 
in the {{site.konnect_saas}} Dev Portal documentation.

For next steps, check out some of the other things you can do in
{{site.konnect_saas}}:

* If you have existing {{site.base_gateway}} configuration you want to use,
[import {{site.base_gateway}} entities into {{site.konnect_saas}}](/konnect/getting-started/import)
* Enable plugins on a [Gateway Service](/konnect/runtime-manager/enable-service-plugin/) or a
[route](/konnect/runtime-manager/enable-route-plugin/)
* [Manage your teams and roles](/konnect/org-management/teams-and-roles/)
