---
title: Manage Control Plane Configuration with decK
content_type: how-to
---

You can manage control planes in your {{site.konnect_saas}} org using configuration
files instead of the GUI or admin API commands. With decK, Kong's declarative
configuration management tool, you can create, update,
compare, and synchronize configuration as part of an automation pipeline.

In {{site.konnect_saas}}, decK can manage [control planes](/konnect/gateway-manager/#control-planes)
and all of their configurations:
* Create state files for different control planes and manage each one
separately.
* Manage [Gateway entities](/konnect/api/) for each control plane.
* Migrate configuration from one control plane to another.

Use a `--konnect`-prefixed CLI flag or pass {{site.konnect_short_name}}
parameters using a decK configuration file (`~/.deck.yaml` by default) to target
`https://cloud.konghq.com`. If you don't pass any {{site.konnect_short_name}} parameters to decK,
decK looks for a local {{site.base_gateway}} instance instead.

Run `deck help` to see all available flags, or see the [decK CLI reference](/deck/latest/reference/deck/).

You _cannot_ use decK to publish content to the Dev Portal, manage application
registration, or configure custom plugins.

## Prerequisites

* decK v1.12.0 or later [installed](/deck/latest/installation/).
* Optional: To test your configuration, [set up a simple data plane node](/konnect/getting-started/configure-data-plane-node/).

## Generate a personal access token

To test your connection, we recommend that you use a personal access token (PAT).

{% include_cached /md/personal-access-token.md %}

## Test your connection

Check that you can log in to {{site.konnect_short_name}} and that decK
recognizes your account credentials:

```sh
deck ping \
  --konnect-control-plane-name default \
  --konnect-token {YOUR_PERSONAL_ACCESS_TOKEN}
```

If the connection is successful, the terminal displays the full name of the user
associated with the account:

```sh
Successfully Konnected to the Example-Name organization!
```

You can also use decK with {{site.konnect_short_name}} more securely by storing
your personal access token in a file, then either calling it with
`--konnect-token-file /path/{FILENAME}.txt`, or adding it to your decK configuration
file under the `konnect-token` option:

```yaml
konnect-token: {YOUR_PERSONAL_ACCESS_TOKEN}
```

The default location for this file is `$HOME/.deck.yaml`. You can target a
different configuration file with the `--config /path/{FILENAME}.yaml` flag, if
needed.

The following steps all use a `.deck.yaml` file to store the
{{site.konnect_short_name}} credentials instead of flags.

## Create a configuration file

Capture a snapshot of the current configuration in a file:

```sh
deck dump --konnect-control-plane-name default
```

If you don't specify the `--konnect-control-plane-name` flag, decK will target the
`default` control plane. If you have more than one control plane in your
organization, we recommend always setting this flag to avoid accidentally
pushing configuration to the wrong group.

The command creates a file named `kong.yaml`. If you have nothing
configured, decK creates the file with only the format version and control plane
name:

```yaml
_format_version: "1.1"
_konnect:
  control_plane_name: default
```

You can specify a different filename or location, or export the
configuration in JSON format:

```sh
deck dump --konnect-control-plane-name default \
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
      control_plane_name: default
    services:
    - name: MyService
      host: httpbin.org
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

    This snippet defines a service named `MyService` pointing to `httpbin.org`.
    The service has one version, and the version gets implemented with the
    route `/mock`, which means that you can access the service by appending
    this route to your proxy URL.

    Because you're also enabling the `key-auth` plugin on the route, you need
    a consumer key to access it, so you can't test the route yet.

1. Compare your local file with the configuration currently in
{{site.konnect_saas}}:

    ```sh
    deck diff --konnect-control-plane-name default
    ```

    If the format and schema is correct, decK gives you a preview of what would
    be added to the {{site.konnect_saas}} configuration:

    ```sh
    creating service MyService
    creating route mockpath
    creating plugin key-auth for route mockpath
    Summary:
      Created: 3
      Updated: 0
      Deleted: 0
    ```

1. If you're satisfied with the preview, sync the changes to
{{site.konnect_saas}}:

    ```sh
    deck sync --konnect-control-plane-name default
    ```

    You should see the same output again:

    ```sh
    creating service MyService
    creating route mockpath
    creating plugin key-auth for route mockpath
    Summary:
      Created: 3
      Updated: 0
      Deleted: 0
    ```

1. Check {{site.konnect_saas}} to make sure the sync worked. Open **Gateway Manager**, select your control plane, and select **Gateway Services**.

    You should see a new service named `MyService` in the control plane.

## Manage consumers and global plugins

You can also use decK to manage objects not tied to a specific service or
route. For this example, create a consumer and a global proxy caching plugin:

* Consumers represent users of a service, and are most often used for
authentication. They provide a way to divide access to your services, and
make it easy to revoke that access without disturbing a service's function.

* Global plugins are plugins that apply to all services, routes, and consumers
in the control plane, as applicable. For example, you can configure proxy
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
    deck diff --konnect-control-plane-name default
    ```

1. If everything looks good, run another sync, then check {{site.konnect_saas}}
to see your changes:

    ```sh
    deck sync --konnect-control-plane-name default
    ```

## Test the service

If you have already have a data plane node deployed, you can test this
configuration now. Or, you can start a new data plane node using the
[Docker quick setup](/konnect/getting-started/configure-data-plane-node/) script.

The default proxy URL is `localhost:8000`.

Make a call to the proxy URL and append the route path `/mock` with an `apikey`
header:

 ```sh
 curl -i -X GET http://localhost:8000/mock \
  -H 'apikey: {API_KEY}'
 ```

If successful, you should see the homepage for `httpbin.org`. On the Service
Version overview page, you’ll see a record for status code `200`.

If you try to access the route without a key, you'll get an authorization error:

```
Kong Error
No API key found in request.
```

## Migrate configuration between control planes


You can also use decK to migrate or duplicate configuration between control planes.

1. Export configuration from the original control plane with
[`deck dump`](/deck/latest/reference/deck_dump) into a state file:

    ```bash
    deck dump \
      --konnect-control-plane-name default \
      --output-file default.yaml
    ```

1. In the file, change the control plane name to the new group:

    ```yaml
    _format_version: "1.1"
    _konnect:
      control_plane_name: staging
    ```

1. Using the state file you just edited, preview the import with
the [`deck diff`](/deck/latest/reference/deck_diff/)
command, pointing to the control plane that you want to target:

    ```sh
    deck diff \
      --konnect-control-plane-name staging \
      --state default.yaml
    ```

1. If everything looks good, [`deck sync`](/deck/latest/reference/deck_sync/)
 the configuration to the new control plane:

    ```sh
    deck sync \
      --konnect-control-plane-name staging \
      --state default.yaml
    ```

You should now have two control planes in {{site.konnect_short_name}} with
the same configuration.

## More information

* [decK CLI reference](/deck/latest/reference/deck/)
* [Import {{site.base_gateway}} configuration into {{site.konnect_short_name}}](/konnect/getting-started/import/)
