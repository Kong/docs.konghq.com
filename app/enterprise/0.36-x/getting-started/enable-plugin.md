---
title: Enable a Plugin
---

### Introduction

This guide walks through enabling a **Plugin** on **Kong Enterprise** via
**Kong Manager**, by showing an example configuration of the 
[**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced) Plugin, the
**Kong Enterprise** version of the popular **Kong Rate Limiting** Plugin. To
learn more about **Rate Limiting Advanced**, or see how to configure this 
Plugin via the command line, checkout the 
[**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced) documentation.


### Prerequisites

* [`enforce_rbac = on`](/enterprise/{{page.kong_version}}/property-reference/#enforce_rbac)
* Kong Enterprise has [started](/enterprise/{{page.kong_version}}/getting-started/start-kong)
* Logged in to Kong Manager as a **Super Admin** 
- _Optionally_ created a [**Service and Route**](/enterprise/{{page.kong_version}}/getting-started/add-service)

### How to Enable a Plugin in Kong Manager

1. Choose the desired **Workspace** in **Kong Manager** and navigate to the
**Plugins** tab under **API Gateway**.

    ![Plugins Tab](https://doc-assets.konghq.com/0.35/getting-started/add-a-plugin/01-plugin-tab.png)

2. Click the **Add New Plugin** button to open the **Plugins** page, which lists
all the **Kong Enterprise** bundled **Plugins** available.
<br/><br/>Scroll to the **Traffic Control** section and select **Rate Limiting Advanced**.

    ![Rate Limiting Advanced](https://doc-assets.konghq.com/0.35/getting-started/add-a-plugin/02-rate-limiting.png)
<br/><br/>This will open the **Plugin Configuration** form for **Rate Limiting Advanced**.

    ![Configuration Form](https://doc-assets.konghq.com/0.35/getting-started/add-a-plugin/03-plugin-form.png)
<br/>Note that the **Plugin** will automatically be enabled when the form is
submitted. Toggle the **This plugin is Enabled** button at the top of the form
to configure the **Plugin** without enabling it.

    ![Toggle Enable](https://doc-assets.konghq.com/0.35/getting-started/add-a-plugin/04-toggle-enable.png)

3. Define the **Plugin** as *global* or *scoped*.
<br/><br/>*Global* will apply the **Plugin** to *every* **Service** and
**Route** in the **Workspace**.
<br/>*Scoped* will apply the **Plugin** to one **Service**, **Route**, and/or
**Consumer**.
<br/><br/>To use this option, select the **Scoped** radio button and select the 
desired **Service**, **Route**, or **Consumer** from the dropdown.

    ![Connect test-service](https://doc-assets.konghq.com/0.35/getting-started/add-a-plugin/05-global-scoped.png)


4. Fill out the **configuration** form.<br/><br/>For **Rate Limiting Advanced** the
following fields are *required*:<br/>-`config.limit`<br/>-`config.sync_rate`<br/>
-`config.window_size`<br/>More information on these fields can be found in the
[**Rate Limiting Advanced** documentation](/hub/kong-inc/rate-limiting-advanced/#parameters)
<br/><br/>For this example set the required fields to the following:
      ```
      config.limit = 10
      config.sync_rate = 10
      config.window_size = 60
      ```

5. Click the **Create** button at the bottom of the form to save and
enable the **Plugin**. If it is successful, the page will automatically 
redirect to the **Plugin Overview**, with the **Rate Limiting Advanced** Plugin
listed.

    ![Plugin Overview](https://doc-assets.konghq.com/0.35/getting-started/add-a-plugin/06-plugin-overview.png)
<br/><br/>If the **Plugin** is *scoped* to a **Service**, **Route**, or
**Consumer**, the **Plugin** will also be listed on that object's **Overview**
page.

    ![Service Overview](https://doc-assets.konghq.com/0.35/getting-started/add-a-plugin/07-service-plugin-table.png)
