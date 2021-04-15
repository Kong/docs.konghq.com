---
title: Add a Service and Route
redirect_from:
  - /enterprise/1.5.x/getting-started/add-service
  - /enterprise/latest/getting-started/add-service
---

### Introduction

This topic walks through the creation and configuration of a
**Service and Route** using **Kong Manager** in **Kong Enterprise**. To do this
using the **command line**, read Kong Community Gateway's guide to
[Configuring a Service](/gateway-oss/latest/getting-started/configuring-a-service/).

For the purpose of this guide, we’ll create a **Service** pointing to the Mockbin
API. Mockbin is an “echo” type public website that returns requests back to
the requester as responses. This visibility is helpful for learning how Kong proxies API
requests.

Kong exposes the RESTful **Admin API** on port `:8001`. Kong’s configuration,
including adding **Services and Routes**, is made via requests on to the
**Admin API**.

### Prerequisites

- **Kong Enterprise** is [installed](/enterprise/{{page.kong_version}}/deployment/installation)
- **Kong Enterprise** is [started](/enterprise/{{page.kong_version}}/start-kong-securely)
- **Super Admin** or [**Admin**](/enterprise/{{page.kong_version}}/kong-manager/administration/admins/add-admin)
access to **Kong Manager**

### Step 1 - Create a New Service

1. Choose the desired **Workspace** in **Kong Manager** and navigate to the
**Services** tab under **API Gateway**.

    ![Service Page](https://doc-assets.konghq.com/0.35/getting-started/add-a-service/01-service-page.png)

2. Click the **New Service** button to open the **Create Service** dialog.
Fill in a **Name** and a **URL** for the **Service**.<br/><br/>For example, set the
name to `test-service` with the URL `http://mockbin.org`.

    ![Create Service Form](https://doc-assets.konghq.com/0.35/getting-started/add-a-service/02-service-name.png)
<br/><br/>Kong Manager also allows **Services** to be configured using **Protocol**,
**Host**, **Path**, and **Port** (optional). To configure the **Service** using
this method, click the **Add using Protocol, Host, and Path** option.

    ![Configure Using Protocol](https://doc-assets.konghq.com/0.35/getting-started/add-a-service/03-service-protocol.png)  
<br/>In addition, Kong Manager exposes several **Advanced Fields**
and their default configuration values: <br/>`Retries: 5`<br/>
`Connect Timeout: 60000` (in ms)<br/>`Write Timeout: 60000` (in ms)<br/>
`Read Timeout: 60000` (in ms)<br/><br/>Adjusting these values is optional and can be
edited later.

    ![Advanced Fields](https://doc-assets.konghq.com/0.35/getting-started/add-a-service/04-service-advanced-fields.png)


3. Create the **Service** by clicking the **Create** button.<br/><br/>If successful, you are automatically redirected to the
**Service's Overview** page.<br/><br/>The **Service Overview** page displays
information and **Activity** on the **Service**, as well as any **Routes** or
**Plugins** that have been connected to the **Service**.

    ![Service Overview](https://doc-assets.konghq.com/0.35/getting-started/add-a-service/05-service-overview.png)


### Step 2 - Create a New Route attached to the Service

1. From the **Service Overview** page accessed in
[Step 1](#step-1---create-a-new-service), click the **Create New Route** button
located in the **Routes** tab at the bottom of the page.

    ![Create Route Service ID](https://doc-assets.konghq.com/0.35/getting-started/add-a-service/06-service-route-object.png)

2. To create a **Route** you must provide the **Service** `name` and `id`, this
will be automatically filled out if the form was accessed via the
**Service Overview** page.

    ![Step 7](https://doc-assets.konghq.com/0.35/getting-started/add-a-service/07-route-service-id.png)
<br/><br/>If this field is not automatically filled, the **Service Id** can be
found via the **Services Overview** page, accessed by clicking on the **Services**
tab on the side navigation and then clicking the **clipboard** icon next to the
desired **Service's Id** field.

3. The **Route** will also need a name, and at least one of the following fields:
**Host**, **Methods**, or **Paths**<br/>To continue with the Mockbin example,
name the **Route** `test-route` with the **Host** `example.com`. Once completed,
click **Create Route**.

    ![Create Route Form](https://doc-assets.konghq.com/0.35/getting-started/add-a-service/08-route-form-example.png)

4. If created successfully, the page will be automatically redirected back to
the **Service Overview** page, and the new **Route** will now appear under the
**Routes** tab.

    ![Completed Route](https://doc-assets.konghq.com/0.35/getting-started/add-a-service/10-completed-route.png)

### Step 3 - Test the new Service and Route

Issue the following cURL request to verify that Kong is properly forwarding
requests to the Service. Note that by default Kong handles proxy requests on
port `:8000`:

```
  $ curl -i -X GET \
  --url http://localhost:8000/ \
  --header 'Host: example.com'
```

A successful response means Kong is now forwarding requests made to
http://localhost:8000 to the **Service URL** configured in
[Step 1](#step-1---create-a-new-service), and is forwarding the response back.
Kong knows to do this through the header defined in the above cURL request.
