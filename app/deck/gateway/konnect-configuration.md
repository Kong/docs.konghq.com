---
title: Konnect Configuration
---

{:.important}
> {{site.konnect_short_name}} requires decK v1.40.0 or above. Versions below this will see inconsistent `deck gateway diff` results.

You can manage {{site.base_gateway}} core entity configuration in your {{site.konnect_short_name}} organization using decK.

decK can only target one control plane at a time.

Managing multiple control planes requires a separate state file per control plane.

decK _does not_ support publishing content to the Dev Portal or managing application registrations. Custom plugins can only be configured if the plugin schema has been uploaded to Konnect. Please note that creating or managing schemas via decK is not supported.

## Using decK with Konnect

To use decK with {{ site.konnect_short_name }}, you must provide a {{ site.konnect_short_name }} authentication method and the name of a control plane to target.

```bash
# This is missing an authentication method
# See below for token/OIDC authentication examples
deck gateway ping --konnect-addr https://us.api.konghq.com --konnect-control-plane-name default
```

`--konnect-addr` is optional. If any `--konnect` flag is set, the Admin API URL will default to `https://us.api.konghq.com`.

```bash
deck gateway ping --konnect-control-plane-name default
```

### Token authentication

If you are using personal access tokens or system access tokens, you can provide them using the `--konnect-token` flag:

```bash
deck gateway ping --konnect-token $KONNECT_TOKEN --konnect-addr https://us.api.konghq.com --konnect-control-plane-name default
```

You can provide the Konnect token in a file on disk rather than as an environment variable using the `--konnect-token-file` flag:

```bash
deck gateway ping --konnect-token-file /path/to/file --konnect-addr https://us.api.konghq.com --konnect-control-plane-name default
```

### Region selection

Use `--konnect-addr` to select the API to connect to.

The default API decK uses is `https://us.api.konghq.com`.

{{site.base_gateway}} supports AU, EU, IN, ME, and US [geographic regions](/konnect/geo/).

To target a specific geo, set `konnect-addr` to one of the following:
* AU geo: `"https://au.api.konghq.com"`
* EU geo: `"https://eu.api.konghq.com"`
* US geo: `"https://us.api.konghq.com"`
* IN geo: `"https://in.api.konghq.com"`
* ME geo: `"https://me.api.konghq.com"`

### Control planes

Each state file targets one control plane.
If you don't provide a control plane, decK targets the `default` control plane.

If you have a custom control plane, you can specify it in the state file,
or use a flag when running any decK command.

* Target a control plane in your state file with the `_konnect.control_plane_name` parameter:

    ```yaml
    _format_version: "3.0"
    _konnect:
      control_plane_name: staging
    ```

* Set a control plane using the `--konnect-control-plane-name` flag:

    ```sh
    deck gateway sync konnect.yaml --konnect-control-plane-name staging
    ```

### Making decK work with AWS PrivateLink

You can make Admin API calls for control plane configuration using decK with a private connection through AWS PrivateLink to stay compliant and save data transfer costs. Once you set up AWS PrivateLink [https://docs.konghq.com/konnect/private-connections/aws-privatelink/] for your environment, you can make decK calls by using the domain {{region.svc.konghq.com/api/}}


## Troubleshooting


### Authentication with a {{site.konnect_short_name}} token file is not working

If you have verified that your token is correct but decK can't connect to your account, check for conflicts with the decK config file (`$HOME/.deck.yaml`) and the {{site.konnect_short_name}} token file.
A decK config file is likely conflicting with the token file and passing another set of credentials.

To resolve, remove one of the duplicate sets of credentials.

### Workspace connection refused

When migrating from {{site.base_gateway}} to {{site.konnect_short_name}}, make sure to remove any `_workspace` tags. If you leave `_workspace` in, you get the following error:

```
Error: checking if workspace exists
```

Remove the `_workspace` key to resolve this error.

You can now sync the file as-is to apply it to the default control plane or add a key to apply the configuration to a specific control plane.

To apply the configuration to custom control planes, replace `_workspace` with `control_plane_name: ExampleName`.

For example, to export the configuration from workspace `staging` to control plane `staging`, you would change:

```yaml
_workspace: staging
```

To:

```yaml
_konnect:
  control_plane_name: staging
```

### decK targets {{site.base_gateway}} instead of {{site.konnect_short_name}}

decK can run against {{site.base_gateway}} or {{site.konnect_short_name}}.
By default, it targets {{site.base_gateway}}, unless a setting tells decK to point to {{site.konnect_short_name}} instead.

decK determines the environment using the following order of precedence:

1. If the declarative configuration file contains the `_konnect` entry, decK runs
against {{site.konnect_short_name}}.

2. If the `--kong-addr` flag is set to a non-default value, decK runs against {{site.base_gateway}}.

3. If {{site.konnect_short_name}} token is set in any way (flag, file, or decK config), decK runs against {{site.konnect_short_name}}.

4. If none of the above are present, decK runs against {{site.base_gateway}}.
