---
title: Proxy Traffic
no_search: true
no_version: true
toc: false
---

## Proxy Traffic for your Kong Proxy Nodes

The Proxy URL is used to access a Service.

1. Copy the Proxy URL. You can find the Proxy URL at the top of any Service
Version overview page.

    ![Konnect Proxy URL](/assets/images/docs/konnect/konnect-proxy-url.png)

2. Paste the URL into a browser and append with the Route path.

    For example, in this guide we use **http://mockbin.org** to create a
    Service with a path **/mock**. When you put the URL into a browser, add
    **/mock** at the end of the Proxy URL. The upstream service, is mockbin.
