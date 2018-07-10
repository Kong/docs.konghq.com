---
title: Plugin Development - Introduction
book: plugin_dev
chapter: 1
---

# Plugin development - Introduction

### What are plugins and how do they integrate with Kong?

Before going further, it is necessary to briefly explain how Kong is built,
especially how it integrates with Nginx and what Lua has to do with it.

[lua-nginx-module] enables Lua scripting capabilities in Nginx. Instead of
compiling Nginx with this module, Kong is distributed along with
[OpenResty](https://openresty.org/), which already includes lua-nginx-module.
OpenResty is *not* a fork of Nginx, but a bundle of modules extending its
capabilities.

Hence, Kong is a Lua application designed to load and execute Lua modules
(which we more commonly refer to as "*plugins*") and provides an entire
development environment for them, including an SDK, database abstractions,
migrations, and more...

Plugins consists of Lua modules interacting with the request/response objects
(among other things) via the **Plugin Development Kit** (or "PDK") to implement
arbitrary logic. The PDK is a set of Lua functions that a plugin can use to
facilitate interactions between plugins and the core (or other components) of
Kong.

This guide will explore in details the structure of plugins, what they can
extend, and how to distribute and install them. For a complete reference of the
PDK, see the [Plugin Development Kit] reference.

---

Next: [File structure of a plugin &rsaquo;]({{page.book.next}})

[lua-nginx-module]: https://github.com/openresty/lua-nginx-module
[Plugin Development Kit]: /{{page.kong_version}}/pdk
