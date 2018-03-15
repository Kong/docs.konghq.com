---
title: Kong Developer Portal
---
# [Welcome to the Kong Dev Portal](#welcome-to-the-kong-dev-portal)

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-home.png "Welcome to the Kong Dev Portal")

Thanks for installing or upgrading Kong Enterprise Edition. This document orients you to Kong's built-in Dev Portal functionality and gets you started with customizing your Kong Dev Portal.

## Index

[**Welcome to the Kong Dev Portal**](#welcome-to-the-kong-dev-portal)

[**Getting Started**](#getting-started)

[**Understanding the Kong Dev Portal**](#understanding-the-kong-dev-portal)

[**Customizing the Kong Dev Portal**](#customizing-the-kong-dev-portal)

[**Authentication**](#authentication)

[**FAQ**](#faq)

[**Known Limitations**](#known-limitations)

## Assumptions

* You have installed a recent version of Kong Enterprise Edition that includes Dev Portal functionality.
    * Dev Portal was introduced in Kong EE v0.31
* You are a Kong Admin, and have Super Admin permissions in Kong RBAC.
    * Or, the RBAC feature of Kong EE is disabled.
* You have a OpenAPI Specification v2 or v3 file (also known as a Swagger Specification, or a Swagger file) that documents at least part of your API. 
    * This isn't a strict requirement to get started, but you'll need it soon.

## Glossary

### Key Terms

* **Example Dev Portal** = The set of pages, partials, and specs that are provided in the example Dev Portal files.
* **Handlebars** = [Handlebars](https://handlebarsjs.com/) is a semantic JavaScript templating language.

### Types of Humans

* **Developer** = A human that wants to learn about your APIs by visiting your Dev Portal.
* **Admin** = A human that has access to administer **Kong** functionality.
    * Sometimes we clarify this to also refer to the specific permissions of the admin:
        * **API Gateway Admin** = A human that can administer the **Kong API Gateway**, but not the Dev Portal or Developers.
        * **Dev Portal Admin** = A human that can administer **Dev Portal** content, but not the Developers.
        * **Developer Admin** = A human that can administer **Developers**, their permissions, and their credentials.

* **User** = A human that uses an Application.
    * When OpenID Connect is in use, the **User** is typically involved in delegating permission to **Kong API Gateway** to proxy the requests that are coming from the **Application** that the **User** is using.

### Types of Files

* **Specifications / Specs** = An API specification, in **OpenAPI** (formerly known as Swagger) format. 
* **Partials** = These are Handlebar files made up of HTML, JS, and CSS content that define the look, feel, functionality, and structure of your Dev Portal.
* **Pages** = Pages are Handlebars templates that bring together the previously described **Partial** files and result in pages in your Dev Portal.
* **Loader** = The mechanism which compiles and serves HTML and JavaScript files to the browser when a visitor visits any **Dev Portal** **page**.
    * The Loader requests **Pages**, **Partials** and **Specifications** from Kong, which it uses to render your **Dev Portal** in the visitor's browser.
    * The **Loader** is not modifiable by Admins - instead, customization is performed by modifying **Specifications**, **Partials**, and **Pages**.

### Other Concepts

* **API** = The APIs that are proxied by Kong API Gateway, the APIs that are documented in Dev Portal, and APIs whose usage is monitored by Vitals, etc.
    * Note that this is *not* the **Admin API** of Kong - we consistently refer to that as **Admin API**
* **Consumer** = [A Kong concept and entity.](https://getkong.org/docs/latest/getting-started/adding-consumers/) 
* **Application** = A computer program that calls API(s) proxied by **Kong API Gateway**.
    * This could be a mobile or web front end, an application running on the server of a partner or customer, or an application running within your company. 

* * *

# [Getting Started](#getting-started)

## Enable the Dev Portal

1. Open the Kong configuration file in your editor of choice (`kong.conf`)
2. Find and change the `portal` configuration option to `on` and remove the `#` from the beginning of the line, it should now look like:
    1. **`portal = on`**
        1. Enables the **Dev Portal File API** which can be accessed at: `:8001/files`
        2. Serves the **Dev Portal** **Loader** on port  `:8003`
        3. Enables the **Public Dev Portal API** on port  `:8004`
            1. The **Public Dev Portal File API** can be accessed at `:8004/file`
3. Restart Kong (`kong restart`)

> Note: Not all deployments of Kong utilize a configuration file, if this describes you (or you are unsure) please reference the [Kong configuration docs](https://getkong.org/docs/0.12.x/configuration/) in order to implement this step.

## Uploading the Example Dev Portal files

Now that we have enabled the Dev Portal, it is time to download the Example Dev Portal Files archive, (made of Pages, Partials, and Specifications) so that the Dev Portal Loader will have something to render (more on that later).

* Login to Bintray and download the [Example Dev Portal files](https://bintray.com/kong/kong-dev-portal/example/v0.0.1#files) archive.
* Unarchive the Example Dev Portal files archive and navigate to it in your terminal
* Run the following commands in your terminal to upload the Example Dev Portal files to Kong:
    * `chmod +x sync.sh`
    * `./sync.sh`
        * If you open this file in your text editor you will see that it is making basic `curl` requests to the Dev Portal File API. We will be making similar requests later.
* Navigate in your browser to `http://127.0.0.1:8001/files` 
    * You should see a list of files, with types, and contents. These are the Example Dev Portal files that we have uploaded via the Dev Portal File API.
* If you are enabling Authentication, jump to the **Authentication** section before moving forward.



## Visit the Example Dev Portal

Now that you have enabled the Dev Portal in Kong, and uploaded the Example Dev Portal files using the Dev Portal File API we can visit the Example Dev Portal:

* Navigate your browser to `http://127.0.0.1:8003`

You should now see the Default Dev Portal Homepage, and be able to navigate through the example pages.

# [Understanding the Kong Dev Portal](#understanding-the-kong-dev-portal)

The Kong Dev Portal is composed of different types of files that are stored in Kong's database and exposed through a read-only Public Dev Portal API (`:8004/files`) used by the Dev Portal Loader (`:8003`) to render your Dev Portal.

To change the appearance and functionality of your Dev Portal, you can modify the contents of the files stored in Kong's database using the Dev Portal File API on the Admin API (`:8001/files`).

## File Types

![alt text](https://konghq.com/wp-content/uploads/2018/03/diagram-partials-02.png "File types diagram")

Dev Portals served by Kong are comprised of three primary file types; **Pages**, **Partials**, and **Specifications**. The unique look, feel, and content of your Dev Portal is controlled through creating and editing these three file types.


* **Page**
    * Handlebars file.
    * Pages can be accessed by appending the Page name to your Dev Portal URL: `:8003/<page_name>`
    * Pages are indicated by `type=page` in Dev Portal File API.
* **Partial** 
    * Handlebars partial registered by name for use within a Pages and other Partials.
    * Partials can be re-used and shared between all pages using the Handlebars import statement:
        *  `{{> partial_name}}`
    * Partials are indicated by `type=partial` in Dev Portal File API.
* **Specification**
    * Open API (Swagger) Spec files that are passed to the OpenAPI Spec Renderer and the Pages / Partials.
    * Kong Dev Portal is compatible with Swagger version 2.x and OpenAPI Spec version 3.x files.
        * Specification files **must** be in _YAML_ or _JSON_ format.
    * Specifications are indicated by `type=spec` in Dev Portal File API.

## File Requirements

* File names **must not** include the file extension, unless you wish your pages and partials to be referenced with them.
    * A **Page** with `name=guides.hbs` would be accessible at: `http://127.0.0.1:8003/guides.hbs`
    * A **Page** with `name=guides` would be accessible at: `http://127.0.0.1:8003/guides`
* File names **must** be _unique_.
    * You cannot have more than one file with the same name, even if they are of different types.
* Files **must** be of the type: `partial` or `page` or `spec`
    * Other file formats like image and video are not supported by the Files API, and must be served either from another web server or added inline.
* Pages and Partials **must** be written in _[Handlebars](https://handlebarsjs.com/)_
    * Files with the `.hbs` extension may contain HTML or [Handlebars](https://handlebarsjs.com/) code
* Specification files **must** be in _YAML_ or _JSON_ format

## Example Files

The following list describes the files that make up the Example Dev Portal being served by Kong:

### **Important Notice**

The file names displayed below reference the file name within the Example Dev Portal files archive. The file extension **must not** be included in the file name when creating, or updating files in the Dev Portal Admin API.

### **Pages**

These pages make up the Example Dev Portal. If authentication is enabled, these pages are accessible only to authenticated users.

* **pages/index.hbs**
    * The page that is served when when visitors access the root URL of your Dev Portal.
* **pages/about.hbs**
    * Sample 'about' page that extends the base `layout` partial.
* **pages/guides.hbs**
    * Sample 'guides' page that extends the base `layout` partial.
* **pages/404.hbs**
    * The page that visitors get when they navigate to a non-existent URL of your Dev Portal.
* **pages/documentation/**index.hbs****
    * See Virtual Paths And The Specification Loader section for more information.
* **pages/documentation/loader.hbs**
    * See Virtual Paths And The Specification Loader section for more information.
* **pages/documentation/api1.hbs**
    * A static page that renders the `petstore` spec using the `spec-renderer` partial using the `spec` argument.
* **pages/documentation/api2.hbs**
    * A static page that renders the `vitals` spec using the `spec-renderer` partial using the `spec` argument.

### **Partials**

These partials make up the Example Dev Portal. If authentication is enabled, these pages are accessible only to authenticated users.

* **partials/layout.hbs**
    * Base layout template for the Example Developer Portal which contains references to the `header`,  `footer`,  `theme-css`,  `custom-css`, and `title` partials. The base layout can be extended using inline partial references inside of **Pages**. An example is the `about.hbs` page.
* **partials/header.hbs**
    * The default Example Dev Portal header partial for authenticated users.
* **partials/sidebar.hbs**
    * The default Example Dev Portal sidebar that is included in the `documentation/{api1,api2,loader}` pages that includes the `sidebar-spec` partial and a link to the `guides.hbs` page.
* **partials/sidebar-spec.hbs**
    * This partial renders a list of links to methods found in the specification loaded through the `spec-renderer` partial.
* **partials/spec-renderer.hbs**
    * This partial renders a specification from the Dev Portal Files API. When the `spec` argument is used it does a direct lookup for either a `json` or `yaml` spec file.
* **partials/spec-dropdown.hbs**
    * This partial renders a dropdown allowing access to all specs stored in the Dev Portal Files API, as well as illustrates how custom components can be built and utilized.
* **partials/custom-js.hbs**
    * This partial defines JavaScript that runs on all pages in the Example Dev Portal - it is “empty” and ready for you to customize

### **Specifications**

* **specs/petstore.json**
    * API specification file, in Swagger 2.0 and JSON format.
* **specs/vitals.yaml**
    * Another API specification file, in Swagger 2.0 and YAML format.

### Unauthenticated pages and partials

See **Adding Authentication** for more information. Some of these files are shared files. These files will be modified later. You can duplicate these and remove the shared dependency if you prefer.

## **File Paths**

Files can be served under nested paths, called *namespaces*, to allow further control over how your content is organized and served.

1. To serve a page named `api1` under the namespace `/documentation`:
    1. Upload a Page with `name=documentation/api1` to the Dev Portal File API
        1. We have already done this for you. You can view this file in the Example Dev Portal file archive you downloaded and sync'd earlier, you can also view it from the Dev Portal File API.
    2. Navigate in your browser to `:8003/documentation/api1`
    3. You will see the contents of the Page you just uploaded to the Dev Portal File API. This is how namespaces work.
2. In order to serve content on the namespace itself (e.g. `/documentation`) you can either:

    1. Upload a page with `name=documentation`
    2. Upload a Page with `name=documentation/index`
        1. We have already uploaded a file with this name to your Dev Portal File API earlier in the Uploading the Example Dev Portal files section. You can view this file in both the archive and inside of your Dev Portal File API.

    * Navigate in your browser to `:8003/documentation` in either of these cases to see the pages content.

### Virtual Paths and the Specification Loader

**Virtual Paths** allow you the ability to dynamically render Specification files without creating a page for each Specification.


> You may have noticed the two static Specification file pages as well as the Specification Loader `documentation/loader` within the Example Dev Portal


The inclusion of a **Specification Loader** (a file defined by `name=<namespace>/loader`),  as well as the inclusion of the `spec-renderer` partial within the Specification Loader itself, enables the following functionality:

* When the Specification Loader is present under a namespace (e.g. `/documentation/loader`) visiting a path such as `/documentation/spec-1` will attempt to render a Specification file uploaded with the name `spec-1`.
* If the Specification does not exist in the Dev Portal File API the path visited will return the **404** page.

An example Specification Loader is as follows:

> Note: while layout of the loader page is flexible the inclusion of the `spec-renderer` partial is required in order to provide spec rendering functionality. Furthermore the Dev Portal needs **all** elements of the `spec-renderer` partial to remain as is to function as expected.

![alt text](https://konghq.com/wp-content/uploads/2018/03/code-spec-renderer.png "Logo Title Text 1")

# [Customizing the Kong Dev Portal](#customizing-the-kong-dev-portal)

Now that you have the Example Dev Portal running and you understand how files interact with and are served by the Dev Portal Loader, lets go through the steps of customizing the look and feel of the Example Dev Portal.

In order to customize the Example Dev Portal, you generally follow these steps:

1. Issue a `GET` command to `:8001/files` to see a list of all your Dev Portal Files.
2. Take the `contents` of the file(s) you would like to modify and edit them to your liking in a local editor.
    1. Alternatively, you can create new files using `POST` requests if you do not wish to modify existing files.
3. `PATCH` the files back into Kong using the `:8001/files/<filename>` endpoint.
4. Reload the Dev Portal in your browser - you'll see the results of the changes you made.


Going forward, we will be modifying and updating the files from the Example Dev Portal file archive.

## Uploading your Specification file

1. Find your Specification file in your filesystem, it should be either a Swagger `json` or `yaml` file.
    1. Should you not have one, we can use the Swagger Pet Store Example: [[Download File](http://petstore.swagger.io/v2/swagger.json)]
2. Upload the Specification with the following curl request in your terminal (relative to the file):
   ```
   curl -X POST http://127.0.0.1:8001/files \
        -F "type=spec" \
        -F "name=swagger" \
        -F "contents=@swagger.json"
   ```
    1. Note: The `@` symbol in the `curl` command will automatically read the file on disk and place its contents into the `contents` argument.

Now let's update **pages/documentation/api1.hbs** to render our newly added Specification file:

1. Find the `pages/documentation/api1.hbs` file in your Example Dev Portal Archive
2. Find the following line of code:
    1.  `{{> spec-renderer spec="petstore"}}`
3. Change:
    1.  `petstore`  →  `swagger`
4. Now make a `PATCH` request to update the page against the Dev Portal File API in your terminal (note, no extension on the filename in the url):
   ```
   curl -X PATCH http://127.0.0.1:8001/files/documentation/api1 \
        -F "contents=@pages/documentation/api1.hbs"
   ```
5. Lastly, navigate to `:8003/documentation/api1` in your browser, you should see that the specification has changed and should look like the following (assuming you used the petstore swagger file from above):

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-petstore.png "Logo Title Text 1")

## **Customizing the look and feel of your Dev Portal**

The Dev Portal default theme is shipped with two CSS file partials:

* `partials/unauthenticated/theme-css.hbs` 
    * Default styles for all theme specific elements across the Example Dev Portal.
* `partials/unauthenticated/custom-css.hbs`
    * Partial describing how to change specific parts of the portal without modifying the default theme CSS.

We strongly encourage you to use the `custom-css` over modifying `theme-css` for small changes so you don't affect the original styles and get unwanted collateral damages.

For this example, this is what we're going to do:

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-nav3.png "Navbar Edited")

### **Structure**

1. Find and open the `partials/header.hbs` file from the Example Dev Files archive you downloaded earlier.
2. Change the content inside of the `.logo` element to `Dev Portal`
   ```
   <a class="logo" href="/">Dev Portal</a>
   ```
3. Change `Developers` → `My Company Developers`:
   ```
   <span>My Company Developers</span>
   ```
4. Update the file by sending a `PATCH` request from your terminal to the Dev Portal File API:
   ```
   curl -X PATCH http://127.0.0.1:8001/files/header \
        -F "contents=@partials/header.hbs"
   ```
5. Refresh the Example Dev Portal. You should see something similar to below (don't worry, we are going to make it look better after we change the styles):

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-nav4.png "Navbar Edited")

### **Style**

1. Find and open `partials/unauthenticated/custom-css.hbs` in the Example Dev Files directory.
2. Let's start by changing the header background, and text colors by adding:
   ```
   #header {
      background-color: #033151;
      color: #FFFFFF;
   }
   ```
3. Next, we're going to change the font color in the navigation from blue to white by adding: 
   ```
   .navigation > li > a,
    #headerSpecDropdownWrapper > .header-text {
      color: `hsla(255, 100%, 100%, .45) !important;
   }
   ```
4. Almost there, now let's change the logo text to white, increase its size, and update the separator color:
   ```
   #header .header-logo-container .logo {
      color: white;
      font-size: 20px;
      font-weight: 700;
      border-right-color: hsla(255, 100%, 100%, .45);
   }
   ```
5. Save the file and send a `PATCH` request in your terminal to the Dev Portal File API to update it:
   ```
   curl -X PATCH http://127.0.0.1:8001/files/custom-css \
        -F "contents=@partials/custom-css.hbs"
   ```
6. Refresh the Example Dev Portal in your browser and now it should look like this: 

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-home2.png "Homepage Edited")

## Working with Page Layouts

To avoid duplicating code in pages and partials, layout partials can be created and used on multiple pages that share common layout.

The Example Dev Portal includes one basic layout: `partials/layout.hbs`

```
{{#if pageTitle}}
  {{> unauthenticated/title }}
{{/if}}

{{#> styles-block}}
  {{!--
    These are the default styles, but can be overridden.
  --}}
  {{> unauthenticated/theme-css}}
  {{> custom-css}}
{{/styles-block}}

{{#> header-block}}
  {{!--
    The `header` partial is the default content, but can be overridden.
  --}}
  {{> header }}
{{/header-block}}

{{#> content-block}}
  {{!-- Default content goes here. --}}
{{/content-block}}

{{#> footer-block}}
  {{!--
    The `footer` partial is the default content, but can be overridden.
  --}}
  {{> unauthenticated/footer }}
{{/footer-block}}

{{#> scripts-block}}
  {{!-- Custom scripts per page can be added.
    {{> unauthenticated/custom-js}}
   --}}
  {{> unauthenticated/auth-js auth=false}}
{{/scripts-block}}
```

Let's create a new page using this template.

## Creating a New Page

We're going to create something super simple, a Hello World page using the `layout` template described above:

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-hello-world2.png "Hello World 2")

1. Create a new file with the name `example.hbs` in your Example Dev Portal files directory under the `pages/` directory.
2. In the file we just created, let's add the following code (the handlebars syntax for opening a partial block):
   ```{{#> layout pageTitle="Hello World" }}```
    1. Note: The `pageTitle` attribute allows you to easily change the title of the page displayed in the browser. Here we have set it to `Hello World`.
3. Now let's add the actual content. When using the layout template, content on the page must be placed **inside** an [inline partial block](http://handlebarsjs.com/partials.html) named `content-block` like so:
   ```
   {{#*inline "content-block"}}
      <div class="app-container">
         <div class="page-wrapper indent">
            <h1>Hello world</h1>
            <p>This is a Sample Page</p>
         </div>
      </div>
    {{/inline}}
    ```
4. Now let's close out the layout block:
   ```
   {{/layout}}
   ```
5. Your file should now look like:
   ```
   {{#> layout pageTitle="Hello World" }}
      {{#*inline "content-block"}}
         <div class="app-container">
            <div class="page-wrapper indent">
               <h1>Hello world</h1>
               <p>This is a sample page.</p>
            </div>
         </div>
      {{/inline}}
   {{/layout}}
   ```
6. Add it to Kong specifying the file as a page:
   ```
   curl -X POST http://127.0.0.1:8001/files \
        -F "name=example" \
        -F "type=page" \
        -F "contents=@pages/example.hbs" \
        -F "auth=true"
   ```
    1. To learn about the `auth` flag see the **Adding Authentication** section.
    2. Note that the name must match that used in the handlebars file (example and example.hbs in this sample)

     
...We're done, this is how our page should look:

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-hello-world2.png "Logo Title Text 1")

## Add New Page to the Nav

Previously we created `example.hbs`, let's add it to the Developer Portal navigation so its accessible to everyone:

1. Find and open `partials/header.hbs` in the Example Dev Portal file directory.
2. Open it in your favorite text editor and find the `nav` container, it should look like:
   ```
   <nav class="header-nav-container">
      <ul class="navigation">
         {{> spec-dropdown url="/documentation/"}}
         <li>
            <a href="/about">About</a>
         </li>
         <li>
            <a href="/guides">Guides</a>
         </li>
         {{> unauthenticated/login-actions auth=false}}
      </ul>
   </nav>
   ```
3. Let's add the following line:
   ```
   <li>
      <a href="/example">Example</a>
   </li>
   ```
4. Your `nav` block should now look like:
   ```
   <nav class="header-nav-container">
      <ul class="navigation">
         {{> spec-dropdown url="/documentation/"}}
         <li>
           <a href="/about">About</a>
         </li>
         <li>
           <a href="/guides">Guides</a>
         </li>
         <li>
           <a href="/example">Example</a>
         </li>
         {{> unauthenticated/login-actions auth=false}}
       </ul>
     </nav>
     ```
5. Finally let's update it using the Dev Portal File API:
   ```
   curl -X PATCH http://127.0.0.1:8001/files/header \
        -F "contents=@partials/header.hbs"
   ```
6. Once uploaded, refresh your Dev Portal and you should see the change:

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-nav2.png "Edited Nav")

## Link From One Dev Portal Page to Another

1. Add a link in the code of a page or partial like:
   ```
   <a href="/example">Example</a>
   ```
    1. This will link to a Page with `name=example`
2. To link to an anchor or section within `/example`, ensure the target includes an unique id:
   ```
   <div id="details">Details Here</div>
   ```
3. Your link should look like:
   ```
   <a href="/example#details">Example</a>
   ```
4. Update the page you edited via the Dev Portal File API and reload that page - you should see the link you added, and when you click it, it will take you to the linked page, and, if you coded it, to the anchor.

## Adding Image, Video, or other file types to a Page

The Dev Portal File API serves only **Pages**, **Partials**, and **Specifications**. To add images, videos, and other file types to your pages, you must either add them inline (e.g. inline SVG) or link to the files being served by some other web server.


* * *

# [Authentication](#authentication)

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-browser-login2.png "Browser Login 1")

## Introduction

Authentication in the Dev Portal is configured by utilizing the Kong proxy and Kong plugins ([Basic Authentication](https://getkong.org/plugins/basic-authentication), [Key Authentication](https://getkong.org/plugins/key-authentication), [OpenID Connect-EE](https://getkong.org/plugins/ee-openid-connect/), etc.). Plugins can be applied to the Dev Portal File API to only serve authenticated file content from your Kong database.

You can:

* grant files as authenticated or anonymous. This ensures users can see landing pages or public APIs but only authenticated users can see business level or private apis.
* use one or many authentication plugins in parallel
* map Kong consumers to a developer's credentials
* provide a “login via Google, Yahoo, Azure AD” flow for developers which can give you more robust experiences such as avatars and easy sign-on. This can also help authenticate users based on host domain of email addresses.

## Getting started

### Enable Authentication

First, create an API to proxy requests to the Public Dev Portal API:

```
curl -i -X POST \
  --url http://127.0.0.1:8001/apis/ \
  --data 'name=portal-files' \
  --data 'uris=/portal' \
  --data 'upstream_url=http://127.0.0.1:8004'
```

Now that we created our API, update the following line in your Kong Configuration to let Kong know that the Public Dev Portal Files API should point to `:8000/portal` and restart Kong:

```
portal_api_uri = 127.0.0.1:8000/portal
```

Next, we need to enable an authentication plugin and apply it our newly created API. You can select from any of the available [Kong plugins](https://konghq.com/plugins/). Let's start with [Basic Authentication:](https://getkong.org/plugins/basic-authentication)

```
curl -X POST http://127.0.0.1:8001/apis/portal-files/plugins \
  --data "name=basic-auth" \
  --data "config.hide_credentials=true"
```

Now, let's enable the [CORS plugin](https://getkong.org/plugins/cors) so your Dev Portal can make requests from `:8003` → `:8000` and with the appropriate access control headers:

```
curl -X POST http://127.0.0.1:8001/apis/portal-files/plugins \
  --data "name=cors" \
  --data "config.origins=http://127.0.0.1:8003" \
  --data "config.methods=GET, POST" \
  --data "config.credentials=true"
```

Now that we have setup authentication for your Dev Portal File API, your developers won't be able to access any of your files without credentials. What about access to **unauthenticated files,** files that have the flag `auth` set to `false`, such as landing pages, and the login form?

Let's create another API to grant access to unauthenticated files:

```
curl -i -X POST \
  --url http://127.0.0.1:8001/apis/ \
  --data 'name=portal-files-unauthenticated' \
  --data 'uris=/portal/files/unauthenticated' \
  --data 'upstream_url=http://127.0.0.1:8004/files/unauthenticated'
```

> The  `:8004/files/unauthenticated` endpoint filters and returns an array of files stored in Kong that have the flag `auth` set to `false`


Now add the CORS plugin:

```
curl -X POST http://127.0.0.1:8001/apis/portal-files-unauthenticated/plugins \
  --data "name=cors" \
  --data "config.origins=http://127.0.0.1:8003" \
  --data "config.methods=GET, POST" \
  --data "config.credentials=true"
```

You should now see that [:8000/portal/files](http://127.0.0.1:8000/portal/files/unauthenticated) requires Basic Authentication headers, while [:8000/portal/files/unauthenticated](http://127.0.0.1:8000/portal/files/unauthenticated) will pass through and return unauthenticated files.

Other auth plugins are also provided and are explained in more detail in “Example configurations”:

* [Key Authentication](https://getkong.org/plugins/key-authentication)
* [OpenID Connect-EE](https://getkong.org/plugins/ee-openid-connect/)

Next, we will tell the Dev Portal that authentication is enabled by manipulating a few files.

### Enable “Auth” in Files

Ensure all files have `auth=true` by editing the auth flags inside these partials:

* `header.hbs`
* `layout.hbs`
* `unauthenticated/header.hbs`
* `unauthenticated/layout.hbs`

```
{{> unauthenticated/login-actions auth=true}} // Default is auth=false
```

This will allow authentication items such as login buttons and `auth-js.hbs` JavaScript to display in the Dev Portal.

### Enable AUTH in JavaScript hooks

After you have set `auth=true` in your Files, you will need to tell the Dev Portal how you are storing/retrieving credentials. In the `unauthenticated/auth-js` partial, set the type to `'basicAuth'` and return a JavaScript auth config associated with basic authentication:
   ```
   // unauthenticated/auth-js.hbs

   <script type="text/javascript">
      window.Auth.setAuthStorageType('basicAuth')

      console.log("custom js for authentication is running")

      function loginDecorator(formData) {
         return {
            auth: formData
         }
      }
      window.loginDecorator = loginDecorator
   </script>
   ```
> See **JavaScript Hooks** section below for more information on JavaScript hooks and other configurations.

### Add a Consumer

Next, [add a Kong consumer](https://getkong.org/docs/0.12.x/getting-started/adding-consumers/) to your `portal-files`  API with [credentials](https://getkong.org/plugins/basic-authentication/#create-a-credential) that are associated with your Basic auth plugin.

### Login to the Dev Portal

Browse to [:8003](http://127.0.0.1:8003/) and view the Dev Portal. Click the Login button and enter the username and password of your newly created Kong Consumer with enabled Basic Authentication credentials.

Congratulations! You have now authenticated your Dev Portal.

For more information and details on configuring other authentication methods, keep reading!


> If your Dev Portal does not render after following these steps, check out the FAQ below.

## Files

### **Unauthenticated Pages**

When authentication is enabled, these pages are served to users who are not authenticated.

* **pages/user.hbs**
    * Page which displays current users data such as their picture, name, and email.
* **pages/unauthenticated/404.hbs**
    * The page visitors get when they navigate to a non-existent URL and are not logged in.
* **pages/unauthenticated/index.hbs**
    * The page that is served when visitors access the root URL of your Dev Portal and are not logged in. 
* **pages/unauthenticated/login-basicauth.hbs**
* **pages/**unauthenticated/login-keyauth.hbs****
* ****pages/**unauthenticated/login-oidc.hbs******
* ********pages/unauthenticated/login.hbs********
    * These pages control authentication for your Dev Portal. See “**Custom Login Form Pages**” for more information on these files.

### **Unauthenticated Partials**

* **partials/unauthenticated/theme-css.hbs**
    * This partial defines the styling of the Example Dev Portal.  It can be modified as a base theme, or removed entirely in favor of your own styles.
    * See **Customizing the Kong Dev Portal** section for more details.
* **partials/unauthenticated/custom-css.hbs**
    * This partial defines override styling for the Dev Portal.  Use this to modify the underlying theme without compromising its content, or feel free to remove if not needed. 
    * See **Customizing the Kong Dev Portal** section for more details.
* **partials/unauthenticated/layout.hbs**
    * Base layout template for the Developer Portal which contains references to the `header`, `footer`, `theme-css`, `custom-css`, and `title` partials. The base layout can be extended using inline partial references inside of **Pages**. An example is the `unauthenticated/login.hbs` page.
* **partials/unauthenticated/login-actions.hbs**
    * Partial that displays login/logout functionality based off of authentication status, as well as a user avatar if the `openid-connect` plugin is being used.
* **partials/unauthenticated/footer.hbs**
    * The default Dev Portal footer partial for both unauthenticated & authenticated users.
* **partials/unauthenticated/header.hbs**
    * The default Dev Portal header partial for unauthenticated users.
* **partials/unauthenticated/title.hbs**
    * This partial sets the page title using `window.document.title` and is used for all users.

* **partials/unauthenticated/auth-js.hbs**
    * Authentication utilities - See **JavaScript Hooks** section below for more details.


### **Understanding Dev Portal Routing & Authentication**

![alt text](https://konghq.com/wp-content/uploads/2018/03/diagram-auth-routing.png "Auth Routing Diagram")

The Dev Portal router runs through a series of steps to determine which files to serve based on the user's authentication status. Let's explore how the Dev Portal router handles authentication by playing with an instance of the Example Dev Portal.

Before we start, check that you:

1. Have an instance of the Example Dev Portal running (see **Getting Started**)
2. Authentication is enabled and configured (see **Authentication > Getting Started**)


Lets first create two test pages that will simply illustrate whether we are viewing an authenticated or unauthenticated page.

1.  `pages/test.hbs`
    1. Create a file named `pages/test.hbs` and open it in your favorite text editor.
    2. Insert the code below into the file and save:
       ```
       <h1>This is an authenticated test page</h1>
       ```
    3. Upload `pages/test.hbs` to the Dev Portal File API with the following command:
       ```
       curl -X POST http://127.0.0.1:8001/files \
            -F "name=test" \
            -F "type=page" \
            -F "contents=@pages/test.hbs" \
            -F "auth=true"
       ```
    4. Navigate to [`:8003/test`](http://127.0.0.1:8003/test) and ensure that the browser looks like this:
    
    ![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-auth-example.png "Authenticated Page")

2. `pages/unauthenticated/test.hbs`
   1. Create a file named `pages/unauthenticated/test.hbs` and open it in your favorite text editor.
   2. Insert the code below into the file and save:
   ```
   <h1>This is an unauthenticated test page</h1>
   ```
   3. Upload `pages/unauthenticated/test.hbs` to the Dev Portal File API with the following command:
      ```
      curl -X POST http://127.0.0.1:8001/files \
            -F "name=unauthenticated/test" \
            -F "type=page" \
            -F "contents=@pages/unauthenticated/test.hbs" \
            -F "auth=false"
      ```
    4. Navigate to [`:8003/unauthenticated`](http://127.0.0.1:8003/unauthenticated/test) test and ensure that the browser looks like this:
    
     ![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-auth-example2.png "Unauthenticated Page")

Now that we have created our two test pages, let's take a look at how the Dev Portal deals with authenticated/unauthenticated routes.

**Authenticated Flow:**

1. If you are not already, login to the Example Dev Portal (see section “**Logging In**”).
2. Navigate to [:8003/test](http://127.0.0.1:8003/test) in your browser, you should see a header stating *“This is an authenticated test page”.*
    1. The Developer Portal went through the following flow:
        1. Search for a page named **test** *There is!*
        2. Check to ensure that you have authorization to access the page. *You do!*
        3. Serve **test** page to the browser.



> **Note:** You can still access the unauthenticated test page by navigating to [:8003/unauthenticated/test](http://127.0.0.1:8003/unauthenticated/test) in the browser.



**Unauthenticated Flow:**

1. If you have not already, log out of the Dev Portal (see section “**Logging Out**”).
2. Navigate to [:8003/test](http://127.0.0.1:8003/test) in your browser, you should see text stating *“This is an unauthenticated test page”*.
3. Notice that although the path **/test** requests `test.hbs` (our authenticated page), we are served `unauthenticated/test.hbs`.
    1. The Developer Portal went through the following flow:
        1. Parse the path `/test` to determine we would like to serve a page named **test**.
        2. Search for a page named **test**. *There is!*
        3. Ensure that you have authorization to access the page. *You don't. You are not currently logged in and the page requires authentication.*
        4. Check to see if there is a page named **unauthenticated/test**. *There is!*
        5. Ensure that you have authorization to access the page. *You do!*
        6. Serve the **unauthenticated/test** page to the browser.



> **Note:** As illustrated by the above example, when a user requests a particular page to access that they are not authorized to view, the Dev Portal will check for the same filename under the 'unauthenticated' namespace to serve instead. For this reason the 'unauthenticated' namespace is reserved, and should be used explicitly for authentication



> **Note pt. 2:** Requesting a page while authenticated that both requires auth, and does not have a corresponding page under the 'unauthenticated' namespace will result in a 404.  You can test this by requesting pages like [:8003/guides](http://127.0.0.1:8003/guides) or [:8003/about](http://127.0.0.1:8003/about) while unauthenticated.




## JavaScript hooks

You can find these functions in the `unauthenticated/auth-js` partial in the Example Dev Portal.

They store and attach authentication headers, query params, and cookies in order to decorate Dev Portal Files API requests. You hook into the Dev Portal authentication behavior through these functions.

**setAuthStorageType**

This function tells the Dev Portal which configs are enabled for storing in [Local Storage API](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) to be used for subsequent requests.

```
/*
 * ***Required*** for authentication to be enabled
 * @param {string} type - comma separated list of config auth storage types
 *                        e.g. 'basicAuth,params,cookie,headers'
*/
window.Auth.setAuthStorageType('basicAuth')

```

**loginDecorator**

`loginDecorator` customizes [axios](https://github.com/axios/axios) configs sent to the Dev Portal Files API. Configs are saved on successful login and stored based on their authentication type.

Customize the axios config by intercepting the login form submit. There is a listener on forms with `id="login"` that will prevent the submission and pass inputs to `loginDecorator`:

```
function loginDecorator(formData) {
    /*
    |--------------------------------------------------------------------------
    | Key Auth
    |--------------------------------------------------------------------------
    |
    | KeyAuth uses query params, so decorate your 
    | requests with the key in the form.
    |
    */
    if (formData['key']) {
      return { params: { key: formData['key'] } }
    }

    /*
    |--------------------------------------------------------------------------
    | Basic Auth
    |--------------------------------------------------------------------------
    |
    | Assumes your formData has a <input name="username" .../> along
    | with a <input name="password" .../>.
    |
    */
    return {
      auth: formData
    }
  }
  window.loginDecorator = loginDecorator
```

**onLoginError**

Customize how your form submit will handle errors:

```
function onLoginError(error) {
  console.error(error)
  alert('Authentication failed')
}
window.onLoginError = onLoginError
```

## Example configurations:

### Basic Authentication

Check out the section “**Enabling Authentication”** for a step by step guide on setting up [Basic Authentication](https://getkong.org/plugins/basic-authentication).

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-browser4.png "Basic Auth")

```
// auth-js.hbs

<script type="text/javascript">
  window.Auth.setAuthStorageType('basicAuth')

  function loginDecorator(formData) {
    return {
      auth: formData
    }
  }
  window.loginDecorator = loginDecorator
</script>
```

### Key Authentication

The [Key Authentication Plugin](https://getkong.org/plugins/key-authentication) allows developers to use API keys to authenticate requests against an API. This is useful when consumers have an API Key rather than a username/password.

Add the key auth plugin to the `portal-files` API:

```
curl -X POST http://`127.0.0.1`:8001/apis/portal-files/plugins \
  --data "name=key-auth" \
  --data "config.key_names=key" \
  --data "config.hide_credentials=true"
```

> **Note:** If you have Basic Auth enabled from the earlier steps, unless you take special steps to enable multiple auth, you should disable other auth methods.

Your `unauthenticated/login` partial should have an input name that can be referenced in the `loginDecorator`, such as `key`.  see an example below:

```
// auth-js.hbs

<script type="text/javascript">
  window.Auth.setAuthStorageType('params')

  function loginDecorator(formData) {
    // For instance, <input name="key"/>
    if (formData['key']) {
      return { params: { key: formData['key'] } }
    }
  }
  window.loginDecorator = loginDecorator
</script>
```

The `loginDecorator` will then save the API key from the form submission in local storage for future requests with query params:

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-browser2.png "Login Decorator")
![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-browser3.png "Login Decorator2")

### Open-ID Connect Plugin

The [OpenID Connect Plugin](https://getkong.org/plugins/ee-openid-connect/) allows you to hook into existing authentication setups using third-party *Identity Providers* (**IdP**) such as Google, Yahoo, Microsoft Azure AD, etc. 

[OIDC](https://getkong.org/plugins/ee-openid-connect/) must be used with the “session” method, utilizing cookies for Dev Portal File API requests.

Add the `openid-connect` plugin to the `portal-files` API:

```
curl -X POST http://127.0.0.1:8001/apis/portal-files/plugins  \
  --data "name=openid-connect"      \
  --data "config.issuer=https://accounts.google.com/" \
  --data "config.client_id=<CLIENT_ID>"   \
  --data "config.client_secret=<CLIENT_SECRET>" \
  --data "config.consumer_by=username,custom_id,id" \
  --data "config.ssl_verify=false" \
  --data "config.consumer_claim=email" \
  --data "config.leeway=1000" \
  --data "config.login_action=redirect" \
  --data "config.login_redirect_mode=query" \
  --data "config.login_redirect_uri=http://127.0.0.1:8003" \
  --data "config.logout_methods=GET" \
  --data "config.logout_query_arg=logout" \
  --data "config.logout_redirect_uri=http://127.0.0.1:8003" \
  --data "config.scopes=openid,profile,email,offline_access"
```

The values above can be replaced with their corresponding values for your custom OIDC configuration:

    * `<ENTER_YOUR_CLIENT_ID_HERE>` - Client ID provided by IdP
        * For Example, Google credentials can be found here: https://console.cloud.google.com/projectselector/apis/credentials
    * `<ENTER_YOUR_CLIENT_SECRET_HERE>` - Client secret provided by IdP


Open `partials/auth-js.hbs` from the Example Dev Portal files and set `setAuthStorageType` to `cookie` then upload back to the Dev Portal File API:

```
// auth-js.hbs

<script type="text/javascript">
  window.Auth.setAuthStorageType('cookie')
</script>
```

By default the Example Dev Portal comes with a “Sign in with Google” button, it can be extended to other OIDC IdP, but for our purposes we will demo Google. 

Browse to the login page (see section “**Logging In**”):

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-browser-login.png "Login Page 2")

Click “Sign in with Google” which will take you to the Google login page. Once logged in, Google will redirect you back to the Example Dev Portal and all requests going forward will have the associated authentication session cookie.

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-browser-oath.png "Sign in with Google")

The Default Dev Portal and the OIDC configuration above will provide an `id_token` which will be used to display an avatar:

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-nav.png "Logged in Nav")

## Logging In

Ensure you are logged out (see section “**Logging Out**”). Visit an authenticated page on the Dev Portal. You should see a login form, which is rendered from the `unauthenticated/login` partial. 

When a user submits an HTML form with an attribute `id=”login"` the Dev Portal will:

1. Obtain request **configuration object** for axios requests by:
    1. Calling `window.loginDectorator` (See **Authentication > Javascript Hooks**)
        1. When `window.loginDecorator` doesn't exist
            1. Use configuration stored in local storage (See section **Authentication > How Authentication is Stored in Local Storage**)
                1. When no configuration is stored in local storage
                    1. Use an empty configuration object (e.g. `{}`)
2. Make a request against the Dev Portal File API with the configuration object
3. If Dev Portal File API returns any HTTP response that is not `200 OK`
    1. Store configuration object inside local storage
    2. redirect to original request.
4. If Dev Portal File API returns a 200 HTTP response
    1. execute `window.onLoginError`

> **Note:** Requests with blank configurations will fail against an authenticated Dev Portal Files API, therefore you must make sure the `loginDecorator` exists and returns a valid config object.

### Customize Your Login Form

The Example Dev Portal provides several example login partials:

* `partials/unauthenticated/login.hbs`
    * **Important**: Default partial rendered when a developer attempts to access a page they do not have access to.
* `partials/unauthenticated/login-basicauth.hbs`
* `partials/unauthenticated/login-keyauth.hbs`
* `partials/unauthenticated/login-oidc.hbs`

Example `login.hbs` page demonstrating a basic auth login page with `username:password`:

![alt text](https://konghq.com/wp-content/uploads/2018/03/code-auth.png "Code Snippet")

## How Authentication is Stored in Local Storage

The Dev Portal uses the [Local Storage API](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) to store and retrieve Authentication credentials, parameters, and headers. Local Storage is saved on every successful login, and it is retrieved on every Dev Portal File API request based the `auth-store-types` value. 

Here is an example local storage with `basic-auth` setup:

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-browser4.png "Auth Storage")

Here is an example local storage after a developer (username: `darren`, password: `kong`) has successfully logged in: 

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-browser5.png "Auth Storage 2")

> **Note:** `auth-data` is a base64-encoded object.

## Multiple Authentication

How to setup:

* https://support.konghq.com/hc/en-us/articles/360000602674
* If you have multiple authentication methods enabled, then you will need to handle multiple login forms in your `loginDecorator`. You can do this by checking which `formData` items are present during the login form submission. 
   ```
   function loginDecorator(formData) {
      // If user is submitting a key-auth form, return params
      // with the associated keyauth configured key param name
      if (formData['key']) {
         return { params: { key: formData['key'] } }
      }

      // otherwise return basic auth assuming the only other form
      // submission is basic auth.
      return {
         auth: formData
      }
   }
   ```
* `window.Auth.setAuthStorageType('cookie,basicAuth,params')` should be a **comma separated list** based on which plugins you have enabled on your Dev Portal.

## Logging Out 👋🏻

Any element with `id="logout"` on click will clear the Local Storage authentication data, for example:

```
<button id="logout">Logout</button>
```

> **Note:** When `setAuthStorageType` contains the type `cookie` developers will be redirected to `<PORTAL_API_URI>?logout=true`.

* * *

# [FAQ](#faq)

I am going to [:8003](http://127.0.0.1:8003/) but I only see `{"message":"not found"}`

    * Check your kong.conf configuration file (/etc/kong/kong.conf by default) to ensure the Dev Portal is set to `on`

When I browse to the Dev Portal, it is blank.

* Check a few things:
   * Are there files populated? Browse to [:8004/files](http://127.0.0.1:8004/files) to check. If you don't have any files in your Kong database, then the portal will not render anything.
   * Difference between 127.0.0.1 vs localhost can affect authentication responses. Look into CORS plugin configuration, Kong configuration, and request url to ensure consistency.
   * Which requests, if any, are failing? If you are getting 401 responses, double check proxy + plugin configuration, and make sure unauthenticated files can be requested without credentials
   * Double check spelling of proxy URI with Kong configuration.
   * Check your browser's console and networking output for errors and additional helpful information.

# [Known Limitations](#known-limitations)

The Dev Portal is built with customization of content, look, feel, and structure in mind. That being said there are a few things to keep in mind while building to ensure everything works as expected.

* When a user requests a particular page to access that they are not authorized to view, the Dev Portal will check for the same filename under the '***unauthenticated***' namespace to serve instead. For this reason the '***unauthenticated***' namespace is reserved, and should be used explicitly for authentication.
* The `spec-renderer` plays an integral part in (you guessed it) spec rendering. You will get best results by utilizing the partial for spec rendering needs, or if completely necessary closely following the pattern established by it.
* The Dev Portal routing mechanism seeks out **index.hbs** and** loader.hbs** files to inform certain behaviour (see **File Paths**).  Use these filenames only when you the seek specific functionality they bring to avoid unwanted side affects.
* You cannot upload two files with the same name (regardless of file type).
* The Dev Portal loader only supports template types: `specification`, `partial`, or `page` (while the file API *will* accept other template types, the loader will not recognize them).
* The Dev Portal File API can only fetch a total of 100 files of each type (`specification`, `partial`, or `page`) stored in Kong and served to your Dev Portal.
* The handlebars loader will not serve content that is *not* of file type:
    * `.hbs`  - layout, styles, JavaScript.
        * Media like images, SVGs, and videos should encoded and inserted inline or hosted elsewhere and referenced.
        * Custom JS and CSS (or supported pre-processors) should be nested in `<style>` or `<script>` tags (or served through a CDN) and placed in a partial.
    * `.json` or `.yaml` - spec files.
* Swagger 2 and OpenAPI 3 are the only spec formats currently formated.
* `<meta>`  and `<head>` tags are not modifiable via html, you can accomplish this through custom JS included as a handlebars partial.
* Spec renderer must render API specification served by the Files API - it cannot reference an API served via URL.
* Content in Markdown format is not currently supported.



# **Known Limitations (Internal)**

* When a user requests a particular page to access that they are not authorized to view, the Dev Portal will check for the same filename under the '***unauthenticated***' namespace to serve instead. For this reason the '***unauthenticated***' namespace is reserved, and should be used explicitly for authentication.
* You cannot have more than a total of 100 files of each type (page, partial, spec) stored in Kong and served to your Dev Portal - [link](https://trello.com/c/MSQdeRGa)
* You cannot edit `<meta>`  or `<head>` tags (which do things like set page title and language, add analytics, etc)  which currently exist outside of the portal customization scope (without custom JavaScript). - [link](https://trello.com/c/svPyAnM3/555-research-best-method-to-enable-meta-and-head-tag-modification-by-dev-portal-admin)
* The handlebars loader will not serve content that is *not* of file type:
    * `.hbs`  - layout, styles, JavaScript. - [link](https://trello.com/c/CHzsmdJT/383-add-ability-to-load-and-serve-other-file-types-like-images-videos-etc-in-the-kong-dev-portal)
        * Media like images, SVGs, and videos should encoded and inserted inline or hosted elsewhere and referenced.
        * Custom JS and CSS (or supported pre-processors) should be nested in `<style>` or `<script>` tags (or served through a CDN) and placed in a partial.
    * `.json` or `.yaml` - spec files.
* The loader does not support template types: `specification`, `partial`, or `page` (while the file API *will* accept other template types, the loader will not recognize them).
* You cannot use spec files in formats other than Swagger 2 and OpenAPI 3.
* You cannot upload two files with the same name (regardless of file type).
* Dev Portal cannot work offline after initial requests.
    * https://developers.google.com/web/progressive-web-apps/checklist
* You cannot render your Dev Portal server-side. - [link](https://trello.com/c/hGBuoPWU/538-research-serving-pages-directly-from-lua-to-avoid-client-side-limitations)
* Spec renderer must render API specification served by the Files API - it cannot reference an API served via URL. - [link](https://trello.com/c/pYqhMPk3/492-as-a-dev-portal-admin-i-want-to-refer-to-an-api-spec-by-url-rather-than-by-the-name-of-the-spec-in-the-files-api)
* You cannot write content in Markdown format. - [link](https://trello.com/c/GBfIDj85/)
* Not yet documented: Integrating Dev Portal authentication with existing IAM or IdP systems via things like SAML, OpenID Connect, Active Directory, etc. - [link](https://trello.com/c/yXgKFV9p/500-research-openid-connect-integration-with-authentication-prototype)
* Workflows are not currently offered by which Developers may request access or credentials, and those requests may be reviewed and accepted or rejected by Admins.
* Not yet documented: Using Kong plugins to extend the Kong Dev Portal.
    * Though [Kong Dev Portal - Developer Authentication](https://konghq.quip.com/b3nHAj0QWM6p) is making progress on documenting how to use auth plugins
* Establishing and managing the association between Developers and Consumers.
* Not yet documented: Serving 301 and 302 redirects. https://discuss.konghq.com/t/http-redirect-301/363/2
* Configuring and serving multiple Dev Portal Instances from a single Kong cluster. Our doc (above) used to include the following, but this capability is not present in the currently-shipping Kong Dev Portal feature. 
    * **Instance** = A given Kong cluster can serve more than one **instance** of a Dev Portal. This could be used to have Dev, Staging, and Production Dev Portals, or different Dev Portals for different users and APIs (though typically you'd accomplish that with a single Dev Portal and access controls).
        * **Instances** need not share anything, except that they are served by a given Kong Cluster, and they can be configured to share Admins. 
* Not yet documented: Working with file metadata via the Files API.
* Not yet documented: Documenting different versions of an API.
* Not yet implemented / researched: Code generation / snippets https://trello.com/c/zk5g4VyT/

### Possibilities/Ideas for things to change and improve

* Support Markdown.
* Allow for same filenames by including file type in unique file validation.
* Each page includes all content for the page (header/meta/style).
* Document how to edit `<meta>` and `<head>` using custom JavaScript.
* Document or describe how to work with `LESS` or `SASS` via CI/CD.
