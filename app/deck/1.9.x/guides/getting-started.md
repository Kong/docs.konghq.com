---
title: Get Started with decK
---

Once you have [installed](/deck/{{page.kong_version}}/installation) decK, use this guide to get started with it.

You can find help in the terminal for any command using the `--help`
flag, or see the [CLI reference](/deck/{{page.kong_version}}/reference/deck).

## Install Kong Gateway

Make sure you have [{{site.base_gateway}} installed](/install) and have access to Kong's [Admin API](/gateway/latest/admin-api).

This guide assumes that {{site.base_gateway}} is running at `http://localhost:8001`.
If your URL is different, change the URL to the network address where the gateway is running.

## Configure Kong Gateway

First, make a few calls to configure {{site.base_gateway}}.

If you already have {{site.base_gateway}} set up with the configuration of your choice, you can skip to [exporting the configuration](#export-the-configuration).

1. Create a service:

    ```shell
    curl -s -X POST http://localhost:8001/services -d 'name=foo' -d 'url=http://example.com' | jq
    {
      "host": "example.com",
      "created_at": 1573161698,
      "connect_timeout": 60000,
      "id": "9e36a21e-3e92-44e3-8810-4fb8d80d3518",
      "protocol": "http",
      "name": "foo",
      "read_timeout": 60000,
      "port": 80,
      "path": null,
      "updated_at": 1573161698,
      "retries": 5,
      "write_timeout": 60000,
      "tags": null,
      "client_certificate": null
    }
    ```

2. Create a route associated with the service:

    ```sh
    curl -s -X POST http://localhost:8001/services/foo/routes -d 'name=bar' -d 'paths[]=/bar' | jq
    {
      "id": "83c2798d-6bd8-4182-a799-2632c9f670a5",
      "tags": null,
      "updated_at": 1573161777,
      "destinations": null,
      "headers": null,
      "protocols": [
        "http",
        "https"
      ],
      "created_at": 1573161777,
      "snis": null,
      "service": {
        "id": "9e36a21e-3e92-44e3-8810-4fb8d80d3518"
      },
      "name": "bar",
      "preserve_host": false,
      "regex_priority": 0,
      "strip_path": true,
      "sources": null,
      "paths": [
        "/bar"
      ],
      "https_redirect_status_code": 426,
      "hosts": null,
      "methods": null
    }
    ```

3. Create a global plugin:

    ```sh
    curl -s -X POST http://localhost:8001/plugins -d 'name=prometheus' | jq
    {
        "config": {},
        "consumer": null,
        "created_at": 1573161872,
        "enabled": true,
        "id": "fba8015e-97d0-45ef-9f27-0ad76fef68c8",
        "name": "prometheus",
        "protocols": [
            "grpc",
            "grpcs",
            "http",
            "https"
        ],
        "route": null,
        "run_on": "first",
        "service": null,
        "tags": null
    }
    ```

## Export the configuration

1. Check that decK recognizes your {{site.base_gateway}} installation:

    ```sh
    deck ping
    ```

    If the connection is successful, the terminal displays your gateway version:

    ```sh
    Successfully connected to Kong!
    Kong version:  2.5.1
    ```

2. Export {{site.base_gateway}}'s configuration:

    ```shell
    deck dump
    ```

3. Open the generated `kong.yaml` file. If you're using the sample
configuration in this guide, the file should look like this:

    ```yaml
    _format_version: "1.1"
    services:
    - connect_timeout: 60000
      host: example.com
      name: foo
      port: 80
      protocol: http
      read_timeout: 60000
      retries: 5
      write_timeout: 60000
      routes:
      - name: bar
        paths:
        - /bar
        preserve_host: false
        protocols:
        - http
        - https
        regex_priority: 0
        strip_path: true
        https_redirect_status_code: 426
    plugins:
    - name: prometheus
      enabled: true
      run_on: first
      protocols:
      - grpc
      - grpcs
      - http
      - https
    ```

You've successfully backed up the configuration of your {{site.base_gateway}} installation.

## Change the configuration

Edit the `kong.yaml` file, making the following changes:
- Change the `port` of service `foo` to `443`
- Change the `protocol` of service `foo` to `https`
- Add another string element `/baz` to the `paths` attribute of route `bar`.

Your `kong.yaml` file should now look like this:

```yaml
_format_version: "1.1"
services:
- connect_timeout: 60000
  host: example.com
  name: foo
  port: 443
  protocol: https
  read_timeout: 60000
  retries: 5
  write_timeout: 60000
  routes:
  - name: bar
    paths:
    - /bar
    - /baz
    preserve_host: false
    protocols:
    - http
    - https
    regex_priority: 0
    strip_path: true
    https_redirect_status_code: 426
plugins:
- name: prometheus
  enabled: true
  run_on: first
  protocols:
  - grpc
  - grpcs
  - http
  - https
```

## diff and sync the configuration to Kong Gateway

1. Run the diff command:

    ```shell
    deck diff
    ```
    You should see decK reporting that the properties you had changed
    in the file are going to be changed by decK in {{site.base_gateway}}'s database.

2. Apply the changes:

    ```sh
    deck sync
    ```

3. Curl Kong's Admin API to see the updated route and service in {{site.base_gateway}}:

    ```sh
    curl -i -X GET http://localhost:8001/services
    ```

4. Run the diff command again, which should report no changes:

    ```sh
    deck diff
    ```

## Drift detection using decK

1. Create a consumer in {{site.base_gateway}}:

    ```shell
    curl -s -X POST http://localhost:8001/consumers -d 'username=example-consumer' | jq
    ```

    Response:
    ```json
    {
      "custom_id": null,
      "created_at": 1573162649,
      "id": "ed32faa1-9105-488e-8722-242e9d266717",
      "tags": null,
      "username": "example-consumer"
    }
    ```

    This command creates a consumer in {{site.base_gateway}}, but the consumer doesn't exist in the `kong.yaml` file saved on disk.

2. Check what decK reports on a diff now:

    ```shell
    deck diff
    ```

    Response:
    ```sh
    deleting consumer example-consumer
    ```

    Since the file does not contain the consumer definition, decK reports that
    a `sync` run will delete the consumer from {{site.base_gateway}}'s database.

3. Run the sync process:

    ```shell
    deck sync
    ```

4. Now, looking up the consumer in {{site.base_gateway}}'s database returns a
`404`:

    ```shell
    curl -i -X GET http://localhost:8001/consumers/example-consumer
    ```

    Response:
    ```sh
    HTTP/1.1 404 Not Found
    Date: Mon, 04 Oct 2021 17:00:50 GMT
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    Access-Control-Allow-Origin: *
    Content-Length: 23
    X-Kong-Admin-Latency: 2
    Server: kong/2.5.1

    {"message":"Not found"}
    ```

This shows how decK can detect changes done directly using Kong's Admin API
can be detected by decK. You can configure your CI or run a `cronjob` in which
decK detects if any changes exist in {{site.base_gateway}} that are not part of your configuration file, and alert your teams if such a discrepancy is present.

## Reset your configuration

You can reset the configuration of {{site.kong_gateway}} using decK.

{:.warning}
> **Warning**: The changes performed by this command are irreversible (unless you've created
a backup using `deck dump`), so be careful.

```sh
deck reset
```

Response:
```
This will delete all configuration from Kong's database.
> Are you sure? y
```

## Next steps
See decK [best practices](/deck/{{page.kong_version}}/guides/best-practices), and check out the individual guides for getting :
* [Backup and restore of Kong Gateway's configuration](/deck/{{page.kong_version}}/guides/backup-restore)
* Deduplicate plugin configuration
