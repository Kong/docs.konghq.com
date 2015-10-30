---
title: Plugin Development - Introduction
book: plugin_dev
chapter: 1
---

# Plugin development - Introduction

### What are plugins and how do they integrate with Kong?

Before going further, it is necessary to briefly explain how Kong is built, especially how it integrates with Nginx and what does Lua has to do with it.

[lua-nginx-module] enables Lua scripting capabilities in Nginx. Instead of compiling Nginx with this module, Kong is distributed along with [OpenResty](https://openresty.org/), which already includes lua-nginx-module. OpenResty is *not* a fork of Nginx, but a bundle of modules extending its capabilities.

Hence, Kong is a Lua application designed to load and execute Lua modules (which we more commonly refer to as "*plugins*") and provides an entire development environment for them, including database abstraction, migrations, helpers and more...

Your plugin will consist of Lua modules which will be loaded and executed by Kong, and it will benefit from two APIs:

- [lua-nginx-module API][lua-nginx-module]: allows interaction with Nginx itself, such as, for example, retrieving the request/response, or accessing Nginx's shared memory zone.
- **Kong's plugin environment**: allows interaction with the datastore holding your configurations (APIs, Consumers, Plugins...) and various helpers allowing the interaction of plugins between each other. This is the environment that will be described by this guide.

<div class="alert alert-warning">
  <strong>Note:</strong> This guide assumes that you are familiar with <a href="http://www.lua.org/">Lua</a> and the <a href="https://github.com/openresty/lua-nginx-module">lua-nginx-module API</a> and will only describe Kong's plugin environment.
</div>

---

Next: [File structure of a plugin &rsaquo;]({{page.book.next}})

[lua-nginx-module]: https://github.com/openresty/lua-nginx-module
