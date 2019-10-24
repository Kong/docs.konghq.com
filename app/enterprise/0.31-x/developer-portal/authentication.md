---
title: Authenticating the Developer Portal
---

## Introduction

- [Enable Authentication](#enable-authentication)
  - [Enable AUTH in Template Files](#enable-auth-in-template-files)
  - [Enable AUTH in JavaScript hooks](#enable-auth-in-javascript-hooks)
- [Add a Consumer](#add-a-consumer)
- [Login to the Dev Portal](#login-to-the-dev-portal)
- [Files](#files)
- [Understanding Dev Portal Routing & Authentication](#understanding-dev-portal-routing-authentication)
- [JavaScript hooks](#javascript-hooks)
- [Example configurations](#example-configurations)
  - [Basic Authentication](#basic-authentication)
  - [Key Authentication](#key-authentication)
  - [Openid-connect](#open-id-connect-plugin)
- [Logging In](#logging-in)
  - [Customize Your Login Form](#customize-your-login-form)
- [How Authentication is Stored in Local Storage](#how-authentication-is-stored-in-local-storage)
- [Multiple Authentication](#multiple-authentication)
- [Logging Out](#logging-out)

## Enable Authentication


First, create an API to proxy requests to the Public Dev Portal Files API:

```bash
curl -i -X POST \
  --url http://127.0.0.1:8001/apis/ \
  --data 'name=portal-files' \
  --data 'upstream_url=http://127.0.0.1:8004' \
  --data 'uris=/portal'
```

Now that we've created our API, update the following line in your Kong Configuration to let Kong know that the Public Dev Portal Files API should point to `:8000/portal` and restart Kong:

```bash
portal_api_uri = 127.0.0.1:8000/portal
```

Next, we need to enable an authentication plugin and apply it our newly created API. You can select from any of the available [Kong plugins](https://konghq.com/plugins/). Let's start with [Basic Authentication:](/plugins/basic-authentication/)

```bash
curl -X POST http://127.0.0.1:8001/apis/portal-files/plugins \
  --data 'name=basic-auth' \
  --data 'config.hide_credentials=true'
```

Now, let's enable the [CORS plugin](/plugins/cors/) so your Dev Portal can make requests from `:8003` → `:8000` and with the appropriate access control headers:

```bash
curl -X POST http://127.0.0.1:8001/apis/portal-files/plugins \
  --data "name=cors" \
  --data "config.origins=http://127.0.0.1:8003" \
  --data "config.methods=GET, POST" \
  --data "config.credentials=true"
```

Now that we have setup authentication for your Dev Portal File API, your developers won't be able to access any of your files without credentials. What about access to **unauthenticated files,** files that have the flag `auth` set to `false`, such as landing pages, and the login form?

Let's create another API to grant access to unauthenticated files:

```bash
curl -i -X POST \
  --url http://127.0.0.1:8001/apis/ \
  --data 'name=portal-files-unauthenticated' \
  --data 'upstream_url=http://127.0.0.1:8004/files/unauthenticated' \
  --data 'uris=/portal/files/unauthenticated'
```

> The  `:8004/files/unauthenticated` endpoint filters and returns an array of files stored in Kong that have the flag `auth` set to `false`

Now add the CORS plugin:

```bash
curl -X POST http://127.0.0.1:8001/apis/portal-files-unauthenticated/plugins \
  --data "name=cors" \
  --data "config.origins=http://127.0.0.1:8003" \
  --data "config.methods=GET, POST" \
  --data "config.credentials=true"
```

You should now see that [:8000/portal/files](http://127.0.0.1:8000/portal/files) requires Basic Authentication headers, while [:8000/portal/files/unauthenticated](http://127.0.0.1:8000/portal/files/unauthenticated) will pass through and return unauthenticated files.

Other auth plugins are also provided and are explained in more detail in “[Example configurations](#example-configs)”:

* [Key Authentication](/plugins/key-authentication/)
* [OpenID Connect-EE](/plugins/ee-openid-connect/)

Next, we will tell the Dev Portal that authentication is enabled by manipulating a few files.

### Enable AUTH in Template Files

Ensure all files have `auth=true` by editing the auth flags inside these partials:

* `header.hbs`
* `layout.hbs`
* `unauthenticated/header.hbs`
* `unauthenticated/layout.hbs`

{% raw %}
```handlebars
{{> unauthenticated/login-actions auth=true}} <!-- Default is auth=false -->
```
{% endraw %}

This will allow authentication items such as login buttons and `auth-js.hbs` JavaScript to display in the Dev Portal.

### Enable AUTH in JavaScript hooks

After you have set `auth=true` in your Files, you will need to tell the Dev Portal how you are storing/retrieving credentials. In the `unauthenticated/auth-js` partial, set the type to `'basicAuth'` and return a JavaScript auth config associated with basic authentication:
   
   ```js
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

Next, [add a Kong consumer](/enterprise/{{page.kong_version}}/getting-started/adding-consumers/) with [credentials](/plugins/basic-authentication/#create-a-credential) that are associated with your Basic auth plugin.

### Login to the Dev Portal

Browse to [:8003](http://127.0.0.1:8003/) and view the Dev Portal. Click the Login button and enter the username and password of your newly created Kong Consumer with enabled Basic Authentication credentials.

Congratulations! You have now authenticated your Dev Portal.

For more information and details on configuring other authentication methods, keep reading!

> If your Dev Portal does not render after following these steps, check out the [FAQ](/enterprise/{{ page.kong_version }}/developer-portal/faq/).

## Files

### Unauthenticated Pages

When authentication is enabled, these pages are served to users who are not authenticated.
  
**pages/user.hbs**

  - Page which displays current users data such as their picture, name, and email.

**pages/unauthenticated/404.hbs**
  
  - The page visitors get when they navigate to a non-existent URL and are not logged in.

**pages/unauthenticated/index.hbs**
  
  - The page that is served when visitors access the root URL of your Dev Portal and are not logged in. 

**pages/unauthenticated/login-basicauth.hbs**
**pages/unauthenticated/login-keyauth.hbs**
**pages/unauthenticated/login-oidc.hbs**
**pages/unauthenticated/login.hbs**

  - These pages control authentication for your Dev Portal. See “**Custom Login Form Pages**” for more information on these files.

### Unauthenticated Partials

**partials/unauthenticated/theme-css.hbs**

  - This partial defines the styling of the Example Dev Portal.  It can be modified as a base theme, or removed entirely in favor of your own styles.
  - See **Customizing the Kong Dev Portal** section for more details.

**partials/unauthenticated/custom-css.hbs**
  
  - This partial defines override styling for the Dev Portal.  Use this to modify the underlying theme without compromising its content, or feel free to remove if not needed. 
  - See **Customizing the Kong Dev Portal** section for more details.

**partials/unauthenticated/layout.hbs**
  
  - Base layout template for the Developer Portal which contains references to the `header`, `footer`, `theme-css`, `custom-css`, and `title` partials. The base layout can be extended using inline partial references inside of **Pages**. An example is the `unauthenticated/login.hbs` page.

**partials/unauthenticated/login-actions.hbs**

  - Partial that displays login/logout functionality based off of authentication status, as well as a user avatar if the `openid-connect` plugin is being used.

**partials/unauthenticated/footer.hbs**
  
  - The default Dev Portal footer partial for both unauthenticated & authenticated users.

**partials/unauthenticated/header.hbs**

  - The default Dev Portal header partial for unauthenticated users.

**partials/unauthenticated/title.hbs**

  - This partial sets the page title using `window.document.title` and is used for all users.

**partials/unauthenticated/auth-js.hbs**

  - Authentication utilities - See **JavaScript Hooks** section below for more details.


## Understanding Dev Portal Routing & Authentication

![alt text](https://konghq.com/wp-content/uploads/2018/03/diagram-auth-routing.png "Auth Routing Diagram")

The Dev Portal router runs through a series of steps to determine which files to serve based on the user's authentication status. Let's explore how the Dev Portal router handles authentication by playing with an instance of the Example Dev Portal.

Before we start, check that you:

1. Have an instance of the Example Dev Portal running (see **Getting Started**)
2. Authentication is enabled and configured (see **Authentication > Getting Started**)


Lets first create two test pages that will simply illustrate whether we are viewing an authenticated or unauthenticated page.

1.  `pages/test.hbs`
    1. Create a file named `pages/test.hbs` and open it in your favorite text editor.
    2. Insert the code below into the file and save:

        ```html
        <h1>This is an authenticated test page</h1>
        ```

    3. Upload `pages/test.hbs` to the Dev Portal File API with the following command:
       
        ```bash
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
      
        ```bash
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

```js
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

```js
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

```js
function onLoginError(error) {
  console.error(error)
  alert('Authentication failed')
}
window.onLoginError = onLoginError
```

## Example configurations

### Basic Authentication

Check out the section “**Enabling Authentication”** for a step by step guide on setting up [Basic Authentication](/plugins/basic-authentication/).

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-browser4.png "Basic Auth")

```js
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

The [Key Authentication Plugin](/plugins/key-authentication/) allows developers to use API keys to authenticate requests against an API. This is useful when consumers have an API Key rather than a username/password.

Add the key auth plugin to the `portal-files` API:

```bash
curl -X POST http://`127.0.0.1`:8001/apis/portal-files/plugins \
  --data "name=key-auth" \
  --data "config.key_names=key" \
  --data "config.hide_credentials=true"
```

> **Note:** If you have Basic Auth enabled from the earlier steps, unless you take special steps to enable multiple auth, you should disable other auth methods.

Your `unauthenticated/login` partial should have an input name that can be referenced in the `loginDecorator`, such as `key`.  see an example below:

```js
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

The [OpenID Connect Plugin](/plugins/ee-openid-connect/) allows you to hook into existing authentication setups using third-party *Identity Providers* (**IdP**) such as Google, Yahoo, Microsoft Azure AD, etc. 

[OIDC](/plugins/ee-openid-connect/) must be used with the “session” method, utilizing cookies for Dev Portal File API requests.

Add the `openid-connect` plugin to the `portal-files` API:

```bash
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

  - `<ENTER_YOUR_CLIENT_ID_HERE>` - Client ID provided by IdP
        * For Example, Google credentials can be found here: https://console.cloud.google.com/projectselector/apis/credentials
  - `<ENTER_YOUR_CLIENT_SECRET_HERE>` - Client secret provided by IdP


Open `partials/auth-js.hbs` from the Example Dev Portal files and set `setAuthStorageType` to `cookie` then upload back to the Dev Portal File API:

```js
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
    - Calling `window.loginDectorator` (See **Authentication > JavaScript Hooks**)
      - When `window.loginDecorator` doesn't exist
        - Use configuration stored in local storage (See section **Authentication > [How Authentication is Stored in Local Storage](#how-authentication-is-stored-in-local-storage)**)
          - When no configuration is stored in local storage
            - Use an empty configuration object (e.g. `{}`)

2. Make a request against the Dev Portal File API with the configuration object
3. If Dev Portal File API returns any HTTP response that is not `200 OK`
    - Store configuration object inside local storage
    - redirect to original request.

4. If Dev Portal File API returns a 200 HTTP response
    - execute `window.onLoginError`

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
   
   ```js
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

```html
<button id="logout">Logout</button>
```

> **Note:** When `setAuthStorageType` contains the type `cookie` developers will be redirected to `<PORTAL_API_URI>?logout=true`.
