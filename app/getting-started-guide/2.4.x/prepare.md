---
title: Prepare to Administer Kong Gateway
---

Before getting started with using {{site.base_gateway}}, verify that it was
installed correctly, and that you’re ready to administer it.

## Before you begin

Before you start this section, make sure that:
* {{site.base_gateway}} is installed and running.
* Kong Manager (if applicable) and Kong Admin API ports are listening on the
appropriate port/IP/DNS settings.
* If using declarative configuration to configure {{site.base_gateway}},
[decK](/deck/latest/installation) is installed.

In this guide, an instance of {{site.base_gateway}} is referenced via
`<admin-hostname>`. Make sure to replace `<admin-hostname>` with the hostname
of your control plane instance.

## Verify the Kong Gateway configuration
{% navtabs %}
{% navtab Using Kong Manager %}
As a {{site.ee_product_name}} user, you can use Kong Manager for environment
administration. You’re going to use it later on in this guide, so first make s
ure you can access Kong Manager.

Open a web browser and navigate to `http://<admin-hostname>:8002`.

If {{site.ee_product_name}} was installed correctly, it automatically logs you
in and presents the Kong Manager Overview page.
{% endnavtab %}
{% navtab Using the Admin API %}
Ensure that you can send requests to the gateway's Admin API using either cURL
or HTTPie.

View the current configuration by issuing the following command in a terminal
window:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```bash
$ curl -i -X GET http://<admin-hostname>:8001
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
$ http <admin-hostname>:8001
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

The current configuration returns.
{% endnavtab %}

{% navtab Using decK (YAML) %}

1. Check that decK is connected to {{site.base_gateway}}:

    ``` bash
    $ deck ping
    ```

    You should see a success message with the version that you're
    connected to:
    ```
    Successfully connected to Kong!
    Kong version:  2.1.0
    ```

2. Ensure that you can pull configuration from {{site.base_gateway}} by issuing
the following command in a terminal window:

    ``` bash
    $ deck dump
    ```

    This command creates a `kong.yaml` file with the gateway's entire current
    configuration, in the directory where decK is installed.

    You can also use this command at any time (for example, after a `deck sync`)
    to see the {{site.base_gateway}}'s most recent configuration.

    <div class="alert alert-warning">

    <strong>Be careful!</strong> Any subsequent <code>deck dump</code> will
    overwrite the existing <code>kong.yaml</code> file. Create backups as needed.
    </div>

3. Open the file in your preferred code editor. Since you haven't configured
anything yet, the file should only contain the decK version:

    ``` yaml
    _format_version: "1.1"
    ```

    You will use this file to configure {{site.base_gateway}}.

{% endnavtab %}
{% endnavtabs %}

## (Optional) Verify Control Plane and Data Plane connection

If you're running {{site.base_gateway}} in Hybrid mode, you will need to
perform all tasks in this guide from the Control Plane. However, you can check
that all of your configurations are being pushed from the Control Plane to your
Data Planes using the Cluster Status CLI.

Run the following on a Control Plane:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```bash
$ curl -i -X GET http://<admin-hostname>:8001/clustering/data-planes
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
$ http :8001/clustering/data-planes
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->
The output shows all of the connected Data Plane instances in the cluster:

```json
{
    "data": [
        {
            "config_hash": "a9a166c59873245db8f1a747ba9a80a7",
            "hostname": "data-plane-2",
            "id": "ed58ac85-dba6-4946-999d-e8b5071607d4",
            "ip": "192.168.10.3",
            "last_seen": 1580623199,
            "status": "connected"
        },
        {
            "config_hash": "a9a166c59873245db8f1a747ba9a80a7",
            "hostname": "data-plane-1",
            "id": "ed58ac85-dba6-4946-999d-e8b5071607d4",
            "ip": "192.168.10.4",
            "last_seen": 1580623200,
            "status": "connected"
        }
    ],
    "next": null
}
```

## Summary and next steps

In this section, you learned about the methods of administering
{{site.base_gateway}} and how to access its configuration. Next, go on to
learn about [exposing your services with {{site.base_gateway}}](/getting-started-guide/{{page.kong_version}}/expose-services).
