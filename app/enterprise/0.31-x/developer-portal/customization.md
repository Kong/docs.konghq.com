---
title: Customizing the Kong Developer Portal
class: page-install-method
---

# Customizing the Kong Developer Portal

Now that you have the Example Dev Portal running and you understand how files interact with and are served by the Dev Portal Loader, lets go through the steps of customizing the look and feel of the Example Dev Portal.

In order to customize the Example Dev Portal, you generally follow these steps:

1. Issue a `GET` command to `:8001/files` to see a list of all your Dev Portal Files.
2. Take the `contents` of the file(s) you would like to modify and edit them to your liking in a local editor. <br><br>Alternatively, you can create new files using `POST` requests if you do not wish to modify existing files.
3. `PATCH` the files back into Kong using the `:8001/files/<filename>` endpoint.
4. Reload the Dev Portal in your browser - you'll see the results of the changes you made.


Going forward, we will be modifying and updating the files from the Example Dev Portal file archive.

## Uploading your Specification file

1. Find your Specification file in your filesystem, it should be either a Swagger `json` or `yaml` file.
    - Should you not have one, we can use the Swagger Pet Store Example: [Download File](http://petstore.swagger.io/v2/swagger.json)
2. Upload the Specification with the following curl request in your terminal (relative to the file):

    ```bash
    curl -X POST http://127.0.0.1:8001/files \
          -F "type=spec" \
          -F "name=swagger" \
          -F "contents=@swagger.json"
    ```

  > Note: The `@` symbol in the `curl` command will automatically read the file on disk and place its contents into the `contents` argument.

Now let's update **pages/documentation/api1.hbs** to render our newly added Specification file:

1. Find the `pages/documentation/api1.hbs` file in your Example Dev Portal Archive
2. Find the following line of code:

    {% raw %}
    ```handlebars
      {{> spec-renderer spec="petstore"}}
    ```
    {% endraw %}

3. Change: `petstore`  →  `swagger`
4. Now make a `PATCH` request to update the page against the Dev Portal File API in your terminal (note, no extension on the filename in the url):

    ```bash
    curl -X PATCH http://127.0.0.1:8001/files/documentation/api1 \
          -F "contents=@pages/documentation/api1.hbs"
    ```

5. Lastly, navigate to `:8003/documentation/api1` in your browser, you should see that the specification has changed and should look like the following (assuming you used the petstore swagger file from above):

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-petstore.png "Screen Petstore")

## Customizing the look and feel of your Dev Portal

The Dev Portal default theme is shipped with two CSS file partials:

* `partials/unauthenticated/theme-css.hbs`
    * Default styles for all theme specific elements across the Example Dev Portal.
* `partials/unauthenticated/custom-css.hbs`
    * Partial describing how to change specific parts of the portal without modifying the default theme CSS.

We strongly encourage you to use the `custom-css` over modifying `theme-css` for small changes so you don't affect the original styles and get unwanted collateral damages.

For this example, this is what we're going to do:

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-nav3.png "Navbar Edited")

### Structure

1. Find and open the `partials/header.hbs` file from the Example Dev Files archive you downloaded earlier.
2. Change the content inside of the `.logo` element to `Dev Portal`

    ```html
    <a class="logo" href="/">Dev Portal</a>
    ```

3. Change `Developers` → `My Company Developers`:

    ```html
    <span>My Company Developers</span>
    ```

4. Update the file by sending a `PATCH` request from your terminal to the Dev Portal File API:

    ```bash
    curl -X PATCH http://127.0.0.1:8001/files/header \
          -F "contents=@partials/header.hbs"
    ```

5. Refresh the Example Dev Portal. You should see something similar to below (don't worry, we are going to make it look better after we change the styles):

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-nav4.png "Navbar Edited")

### Style

1. Find and open `partials/unauthenticated/custom-css.hbs` in the Example Dev Files directory.
2. Let's start by changing the header background, and text colors by adding:

    ```css
    #header {
        background-color: #033151;
        color: #FFFFFF;
    }
    ```

3. Next, we're going to change the font color in the navigation from blue to white by adding:

    ```css
    .navigation > li > a,
      #headerSpecDropdownWrapper > .header-text {
        color: hsla(255, 100%, 100%, .45) !important;
    }
    ```

4. Almost there, now let's change the logo text to white, increase its size, and update the separator color:

    ```css
    #header .header-logo-container .logo {
        color: white;
        font-size: 20px;
        font-weight: 700;
        border-right-color: hsla(255, 100%, 100%, .45);
    }
    ```

5. Save the file and send a `PATCH` request in your terminal to the Dev Portal File API to update it:

    ```bash
    curl -X PATCH http://127.0.0.1:8001/files/custom-css \
          -F "contents=@partials/custom-css.hbs"
    ```

6. Refresh the Example Dev Portal in your browser and now it should look like this:

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-home2.png "Homepage Edited")

## Working with Page Layouts

To avoid duplicating code in pages and partials, layout partials can be created and used on multiple pages that share common layout.

The Example Dev Portal includes one basic layout: `partials/layout.hbs`
{% raw %}
```handlebars
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
{% endraw %}

Let's create a new page using this template.

## Creating a New Page

We're going to create something super simple, a Hello World page using the `layout` template described above:

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-hello-world2.png "Hello World 2")

1. Create a new file with the name `example.hbs` in your Example Dev Portal files directory under the `pages/` directory.
2. In the file we just created, let's add the following code (the handlebars syntax for opening a partial block):

    {% raw %}
    ```handlebars
    {{#> layout pageTitle="Hello World" }}
    ```
    {% endraw %}

    Note: The `pageTitle` attribute allows you to easily change the title of the page displayed in the browser. Here we have set it to `Hello World`.

3. Now let's add the actual content. When using the layout template, content on the page must be placed **inside** an [inline partial block](http://handlebarsjs.com/partials.html) named `content-block` like so:

   {% raw %}
    ```handlebars
    {{#*inline "content-block"}}
      <div class="app-container">
          <div class="page-wrapper indent">
            <h1>Hello world</h1>
            <p>This is a Sample Page</p>
          </div>
      </div>
    {{/inline}}
    ```
    {% endraw %}

4. Now let's close out the layout block:

    {% raw %}
    ```handlebars
    {{/layout}}
    ```
    {% endraw %}

5. Your file should now look like:

    {% raw %}
    ```handlebars
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
    {% endraw %}

6. Add it to Kong specifying the file as a page:

    ```bash
    curl -X POST http://127.0.0.1:8001/files \
          -F "name=example" \
          -F "type=page" \
          -F "contents=@pages/example.hbs" \
          -F "auth=true"
    ```

    - To learn about the `auth` flag see the **Adding Authentication** section.
    - Note that the name must match that used in the handlebars file (example and example.hbs in this sample)

...We're done, this is how our page should look:

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-hello-world2.png "Dev Portal Hello World")

## Add New Page to the Nav

Previously we created `example.hbs`, let's add it to the Developer Portal navigation so its accessible to everyone:

1. Find and open `partials/header.hbs` in the Example Dev Portal file directory.
2. Open it in your favorite text editor and find the `nav` container, it should look like:

    {% raw %}
    ``` handlebars
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
    {% endraw %}

3. Let's add the following line:

    ```
    <li>
      <a href="/example">Example</a>
    </li>
    ```

4. Your `nav` block should now look like:

    {% raw %}
    ``` handlebars
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
    {% endraw %}

5. Finally let's update it using the Dev Portal File API:

    ```bash
    curl -X PATCH http://127.0.0.1:8001/files/header \
         -F "contents=@partials/header.hbs"
    ```

6. Once uploaded, refresh your Dev Portal and you should see the change:

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-nav2.png "Edited Nav")

## Link From One Dev Portal Page to Another

1. Add a link in the code of a page or partial like:

    ```html
     <a href="/example">Example</a>
    ```

  - This will link to a Page with `name=example`

2. To link to an anchor or section within `/example`, ensure the target includes an unique id:

    ```html
    <div id="details">Details Here</div>
    ```

3. Your link should look like:

    ```html
    <a href="/example#details">Example</a>
    ```

4. Update the page you edited via the Dev Portal File API and reload that page - you should see the link you added, and when you click it, it will take you to the linked page, and, if you coded it, to the anchor.

## Adding Image, Video, or other file types to a Page

The Dev Portal File API serves only **Pages**, **Partials**, and **Specifications**. To add images, videos, and other file types to your pages, you must either add them inline (e.g. inline SVG) or link to the files being served by some other web server.
