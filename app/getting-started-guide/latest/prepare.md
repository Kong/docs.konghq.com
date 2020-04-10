---
title: Prepare to Administer Kong Gateway
---

Before getting started with using Kong Gateway, verify that it was installed correctly, and that you’re ready to administer it.

## Before you begin

Before you start this section, make sure that:
* Kong Gateway is installed and running.
* Kong Manager (if applicable) and Kong Admin API ports are listening on the appropriate port/IP/DNS settings.

In this guide, an instance of Kong Gateway is referenced via `<admin-hostname>`. Make sure to replace `<admin-hostname>` with the hostname of your control plane instance.

<div class="alert alert-ee">
<h5><img src="/assets/images/icons/icn-enterprise-grey.svg" alt="Enterprise" />Note for Kong Enterprise free trial users</h5>
If you are trying out Kong Enterprise using a hosted free trial, you can go through this guide to experience some of this enhanced functionality. However, you need to enable access to the Admin API first.
  <ol>
    <li>Open the Kong Manager using the link provided in your free trial welcome email.</li>
    <li>Open <strong>Teams</strong> > <strong>RBAC Users</strong>, then click <strong>Add New User</strong>.</li>
    <li>Set up an RBAC user with an appropriate role (e.g. admin) and an RBAC token. Make sure to leave the <strong>Enabled</strong> box checked.</li>
    <li>Test by building a request to the Admin API.
<p></p>
<span style="font-size:14px"><em>Using cURL:</em></span>
<pre class="highlight">
<code>$ curl -H “Kong-Admin-Token:&lt;your-RBAC-token&gt;” \
&lt;admin-endpoint-from-email&gt;/services </code></pre>
<span style="font-size:14px"><em>Or using HTTPie:</em></span>
<pre class="highlight">
<code>$ http https://&lt;admin-endpoint-from-email>/services \
Kong-Admin-Token:&lt;your-RBAC-token&gt; </code></pre>
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
As a Kong Enterprise user, you can use Kong Manager for environment administration. You’re going to use it later on in this guide, so first make sure you can access Kong Manager.

Open a web browser and navigate to `http://<admin-hostname>:8002`.

If Kong Enterprise was installed correctly, it automatically logs you in and presents the Kong Manager Overview page.
{% endnavtab %}
{% endnavtabs %}


## Summary and next steps

In this section, you learned about the two methods of administering Kong Gateway and how to access its configuration. Next, go on to learn about [exposing your services with Kong Gateway](/getting-started-guide/{{page.kong_version}}/expose-services).
