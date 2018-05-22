---
title: Networking
book: portal
chapter: 1
---

# Networking

This document reviews how the [`proxy_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#proxy_url)
and [`portal_gui_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#portal_gui_url) config variables are utilized within the Kong proxy, Dev Portal, and Admin GUI. Below you find a summary of these config variables and their default settings.

## Summary

### proxy_url
  
**Description:**  
The Dev Portal will use this information to build the API endpoint for requests to Kong. By default, the Kong Portal will use the window request host and append the resolved listener port depending on the requested protocol.

### portal_gui_url

**Description:**  
Sets [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) Access Origin in regards to requests related to the developer portal (set to `*` by default). Acts as Dev Portal location reference for Kong, the Admin GUI, and the Dev Portal itself. By default, the Kong Portal will use the window request host and append the resolved listener port depending on the requested protocol.


## Default Configuration

The Kong Dev Portal works out of the box:

1. Start Kong without custom configuration:

```
kong start
```

2. Navigate to `127.0.0.1:8003` (default [`portal_gui_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#portal_gui_url) location).  You should see the Default Dev Portal.

3. Open your developer tools in your browser and click on the `network` tab.

4. Refresh the Dev Portal window and inspect the network tab again.  Notice that the Kong Portal is making requests to the [`proxy_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#proxy_url) default value: `http://127.0.0.1:8000`.


## Custom Configuration

There _are_ cases in which [`proxy_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#proxy_url) and [`portal_gui_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#portal_gui_url) need to be set to accommodate your network setup.  Below you will find an example for a common use case where the Kong proxy and Dev Portal are served via different URLs.

Consider this domain setup:

- http://company.com (public facing website)
- http://proxy.company.com -> (Kong Proxy)
- http://dev-portal.company.com -> (public Dev Portal)
- http://admin-gui.company.com -> (internal Admin GUI)


### proxy_url configuration

With [`proxy_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#proxy_url) set to it's default value the Dev Portal will make requests to `http://dev-portal.company.com:8000`, as [`proxy_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#proxy_url) defaults to `window.location` when no value is set.  As a result the Dev Portal incorrectly requests files from `http://dev-portal.company.com` rather than `http://proxy.company.com`, resulting in an error.

Setting [`proxy_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#proxy_url) to `http://proxy.company.com` in `kong.config` will allow the Dev Portal to make requests to the correct location.  

```
proxy_url = http://proxy.company.com
```

Visiting `http://dev-portal.company.com` will now result in a successful render.


### portal_gui_url configuration

[`portal_gui_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#portal_gui_url) has a value of `NONE` by default. It will appear as empty and commented out in `kong.conf`:

```
#portal_gui_url =
```

When [`portal_gui_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#portal_gui_url) is not defined:  

  - Kong Proxy will set [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) to `*`, allowing any origin to make requests to the Dev Portal.
  - Admin GUI and Dev Portal use [`portal_gui_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#portal_gui_url) to reference Dev Portal location. As a result the Admin GUI will reference `window.location` by default when linking out to the Dev Portal resulting in a redirect to `http://admin-gui.company.com` rather than `http://dev-portal.company.com`.

Setting [`portal_gui_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#portal_gui_url) to `http://dev-portal.company.com` will:  

  - Give context to Admin GUI and Dev Portal.
  - Update [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) in the Kong Proxy to only accept Dev Portal requests from the [`portal_gui_url`](/docs/enterprise/0.32-x/developer-portal/property-reference/#portal_gui_url).
