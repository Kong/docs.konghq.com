---
title: Manage Konnect Cloud with decK
no_version: true
---

You can manage entities in your {{site.konnect_saas}} org using configuration
files instead of the GUI or admin API commands. With decK, Kong's declarative
configuration management tool, you can create, update,
compare, and synchronize configuration as part of an automation pipeline.

In {{site.konnect_saas}}, decK can manage:
* **All parts of a service:** Service versions, implementations, routes, and
plugins.
* **Dev Portal documents:** Specs and markdown files.
* Consumers, upstreams, and global plugins.

To do this, you need [decK v1.7.0 or later](/deck/).

You _cannot_ use decK to publish content to the Dev Portal, manage application
registration, or configure custom plugins.

## Prerequisites

* [**Organization Admin**](/konnect/legacy/org-management/users-and-roles) permissions.
* decK v1.7.0 or later [installed](/deck/latest/installation/).
* Optional: To test your configuration, [set up a simple runtime](/konnect/legacy/getting-started/configure-runtime).

## Test your connection

Check that you can log in to {{site.konnect_short_name}} and that decK
recognizes your account credentials:

```sh
deck konnect ping --konnect-email <email> --konnect-password <password>
```

If the connection is successful, the terminal displays the first and last name
associated with the account:

```sh
Successfully Konnected as Some Name (Kong)!
```

You can also use decK with {{site.konnect_short_name}} more securely by storing
your password in a file, then either calling it with
`--konnect-password-file <pass>.txt`, or adding it to your decK configuration
under the `konnect-password` option.

The following steps all use `--konnect-password-file`.


## Create a configuration file

Capture a snapshot of the current configuration in a file:

```sh
deck konnect dump --konnect-email <email> --konnect-password-file <pass>.txt
```

The command creates a file named `konnect.yaml`. If you have nothing
configured, decK creates the file with only the format version:

```yaml
_format_version: "0.1"
```

You can specify a different file name or location, or export the
configuration in JSON format:

```sh
deck konnect dump --konnect-email <email> --konnect-password-file <pass>.txt \
--format json \
--output-file examples/konnect2.yaml
```

## Make changes to configuration

Make any changes you like using YAML or JSON format.
For this example, let's add a new service.

1. Generate a UUID. You can do this in any way you want; a common tool is the
`uuidgen` utility.

2. Add the following snippet to your `konnect.yaml` file, replacing the `id` in
the example with your generated UUID:

    ```yaml
    _format_version: "0.1"
    service_packages:
    - name: MyService
      versions:
      - implementation:
          type: kong-gateway
          kong:
            service:
              host: mockbin.org
              port: 80
              protocol: http
              id: {YOUR_GENERATED_UUID}
              routes:
              - methods:
                - GET
                - POST
                name: mockpath
                paths:
                - /mock
                plugins:
                - name: key-auth
                  config:
                    key_names:
                    - apikey
        version: "1"
    ```

    This snippet defines a service named `MyService` pointing to `mockbin.org`.
    The service has one version, and the version gets implemented with the
    route `/mockpath`, which means that you can access the service by appending
    this route to your proxy URL.

    Because you're also enabling the `key-auth` plugin on the route, you need
    a consumer key to access it, so you can't test the route yet.

3. Compare your local file with the configuration currently in
{{site.konnect_saas}}:

    ```sh
    deck konnect diff --konnect-email <email> --konnect-password-file <pass>.txt
    ```

    If the format and schema is correct, decK gives you a preview of what would
    be added to the {{site.konnect_saas}} configuration:

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

4. If you're satisfied with the preview, sync the changes to
{{site.konnect_saas}}:

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

5. Check {{site.konnect_saas}} to make sure the sync worked. You should see a
new service named `MyService` in the
[ServiceHub](https://konnect.konghq.com/servicehub/).

    ![ServiceHub tiles](/assets/images/docs/konnect/konnect-myservice.png)


## Manage consumers and global plugins

You can also use decK to manage objects not tied to a specific service or
route. For this example, create a consumer and a global proxy caching plugin:

* Consumers represent users of a service, and are most often used for
authentication. They provide a way to divide access to your services, and
make it easy to revoke that access without disturbing a service's function.

* Global plugins are plugins that apply to all services, routes, and consumers
in the cluster, as applicable. For example, you can configure proxy caching on
all your services at once with one `proxy-cache` plugin entry.


1. In the previous section, you created a route with key authentication. To
access this route, add a consumer to the `konnect.yaml` file and configure
a key:

    ```yaml
    consumers:
     - custom_id: consumer
       username: consumer
       keyauth_credentials:
       - key: apikey
    ```

2. Enable proxy caching so that your upstream service is not bogged
down with repeated requests. Add a global proxy cache plugin:

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

4. If everything looks good, run another sync, then check {{site.konnect_saas}}
to see your changes:

    ```sh
    deck konnect sync --konnect-email <email> --konnect-password-file <pass>.txt
    ```

    You can find consumers and global plugins under the
    ![icon](/assets/images/icons/konnect/konnect-shared-config.svg){:.inline .no-image-expand}
    **[Shared Config](https://konnect.konghq.com/configuration)** menu option.

    ![Shared Config overview page](/assets/images/docs/konnect/konnect-shared-config.png)

    {:.note}
    > **Note:** If you add consumers to the `konnect.yaml` file and sync your
    local file to Konnect, it picks up consumers automatically. However, if you
    want to pull consumer configuration down **from** Konnect, use the
    `--include-consumers` flag in your command.


## Test the service

If you have already have a runtime set up, you can test this
configuration now. Or, you can start a simple runtime using the
[Docker quick setup](/konnect/legacy/getting-started/configure-runtime) script.

The default proxy URL is `localhost:8000`.

Enter the proxy URL into your browser’s address bar and append the route path
`/mock` with an `apikey` query:

```
http://localhost:8000/mock?apikey=apikey
```

If successful, you should see the homepage for `mockbin.org`. On your Service
Version overview page, you’ll see a record for status code 200. This might
take a few moments.

If you try to access the route without a key, you'll get an authorization error:

```
Kong Error
No API key found in request.
```

## See also

* [decK CLI reference](/deck/latest/reference/deck_konnect): decK commands for {{site.konnect_short_name}}
<!-- * [Migrate from a self-managed {{site.base_gateway}} deployment](/konnect/legacy/deployment/migrate-from-self-managed):
Use decK to migrate {{site.base_gateway}} entities to {{site.konnect_saas}} -->
