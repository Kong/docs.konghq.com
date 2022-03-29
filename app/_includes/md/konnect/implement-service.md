<!-- Used in Konnect getting started guides -->

1. On the **example_service** overview, in the Versions section, click **v1**.

1. Click **New Implementation**.

1. In the **Create Implementation** dialog, in step 1, create a new Service
implementation to associate with your Service version.

    1. In the **Name** field, enter a unique name for the Gateway Service.

        You can't use a Gateway Service that already exists in this runtime
        group.

    1. Click the **Add using URL** radio button. This is the default.

    1. In the URL field, enter `http://mockbin.org`.

    1. Use the defaults for the **6 Advanced Fields**.

    1. Click **Next**.

1. In step 2, **Add a Route** to add a route to your Service Implementation.

    For this example, enter the following:

    * **Name**: `mockbin`
    * **Method**: `GET`
    * **Path(s)**: Click **Add Path** and enter `/mock`

    For the remaining fields, use the default values listed.

1. Click **Create**.

    The **v1** Service Version overview displays.

    If you want to view the configuration, edit or delete the implementation,
    or delete the version, click the **Actions** menu.
