<!-- Used in Konnect getting started guides -->

Let's set up the first version of your API service.

1. On your Service's overview page, scroll down to **Versions** and
 click **New Version**.

1. Enter a **Version Name**. For this example, enter `v1`.

    A version name can be any string containing letters, numbers, or characters;
    for example, `1.0.0`, `v1`, or `version#1`. A Service can have multiple
    versions.

1. Select a runtime group.

    Choose a [group](/konnect/configure/runtime-manager/runtime-groups) to
    deploy this Service version to. This lets you deploy to a specific group of
    runtime instances in a specific environment.

    {:.note}
    > **Note:** Application registration is only available for
    Services in the default runtime group, so if you plan on using
    [application registration](/konnect/dev-portal/applications/application-overview),
    choose `default` in this step.

    Different versions of the same Service can run in different runtime groups.
    The version name is unique within a group:

    * If you create multiple versions in the **same group**, they must have unique names.
    * If you create multiple versions in **different groups**, the versions can have the same name.

1. Click **Create** to save.
