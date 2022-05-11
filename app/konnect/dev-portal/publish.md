---
title: Publish a Service to the Dev Portal
no_version: true
---

Through ServiceHub, you can publish any Service in your catalog and its
documentation to the Developer Portal. Publishing services to the Dev Portal is the only way to expose your service to Developers. Once the Service is published and available to Developers, they can apply for access by [registering](/konnect/dev-portal/access-and-approval/dev-reg/) a Developer Account. You can also [manage](/konnect/dev-portal/access-and-approval/manage-devs/) access to the Developer Portal from the {{site.konnect_saas}} interface.

This doc covers:

* [Publishing a Service](#publish)

* [Unpublishing a Service](#unpublish)

* [Accessing the Developer Portal](#url)

* [Toggling public access to the Developer Portal](#access)

## Publish a Service {#publish}

1. From the left navigation menu, open the {% konnect_icon servicehub %} **ServiceHub** page and select a

2. Click on the **Service actions** dropdown menu and select **Publish to portal**.

    This publishes a Service's API specs to the Dev Portal.

## Unpublish a Service {#unpublish}

1. In the left navigation menu, open the {% konnect_icon servicehub %}
**ServiceHub** and select a Service.

2. Click on the **Service actions** dropdown and select **Unpublish from portal**.

## Access the Developer Portal {#url}

1. From the left navigation menu, open the **Dev Portal** page.

    The DevPortal page contains a list of all of your Published Services. 

2. Click the button next to the desired service, then click **View in portal**.

    * You can also click **Konnect Portal URL** from this page.

    {:.note}
    >**Note**: You can also visit the default URL for your Developer Portal at `https://<org-name>.us.portal.konghq.com/`

The Developer Portal is accessible by a default URL. For instructions on customizing the URL of your Developer Portal, please see our [Customization Reference](/konnect/dev-portal/customization/custom/). 

## Enable or disable public access for a Dev Portal {#access}

1. In {{site.konnect_short_name}}, open {% konnect_icon dev-portal %}
**Dev Portal** from the left side menu, then click **Settings**.

2. In the **Public Portal** pane, toggle **Enabled** or **Disabled**.

3. Click **Save**.

## Next Steps 

After publishing a service to the Developer Portal, please review our [Access and Approval documentation](/konnect/dev-portal/access-and-approval/manage-devs/) and our [Customization documentation](/konnect/dev-portal/customization/custom/)