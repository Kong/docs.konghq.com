---
title: Prepare to Administer Kong Gateway
---

Before getting started with using {{site.base_gateway}}, verify that it was installed correctly, and that you’re ready to administer it.

## Before you begin

Before you start this section, make sure that:
* {{site.base_gateway}} is installed and running.
* Kong Manager (if applicable) and Kong Admin API ports are listening on the appropriate port/IP/DNS settings.

In this guide, an instance of {{site.base_gateway}} is referenced via `<admin-hostname>`. Make sure to replace `<admin-hostname>` with the hostname of your control plane instance.

<div class="alert alert-ee">
<h5><img class="no-image-expand" src="/assets/images/icons/icn-enterprise-grey.svg" alt="Enterprise" />Note for {{site.ee_product_name}} free trial users</h5>
If you are trying out {{site.ee_product_name}} using a hosted free trial, you can go through this guide to experience some of this enhanced functionality. However, you need to enable access to the Admin API first.
  <ol>
    <li>Open the Kong Manager using the link provided in your free trial welcome email.</li>
    <li>Open <strong>Teams</strong> > <strong>RBAC Users</strong>, then click <strong>Add New User</strong>.</li>
    <li>Set up an RBAC user with an appropriate role (e.g. admin) and an RBAC token. Make sure to leave the <strong>Enabled</strong> box checked.</li>
    <li>Test by building a request to the Admin API.
<p></p>
<span style="font-size:14px"><em>Using cURL:</em></span>
<pre class="highlight">
<code>$ curl -H “Kong-Admin-Token:&lt;your-RBAC-token&gt;” \
&lt;admin-endpoint-from-email&gt;/services</code></pre>
<span style="font-size:14px"><em>Or using HTTPie:</em></span>
<pre class="highlight">
<code>$ http &lt;admin-endpoint-from-email&gt;/services \
Kong-Admin-Token:&lt;your-RBAC-token&gt; </code></pre>
You should get a 200 response code and your list of services will be empty.
<br/>
<br/>You can now use the Admin API instructions in this guide. Remember to switch any mentions of <code>http://&lt;admin-hostname&gt;:8001</code> or <code>&lt;admin-hostname&gt;:8001</code> with your Admin API endpoint (no port number required).
</li>
</ol>
</div>

## Verify the Kong Gateway configuration
{% navtabs %}
{% navtab Using the Admin API %}
Ensure that you can send requests to the Kong Admin API using either cURL or HTTPie.

View the current configuration by issuing the following command in a terminal window:

*Using cURL:*
```
$ curl -i -X GET http://<admin-hostname>:8001
```

*or using HTTPie:*
```
$ http <admin-hostname>:8001
```
The current configuration returns.
{% endnavtab %}

{% navtab Using Kong Manager %}
As a {{site.ee_product_name}} user, you can use Kong Manager for environment administration. You’re going to use it later on in this guide, so first make sure you can access Kong Manager.

Open a web browser and navigate to `http://<admin-hostname>:8002`.

If {{site.ee_product_name}} was installed correctly, it automatically logs you in and presents the Kong Manager Overview page.
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
```
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

```bash
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

In this section, you learned about the two methods of administering {{site.base_gateway}} and how to access its configuration. Next, go on to learn about [exposing your services with {{site.base_gateway}}](/getting-started-guide/{{page.kong_version}}/expose-services).
