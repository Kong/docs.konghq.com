---
title: Host your Dev Portal with Netlify
content_type: how-to
---

You can use the self-hosted, open source Dev Portal to offer a fully-customizable user experience for your developers.

This guide shows you how to configure an example open-source Dev Portal with Netlify. Using this example as a starting point, you can adjust the code of the sample app and self-host it on a frontend application of your choice.

The example application is pre-configured with the following:
* All [features in the {{site.konnect_short_name}}-hosted Dev Portal](/konnect/dev-portal/customization/)
* Localization is set to English by default. You can configure it using [`src/locales`](https://github.com/Kong/konnect-portal/tree/main/src/locales).
* [UI test automation through Cypress](https://github.com/Kong/konnect-portal/tree/main/cypress)

## Prerequisites

* [A {{site.konnect_saas}} account](/konnect/getting-started/access-account/)
* [Yarn 1.22.x installed](https://classic.yarnpkg.com/lang/en/docs/install/#mac-stable)
* [A Netlify account](https://www.netlify.com/)

## Configure your self-hosted domains in {{site.konnect_short_name}}

1. In {{site.konnect_short_name}}, click {% konnect_icon dev-portal %} **Dev Portal** > [**Settings**](https://cloud.konghq.com/portal/portal-settings) in the sidebar.
1. Click the **Portal Domain** tab.
1. Enter a name for your custom portal domain API in the **Custom Hosted Domain** field. For example, `api.mycompany.com`. 
1. Enter a name for your custom portal client domain in the **Custom Self-Hosted UI Domain** field. For example, `client.mycompany.com`.
1. Add a CNAME record to your domain's DNS records that points the custom API domain to the default portal domain. For example:
    ```sh
    api.mycompany.com   CNAME   3600    portal29asdfj278.us.portal.konghq.com
    ```

Now the self-hosted Dev Portal is enabled and the {{site.konnect_short_name}}-hosted Dev Portal is disabled. The custom portal domain API you specified will be used as the API domain of your portal and the custom portal client domain will be used to access the UI of your self-hosted portal.

## Deploy your self-hosted Dev Portal with Netlify

You will deploy the self-hosted example Dev Portal using Netlify in this example, but you can use any hosting provider to host the Dev Portal.

### Fork and configure the GitHub repository

1. In GitHub, [fork](https://docs.github.com/get-started/quickstart/fork-a-repo) the [open source Dev Portal application example](https://github.com/Kong/konnect-portal).
1. In the forked repository, [create a new branch](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-and-deleting-branches-within-your-repository#creating-a-branch) that you will use to deploy your Dev Portal. For example, `prod`. 
    Upstream changes from `kong/konnect-portal` are merged into `main` and then finally merged into `prod` to trigger a deploy.
1. On the `prod` branch, create a new `netlify.toml` file:
    ```toml
    [[redirects]]
      from = "/*"
      to = "/index.html"
      status = 200
      force = false
    ```
    This is necessary for a single page application.
1. Push changes to the `prod` branch.
1. In Netlify, on the Team Overview dashboard, click **Add new site**, then select **Import an existing project**. 
1. Click **GitHub** for your Git provider.
1. Grant Netlify access to GitHub, then click **Configure Netlify on Github**. When prompted, install Netlify on your GitHub account with the example Dev Portal repository.

### Configure deployment settings in Netlify

1. In Netlify, select the Dev Portal repository you just forked.
1. Select **prod** from the **Branch to deploy** drop-down menu.
1. Click **Show advanced**. 
1. In the **Environment variables** section, click **New variable**.
1. Enter `VITE_PORTAL_API_URL` in the **Key** field and your custom portal domain API (`api.mycompany.com`) in the **Value** field.
1. Click **Deploy site**. 

### Add your domain to Netlify

1. In Netlify, click **Domain settings**, then **Add a domain**.
1. Enter your custom portal client domain in the **Custom domain or subdomain** field, then click **Verify**.
1. Click **Domains** in the sidebar, then select your domain.
1. [Configure the name servers in your domain registrar](https://docs.netlify.com/domains-https/netlify-dns/delegate-to-netlify/).

Once your name servers are propogated (this may take a few minutes), your Dev Portal will be deployed by Netlify.

## Customize the example open source Dev Portal 

If you want to further customize the example self-hosted Dev Portal, you can edit the settings in your forked copy of the open source {{site.konnect_short_name}} Dev Portal repository. For more information, see the [{{site.konnect_short_name}} Portal repository](https://github.com/Kong/konnect-portal).  

You can also customize your Dev Portal using the [Portal API](/konnect/api/portal/v2/) and [Portal SDK](https://www.npmjs.com/package/@kong/sdk-portal-js). 

## More information

[About Self-Hosted Dev Portal](/konnect/dev-portal/customization/self-hosted-portal/) - Learn more about how the self-hosted Dev Portal works and why you should use it.
