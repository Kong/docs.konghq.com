---
title: Kong Gateway (OSS)
subtitle: A lightweight open-source API gateway
---

## What is Kong Gateway, technically?

You’ve probably heard that {{site.base_gateway}} is built on Nginx, leveraging its stability and efficiency. But how is this possible exactly?

To be more precise, {{site.base_gateway}} is a Lua application running in Nginx and made possible by the [lua-nginx-module](https://github.com/openresty/lua-nginx-module). Instead of compiling Nginx with this module, Kong is distributed along with [OpenResty](https://openresty.org/), which already includes lua-nginx-module. OpenResty is *not* a fork of Nginx, but a bundle of modules extending its capabilities.

This sets the foundations for a pluggable architecture, where Lua scripts (referred to as *plugins*) can be enabled and executed at runtime. Because of this, we like to think of {{site.base_gateway}} as **a paragon of microservice architecture**: at its core, it implements database abstraction, routing and plugin management. Plugins can live in separate code bases and be injected anywhere into the request lifecycle, all in a few lines of code.

## Next Steps

Pick your path:
* **[Quickstart][quickstart]**: A quick-and-dirty introduction to
{{site.base_gateway}}, common objects, and basic Admin API commands. Use this
if you just want the basics.
* **[Getting started guide][getting-started]**: An alternative to the
quickstart, the complete {{site.base_gateway}} getting started guide provides
in-depth examples, explanations, and step-by-step instructions, and explores
Kong's many available tools for managing the gateway.

[quickstart]: /gateway-oss/{{page.kong_version}}/getting-started/quickstart
[configuring-a-service]: /gateway-oss/{{page.kong_version}}/getting-started/configuring-a-service
[enabling-plugins]: /gateway-oss/{{page.kong_version}}/getting-started/enabling-plugins
[getting-started]: /getting-started-guide/latest/overview
