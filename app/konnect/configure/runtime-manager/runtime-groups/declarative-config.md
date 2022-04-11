---
title: Manage Runtime Groups with decK
no_version: true
---

You can manage runtime groups in your {{site.konnect_saas}} org using configuration
files instead of the GUI or admin API commands. With decK, Kong's declarative
configuration management tool, you can create, update,
compare, and synchronize configuration as part of an automation pipeline.

In {{site.konnect_saas}}, decK can manage [runtime groups](/konnect/configure/runtime-manager/runtime-groups)
and all of their configurations:
* Create state files for different runtime groups and manage each group
separately.
* Manage Gateway Services, routes, consumers, plugins, and upstreams for each
group.
* Migrate configuration from one group to another.

{:.note}
> **Note:** To work with runtime groups, you need [decK v1.12.0 or later](/deck/).

Use any `--konnect`-prefixed CLI flag or pass {{site.konnect_short_name}}
parameters using a decK configuration file (`~/.deck.yaml` by default) to target
`https://cloud.konghq.com`. If you don't pass any Konnect parameters to decK,
decK looks for a local {{site.base_gateway}} instance instead.

Run `deck help` to see all available flags, or see the [decK CLI reference](/deck/latest/reference/deck).

You _cannot_ use decK to publish content to the Dev Portal, manage application
registration, or configure custom plugins.

## Prerequisites

* [**Organization Admin**](/konnect/org-management/teams-and-roles) permissions.
* decK v1.12.0 or later [installed](/deck/latest/installation/).
* Optional: To test your configuration, [set up a simple runtime](/konnect/getting-started/configure-runtime).

## Test your connection

Check that you can log in to {{site.konnect_short_name}} and that decK
recognizes your account credentials:

```sh
deck ping \
  --konnect-runtime-group-name default \
  --konnect-email {YOUR_EMAIL} \
  --konnect-password {YOUR_PASSWORD}
```

If the connection is successful, the terminal displays the full name of the user
associated with the account:

```sh
Successfully Konnected as Some Name (Org Name)!
```

You can also use decK with {{site.konnect_short_name}} more securely by storing
your password in a file, then either calling it with
`--konnect-password-file /path/{FILENAME}.txt`, or adding it to your decK configuration
file under the `konnect-password` option along with your email:

```yaml
konnect-password: {YOUR_PASSWORD}
konnect-email: {YOUR_EMAIL}
```

The default location for this file is `$HOME/.deck.yaml`. You can target a
different configuration file with the `--config /path/{FILENAME}.yaml` flag, if
needed.

The following steps all use a `.deck.yaml` file to store the
{{site.konnect_short_name}} credentials instead of flags.

## Create a configuration file

Capture a snapshot of the current configuration in a file:

```sh
deck dump --konnect-runtime-group-name default
```

If you don't specify the `--konnect-runtime-group-name` flag, decK will target the
`default` runtime group. If you have more than one runtime group in your
organization, we recommend always setting this flag to avoid accidentally
pushing configuration to the wrong group.

The command creates a file named `kong.yaml`. If you have nothing
configured, decK creates the file with only the format version and runtime group
name:

```yaml
_format_version: "1.1"
_konnect:
  runtime_group_name: default
```

You can specify a different file name or location, or export the
configuration in JSON format:

```sh
deck dump --konnect-runtime-group-name default \
  --format json \
  --output-file examples/konnect.json
```

## Make changes to configuration

Make any changes you like using YAML or JSON format.
For this example, let's add a new service.

1. Add the following snippet to your `kong.yaml` file:

    ```yaml
    _format_version: "1.1"
    _konnect:
      runtime_group_name: default
    services:
    - name: MyService
      host: mockbin.org
      port: 80
      protocol: http
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
    ```

    This snippet defines a service named `MyService` pointing to `mockbin.org`.
    The service has one version, and the version gets implemented with the
    route `/mockpath`, which means that you can access the service by appending
    this route to your proxy URL.

    Because you're also enabling the `key-auth` plugin on the route, you need
    a consumer key to access it, so you can't test the route yet.

1. Compare your local file with the configuration currently in
{{site.konnect_saas}}:

    ```sh
    deck diff --konnect-runtime-group-name default
    ```

    If the format and schema is correct, decK gives you a preview of what would
    be added to the {{site.konnect_saas}} configuration:

    ```sh
    creating route mockpath
    creating service MyService
    Summary:
      Created: 2
      Updated: 0
      Deleted: 0
    ```

1. If you're satisfied with the preview, sync the changes to
{{site.konnect_saas}}:

    ```sh
    deck sync --konnect-runtime-group-name default
    ```

    You should see the same output again:

    ```sh
    creating route mockpath
    creating service MyService
    Summary:
      Created: 2
      Updated: 0
      Deleted: 0
    ```

1. Check {{site.konnect_saas}} to make sure the sync worked. Open **Runtimes** from
the left side menu, then select your runtime group > **Gateway Services**.

    You should see a new service named `MyService` in the runtime group.

## Manage consumers and global plugins

You can also use decK to manage objects not tied to a specific service or
route. For this example, create a consumer and a global proxy caching plugin:

* Consumers represent users of a service, and are most often used for
authentication. They provide a way to divide access to your services, and
make it easy to revoke that access without disturbing a service's function.

* Global plugins are plugins that apply to all services, routes, and consumers
in the runtime group, as applicable. For example, you can configure proxy
caching on all your services at once with one `proxy-cache` plugin entry.


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

1. Enable proxy caching so that your upstream service is not bogged
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

1. Run a diff to test your changes:

    ```sh
    deck diff --konnect-runtime-group-name default
    ```

1. If everything looks good, run another sync, then check {{site.konnect_saas}}
to see your changes:

    ```sh
    deck sync --konnect-runtime-group-name default
    ```

## Test the service

If you have already have a runtime set up, you can test this
configuration now. Or, you can start a simple runtime using the
[Docker quick setup](/konnect/getting-started/configure-runtime) script.

The default proxy URL is `localhost:8000`.

Make a call to the proxy URL and append the route path `/mock` with an `apikey`
header:

 ```sh
 curl -i -X GET http://localhost:8000/mock \
  -H 'apikey: {API_KEY}'
 ```

If successful, you should see the homepage for `mockbin.org`. On your Service
Version overview page, you’ll see a record for status code 200. This might
take a few moments.

If you try to access the route without a key, you'll get an authorization error:

```
Kong Error
No API key found in request.
```

## Migrate configuration between runtime groups
{:.badge .enterprise}

You can also use decK to migrate or duplicate configuration between runtime
groups.

1. Export configuration from the original runtime group with
[`deck dump`](/deck/latest/reference/deck_dump) into a state file:

    ```bash
    deck dump \
      --konnect-runtime-group-name default \
      --output-file default.yaml
    ```

1. In the file, change the runtime group name to the new group:

    ```yaml
    _format_version: "1.1"
    _konnect:
      runtime_group_name: staging
    ```

1. Using the state file you just edited, preview the import with
the [`deck diff`](/deck/latest/reference/deck_diff)
command, pointing to the runtime group that you want to target:

    ```sh
    deck diff \
      --konnect-runtime-group-name staging \
      --state default.yaml
    ```

1. If everything looks good, [`deck sync`](/deck/latest/reference/deck_sync)
 the configuration to the new runtime group:

    ```sh
    deck sync \
      --konnect-runtime-group-name staging \
      --state default.yaml
    ```

You should now have two runtime groups in {{site.konnect_short_name}} with
the same configuration.

## See also

* [decK CLI reference](/deck/latest/reference/deck)
* [Import {{site.base_gateway}} configuration into {{site.konnect_short_name}}](/konnect/deployment/import)
