---
title: Publish a Service to the Dev Portal
no_version: true
---

Through ServiceHub, you can publish any Service in your catalog and its
documentation to the Developer Portal. Publishing services to the Developer Portal is the only way to expose your service to Developers. Once the Developer Portal is published and available to Developers, they can apply for access by [registering](/konnect/dev-portal/access-and-approval/dev-reg/) a Developer Account. You can also [manage](/konnect/dev-portal/access-and-approval/manage-devs/) access to the Developer Portal from the Konnect Cloud interface.

This doc will cover

* [Publishing a Service](#publish)

* [Unpublishing a Service](#unpublish)

* [Accessing the Developer Portal](#url)

* [Toggling public access to the Developer Portal](#access)

## Publish a Service {#publish}

1. From the left navigation menu, open the **ServiceHub** page and select a
Service.

2. Click on the **Service Actions** dropdown menu and select **Publish to Portal**.

    This publishes a Service's API specs to the Dev Portal.

## Unpublish a Service {#unpublish}

1. In the left navigation menu, open the {% konnect_icon servicehub %}
**ServiceHub** and select a Service.

2. Click on the **Service Actions** dropdown and select **Unpublish from Portal**.

## Access the Developer Portal {#url}

1. From the left navigation menu, open the **DevPortal** page.

    The DevPortal page contains a list of all of your Published Services. 

2. Click the button next to the desired service, then click **View in Portal**.

    * You can also click **Konnect Portal URL** from this page.

    {:.note}
    >**Note**: You can also visit the default URL for your Developer Portal at `https://<org-name>.us.portal.konghq.com/`

The Developer Portal is accessible by a default URL. For instructions on customizing the URL of your Developer Portal, please see our [Customization Reference](/konnect/dev-portal/customization/custom/). 

## Enable or disable public access for a Dev Portal {#access}

<<<<<<< HEAD
1. From the left navigation menu, open the **ServiceHub** page and select a Service.
=======
1. In {{site.konnect_short_name}}, open {% konnect_icon dev-portal %}
**Dev Portal** from the left side menu, then click **Settings**.
>>>>>>> 7234f32b1e (Add troubleshooting section)

2. In the **Public Portal** pane, toggle **Enabled** or **Disabled**.

3. Click **Save**.

## Next Steps 

After publishing a service to the Developer Portal, please review our [Access and Approval documentation](/konnect/dev-portal/access-and-approval/manage-devs/) and our [Customization documentation](/konnect/dev-portal/customization/custom/)