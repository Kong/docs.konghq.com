---
title: Prepare to Administer Kong Gateway
---

Before getting started with using {{site.base_gateway}}, verify that it was installed correctly, and that you’re ready to administer it.

## Before you begin

Before you start this section, make sure that:
* {{site.base_gateway}} is installed and running.
* Kong Manager (if applicable) and Kong Admin API ports are listening on the appropriate port/IP/DNS settings.
* If using declarative configuration to configure Kong, [decK](/deck/installation) is installed.

In this guide, an instance of {{site.base_gateway}} is referenced via `<admin-hostname>`. Make sure to replace `<admin-hostname>` with the hostname of your control plane instance.

## (Free Trials Only) Expose the Admin API {#free-trials-setup}

<div class="alert alert-ee">
  <img class="no-image-expand" src="/assets/images/icons/icn-enterprise-grey.svg"
  alt="Enterprise" />
  This section is only applicable to {{site.ee_product_name}} hosted free trials.
  Skip to <a href="#verify-the-kong-gateway-configuration">Verify the Kong Gateway Configuration</a>
  if you aren't a free trial user.
</div>

If you are trying out {{site.ee_product_name}} using a hosted free trial, you
can go through this guide to experience some of this enhanced functionality.
We recommend that you get started using the Kong Manager user interface.
However, if you want to test out configuring {{site.ee_product_name}}
programmatically, you need to enable access to the Admin API first.

### Hosted Free Trial Endpoints

In the Free Trials welcome email, you should have received a list of endpoints.
You will need to reference the following endpoints and substitute them in
instructions throughout this guide.

{% navtabs %}
{% navtab Kong Administration endpoint %}
Use this endpoint for configuring Kong Gateway using the Kong Admin API. The
endpoint looks something like this:

`https://admin-kong1a2b3c.kong-cloud.com`

In this guide, substitute this endpoint any time you're asked to access the
admin host with **port 8001**. For example, given the following request
and placeholders:

```sh
$ curl -i -X GET http://<admin-hostname>:8001/services/
```

Replace `http://<admin-hostname>:8001` with your administration endpoint:

```sh
$ curl -i -X GET https://admin-kong1a2b3c.kong-cloud.com/services/
```
{% endnavtab %}
{% navtab Kong Proxy endpoint %}

Use this URL to access your Services. The URL looks something like this:

`http://kong1a2b3c.kong-cloud.com`

In this guide, substitute this URL any time you're asked to access the admin
host with **port 8000**. For example, given the following request and
placeholders:

```sh
$ curl -i -X GET http://<admin-hostname>:8000/mock/request
```

Replace `http://<admin-hostname>:8000` with your proxy URL:

```sh
$ curl -i -X GET http://kong1a2b3c.kong-cloud.com/mock/request
```

{% endnavtab %}
{% endnavtabs %}

### Create a User with an RBAC Token

1. Open the Kong Manager using the link provided in your free trial welcome
email.
2. Open **Teams** > **RBAC Users**, then click **Add New User**.
3. Set up an RBAC user with an appropriate role (e.g. admin) and an RBAC token.
Make sure to leave the **Enabled** box checked.
4. Test by building a request to the Admin API:

    *Using cURL:*
    ```sh
    $ curl <admin-endpoint-from-email>/services \
      -H “Kong-Admin-Token:<your-RBAC-token>”
    ```

    *Or using HTTPie:*
    ```sh
    $ http <admin-endpoint-from-email>/services \
      Kong-Admin-Token:<your-RBAC-token>
    ```

    You should get a `200` response code and your list of services will be empty.

You can now use the Admin API instructions in this guide.

Remember to switch any mentions of `http://<admin-hostname>:8001` or
`<admin-hostname>:8001` with your Admin API endpoint (no port number required).


## Verify the Kong Gateway configuration
{% navtabs %}
{% navtab Using the Admin API %}
Ensure that you can send requests to the Kong Admin API using either cURL or HTTPie.

View the current configuration by issuing the following command in a terminal window:

*Using cURL:*
```bash
$ curl -i -X GET http://<admin-hostname>:8001
```

*or using HTTPie:*
```bash
$ http <admin-hostname>:8001
```
The current configuration returns.
{% endnavtab %}

{% navtab Using Kong Manager %}
As a {{site.ee_product_name}} user, you can use Kong Manager for environment administration. You’re going to use it later on in this guide, so first make sure you can access Kong Manager.

Open a web browser and navigate to `http://<admin-hostname>:8002`.

If {{site.ee_product_name}} was installed correctly, it automatically logs you in and presents the Kong Manager Overview page.
{% endnavtab %}

{% navtab Using decK (YAML) %}

1. Check that decK is connected to Kong:

    ``` bash
    $ deck ping
    ```

    You should see a success message with the version of Kong that you're
    connected to:
    ```
    Successfully connected to Kong!
    Kong version:  2.1.0
    ```

2. Ensure that you can pull configuration from Kong by issuing the following
command in a terminal window:

    ``` bash
    $ deck dump
    ```

    This command creates a `kong.yaml` file with Kong's entire current
    configuration, in the directory where decK is installed.

    You can also use this command at any time (for example, after a `deck sync`)
    to see the {{site.base_gateway}}'s most recent configuration.

    <div class="alert alert-warning">
    <i class="fas fa-exclamation-triangle" style="color:orange; margin-right:3px"></i>
    <strong>Be careful!</strong> Any subsequent <code>deck dump</code> will
    overwrite the existing <code>kong.yaml</code> file. Create backups as needed.
    </div>

3. Open the file in your preferred code editor. Since you haven't configured
anything yet, the file should only contain the decK version:

    ``` yaml
    _format_version: "1.1"
    ```

    You will use this file to configure Kong.

{% endnavtab %}
{% endnavtabs %}

## (Optional) Verify Control Plane and Data Plane connection

If you're running Kong in Hybrid mode, you will need to perform all tasks in this
guide from the Control Plane. However, you can check that all of your
configurations are being pushed from the Control Plane to your Data Planes using
the Cluster Status CLI.

Run the following on a Control Plane:
{% navtabs %}
{% navtab Using cURL %}
```sh
$ curl -i -X GET http://<admin-hostname>:8001/clustering/status
```
{% endnavtab %}
{% navtab Using HTTPie %}
```bash
$ http :8001/clustering/status
```
{% endnavtab %}
{% endnavtabs %}
The output shows all of the connected Data Plane instances:

```sh
{
    "a08f5bf2-43b8-4f1c-bdf5-0a0ffb421c21": {
        "config_hash": "64d661f505f7e1de5b4c5e5faa1797dd",
        "hostname": "data-plane-2",
        "ip": "192.168.10.3",
        "last_seen": 1571197860
    },
    "e1fd4970-6d24-4dfb-b2a7-5a832a5de6e1": {
        "config_hash": "64d661f505f7e1de5b4c5e5faa1797dd",
        "hostname": "data-plane-1",
        "ip": "192.168.10.4",
        "last_seen": 1571197866
    }
}
```

## Summary and next steps

In this section, you learned about the methods of administering {{site.base_gateway}} and how to access its configuration. Next, go on to learn about [exposing your services with {{site.base_gateway}}](/getting-started-guide/{{page.kong_version}}/expose-services).
