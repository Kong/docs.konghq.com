---
title: Self-Host your Dev Portal with Netlify
content_type: how-to
badge: oss
---

You can use the self-hosted, open source Dev Portal to display your APIs to developers on a self-hosted website. This guide shows you how to configure an example open source Dev Portal, which you can further customize by adjusting the code of the sample app and self-hosting it on a frontend application of your choice.

<!--Some explanation of what features are configured in the example app. -->

## Prerequisites

* [A {{site.konnect_saas}} account](/konnect/getting-started/access-account/)
* [Yarn 1.22.x installed](https://classic.yarnpkg.com/lang/en/docs/install/#mac-stable)
* A [Netlify account](https://www.netlify.com/)

## Configure your self-hosted domains in {{site.konnect_short_name}}

1. In {{site.konnect_short_name}}, click {% konnect_icon dev-portal %} **Dev Portal** > [**Settings**](https://cloud.konghq.com/portal/portal-settings) in the sidebar.
1. Click the **Portal Domain** tab.
1. Enter a name for your custom portal domain API in the **Custom Hosted Domain** field. For example, `api.mycompany.com`. 
1. Enter a name for your custom portal client domain in the **Customm Self-Hosted UI Domain** field. For example, `client.mycompany.com`. <!-- what's the difference between the client and API domain?-->
1. After you configure these domains in {{site.konnect_short_name}}, add a CNAME record to your domain's DNS records that points the custom API domain to the default portal domain. For example:
    ```sh
    api.mycompany.com   CNAME   3600    client.mycompany.com
    ```

<!-- what is the result here? the self-hosted portal isn't working, we just turned it on and disabled the Konnect hosted one, right?-->

## Deploy your self-hosted Dev Portal with Netlify

In this example, you will deploy the self-hosted example Dev Portal using Netlify. You can use any static site generator of your choice to host your Dev Portal.

1. In GitHub, [fork a copy](https://docs.github.com/get-started/quickstart/fork-a-repo) of the [open source Dev Portal application example](https://github.com/Kong/konnect-portal).
1. In the forked repository, [create a new branch](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-and-deleting-branches-within-your-repository#creating-a-branch) that you will use to deploy your Dev Portal. For example, `prod`. 
    Upstream changes from `kong/konnect-portal` are merged into `main` and then finally merged into `prod` to trigger a deploy.
1. On the `prod` branch, create a new `netlify.toml` file:
    ```sh
    [[redirects]]
      from = "/*"
      to = "/index.html"
      status = 200
      force = false
    ```
    This is necessary for a single page application. <!-- What does this mean?-->

1. Push changes to the `prod` branch.
1. In Netlify on the Team overview dashboard, click **Add new site** and then select **Import an existing project**. 
1. Click **GitHub** for your Git provider.
1. Grant Netlify access to GitHub and then click **Configure Netlify on Github**.
1. Install Netlify on your GitHub account with the example Dev Portal repository.
1. In Netlify, select the Dev Portal repository you just forked.
1. Select "prod" from the **Branch to deploy** drop-down menu.
1. Click **Show advanced**. 
1. In the Environment variables section, click **New variable**.
1. Enter `VITE_PORTAL_API_URL` in the **Key** field and your custom portal domain API (`api.mycompany.com`) in the **Value** field.
1. Click **Deploy site**. 
1. Click **Domain settings** and **Add a domain**.
1. Enter your custom portal client domain (`client.mycompany.com`) in the **Custom domain or subdomain** field. 
1. Click **Verify**.
1. Click **Domains** in the sidebar and then click the domain you just added.
1. In the Name servers pane, note the listed name servers. Then, [configure the name servers in your domain registrar](https://docs.netlify.com/domains-https/netlify-dns/delegate-to-netlify/).

Once your name servers are propogated (this may take a few minutes), your Dev Portal will now be deployed by Netlify.

## Customize the example open source Dev Portal 

If you want to further customize the example self-hosted Dev Portal, you can... 

## More information

[About Self-Hosted Dev Portal](/konnect/dev-portal/customization/self-hosted-portal/) - Learn more about how the self-hosted Dev Portal works and why you should use it.