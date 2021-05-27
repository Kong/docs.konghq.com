---
title: Managing a Kong-hosted control plane with declarative config
no_version: true
---

Manage entities in your Konnect cloud control plane with declarative
configuration. To do this, you need [decK](/deck/).

With declarative configuration, you can manage:
* **All parts of a service:** Service versions, implementations, routes, and
plugins.
* **Dev Portal documents:** Specs and markdown files.
* **Global configuration:** If you want to use global plugins or consumers, you
have to use declarative configuration. Global plugins appear in the
Konnect UI as read-only.

DecK _cannot_ manage Dev Portal, application registration, or custom plugins.

## Prerequisites

* Permissions?
* decK is [installed](/deck/installation/).

## Test your connection

First, make sure that you can log in to Konnect and that decK recognizes your
account credentials:

```sh
deck konnect ping --konnect-email <email> --konnect-password <password>
```

If the connection is successful, the terminal displays the first and last name
attributed to the account:

```sh
Successfully Konnected as Some Name (Kong)!
```

{:.tip}
> **Tip:** You can also use decK with Konnect more securely by storing your
password in a file, then calling it with `--konnect-password-file <pass>.txt`.

## Create a configuration file

Pull down Konnect configuration into a file:

```sh
deck konnect dump --konnect-email <email> --konnect-password-file <pass>.txt
```

Your existing services and global configurations are saved locally to a file
named `konnect.yaml`. If you have no services configured yet, decK still
creates the file with a format version:

```yaml
_format_version: "0.1"
```

You can also choose to set a different file name or location, or export the
configuration in JSON format instead:

```sh
deck konnect dump --konnect-email <email> --konnect-password-file <pass>.txt \
--format json \
--output-file examples/konnect2.yaml
```

### Make changes to configuration

Make any changes you like using YAML or JSON format.
For the sake of this example, let's add a new service.

1. Generate a UUID. You can do this in any way you want; a common tool is the
`uuidgen` utility.

2. Add the following snippet to your `konnect.yaml` file, replacing the `id`
in the example with your generated UUID:

    ```yaml
    _format_version: "0.1"
    service_packages:
    - name: MyService
      versions:
      - implementation:
          version: "1"
          type: kong-gateway
          kong:
            service:
              host: mockbin.org
              port: 80
              protocol: http
              id: 9595B5F9-3B6A-4C48-BE93-9EC1B0EA487A
              routes:
              - methods:
                - GET
                - POST
                name: mockpath
                paths:
                - /mockpath
    ```

    Every service must have at least one initial version.

3. Check that the format is correct and that decK recognizes that you've made
changes:

    ```sh
    deck konnect diff --konnect-email <email> --konnect-password-file <pass>.txt
    ```

    If the format and schema is correct, decK gives you a preview of what will
    be added to the control plane configuration:

    ```sh
    creating service 9595B5F9-3B6A-4C48-BE93-9EC1B0EA487A
    creating route mockpath
    creating service-package MyService
    creating service-version 1
    Summary:
      Created: 4
      Updated: 0
      Deleted: 0
    ```

4. If you're satisfied with the preview, sync the changes to the control plane:

    ```sh
    deck konnect sync --konnect-email <email> --konnect-password-file <pass>.txt
    ```

    You should see the same output again:

    ```sh
    creating service 9595B5F9-3B6A-4C48-BE93-9EC1B0EA487A
    creating route mockpath
    creating service-package MyService
    creating service-version 1
    Summary:
      Created: 4
      Updated: 0
      Deleted: 0
    ```

5. Check Konnect Cloud to make sure the sync worked. You should see a
new service named `MyService` in the ServiceHub.

    ![ServiceHub tiles](/assets/images/docs/konnect/konnect-myservice.png)


## Add global configuration

While you can't fully edit global configuration through the Konnect Cloud GUI yet,
you can do it with decK.

1. Add a consumer to the `konnect.yaml` file:

    ```yaml
    consumers:
     - custom_id: consumer
       username: consumer
       keyauth_credentials:
       - key: apikey
    ```

2. Add a global proxy cache plugin:

    ```yaml
    plugins:
    - name: proxy-cache
      config:
        content_type:
        - "application/json; charset=utf-8"
        cache_ttl: 30
        strategy: memory
    ```

3. Run a diff to test your changes:

    ```sh
    deck konnect diff --konnect-email <email> --konnect-password-file <pass>.txt
    ```

4. If everything looks good, run another sync, then check Konnect to see your
changes:

    ```sh
    deck konnect sync --konnect-email <email> --konnect-password-file <pass>.txt
    ```

    You can find the global configuration under the
    ![icon](/assets/images/icons/konnect/konnect-shared-config.svg){:.inline .no-image-expand}
    **Shared Config** menu option.

    ![Shared config overview](/assets/images/docs/konnect/konnect-shared-config.png)

    {:.note}
    > **Note:** If you add consumers to the `konnect.yaml` file and sync your
    local file to Konnect, it picks up consumers automatically. However, if you
    want to pull consumer configuration down **from** Konnect, use the
    `--include-consumers` flag in your request.

## Next steps

If you haven't already, [set up a runtime](/konnect/runtime-manager/) to start
proxying your services.
