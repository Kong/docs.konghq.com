---
title: Kong Enterprise Changelog
---

## 0.34-1 - 2018/12/19

**Notifications**
- **Kong EE 0.34** inherits from **Kong CE 0.13.1**; make sure to read 0.13.1 - and 0.13.0 - changelogs:
  - [0.13.0 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0130---20180322)
  - [0.13.1 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0131---20180423)
- **Kong EE 0.34** has these notices from **Kong CE 0.13**:
  - Support for **Postgres 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with Postgres 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon

**CHANGES**
- **Kong Manager**
  - Email addresses are stored in lower-case. These addresses must be case-insensitively unique. In previous versions, you could store mixed case email addresses. A migration for Postgres converts all existing email addresses to lower case. Cassandra users should review the email address of their admins and developers and update them to lower-case if necessary. Use the Kong Manager or the Admin API to make these updates.
- **Plugins**
  - **Forward Proxy**
    - Do not do a DNS request to the original upstream that would be discarded anyway as proxy will manage the resolving of the configured host.
  - **OpenID Connect**
    - Remove obsolete daos (adds migration)
    - Hide secret from Admin API (used with sessions)
    - Bump lua-resty-session to 2.23
    - Change token verification to check token types when requested

**FEATURES**
- **Dev Portal**
  - [kong_portal_templates](https://github.com/Kong/kong-portal-templates) repository:
    - A public repository containing dev portal themes, examples, and dev tools for working with the Dev Portal template files.
  - sync.js:
    - Script which allows dev portal developers to `push`, `pull`, and `watch` the most up to date template files to and from kong to their local machine.
  - default portal theme:
    - Directory containing the most up to date version of the default portal template files that ship with Kong EE each release.
  - Bugfixes, updates, and template features will be pushed here regularly and independently of the EE release cycle.
  - Dev Portal now caches static JS assets
- **Plugins**
  - **OpenID Connect**
    - add `config.http_proxy_authorization` (note: this is not yet in upstream lua-resty-http)
    - add `config.https_proxy_authorization` (note: this is not yet in upstream lua-resty-http)
    - add `config.no_proxy`
    - add `config.logout_revoke_access_token`
    - add `config.logout_revoke_refresh_token`
    - add `config.refresh_token_param_name`
    - add `config.refresh_token_param_type`
    - add `config.refresh_tokens`
- **CORE**
  - **License**
    - Added an increasingly "loud" logging to notify via nginx logs as the expiration date approaches.
      - 90 days before the expiration date: Daily WARN log
      - 30 days before the expiration date: Daily ERR log
      - After the expiration date: Daily CRIT log
  - **DB**
    - **Cassandra**
      - Support request-aware load-balancing policies in conf &
        DAOs. `cassandra_lb_policy` now supports two new
        policies RequestRoundRobin and RequestDCAwareRoundRobin.

**FIXES**
- **Admin API**
  - Prevent creating or modifying developers and admins through the
    /consumers endpoints
  - Prevent creating or modifying consumers through the /admins
    endpoints
  - Fix error on /admins when trying to create an admin with the
    same name as an existing RBAC user
  - Roll back if a POST to /admins fails
- **Dev Portal**
  - KONG_PORTAL_AUTH_CONF param values can now handle escaped
    characters such as #
  - ACL plugin credential management no longer accessible from Dev
    Portal client
  - "Return to login" CTA on the password-reset page now redirects
    to appropriate workspace
  - Improved support for OAS 3 specifications
  - General SwaggerUI improvements
  - Developer approval email will only send once (on first
    approval).  A developer will not receive an additional email if
    they are revoked and re-approved.
- **Kong Manager**
  - When creating a new workspace, always create roles for that workspace
  - List workspace roles in alphabetical order
  - Provide a button on the Admin show page to generate a registration URL
  - Fix misleading error message when adding an existing user to a
    new workspace
  - Add validation of image type when creating a workspace with an avatar
  - Add configuration fields and icon for the JWT signer plugin
  - Clean up console errors due to lack of permissions
  - Make the UTC button on Vitals charts work in Firefox
  - Change the display order of plugins to match the Plugin Hub
- **CORE**
  - **Workspaces**
    - When removing an entity from a workspace, delete the entity
      itself if it only belongs to that workspace.
    - Developers nor admins do not affect consumer counters in
      workspaces. Only proxy consumers do.
  - **DB**
    - **Cassandra**
      - Fix an issue where Insert operation fails to return an entity as not all Cassandra nodes are synced yet while reading the data.
      - Now Kong will make one try to fetch the inserted row before throwing error. (Fix: https://support.konghq.com/hc/en-us/requests/6217 )
- **Plugins**
  - **Rate-limiting**
    - Use database-based redis connection pool to reduce unnecessary select call
  - **Response-ratelimiting**
    - Use database-based redis connection pool to reduce unnecessary select call
  - **OpenID Connect**
    - Fix schema `self_check` to verify issuer only when given (e.g. when using `PATCH` to update configuration)

## 0.34 - 2018/11/17

**Notifications**
- **Kong EE 0.34** inherits from **Kong CE 0.13.1**; make sure to read 0.13.1 - and 0.13.0 - changelogs:
  - [0.13.0 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0130---20180322)
  - [0.13.1 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0131---20180423)
- **Kong EE 0.34** has these notices from **Kong CE 0.13**:
  - Support for **Postgres 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with Postgres 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon

- **Kong Manager**
  - The name of the `Admin GUI` has changed to `Kong Manager`
- **Licensing**
  - License expiration logs: Kong will start logging the license expiration date once a day - with a `WARN` log - 90 days before the expiry; 30 days before, the log severity increases to `ERR` and, after expiration, to `CRIT`

**CHANGES**
- **Admin API**
  - The system-generated `default` role for an RBAC user is no longer accessible via the Admin API
  - Auto-config OAPI endpoint available for Admin API (configure services & routes via Swagger)
- **Workspaces**
  - Workspaces on Workspaces has been disabled, meaning that workspaces do not apply on `/workspaces/` endpoints
  - Renaming workspaces is no longer allowed
- **Vitals**
  - Now enabled by default when starting Kong for the first time
- **Dev Portal**
  - **Breaking change** - change of config options
  - `portal_gui_url` is removed, and `protocol`, `host`, and `portal_gui_use_subdomains` added
  - `protocol` and `host` replace `portal_gui_url`
  - `portal_gui_use_subdomains` avoids conflicts if base path name matches workspace name
- **Plugins**
  - **Prometheus**
    - **Warning** - Dropped metrics that were aggregated across services in Kong. These metrics can be obtained much more efficiently using queries in Prometheus.
  - **Zipkin**
    - Add kong.node.id tag
  - **Proxy Cache**
    - Add `application/json` to config `content-type`
  - **All logging plugins**
    - Workspace of the request is logged
  - **StatsD Advanced**
    - Add workspace support with new metrics `status_count_per_workspace`
  - **OpenID Connect**
    - NOTE - If using an older version of the OpenID Connect plugin, with sub-plugins, Kong will not start after upgrading to 0.34. Sub-plugins are now disabled by default will be removed completely in subsequent releases. To make sure Kong starts, enable OIDC sub-plugins manually, with the custom_plugins configuration directive - or through the `KONG_CUSTOM_PLUGINS` environment variable; for example:

    Set the following in the kong.conf file:

    ```
    custom_plugins=openid-connect-verification,openid-connect-authentication,openid-connect-protection
    ```
    Or the following environment variable:
    ```
    KONG_CUSTOM_PLUGINS=openid-connect-verification,openid-connect-authentication,openid-connect-protection
    ```
    The all-in-one version of OIDC is enabled by default (and is not deprecated).

    - Always log the original error message when authorization code flow verification fails
    - Optimize usage of ngx.ctx by loading it once and then passing it to functions
    - **Breaking change** - Change config.ssl_verify default to false.

**FEATURES**

- **Dev Portal**
  - Filterable API list
  - Improved portal management in Kong Manager
    - Overview page with quick links to portal, create pages
    - Split out pages, specs, partials for ease of navigation
  - SMTP support and admin/access request workflow improvements
  - Global search
  - Option for one dev portal per workspace, and option to enable within Kong Manager
  - Improved OAS 3.0 support
  - Markdown support
- **Kong Manager**
  - Workspaces are now configurable in Kong Manager
    - Creation, management of workspaces for super admin
    - RBAC assignment globally for super admin
    - Vitals is workspace-aware
  - Support for inviting additional users
  - Self-service credential management
  - General UI cleanup (tables, modals, forms, notifications)
  - New menu/navigation system
- **Vitals**
  - Functionality to support storing Vitals data in Prometheus (via the StatsD Advanced plugin)
  - InfluxDB support for Vitals
- **Plugins**
  - HTTPS support for **Forward Proxy plugin**
  - **Route by header** added to the package - docs can be found [here](https://docs.konghq.com/hub/kong-inc/route-by-header/)
  - **JWT Signer** added to the package - docs can be found [here](https://docs.konghq.com/hub/kong-inc/jwt-signer/)
  - **OpenID Connect**
    - Add `config.unauthorized_error_message`
    - Add `config.forbidden_error_message`
    - Add `config.http_proxy`
    - Add `config.https_proxy`
    - Add `config.keepalive`
    - Add `config.authenticated_groups_claim`
    - Add `config.rediscovery_lifetime`
    - Add support for `X-Forwarded-*` headers in automatic `config.redirect_uri` generation
    - Add `config.session_cookie_path`
    - Add `config.session_cookie_domain`
    - Add `config.session_cookie_samesite`
    - Add `config.session_cookie_httponly`
    - Add `config.session_cookie_secure`
    - Add `config.authorization_cookie_path`
    - Add `config.authorization_cookie_domain`
    - Add `config.authorization_cookie_samesite`
    - Add `config.authorization_cookie_httponly`
    - Add `config.authorization_cookie_secure`
- **CORE**
  - Admin API and DAO Audit Log
  - **Healthchecks**
    - HTTPS support
  - **License**
    - Added an increasingly `loud` logging to notify via nginx logs as the expiration date approaches
      - 90 days before the expiration date: Daily `WARN` log
      - 30 days before the expiration date: Daily `ERR` log
      - After the expiration date: Daily `CRIT` log
- **Workspaces**
  - Added endpoint `/workspaces/:ws_id/meta` that provides info about workspace `ws_id`. Current counts of entities per entity type are returned

**FIXES**
- **CORE**
  - **Plugin runloop**
    - Fix issue where Log phase plugins are not executed for request with non-matching routes.
    Note: For request with non-matching routes, every logging phase plugin enabled in the cluster will run irrespective of the workspace where it's configured
  - **Workspaces**
    - Logging plugins log workspace info about requests
    - Fix issue where attempt to share an entity outside the current request's workspace would result in an Internal Server Error
    - Fix issue where a global plugin would be executed for a workspace where it doesn't belong
  - **RBAC**
    - Fix issue where admin could grant privileges to workspaces on which they don't have permissions
    - Permissions created with the `/rbac/roles/:role/endpoints` endpoint receive the current request's workspace instead of the default workspace
    - Return HTTP status code 500 for database errors instead of 401 and 404
    - Fix issue where a user with Admin privilege was able to access RBAC admin endpoints
  - **DAO**
    - Allow self-signed certificates in Cassandra connections
    - check for schema consensus in Cassandra migration
    - Ensure ScyllaDB compatibility in Cassandra migraton
  - **Config**
    - IPv6 addresses in listen configuration directives are correctly parsed
  - **Certificates & SNIs**
    - Fix issue where internal server error was returned when CRUD operations were performed on Certificate endpoint
- **Plugins**
  - **Request Termination**
    - Allow user to unset the value of `config.body` or `config.message` or both
  - **Zipkin**
    - Fix failures when request is invalid or exits early
    - Fix issue when service name is missing
  - **Proxy Cache**
    - Fix issue where responses were not cached if they met at least one positive criteria and did not meet any negative criteria
    - Allow caching of responses without an explicit `public` directive in the `Cache-Control` header
  - **HMAC Authentication**
    - Fix issue where request was not correctly validated against the digest header when `config.validate_request_body` was set and request had no body

  - **OpenID Connect**
    - Fix `cache.tokens_load` ttl fallback to access token exp in case when expires_in is missing
    - Fix headers to not set when header value is `ngx.null` (a bit more robust now)
    - Fix encoding of complex upstream and downstream headers
    - Fix multiple authentication plugins AND / OR scenarios
    - Fix expiry leeway counting when there is refresh token available and when there is not.
    - Fix issue when using password grant or client credentials grant with token caching enabled, and rotating keys on IdP that caused the cached tokens to give 403. The cached tokens will now be flushed and new tokens will be retrieved from the IdP.
    - Fix a bug that prevented sub-plugins from loading the issuer data.

## 0.33-2 - 2018/10/09

**Notifications**

- **Kong EE 0.33** inherits from **Kong CE 0.13.1**; make sure to read 0.13.1 - and 0.13.0 - changelogs:
  - [0.13.0 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0130---20180322)
  - [0.13.1 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0131---20180423)
- **Kong EE 0.33** has these notices from **Kong CE 0.13**:
  - Support for **Postgres 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with Postgres 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon
- **Breaking**: Since 0.32, the `latest` tag in Kong Enterprise Docker repository **changed from CentOS to Alpine** - which might result in breakage if additional packages are assumed to be in the image pointed to by `latest`, as the Alpine image only contains a minimal set of packages installed by default

**Fixes**

- **Core**
  - **DB**
      - [lua-cassandra](https://github.com/thibaultcha/lua-cassandra/blob/master/CHANGELOG.md#132) version bumped to 1.3.2
          - Fix an issue encountered in environments with DNS load-balancing in effect for contact_points provided as hostnames (e.g.Kubernetes with `contact_points = { "cassandra" }`).

  - **Plugin Runloop**
      - Plugin runloop performance optimizations
        - Reduce the number of invocations of the plugins iterator by attempting to load configurations only for plugins we know are configured on the cluster
        - Pre-calculate plugins cache key
        - Avoid unnecessary L2 cache deserialization

  - **Balancer**
      - Fix issue where Upstream for different workspace getting cached to same key
      - Fix an issue where Balancer are not run into limited workspace scope

  - **Dev Portal**
      - Fix an issue which may expose information on the URL query string
      - **Breaking**: If you are updating from a previous version (not a clean install), you will need to update the files below in order to take advantage of security and performance updates.

**unauthenticated/login (page)**


{% raw %}
```html
{{#> unauthenticated/layout pageTitle="Login" }}

  {{#*inline "content-block"}}

  <div class="authentication">
    {{#unless authData.authType}}
        <h1>404 - Not Found</h1>
    {{/unless}}
    {{#if authData.authType}}
      <h1>Login</h1>
      <form id="login" method="post">
        {{#if (eq authData.authType 'basic-auth')}}
          <label for="username">Email</label>
          <input id="username" type="text" name="username" required />
          <label for="password">Password</label>
          <input id="password" type="password" name="password" required />
          <button id="login-button" class="button button-primary" type="submit">Login</button>
        {{/if}}
        {{#if (eq authData.authType 'key-auth')}}
          <label for="key">Api Key</label>
          <input id="key" type="text" name="key" required />
          <button id="login-button" class="button button-primary" type="submit">Login</button>
        {{/if}}

        {{#if (eq authData.authType 'openid-connect')}}
        <a href="{{config.PROXY_URL}}" class="button button-outline">
          <svg class="google-button-icon" viewBox="0 0 366 372" xmlns="http://www.w3.org/2000/svg"><path d="M125.9 10.2c40.2-13.9 85.3-13.6 125.3 1.1 22.2 8.2 42.5 21 59.9 37.1-5.8 6.3-12.1 12.2-18.1 18.3l-34.2 34.2c-11.3-10.8-25.1-19-40.1-23.6-17.6-5.3-36.6-6.1-54.6-2.2-21 4.5-40.5 15.5-55.6 30.9-12.2 12.3-21.4 27.5-27 43.9-20.3-15.8-40.6-31.5-61-47.3 21.5-43 60.1-76.9 105.4-92.4z" id="Shape" fill="#EA4335"/><path d="M20.6 102.4c20.3 15.8 40.6 31.5 61 47.3-8 23.3-8 49.2 0 72.4-20.3 15.8-40.6 31.6-60.9 47.3C1.9 232.7-3.8 189.6 4.4 149.2c3.3-16.2 8.7-32 16.2-46.8z" id="Shape" fill="#FBBC05"/><path d="M361.7 151.1c5.8 32.7 4.5 66.8-4.7 98.8-8.5 29.3-24.6 56.5-47.1 77.2l-59.1-45.9c19.5-13.1 33.3-34.3 37.2-57.5H186.6c.1-24.2.1-48.4.1-72.6h175z" id="Shape" fill="#4285F4"/><path d="M81.4 222.2c7.8 22.9 22.8 43.2 42.6 57.1 12.4 8.7 26.6 14.9 41.4 17.9 14.6 3 29.7 2.6 44.4.1 14.6-2.6 28.7-7.9 41-16.2l59.1 45.9c-21.3 19.7-48 33.1-76.2 39.6-31.2 7.1-64.2 7.3-95.2-1-24.6-6.5-47.7-18.2-67.6-34.1-20.9-16.6-38.3-38-50.4-62 20.3-15.7 40.6-31.5 60.9-47.3z" fill="#34A853"/></svg>
          <span class="google-button-text">Sign in with Google</span>
        </a>
        {{/if}}
      </form>
    {{/if}}
  </div>

  {{/inline}}

{{/unauthenticated/layout}}
```
{% endraw %}


**unauthenticated/register (page)**


{% raw %}
```html
{{#> unauthenticated/layout pageTitle="Register" }}

    {{#*inline "content-block"}}
    <div class="authentication">
      <h1>Request Access</h1>
      <div class="alert alert-info">
        <b>Please fill out the below form and we will notify you once your request gets approved.</b>
      </div>
      <form id="register" method="post">
        <label for="full_name">Full Name</label>
        <input id="full_name" type="text" name="full_name" required />
        {{#if (eq authData.authType 'basic-auth')}}
          <label for="email">Email</label>
          <input id="email_basic" type="text" name="email" required />
          <label for="password">Password</label>
          <input id="password_basic" type="password" name="password" required />
        {{/if}}
        {{#if (eq authData.authType 'key-auth')}}
          <label for="email">Email</label>
          <input id="email_key" type="text" name="email" required />
          <label for="key">Api Key</label>
          <input id="key" type="text" name="key" required />
        {{/if}}
        {{#if (eq authData.authType 'openid-connect')}}
          <label for="email">Email</label>
          <input id="email-oidc" type="text" name="email" required />
        {{/if}}
        <button class="button button-primary" type="submit">Sign Up</button>
      </form>
    </div>
    {{/inline}}

{{/unauthenticated/layout}}
```
{% endraw %}


**unauthenticated/custom-css (partial)**


{% raw %}
```html
{{!--
    |--------------------------------------------------------------------------
    | Here's where the magic happens. This is where you can add your own
    | custom CSS as well as override any default styling we've provided.
    | This file is broken up by section, but feel free to organize as you
    | see fit!
    |
    | Helpful articles on customizing your Developer Portal:
    |   - https://getkong.org/docs/enterprise/latest/developer-portal/introduction/
    |   - https://getkong.org/docs/enterprise/latest/developer-portal/getting-started/
    |   - https://getkong.org/docs/enterprise/latest/developer-portal/understand/
    |   - https://getkong.org/docs/enterprise/latest/developer-portal/customization/
    |   - https://getkong.org/docs/enterprise/latest/developer-portal/authentication/
    |   - https://getkong.org/docs/enterprise/latest/developer-portal/faq/
    |
    |--------------------------------------------------------------------------
    |
    --}}

    {{!-- Custom fonts --}}
    {{!-- <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
    <link href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/default.min.css" rel="stylesheet"> --}}

    <style>
    /*
    |--------------------------------------------------------------------------
    | Typography:
    | h1, h2, h3, h4, h5, h6, p
    |--------------------------------------------------------------------------
    |
    */

    h1 {}

    h2 {}

    h3 {}

    h4 {}

    h5 {}

    h6 {}

    p {}

    /* Header */
    #header {}

    /* Sidebar */
    #sidebar {}

    /* Footer */
    #footer {}

    /* Swagger UI */
    .swagger-ui .side-panel {}

    /*
    |--------------------------------------------------------------------------
    | Code block prismjs theme.
    | e.g. https://github.com/PrismJS/prism-themes
    |--------------------------------------------------------------------------
    |
    */

    .token.block-comment,
    .token.cdata,
    .token.comment,
    .token.doctype,
    .token.prolog {
      color: #999
    }

    .token.punctuation {
      color: #ccc
    }

    .token.attr-name,
    .token.deleted,
    .token.namespace,
    .token.tag {
      color: #e2777a
    }

    .token.function-name {
      color: #6196cc
    }

    .token.boolean,
    .token.function,
    .token.number {
      color: #f08d49
    }

    .token.class-name,
    .token.constant,
    .token.property,
    .token.symbol {
      color: #f8c555
    }

    .token.atrule,
    .token.builtin,
    .token.important,
    .token.keyword,
    .token.selector {
      color: #cc99cd
    }

    .token.attr-value,
    .token.char,
    .token.regex,
    .token.string,
    .token.variable {
      color: #7ec699
    }

    .token.entity,
    .token.operator,
    .token.url {
      color: #67cdcc
    }

    .token.bold,
    .token.important {
      font-weight: 700
    }

    .token.italic {
      font-style: italic
    }

    .token.entity {
      cursor: help
    }

    .token.inserted {
      color: green
    }

</style>
```
{% endraw %}


- **Plugins**
  - **LDAP Auth Advanced**
      - Fix an issue where the plugin fails to authenticate a user when the LDAP server doesn't return the user's password as part of the search result
      - Fix issue where the username field wasn't allowed to contain non-alaphanumeric characters

## 0.33-1 - 2018/09/05

**Notifications**

- **Kong EE 0.33** inherits from **Kong CE 0.13.1**; make sure to read 0.13.1 - and 0.13.0 - changelogs:
  - [0.13.0 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0130---20180322)
  - [0.13.1 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0131---20180423)
- **Kong EE 0.33** has these notices from **Kong CE 0.13**:
  - Support for **Postgres 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with Postgres 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon
- **Breaking**: Since 0.32, the `latest` tag in Kong Enterprise Docker repository **changed from CentOS to Alpine** - which might result in breakage if additional packages are assumed to be in the image pointed to by `latest`, as the Alpine image only contains a minimal set of packages installed by default

**Changes**

- **Plugins**
  - **HMAC Auth**
      - Attempt signature generation without querystring arguments if the newer signature verification, that includes querystring, fails
  - **StatsD Advanced**
      - Improve performance when constructing the metrics key
      - Allow hostname to be written into the key prefix, based on a boolean plugin config flag

**Fixes**

- **Core**
  - **RBAC**
      - Fix an issue where entities are not added to the role-entities table when id is not the primary key
      - Fix an issue where role-entities and role-endpoints relationships are not deleted when role is removed
      - Fix issue leading to SNI creation failure when RBAC is on
  - **Workspaces**
      - Fix an issue where authentication keys prefixed with a workspace name would be considered valid
    - **DB**
      - Cassandra
        - Fix Cassandra unique violation check on update
    - **Migrations**
      - Remove dependency on "public" schema or "pg_default" tablespaces in Postgres - such a dependency would cause migrations to fail if such tablespaces weren't being used
    - **Healthchecks**
      - Fix Host header in active healthchecks
      - Fix for connection timeouts on passive healthchecks
  - **Dev Portal**
      - Fix issue leading migrations `2018-04-10-094800_dev_portal_consumer_types_statuses` and `2018-05-08-143700_consumer_dev_portal_columns` to fail
      - Automatically log users in after registering when auto-approve is on
      - Reduce the size of the mobile breakpoint
      - Improve performance and file sizes of bundled code
      - Fix issue causing Portal to list spec files twice
      - Swagger Improvements:
          - Fix for rendering OAS 3.0 spec files
          - Ensure that page loading isn't blocked by Swagger UI rendering

- **Plugins**
  - **LDAP Auth & LDAP Auth Advanced**
      - Fix an issue where a request would fail when the password field had more than 128 characters in length
      - Make the password part of the cache key, so that an invalid credential can be cached without blocking valid credentials
  - **Zipkin**
      - Fix operation when service and/or route are missing
      - Fix cause of missing kong.credential field
      - Support for deprecated Kong "api" entity via kong.api tag
  - **Rate Limiting Advanced Plugin**
      - Fix issue preventing the plugin to correctly propagate configuration changes across Kong Nginx workers
      - Fix issue preventing the plugin to load configuration and create sync timers
      - Fix plugin name in log messages
  - **Canary**
      - Fixed the type attribute for port configuration setting
  - **Forward Proxy**
      - Fix Kong core dependency causing the access phase handle to fail
  - **Proxy Cache**
      - Fix issue leading to cache key collision in some scenarios - e.g., for requests issued by the same consumer
      - Fix cache key for Routes and Services: previously, distinct routes/services entities would be given the same cache key

## 0.33 - 2018/07/24

**Notifications**

- **Kong EE 0.33** inherits from **Kong CE 0.13.1**; make sure to read 0.13.1 - and 0.13.0 - changelogs:
  - [0.13.0 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0130---20180322)
  - [0.13.1 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0131---20180423)
- **Kong EE 0.33** has these notices from **Kong CE 0.13**:
  - Support for **Postgres 9.4 has been removed** - starting with 0.32, Kong Enterprise does not start with Postgres 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
  - Additional requirements:
      - **Vitals** requires Postgres 9.5+
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon
- **Breaking**: Since 0.32, the `latest` tag in Kong Enterprise Docker repository **changed from CentOS to Alpine** - which might result in breakage if additional packages are assumed to be in the image pointed to by `latest`, as the Alpine image only contains a minimal set of packages installed by default

**Changes**

- **Vitals**
  - Internal proxies are no longer tracked
  - Admin API endpoint `/vitals/consumers/:username_or_id/nodes`, deprecated in 0.32, has been removed
- **Prometheus Plugin**
  - The plugin uses a dedicated shared dictionary. If you use a custom template, define the following for Prometheus:

    ```
    lua_shared_dict prometheus_metrics 5m;
    ```
- **OpenID Connect Plugin**
  - Change `config_consumer_claim` from string to array

**Features**

- **Core**
  - **New RBAC implementation**, supporting both endpoint and entity-level
  access control - read the docs [here][rbac-overview]
  - **Workspaces**, allowing segmentation of Admin API entities - read the docs
  [here][workspaces-overview]. Note that workspaces are available in the API only,
  and not in the Admin GUI
- **Admin GUI**
  - Log in to the Admin GUI using Kong's own authentication plugins; supported
  plugins are key-auth, basic-auth, and ldap-auth-advanced.  Use of other
  authentication plugins has not been tested.
  - Add ability to see what plugins are configured on a consumer
- **Dev Portal**
  - Revoked Dev Portal Users/Consumers are blocked at proxy
  - Files API Improvements
  - File editor in Admin GUI
  - Consumer API usage on Dev Portal user area
- **OpenID Connect Plugin**
  - Add `config.consumer_optional`
  - Add `config.token_endpoint_auth_method`
  - Add `consumer.status` check for internal authentication
- **Forward Proxy Plugin**
  - Add support for delayed response
  - Add `via` header
- **Canary Plugin**
  - Added whitelist and blacklist options to be able to select consumers instead of having random consumers
  - Added a port parameter to be able to be set a new port for the alternate upstream
- **LDAP Auth Advanced**
  - Find consumers by `consumer_by` fields and map to ldap-auth user. This will set the authenticated consumer so that `X-Consumer-{ID, USERNAME, CUSTOM_ID}` headers are set and consumer functionality is available
  - Add fields
      - `consumer_by`: optional, default: `{username, custom_id}`
      - `consumer_optional`: optional, default: `false`
- **StatsD Plugin**
  - New plugin; see documentation [here][statsd-docs]
- **Prometheus Plugin**
  - New plugin; see documentation [here][prometheus-docs]

**Fixes**

- **Core**
  - **Healthchecks**: health status no longer resets when a Target is added to an Upstream
  - **Runloop**: properly throw errors from plugins fetch
  - **DB**: fix double-wraping of `err_t` strategy error
- **Plugins**
  - Azure delayed response
  - Lambda delayed response
  - Request Termination delayed response
- **Admin GUI**
  - Fix a problem where a plugin value cannot be unset
  - Fix a problem where error messages on the login screen fail to display
- **Portal**
  - Auto-approve messaging
- **OpenID Connect Plugin**
  - Fix `kong_oauth2` `auth_method` so that it works without having to also add bearer or introspection to `config.auth_method`
  - Fix `ngx.ctx.authenticated_credential` so that it isn't set when a value with `config.credential_claim` isn't found
- **Zipkin Plugin**
  - Fix an issue with how timestamps can sometimes be encoded with scientific notation, causing the Zipkin collector to refuse some traces
- **LDAP Auth Advanced Plugin**
  - Fix require statements pointing to Kong CE's version of the plugin
  - Fix usage of the LuaJIT FFI, where an external symbol was not accessed properly, resulting in an Internal Server Error
- **Rate Limiting Advanced Plugin**
  - Fix an issue in Cassandra migrations that would stop the migration process
  - Allow existing plugin configurations without a value for the recently-introduced introduced `dictionary_name` field to use the default dictionary for the plugin - `kong_rate_limiting_counters`.
  - Customers using a custom Nginx template are advised to check if such a dictionary is defined in their template:

    ```
    lua_shared_dict kong_rate_limiting_counters 12m;
    ```

## 0.32 - 2018/05/24

**Notifications**

- **Kong EE 0.32** inherits from **Kong CE 0.13.1**; make sure to read 0.13.1 - and 0.13.0 - changelogs:
  - [0.13.0 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0130---20180322)
  - [0.13.1 Changelog](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0131---20180423)
- **Kong EE 0.32** has these notices from **Kong CE 0.13**:
  - Support for **Postgres 9.4 has been removed** - starting with 0.32, Kong Enterprise will not start with Postgres 9.4 or prior
  - Support for **Cassandra 2.1 has been deprecated, but Kong will still start** - versions beyond 0.33 will not start with Cassandra 2.1 or prior
  - Additional requirements:
      - **Vitals** requires Postgres 9.5+
      - **Dev Portal** requires Cassandra 3.0+
  - **Galileo - DEPRECATED**: Galileo plugin is deprecated and will reach EOL soon
- **Breaking**: The `latest` tag in Kong Enterprise Docker repository changed from CentOS to Alpine - which might result in breakage if additional packages are assumed to be in the image, as the Alpine image only contains a minimal set of packages installed
- **OpenID Connect**
  - The plugins listed below were deprecated in favor of the all-in-one openid-connect plugin:
      - `openid-connect-authentication`
      - `openid-connect-protection`
      - `openid-connect-verification`

**Changes**

- **New Data Model** - Kong EE 0.32 is the first Enterprise version including the [**new model**](https://github.com/Kong/kong/blob/master/CHANGELOG.md#core-2), released with Kong CE 0.13, which includes Routes and Services
- **Rate Limiting Advanced**
  - **Breaking** - the Enterprise Rate Limiting plugin, named `rate-limiting` up to EE 0.31, was renamed `rate-limiting-advanced` and CE Rate Limiting was imported as `rate-limiting`. Any Admin API calls that were previously targeting the Enterprise Rate Limiting plugin in Kong EE up to 0.31 need to be updated to target `rate-limiting-advanced`
  - Rate Limiting Advanced, similarly to CE rate-limiting, now uses a dedicated shared dictionary named `kong_rate_limiting_counters` for its counters; if you are using a custom template, make sure to define the following shared memory zones:

    ```
    lua_shared_dict kong_rate_limiting_counters 12m;
    ```
- **Vitals**
  - Vitals uses two dedicated shared dictionaries. If you use a custom template, define the following shared memory zones for Vitals:

    ```
    lua_shared_dict kong_vitals_counters 50m;
    lua_shared_dict kong_vitals_lists     1m;
    ```
  You can remove any existing shared dictionaries that begin with `kong_vitals_`, e.g., `kong_vitals_requests_consumers`
- **OpenID Connect**
  - Remove multipart parsing of ID tokens - they were not proxy safe
  - Change expired or non-active access tokens to give `401` instead of `403`

**Features**

- **Admin GUI**
  - New Listeners (Admin GUI + Developer Portal)
  - Routes and Services GUI
  - New Plugins thumbnail view
  - Healthchecks GUI
  - Syntax for form-encoded array elements
  - Dev Portal Overview tab
  - Developers management tab
- **Vitals**
  - **Status Code** tracking - GUI and API
      - Status Code groups per Cluster - counts of `1xx`, `2xx`, `3xx`, `4xx`, `5xx` groups across the cluster over time. Visible in the Admin GUI at `ADMIN_URL/vitals/status-codes`
      - Status Codes per Service - count of individual status codes correlated to a particular service. Visible in the Admin GUI at `ADMIN_URL/services/{service_id}`
      - Status Codes per Route - count of individual status codes correlated to a particular route. Visible in the Admin GUI at `ADMIN_URL/routes/{route_id}`
      - Status Codes per Consumer and Route - count of individual status codes returned to a given consumer on a given route.  Visible in the Admin GUI at `ADMIN_URL/consumers/{consumer_id}`
- **Dev Portal**
  - Code Snippets
  - Developer "request access" full life-cycle
  - Default Dev Portal included in Kong distributions (with default theme)
  - Authentication on Dev Portal out of box (uncomment in Kong.conf)
  - Docs for Routes/Services for Dev Portal
  - Docs for Admin API
  - **Requires Migration** - `/files` endpoint is now protected by RBAC
- **Plugins**
  - **Rate Limiting Advanced**: add a `dictionary_name` configuration, to allow using a custom dictionary for storing counters
  - **Requires Migration - Rate Limiting CE** is now included in EE
  - **Request Transformer CE** is now included in EE
  - **Edge Compute**: plugin-based, Lua-only preview
  - **Proxy Cache**: Customize the cache key, selecting specific headers or query params to be included
  - **Opentracing Plugin**: Kong now adds detailed spans to Zipkin and Jaeger distributed tracing tools
  - **Azure Functions Plugin**: Invoke Azure functions from Kong
  - **LDAP Advanced**: LDAP plugin with augmented ability to search by LDAP fields
- **OpenID Connect**
  - Add `self_check` function to validate that OIDC discovery information can be downloaded
  - Bearer token is now looked up on `Access-Token` and `X-Access-Token` headers in addition to Authorization Bearer header (query and body args are supported as before)
  - JWKs are rediscovered and the new keys are cached cluster wide (works better with keys rotation schemes)
  - Admin API does self-check for discovery endpoint when the plugin is added and reports possible errors back
  - Add configuration directives
      - `config.extra_jwks_uris`
      - `config.credential_claim`
      - `config.session_storage`
      - `config.session_memcache_prefix`
      - `config.session_memcache_socket`
      - `config.session_memcache_host`
      - `config.session_memcache_port`
      - `config.session_redis_prefix`
      - `config.session_redis_socket`
      - `config.session_redis_host`
      - `config.session_redis_port`
      - `config.session_redis_auth`
      - `config.session_cookie_lifetime`
      - `config.authorization_cookie_lifetime`
      - `config.forbidden_destroy_session`
      - `config.forbidden_redirect_uri`
      - `config.unauthorized_redirect_uri`
      - `config.unexpected_redirect_uri`
      - `config.scopes_required`
      - `config.scopes_claim`
      - `config.audience_required`
      - `config.audience_claim`
      - `config.discovery_headers_names`
      - `config.discovery_headers_values`
      - `config.introspect_jwt_tokens`
      - `config.introspection_hint`
      - `config.introspection_headers_names`
      - `config.introspection_headers_values`
      - `config.token_exchange_endpoint`
      - `config.cache_token_exchange`
      - `config.bearer_token_param_type`
      - `config.client_credentials_param_type`
      - `config.password_param_type`
      - `config.hide_credentials`
      - `config.cache_ttl`
      - `config.run_on_preflight`
      - `config.upstream_headers_claims`
      - `config.upstream_headers_names`
      - `config.downstream_headers_claims`
      - `config.downstream_headers_names`

**Fixes**

- **Core**
  - **Healthchecks**
      - Fix an issue where updates made through `/health` or `/unhealth` wouldn't be propagated to other Kong nodes
      - Fix internal management of healthcheck counters, which corrects detection of state flapping
  - **DNS**: a number of fixes and improvements were made to Kong's DNS client library, including:
      - The ring-balancer now supports `targets` resolving to an SRV record without port information (`port=0`)
      - IPv6 nameservers with a scope in their address (eg. `nameserver fe80::1%wlan0`) will now be skipped instead of throwing errors
- **Rate Limiting Advanced**
  - Fix `failed to upsert counters` error
  - Fix issue where an attempt to acquire a lock would result in an error
  - Mitigate issue where lock acquisitions would lead to RL counters being lost
- **Proxy Cache**
  - Fix issue where proxy-cache would shortcircuit requests that resulted in a cache hit, not allowing subsequent plugins - e.g., logging plugins - to run
  - Fix issue where PATCH requests would result in a 500 response
  - Fix issue where Proxy Cache would overwrite X-RateLimit headers
- **Request Transformer**
  - Fix issue leading to an Internal Server Error in cases where the Rate Limiting plugin returned a 429 Too Many Requests response
- **AWS Lambda**
  - Fix issue where an empty array `[]` was returned as an empty object `{}`
- **Galileo - DEPRECATED**
  - Fix issue that prevented Galileo from reporting requests that were cached by proxy-cache
  - Fix issue that prevented Galileo from showing request/response bodies of requests served by proxy-cache
- **OpenID Connect**
  - Fix `exp` retrieval
  - Fix `jwt_session_cookie` verification
  - Fix consumer mapping using introspection where the claim was searched in an inexistent location
  - Fix header values when their callbacks fail to get the value - instead of setting their values as `function ...`
  - Fix `config.scopes` when set to `null` or `""` so that it doesn't add an OpenID scope forcibly, as the plugin is not only OpenID Connect only, but also OAuth2


## 0.31-1 - 2018/04/25

**Changes**

- New shared dictionaries named `kong_rl_counters` and `kong_db_cache_miss` were defined in Kong’s default template - customers using custom templates are encouraged to update them to include those, as they avoid the reuse of the `kong_cache` shared dict; such a reuse is known to be one of the culprits behind `no memory` errors - see diff below
- The rate-limiting plugin now accepts a `dictionary_name` argument, which is used for temporarily storing rate-limiting counters

*NOTE*: if you use a custom Nginx configuration template, apply the following patch to your template:

```
diff --git a/kong/templates/nginx_kong.lua b/kong/templates/nginx_kong.lua
index 15682975..653a7ddd 100644
--- a/kong/templates/nginx_kong.lua
+++ b/kong/templates/nginx_kong.lua
@@ -29,7 +29,9 @@ lua_socket_pool_size ${{LUA_SOCKET_POOL_SIZE}};
 lua_max_running_timers 4096;
 lua_max_pending_timers 16384;
 lua_shared_dict kong                5m;
+lua_shared_dict kong_rl_counters   12m;
 lua_shared_dict kong_cache          ${{MEM_CACHE_SIZE}};
+lua_shared_dict kong_db_cache_miss 12m;
 lua_shared_dict kong_process_events 5m;
 lua_shared_dict kong_cluster_events 5m;
 lua_shared_dict kong_vitals_requests_consumers 50m;
```

**Fixes**

- Bump mlcache to 2.0.2 and mitigates a number of issues known to be causing `no memory` errors
- Fixes an issue where boolean values (and boolean values as strings) were not correctly marshalled when using Cassandra
- Fixes an issue in Redis Sentinel configuration parsing

## 0.31 - 2018/03/16

Kong Enterprise 0.31 is shipped with all the changes present in Kong Community Edition 0.12.3, as well as with the following additions:

**Changes**
- Galileo plugin is disabled by default in this version, needing to be explicitly enabled via the custom_plugins configuration
  - *NOTE*: If a user had the Galileo plugin applied in an older version and migrate to 0.31, Kong will fail to restart unless the user enables it via the [custom_plugins](/latest/configuration/#custom_plugins) configuration; however, it is still possible to enable the plugin per API or globally without adding it to custom_plugins
- OpenID Connect plugin:
  - Change `config.client_secret` from `required` to `optional`
- Change `config.client_id` from `required` to `optional`
- If `anonymous` consumer is not found Internal Server Error is returned instead of Forbidden
- **Breaking Change** - `config.anonymous` now behaves similarly to other plugins and doesn't halt execution or proxying (previously it was used just as a fallback for consumer mapping) and the plugin always needed valid credentials to be allowed to proxy if the client wasn't already authenticated by higher priority auth plugin
- Anonymous consumer now uses a simple cache key that is used in other plugins
- In case of auth plugins concatenation, the OpenID Connect plugin now removes remnants of anonymous

**Fixes**
- **Admin GUI**
  - Remove deprecated orderlist field from Admin GUI Upstreams entity settings
  - Fix issue where Admin GUI would break when running Kong in a custom prefix
  - Fix issue where Healthchecks had a field typed as number instead of string.
  - Fix issue where Healthchecks form had incorrect default values.
  - Fix issue where table row text was overflowing and expanding the page.
  - Fix issue where notification bar in mobile view could have text overflow beyond the container.
  - Fix issue where deleting multiple entities in a list would cause the delete modal to not show.
  - Fix issue where cards on the dashboard were not evenly sized and spaced.
  - Fix issue where cards on the dashboard in certain widths could have text overflow beyond their container.
  - Fix issue where Array's on Plugin Entities were not being processed and sent to the Admin API.
  - Fix issue where Models were improperly handled when not updated and not sending default values properly.
  - Fix issue where Plugin lists were not displaying config object.
  - Fix issue where Kong was not processing SSL configuration for Admin GUI

- **OpenID Connect plugin**
  - Fixed anonymous consumer mapping

- **Vitals**

  - Correct the stats returned in the "metadata" attribute of the /vitals/consumers/:consumer_id/* endpoints
  - Correct a problem where workers get out of sync when adding their data to cache
  - Correct inconsistencies in chart axes when toggling between views or when Kong has no traffic

- **Proxy Cache**
  - Fix issue that prevented cached requests from showing up in Vitals or Total Requests graphs
  - Fixes inherited from Kong Community Edition 0.12.3.

**Features**
- Admin GUI
  - Add notification bar alerting users that their license is about to expire, and has expired.
  - Add new design to vitals overview, table breakdown, and a new tabbed chart interface.
  - Add top-level vitals section to the sidebar.

- Requires migration - Vitals
  - New datastore support: Cassandra 2.1+
  - Support for averages for Proxy Request Latency and Upstream Latency

- Requires migration - Dev Portal
  - Not-production-ready feature preview of:
    - "Public only" Portal - no authentication (eg. the portal is fully accessible to anyone who can access it)
    - Authenticated Portal - Developers must log in, and then they can see what they are entitled to see

## 0.30 - 2018/01/24

Kong Enterprise 0.30 is shipped with all the changes present in [Kong Community Edition 0.12.1](https://github.com/Kong/kong/blob/master/CHANGELOG.md#0121---20180118), as well as with the following additions:

**Notifications**

- EE 0.30 inherits dependency **deprecation** notices from CE 0.12. See the "Deprecation Notes" section of Kong 0.12.0 changelog
- ⚠️ By default, the Admin API now only listens on the local interface. We consider this change to be an improvement in the default security policy of Kong. If you are already using Kong, and your Admin API still binds to all interfaces, consider updating it as well. You can do so by updating the `admin_listen` configuration value, like so: `admin_listen = 127.0.0.1:8001`.

- 🔴 Note to Docker users: Beware of this change as you may have to ensure that your Admin API is reachable via the host's interface. You can use the `-e KONG_ADMIN_LISTEN` argument when provisioning your container(s) to update this value; for example, `-e KONG_ADMIN_LISTEN=0.0.0.0:8001`.

**Changes**
- **Renaming of Enterprise plugin**
  - `request-transformer` becomes `request-transformer-advanced`

- **Rate-limiting** plugin
  - Change default `config.identifier` in EE's from `ip` to `consumer`

- **Vitals**
  - Aggregate minutes data at the same time as seconds data
  - **Breaking Change:** Replace previous Vitals API (part of the Admin API) with new version. **Not backwards compatible.**
  - **Upgrading from Kong EE (0.29) will result in the loss of previous Vitals data**

- **Admin GUI**
  - Vitals chart settings stored in local storage
  - Improve vital chart legends
  - Change Make A Wish email to <a href="mailto:wish@konghq.com`>wish@konghq.com</a>

- **OpenID Connect Plugins**
  - Change `config.login_redirect_uri` from `string` to `array`
  - Add new configuration parameters
    - config.authorization_query_args_client
    - config.client_arg
    - config.logout_redirect_uri
    - config.logout_query_arg
    - config.logout_post_arg
    - config.logout_uri_suffix
    - config.logout_methods
    - config.logout_revoke
    - config.revocation_endpoint
    - config.end_session_endpoint

- **OpenID Connect Library**
  - Function `authorization:basic` now return as a third parameter, the grant type if one was found - previously, it returned parameter location in HTTP request
  - Issuer is no longer verified on discovery as some IdPs report different value (it is still verified with claims verification)

**Added**

- New **Canary Release plugin**

- Vitals
  - Addition of "node-specific" dimension for previously-released metrics (Kong Request Latency and Datastore Cache)
  - New metrics and dimensions:
    - **Request Count per Consumer**, by Node or Cluster
    - **Total Request Count**, by Node or Cluster
    - **Upstream Latency** (the time between a request being sent upstream by Kong, and the response being received by Kong), by Node or Cluster
  - All new metrics and dimensions accessible in **Admin GUI and API**
  - **Important limitations and notifications:**
    - PostgreSQL 9.5+ only - no Cassandra support yet
    - Upgrading from the previous version of Kong EE will result in all historic Vitals data being dropped
    - The previous Vitals API (which is part of the Admin API) is replaced with a new, better one (the old API disappears, and there is no backwards compatibility)

  - **Proxy Cache**
    - Implement Redis (stand-alone and Sentinel) caching of proxy cache entities

  - **Enterprise Rate Limiting**
    - Provide **fixed-window** quota rate limiting (which is essentially what the CE rate-limiting plugin does) in addition to the current sliding window rate limiting
    - Add *hide_client_headers* configuration to disable response headers returned by the rate limiting plugin

  - **Admin GUI**
    - Addition of **"Form Control Grouping"** for the new Upstream health-check configuration options.
    - Add **Healthy** or **Unhealthy** buttons for the new health-check functionality on Upstream Targets table.
    - Add **Hostname** and **Hostname + Id** reporting and labeling functionality to Vitals components.
    - Add **Total Requests per Consumer** chart to individual consumer pages.
    - Add **Total Requests** and **Upstream Latency** charts to the Vitals page.
    - Add information dialogs for vital charts next to chart titles.
    - Introduced **Total Requests** chart on Dashboard.
    - Automatically saves chart preferences and restores on reload.

  - **OpenID Connect plugins**
    - Support passing dynamic arguments to authorization endpoint from client
    - Support logout with optional revocation and RP-initiated logout

  - Features inherited from [Kong Community Edition 0.12.0](https://github.com/Kong/kong/blob/master/CHANGELOG.md#added) - includes:
    - Health checks
    - Hash-based load balancing
    - Logging plugins track unauthorized and rate-limited requests
    - And more...

**Fixes**
- **Proxy Cache**
  - Better handling of input configuration data types. In some cases configuration sent from the GUI would case requests to be bypassed when they should have been cached.

- **OAuth2 Introspection**
  - Improved error handling in TCP/HTTP connections to the introspection server.

- **Vitals**
  - Aggregating minutes at the same time as seconds are being written.
  - Returning more than one minute's worth of seconds data.

- **Admin GUI**
  - Input type for Certificates is now a text area box.
  - Infer types based on default values and object type from the API Schema for Plugins.

- Fixes inherited from Kong Community Edition 0.12.0.

---

[rbac-overview]: /enterprise/0.33-x/rbac/overview
[workspaces-overview]: /enterprise/0.33-x/workspaces/overview
[statsd-docs]: /enterprise/0.33-x/plugins/statsd-advanced
[prometheus-docs]: /plugins/prometheus
