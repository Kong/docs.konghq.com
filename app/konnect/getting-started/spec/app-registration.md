---
title: Register an Application to a Service
no_version: true
---

Along with hosting API documentation, the Dev Portal can let your developers
register applications against Konnect Services. Your applications can then
consume those Services using application-level authentication.

For example, the application can represent a mobile banking app and the
Services registered to the application can be a billing API, a users API, and a
legal agreements API.

## Prerequisites

* If you're following the {{site.konnect_short_name}} API spec guide,
make sure you have [published the Konnect Service to the Dev Portal](/konnect/getting-started/spec/service/).

* To use app registration, Dev Portal must be protected by
some sort of authentication. That means you can't have a public portal for this step.
If you set your Dev Portal to public, [disable the setting and create a developer account](/konnect/getting-started/spec/publish/).

* You must have a Konnect Service in the default runtime group.
Application registration is not supported for custom runtime groups.

## Enable app registration

1. From the [ServiceHub](https://cloud.konghq.com/servicehub/), open
a version of the `example_service`.

1. From the **Actions** dropdown menu, select **Enable app registration**.

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

Link an application to a published Service.

1. Log into the {{site.konnect_short_name}} Dev Portal.

    You can always find your Dev Portal URL under the [Dev Portal menu](https://konnect.konghq.tech/portal/portal-url).

1. In the {{site.konnect_short_name}} Dev Portal, click **My Apps** from the
dropdown menu in the upper right.

1. On the **My Apps** page, click the **New App** button.

1. Fill out the form with your application name,
reference ID, and description. The reference ID must be unique.

1. Click **Create** to save and see your new application's detail page.

## Register the application

1. Open the **Catalog** from the top menu and click on a Service tile.

3. Choose the version of the Service you want to use and click **Register**.

    If you don't see the registration button, that means this version doesn't
    have application registration enabled.

4. Select the application you want to register from the list.

5. Click **Request Access**.

    This opens the application's details page. If auto approval is enabled,
    the service appears with the status `Approved`.

## Generate a key auth credential

1. In the **Authentication** pane of the application detail page, click **Generate Credential**.

1. Test the generated credential by making a call to the service the
   [application is registered with](/konnect/dev-portal/applications/dev-reg-app-service)
   using your generated API key:

   ```sh
   curl -i -X GET http://localhost:8000/mock \
    -H 'apikey: {API_KEY}'
   ```

   Use this key in any applications that need to access this service.

## Summary and next steps

In this topic, you:
* Enabled application registration for the service `example_service`.
* From the Dev Portal, created an application and registered it against the `example_service`.
* Generated an API key for the application and made a call using this key.
