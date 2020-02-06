---
title: Welcome to Kong
---

<div class="alert alert-warning">
  <strong>Before you start:</strong> Make sure you've <a href="https://konghq.com/install/">installed Kong</a> &mdash; It should only take a minute!
</div>

Before going further into Kong, make sure you understand its [purpose and philosophy](/about). Once you are confident with the concept of API Gateways, this guide is going to take you through a quick introduction on how to use Kong and perform basic operations such as:

- [Running your own Kong instance][quickstart]
- [Adding and consuming Services][configuring-a-service]
- [Installing plugins on Kong][enabling-plugins]

## What is Kong, technically?

You’ve probably heard that Kong is built on Nginx, leveraging its stability and efficiency. But how is this possible exactly?

To be more precise, Kong is a Lua application running in Nginx and made possible by the [lua-nginx-module](https://github.com/openresty/lua-nginx-module). Instead of compiling Nginx with this module, Kong is distributed along with [OpenResty](https://openresty.org/), which already includes lua-nginx-module. OpenResty is *not* a fork of Nginx, but a bundle of modules extending its capabilities.

This sets the foundations for a pluggable architecture, where Lua scripts (referred to as *”plugins”*) can be enabled and executed at runtime. Because of this, we like to think of Kong as **a paragon of microservice architecture**: at its core, it implements database abstraction, routing and plugin management. Plugins can live in separate code bases and be injected anywhere into the request lifecycle, all in a few lines of code.

## Next Steps

Now, lets get familiar with learning how to "start" and "stop" Kong.

Go to [5-minute quickstart with Kong &rsaquo;][quickstart]

[quickstart]: /{{page.kong_version}}/getting-started/quickstart
[configuring-a-service]: /{{page.kong_version}}/getting-started/configuring-a-service
[enabling-plugins]: /{{page.kong_version}}/getting-started/enabling-plugins
