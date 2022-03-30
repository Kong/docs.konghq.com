<!-- Used in Konnect getting started guides -->

In this section, you can take one of two paths: keep the Dev Portal private
and require a login, or switch it to public, making it visible to anyone with
a link.

If you choose to make the Dev Portal public, application registration
will not be available.

{:.note}
> **Note:** The Dev Portal is a separate site that requires its own credentials.
You can't use your Konnect credentials to log in here.

{% navtabs %}
{% navtab Private Dev Portal %}

1. Access the Dev Portal in one of the following ways:
    * From [{{site.konnect_short_name}}](https://cloud.konghq.com/) menu,
    go to **Dev Portal**. From there, click the **Portal URL**.
    * Directly visit the default Dev Portal URL:

    ```
    https://{ORG_NAME}.portal.cloud.konghq.com/
    ```

1. Click **Sign Up** and fill out the form to create a developer account.

    Remember, the Dev Portal does not share credentials with your Konnect
    account.

1. As as admin, return to Konnect and approve the new account:

    1. From the left side menu, click **Connections**. This opens the Requests
    page and the Developers tab, which displays the pending developer request.

    2. In the row for developer request you want to approve, click the icon and choose
       **Approve** from the context menu.

       The status is updated from **Pending** to **Approved**. The developer
       transfers from the pending Requests page Developers tab to the Developers page.

1. Check your email for a confimation link. Click the link, then log
into the Dev Portal.

1. Open the `example_service` to check it out.

{% endnavtab %}
{% navtab Public Dev Portal %}

1. From the [{{site.konnect_short_name}}](https://cloud.konghq.com/) menu, open
![settings icon](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand}
**Settings**.

1. In the **Public Portal** pane, toggle the switch to **Enabled**.

1. Click **Save**.

1. Access the Dev Portal in one of the following ways:
    * From the left navigation menu again, go to **Dev Portal**.
    From there, click the **Portal URL**.
    * Directly visit the default Dev Portal URL:

    ```
    https://{ORG_NAME}.portal.cloud.konghq.com/
    ```
1. Open the `example_service` to check it out.

{% endnavtab %}
{% endnavtabs %}
