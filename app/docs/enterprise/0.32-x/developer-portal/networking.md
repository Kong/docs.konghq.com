---
title: Networking
book: portal
chapter: 1
---

# Networking

This document reviews how the [`proxy_url`](/docs/latest/developer-portal/property-reference#proxy_url)
and [`portal_api_url`](/docs/latest/developer-portal/property-reference#portal_api_url) config variables are utilized within the Kong proxy, Dev Portal, and Admin GUI. Below you find a summary of these config variables and their default settings.

## Summary

#### proxy_url

**Default:** `NONE` (defaults to clients window.location + listener port)
  
**Description:**  
Informs the Dev Portal about the location of the Kong proxy. The Dev Portal will use this information to build the API endpoint for requests to Kong.

#### portal_gui_url

**Default:** `NONE` (defaults to clients window.location + listener port)

**Description:**    
Sets CORS Access Origin in regards to requests related to the developer portal (set to `*` by default).  Acts as a reference to Kong, the Admin GUI, and the Dev Portal for various actions like as the location for an `href`.


##Default Configuration

Lets start by looking at how Kong configures the Dev Portal out of the box:

1. Start kong with its default configuration (no kong.conf values set)

```
kong start -c kong.conf.default
```

2. Navigate to `localhost:8003` (default [`portal_api_url`](/docs/latest/developer-portal/property-reference#portal_api_url) location).  You should see the Default Dev Portal.

3. Open your developer tools in your browser and click on the `network` tab.

4. Refresh the Dev Portal window take a look at the network tab and click on one of the requests made.  Notice that the Kong Portal is making requests to the [`proxy_url`](/docs/latest/developer-portal/property-reference#proxy_url) default value: `http://127.0.0.1:8000`.


## Custom Configuration

There _are_ cases in which [`proxy_url`](/docs/latest/developer-portal/property-reference#proxy_url) and [`portal_api_url`](/docs/latest/developer-portal/property-reference#portal_api_url) need to be set to accommodate your network setup.  Below you will find an example for a common use case where the Kong proxy and Dev Portal are served via different URLs.

Consider this domain setup:

- http://company.com (public facing website)
- http://proxy.company.com -> DNS NAME -> (Kong Proxy)
- http://dev-portal.company.com -> (public Dev Portal)
- http://admin-gui.company.com -> (internal Admin GUI)


#### proxy_url

With [`proxy_url`](/docs/latest/developer-portal/property-reference#proxy_url) set to it's default value, Dev Portal will make requests to `http://dev-portal.company.com:8000`, as [`proxy_url`](/docs/latest/developer-portal/property-reference#proxy_url) defaults to `window.location` when no value is set.  As a result the Dev Portal incorrectly requests files from `http://dev-portal.company.com` rather than `http://proxy.company.com`. This will result in an error.

Setting [`proxy_url`](/docs/latest/developer-portal/property-reference#proxy_url) to `http://proxy.company.com` in kong.config will allow the Dev Portal to make requests to the correct location.  

```
proxy_url = http://proxy.company.com
```

Visiting `http://dev-portal.company.com` will now result in a successful render.


#### portal_gui_url

With [`portal_api_url`](/docs/latest/developer-portal/property-reference#portal_api_url) set to it's default value:

  - Kong Proxy will set CORS to `*`, allowing any origin to make requests to the Dev Portal.
  - Admin GUI and Dev Portal use [`portal_api_url`](/docs/latest/developer-portal/property-reference#portal_api_url) to reference Dev Portal location. Set to the default value the Admin GUI will reference it's own url when linking out to the Dev Portal (Admin GUI will link to itself rather than the Dev Portal).

Setting [`portal_api_url`](/docs/latest/developer-portal/property-reference#portal_api_url) to `http://dev-portal.company.com` will:

  - Give location context to Admin GUI and Dev Portal.
  - Update CORS in the Kong Proxy to only accept requests from the [`portal_api_url`](/docs/latest/developer-portal/property-reference#portal_api_url) location.
