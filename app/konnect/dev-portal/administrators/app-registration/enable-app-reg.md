---
title: Enable Application Registration for a Service
no_search: true
no_version: true
beta: true
toc: true
---

Enable application registration on a Service package. When application registration
is enabled, developers must [register an application](/konnect/dev-portal/developers/dev-reg-app-service)
to a Service.

All versions of a Service
share the same authentication strategy. When you add another version to a Service,
it inherits the automatically enabled plugins for that strategy.

You can [disable application registration](/konnect/dev-portal/administrators/app-registration/disable-app-reg/)
again any time at your discretion.

## Prerequisites

- Proper role permissions.

  You must be a Konnect admin with the
  [correct roles and permissions](/konnect/reference/org-management/#role-definitions)
  to manage application connections to a Service.

  The following roles allow you to
  enable app registration for a Service:

  - Organization Admin
  - Service Admin

- The Service packages have been created, versioned, and published to the Konnect Dev Portal
  so that they appear in the Catalog.


## Enable App Registration for the Key Authentication Flow

1. From the Konnect menu, click **Services**.

   The Services page is displayed.

   ![Konnect Services Page](/assets/images/docs/konnect/konnect-services-page.png)

2. Depending on your view, click the tile for the Service in cards view or the row
   for the Service in table view.

   The Overview page for the Service is displayed.

   ![Konnect Enable App Registration](/assets/images/docs/konnect/konnect-enable-app-reg-service-menu.png)

3. From the **Actions** menu, click **Enable app registration**.

   The Enable App Registration dialog is displayed.

   ![Konnect Enable App Registration](/assets/images/docs/konnect/konnect-enable-app-reg-key-auth.png)

4. Select `key-auth` from the **Auth Type** list.

   <div class="alert alert-ee red"> Key authentication is the only authorization type
   available for the {{site.konnect_product_name}} beta.
   </div>

5. (Optional) Click to enable **Auto Approve**. Any developer registration
   requests for an application are automatically approved. A Konnect admin does not need to
   [manually approve](/konnect/dev-portal/administrators/app-registration/manage-app-reg-requests/) application
   registration requests for developers.

6. Click **Enable**.

   The status for application registration changes to **Enabled**.

   The Version information page for the service shows the `acl` and `key-auth` plugins were automatically enabled.

   ![Konnect App Registration Key Auth Plugins](/assets/images/docs/konnect/key-auth-acl-plugins.png)


## Troubleshooting

If you encounter any of the errors below that appear in the Enable App Registration dialog, follow the recommended solution.

| Error Message | Solution |
|------------------------------|---------------------------------------------------------------------------------|
| No Service implementation in the Service package. | Create a Service implementation. See the [example](/konnect/getting-started/configure-service/#implement-a-service-version) in the getting started guide. |
