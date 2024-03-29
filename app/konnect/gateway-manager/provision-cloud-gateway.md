---
title: Provision a Dedicated Cloud Gateway
---

This guide explains how to provision a [Dedicated Cloud Gateway](/konnect/?) in {{site.konnect_short_name}}.

## Prerequisites

## Provision

{% navtabs %}
{% navtab UI %}
1. From Gateway Manager in the navigation menu, click the **New Control Plane** menu and select **Kong Gateway**.

1. In the **Create a Control Plane** dialog, enter a name for your cloud gateway and click **Dedicated Cloud Instances**.

1. Configure any labels as needed, and click **Next Step**. 
    You will be redirected the provisioning dialog for your newly created Dedicated Cloud Gateway. The cloud gateway is only created, it still needs to be provisioned and a data plane node needs to be added.

1. To add a data plane node to your Dedicated Cloud Gateway, do the following in the **Create a Data Plane Node** dialog:

    1. From the **Gateway Version** menu, select the {{site.base_gateway}} version you want to use. 
        {{site.base_gateway}} versions 3.4.x and later are supported.

    1. Select one of the following modes to configure your data plane node:
        * **Autopilot**: This mode allows Kong to automatically scale your instances based on incoming traffic. You can pre-warm your cluster by specifying the number of requests per second. 
        * **Custom**: This mode allows you to select from three different instance sizes: small, medium, or large.

    1. To configure your cluster, select your provider, region, network, and specify the number of nodes. Repeat this step for as many regions as you need. <!-- why would you want multiple regions? Would you ever want two or more of the same region? Why?-->

    1. Configure you API access to either public or private, and then click **Create Cluster**. 

Your cloud gateway is now provisioned. You can use it like you would any other {{site.base_gateway}} in {{site.konnect_short_name}}.
{% endnavtab %}
{% navtab API %}
1. ? 
{% endnavtab %}
{% endnavtabs %}

## Upgrade

{% navtabs %}
{% navtab UI %}
1. I have no idea where this is in the UI, unless you just go to update config in Actions and then just select the new version from the config dialog.
{% endnavtab %}
{% navtab API %}
1. ? 
{% endnavtab %}
{% endnavtabs %}

## Delete

{% navtabs %}
{% navtab UI %}
1. ?
{% endnavtab %}
{% navtab API %}
1. ? 
{% endnavtab %}
{% endnavtabs %}

## Scale 

{% navtabs %}
{% navtab UI %}
1. Also not sure where this in the UI.
{% endnavtab %}
{% navtab API %}
1. ? 
{% endnavtab %}
{% endnavtabs %}

## Troubleshooting

### Issue name here

## More information

* link to CGW overview