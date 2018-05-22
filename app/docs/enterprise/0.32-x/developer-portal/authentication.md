---
title: Authenticating the Developer Portal
book: portal
chapter: 6
---

# Authenticating the Kong Developer Portal

- [Enable Authentication](#enable-authentication)
- [Developer Registration](#developer-registration)
  - [Login as Your New Developer](#login-as-your-new-developer)
- [Example configurations](#example-configurations)
  - [Basic Authentication](#basic-authentication)
  - [Key Authentication](#key-authentication)
  - [OpenID Connect](#open-id-connect-plugin)
- [Logging In](#logging-in)
  - [Customize Your Login Form](#customize-your-login-form)
- [Logging Out](#logging-out)
- [Files](#files)
- [Understanding Dev Portal Routing & Authentication](#understanding-dev-portal-routing-authentication)
- [JavaScript hooks](#javascript-hooks)
- [How Authentication is Stored in Local Storage](#how-authentication-is-stored-in-local-storage)


> Before you begin, make sure you have gone through the [Getting Started with the Dev Portal](https://getkong.org/docs/enterprise/latest/developer-portal/getting-started/#getting-started-with-the-kong-developer-portal)

## Enable Authentication

First, we will configure the portal using [Basic Authentication](https://getkong.org/plugins/basic-authentication). Update the following in your Kong Configuration, then restart Kong:

```
portal_auth = basic-auth
```

The Dev Portal templates are now aware that the Dev Portal is authenticated. Browse to the Dev Portal and you should see [Login](#developer-login) and [Sign Up](#developer-registration) links in the top right navigation. 

> Note: Once Kong starts, you will notice that your [Admin API configuration](https://127.0.0.1:8001/) now shows `cors` and `basic-auth` plugins are enabled. This is because Kong sets up an internal proxy to the Portal API (e.g. `:8004` -> `:8000/_kong/portal`) and configures a Basic Authentication plugin applied only to the `/files` route. These routes &amp; services will be tracked by Kong Vitals and appear in your proxy traffic, but the internal plugins will not be applied to any other routes or services or be configurable in your Kong instance.

The Dev Portal supports other Authentication plugins which are explained in more detail under [Example configurations](#example-configs):

* [Key Authentication](https://getkong.org/plugins/key-authentication)
* [OpenID Connect-EE](https://getkong.org/plugins/ee-openid-connect/)

## Developer Registration

Developers are now able to request access to your Dev Portal via the `unauthenticated/register` partial. Any `<input />` field inside this partial will be submitted to the `http://127.0.0.1:8000/_kong/portal/register` endpoint and a Developer credential is created upon registration. The Developer will not be able to use this credential until they are approved. See [Approving Developers](/docs/enterprise/{{page.kong_version}}/developer-portal/managing-developers#approving-developers).

Browse to [http://127.0.0.1:8003/register](http://127.0.0.1:8003/register) and fill out the form. Remember your password so that once you are approved, you can use this password to login.

Required Registration fields by Authentication plugin:

  - Basic Authentication: 

      ```html
      <input type="text" name="email" required />
      <input type="password" name="password" required />
      ```

  - Key Authentication: 

      ```html
      <input type="text" name="email" required />
      <input type="text" name="key" required />
      ```

  - Open-ID Connect:

      ```html
      <input type="text" name="email" required />
      ```
> **Note:** All plugins require the email input since Developers will register and be unique by email.

### Collecting More Data on Registration

Additional information can be stored for the Developer inside the `meta` data attribute. This field is stored in the Kong datastore on the Developer entity and will be visible to you, a Kong Admin. 

The default Dev Portal theme demonstrates this through the "full_name" input: 

```html
<input type="text" name="full_name" required />
```

This is helpful if you want to get more information (e.g. "referral source", "phone-number", "company", "team" etc.) Meta tags are stored in plain text, so be careful not to store sensitive information in meta.

### Login As Your New Developer

After you have [approved](/docs/enterprise/{{page.kong_version}}/developer-portal/managing-developers#approving-developers) a Developer that has [requested access](#developer-registration):

1. browse to [http://127.0.0.1:8003] (i.e. `portal_gui_url`)
1. click the Login button. 
1. Enter the username and password of your newly registered Developer.
1. click the Login button

You should now be redirected to [http://127.0.0.1:8003/dashboard] where, as a Developer, you can begin [managing your Developer credentials](/docs/enterprise/{{page.kong_version}}/developer-portal/developer-access)

For more information and details on configuring other authentication methods, and [Logging In](#logging-in) keep reading!

> If your Dev Portal does not render after following these steps, check out the <a href="/docs/enterprise/{{page.kong_version}}/developer-portal/FAQ">FAQ</a>.

## Example configurations

### Basic Authentication

Check out the section "**Enabling Authentication"** for a step by step guide on setting up [Basic Authentication](https://getkong.org/plugins/basic-authentication).

### Key Authentication

The [Key Authentication Plugin](https://getkong.org/plugins/key-authentication) allows developers to use API keys to authenticate requests, and can be used to authenticate the developer portal. This is useful when you would prefer a Developer to only have a single API Key to login, rather than a username/password.

Update the following in your Kong Configuration, then restart Kong:

```
portal_auth = key-auth
```

Browse to the Dev Portal and you should now see [Login](#developer-login) and [Sign Up](#developer-registration) links in the top right navigation. These forms will reflect that a developer will now only need an API Key to register and login.

### Open-ID Connect Plugin

The [OpenID Connect Plugin](/plugins/ee-openid-connect/) allows you to hook into existing authentication setups using third-party *Identity Providers* (**IdP**) such as Google, Yahoo, Microsoft Azure AD, etc. 

[OIDC](/plugins/ee-openid-connect/) must be used with the `session` method, utilizing cookies for Dev Portal File API requests.

Update the following in your Kong Configuration, then restart Kong:

```
portal_auth = openid-connect
```

Add the `openid-connect` configuration to `portal_auth_conf` using valid [JSON](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON). Here is an example configuration:

```
portal_auth_conf = {                                               \
  "issuer": "https://accounts.google.com/",                        \
  "client_id": "<ENTER_YOUR_CLIENT_ID_HERE>",                      \
  "client_secret": "<ENTER_YOUR_CLIENT_SECRET_HERE>",              \
  "consumer_by": "username,custom_id,id",                          \
  "ssl_verify": "false",                                           \
  "consumer_claim": "email",                                       \
  "leeway": "1000",                                                \
  "login_action": "redirect",                                      \
  "login_redirect_mode": "query",                                  \
  "login_redirect_uri": "http://127.0.0.1:8003",                   \
  "forbidden_redirect_uri": "http://127.0.0.1:8003/unauthorized",  \
  "logout_methods": "GET",                                         \
  "logout_query_arg": "logout",                                    \
  "logout_redirect_uri": "http://127.0.0.1:8003",                  \
  "scopes": "openid,profile,email,offline_access"                  \
}
```

The values above can be replaced with their corresponding values for your custom OIDC configuration:

  - `<ENTER_YOUR_CLIENT_ID_HERE>` - Client ID provided by IdP
        * For Example, Google credentials can be found here: https://console.cloud.google.com/projectselector/apis/credentials
  - `<ENTER_YOUR_CLIENT_SECRET_HERE>` - Client secret provided by IdP

<video width="100%" autoplay loop controls>
  <source src="https://konghq.com/wp-content/uploads/2018/05/May-17-2018-13-52-15_.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

By default the Example Dev Portal comes with a "Sign in with Google" button, but you can override this button in the `unauthenticated/login` partial. See [Customize Your Login Form](#customize-your-login-form)

Browse to the login page (see section [Logging In](#logging-in)). Click "Sign in with Google" which will take you to the Google login page. Once logged in, Google will redirect you back to the Example Dev Portal and all requests going forward will have the associated authentication session cookie. The Default Dev Portal and the OIDC configuration above will provide an `id_token` which will be used to display a Developer's avatar.

## Logging In

Ensure you are logged out (see section [Logging Out](#logging-out)). Visit an authenticated page on the Dev Portal. You should see a login form, which is rendered from the `unauthenticated/login` partial. 

When a Developer submits an HTML form with an attribute `id="login"` the Dev Portal will make a request against the Dev Portal File API using the specified `portal_auth` with the data in the form. For instance, if you have `basic-auth` enabled, then the form will submit with the Authorization header e.g. `Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=`. If the Login returns a response with a status code that is not `200`, then it runs `onLoginError`.

### Customize Your Login Form

The Example Dev Portal provides the `partials/unauthenticated/login.hbs` file and **is required** to exist in order for authentication functionality to work. This partial is rendered when a developer attempts to access a page they do not have access to. You can customize this page's styles or add/update any marketing copy, but the `<input />` elements are required when using [Basic Authentication](#basic-authentication) or [Key Authentication](#key-authentication).

## Logging Out 👋🏻

Any element with `id="logout"` on click will clear the Local Storage authentication data, for example:

```html
<button id="logout">Logout</button>
```

> **Note:** When using `openid-connect`, developers will be redirected to `<PORTAL_API_URI>?logout=true`, clearing the session cookie. This config should be set inside the openid-connect plugin configuration inside `portal_auth_conf`. See the section on [configuring the Open-ID Connect Plugin](#open-id-connect-plugin)


## Files

### Unauthenticated Pages

When authentication is enabled, these pages are served to developers who are not authenticated.
  
**pages/user.hbs**

  - Page which displays current users data such as their picture, name, and email.

**pages/unauthenticated/404.hbs**
  
  - The page visitors get when they navigate to a non-existent URL and are not logged in.

**pages/unauthenticated/index.hbs**
  
  - The page that is served when visitors access the root URL of your Dev Portal and are not logged in. 

**pages/unauthenticated/login.hbs**

  - This page controls authentication for your Dev Portal. See ["Customize Your Login Form"](#customize-your-login-form)

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

![alt text](https://konghq.com/wp-content/uploads/2018/05/dev_portal_auth_flow.png "Auth Routing Diagram")

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
    
    ![alt text](https://konghq.com/wp-content/uploads/2018/05/unauthed-message.png "Authenticated Page")

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
    
     ![alt text](https://konghq.com/wp-content/uploads/2018/05/unauthed-message2.png "Unauthenticated Page")

Now that we have created our two test pages, let's take a look at how the Dev Portal deals with authenticated/unauthenticated routes.

**Authenticated Flow:**

1. If you are not already, login to the Example Dev Portal (see section [Logging In](#logging-in)).
2. Navigate to [:8003/test](http://127.0.0.1:8003/test) in your browser, you should see a header stating *"This is an authenticated test page".*
    1. The Developer Portal went through the following flow:
        1. Search for a page named **test** *There is!*
        2. Check to ensure that you have authorization to access the page. *You do!*
        3. Serve **test** page to the browser.

> **Note:** You can still access the unauthenticated test page by navigating to [:8003/unauthenticated/test](http://127.0.0.1:8003/unauthenticated/test) in the browser.

**Unauthenticated Flow:**

1. If you have not already, log out of the Dev Portal (see section [Logging Out](#logging-out)).
2. Navigate to [:8003/test](http://127.0.0.1:8003/test) in your browser, you should see text stating *"This is an unauthenticated test page"*.
3. Notice that although the path **/test** requests `test.hbs` (our authenticated page), we are served `unauthenticated/test.hbs`.
    1. The Developer Portal went through the following flow:
        1. Parse the path `/test` to determine we would like to serve a page named **test**.
        1. Search for a page named **test**. *There is!*
        1. Ensure that you have authorization to access the page. *You don't. You are not currently logged in and the page requires authentication.*
        1. Check to see if there is a page named **unauthenticated/test**. *There is!*
        1. Ensure that you have authorization to access the page. *You do!*
        1. Serve the **unauthenticated/test** page to the browser.

> **Note:** As illustrated by the above example, when a user requests a particular page to access that they are not authorized to view, the Dev Portal will check for the same filename under the 'unauthenticated' namespace to serve instead. For this reason the 'unauthenticated' namespace is reserved, and should be used explicitly for authentication

> **Note pt. 2:** Requesting a page while unauthenticated that both requires auth, and does not have a corresponding page under the 'unauthenticated' namespace will result in a 404.  You can test this by requesting pages like [:8003/guides](http://127.0.0.1:8003/guides) or [:8003/about](http://127.0.0.1:8003/about) while unauthenticated.

## JavaScript hooks

You can find these functions in the `unauthenticated/auth-js` partial in the Example Dev Portal. They allow you to hook into the Dev Portal authentication behavior through javascript functions.

**onLoginError**

Customize how your form submit will handle errors, as well as customize default error messages:

```js
/*
 * When a user attempts to log in, but authentication fails.
 */
function onLoginError(error) {
  var resp = error.response
  var errorMessages = {
  // Note: Approved developers will not receive an error, so this is
  // here only for status type documentation purposes.
  // 0: {
  //  status: 'approved',
  //  message: ""
  // },
    1: {
      status: 'requested',
      message: "You have requested access, but your account is pending approval."
    },
    2: {
      status: 'rejected',
      message: "This account has been rejected."
    },
    3: {
      status: 'revoked',
      message: "This account has been revoked."
    }
  }
  
  /**
   *  Parse error response and utilize Kong function getMessageFromError helper
   */
  var errorMessage = errorMessages[resp.data.status] 
                       && errorMessages[resp.data.status].message 
                       || window.getMessageFromError(error)
  alert('Login failed. ' + errorMessage)
}

/* 
 * When a user attempts to register, but registration fails.
 */
function onRegistrationError(error) {
  alert('Registration failed. ' + window.getMessageFromError(error))
}

/**
 * When a user registers successfully, you can customize
 * where they are redirected. By default, they are redirected
 * to the index route '/', PORTAL_GUI_URL
*/
function onRegistrationSuccess() {
  alert('Thank you for registering! Your request will be reviewed.')
  window.navigateToHome() // Navigates to PORTAL_GUI_URL
}
```

## How Authentication is Stored in Local Storage

The Dev Portal uses the [Local Storage API](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) to store and retrieve Authentication credentials, parameters, and headers. Local Storage is saved on every successful login, and it is retrieved on every Dev Portal File API request based the `auth-store-types` value, until you [logout](#logging-out). 

> **IMPORTANT**: Local Storage Authentication credentials are stored in the browser via base64-encoding, but are not encrypted. Any javascript executed on the same domain as your Dev Portal can access these values so it advised that you always used SSL/TLS and either use openid-connect to secure your developer portal (as it uses javascript inaccessible HTTP-only encrypted cookies), or limit the amount of third-party javascript injected on your Developer Portal to prevent [XSS vulnerabilities](https://developer.mozilla.org/en-US/docs/Glossary/Cross-site_scripting).

> **Note:** Openid-connect uses cookies to persist authentication, and therefore does not use Local Storage.

+Next: [Learn about Dev Portal Networking &rsaquo;]({{page.book.next}})

