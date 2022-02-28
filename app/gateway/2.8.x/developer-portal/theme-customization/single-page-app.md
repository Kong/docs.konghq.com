---
title: Hosting Single Page App out of Kong Dev Portal
badge: enterprise
---

The Kong Developer Portal ships with a default server-side rendered theme; however, it is possible to replace this with a Single Page App (SPA). This example is in Angular using the Angular CLI Tool, but you can follow along with any other JavaScript framework with just a few tweaks.

To view the basic example Angular template from this guide, visit the [`example/spa-angular`](https://github.com/Kong/kong-portal-templates/tree/example/spa-angular) branch from the `kong-portal-templates branch`.

## Prerequisites

* Portal Legacy is turned off
* The Developer Portal is enabled and running
* kong-portal-cli tool is installed locally

## What is a SPA

A Single Page App (SPA) is a website that loads all HTML, JavaScript, and CSS on the first load. Instead of loading subsequent pages from the server, JavaScript is used to dynamically change the page content. You may want to use an SPA in Dev Portal if you have a preexisting SPA you want to integrate with the portal, or you are trying to achieve a more application-like experience across many pages. An SPA takes control of routing from the server, and handles it client-side instead.

Custom JavaScript can also be added to run only on specific layouts, allowing you to maintain server-side rendering. [Learn more](/gateway/{{page.kong_version}}/developer-portal/theme-customization/adding-javascript-assets) about adding JavaScript to a layout without implementing an SPA.

## Making Choices


We recommend Catalog and Spec routes not be handled by SPA.
If you are using Authentication, then you probably also want to leave server-side rendering for any account pages.

## Getting Started

Clone the [portal-templates](https://github.com/Kong/kong-portal-templates) repo

Create a file called `router.conf.yaml` in `workspaces/default` This file will override the default routing, allowing you to control routing via JavaScript.

`router.conf.yaml` must be a yaml file, where the key is each route, and the value a content or spec path. `/*` Is a catch-all wildcard for all routes not specified in `router.conf.yaml`, it will overwrite all default routing set by collections or set in headmatter.

In the `router.conf.yaml` example below, we are hardcoding routing for all kong related functionality and deferring to SPA routing for all other routes.  The `/*` route at the bottom of the file is a wildcard route. The wildcard route, in this case, tells Kong to serve `content/index.txt` for any request that is not handled by the route declarations above.

```
/login: content/login.txt
/logout: content/logout.txt
/register: content/register.txt
/settings: content/settings.txt
/reset-password: content/reset-password.txt
/account/invalidate-verification: content/account/invalidate-verification.txt
/account/resend-verification: content/account/resend-verification.txt
/account/verify: content/account/resend-verification.txt
/documentation: content/documentation/index.txt
/documentation/httpbin: specs/httpbin.json
/documentation/petstore: specs/petstore.yaml
/*: content/index.txt

```

### Create your SPA

Create an SPA app in the JavaScript framework of your choice. This
example uses angular.

```
ng new
```

Make sure to include a 404 route, as well as all routes you want to have on the Portal (excluding the routes handled by server-side rendering excluded above).

Run the build process

For angular:

```
ng build
```

Copy the build output JS and CSS files to a folder inside `workspaces/default/themes/assets/js`.

For this example, place the angular build inside a `workspaces/default/themes/assets/js/ng`.

### Mounting an SPA

To load our JS, we need to mount it. Let's create a new layout page.

Create a file called `spa.html` in `workspaces/default/themes/layouts`.

This file will need to contain the html element that the SPA will mount to as well as the scripts necessary to do this.
For reference, view the `index.html` inside the build folder created by the build step of the SPA.

The example uses `layouts/_base.html` as the base for the layout template.
By doing so, the <head> element is handled the same way as other pages in the portal, as well as the same CSS and scripts.

If you want to have the top nav bar and bottom nav bar, be sure to include them in your layout.

This is the resulting layout:

{% raw %}
```
{% layout = "layouts/_base.html" %}
{-main-}

    {(partials/header.html)}
    <div class="page">
        <app-root></app-root>
    </div>
    {(partials/footer.html)}


    <script src="assets/js/ng/runtime-es2015.js" type="module"></script>
    <script src="assets/js/ng/runtime-es5.js" nomodule defer></script>
    <script src="assets/js/ng/polyfills-es5.js" nomodule defer></script>
    <script src="assets/js/ng/polyfills-es2015.js" type="module"></script>
    <script src="assets/js/ng/styles-es2015.js" type="module"></script>
    <script src="assets/js/ng/styles-es5.js" nomodule defer></script>
    <script src="assets/js/ng/vendor-es2015.js" type="module"></script>
    <script src="assets/js/ng/vendor-es5.js" nomodule defer></script>
    <script src="assets/js/ng/main-es2015.js" type="module"></script>
    <script src="assets/js/ng/main-es5.js" nomodule defer></script>

{-main-}
```
{% endraw %}

If the SPA build process creates a css file, edit the `head.html` partial to include your css file.

### Loading your layout

Modify `workspaces/default/content/index.txt` to use your layout.
The title you set here will be the one that displays until the JS set title loads.

{% raw %}
```
---
layout: spa.html
title: Home
---
```
{% endraw %}

### Deploy the Portal

Now using the kong-portal-cli tool, deploy the portal.

From the root folder of the templates repo:

```
portal deploy default
```
