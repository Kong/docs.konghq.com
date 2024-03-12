---
title: Introduction
book: plugin_dev
chapter: 1
---

Before building custom plugins, it is important to understand how {{site.base_gateway}} 
is built, how it integrates with Nginx, and how the high performance [Lua](https://www.lua.org/about.html) 
language is used.

Lua development is enabled in Nginx with the [lua-nginx-module]. Instead of
compiling Nginx with this module, Kong is distributed along with
[OpenResty](https://openresty.org/), which includes the `lua-nginx-module`.
OpenResty is *not* a fork of Nginx, but a bundle of modules extending its
capabilities.

{{site.base_gateway}} is a Lua application, designed to load and execute Lua modules,
commonly refered to as *plugins*. {{site.base_gateway}} provides a broad plugin 
development environment including an SDK, database abstractions, migrations, and more.

Plugins consist of Lua modules interacting with request/response objects or
network streams to implement arbitrary logic. {{site.base_gateway}} provides a 
**Plugin Development Kit** (PDK) which is a set of Lua functions that are used  
to facilitate interactions between plugins, the {{site.base_gateway}} core, and other 
components. 

This guide will explore in detail the structure of plugins, what they can
extend, and how to distribute and install them. For a complete reference of the
PDK, see the [Plugin Development Kit] reference.

[lua-nginx-module]: https://github.com/openresty/lua-nginx-module
[Plugin Development Kit]: /gateway/{{page.release}}/plugin-development/pdk
