---
title: Welcome to Kong
---

## Introduction

<div class="alert alert-warning">
  <strong>Before you start:</strong> Make sure you've <a href="https://konghq.com/install/">installed Kong</a> &mdash; It should only take a minute!
</div>

Before going further into Kong, make sure you understand its [purpose and philosophy](/about). Once you are confident with the concept of API Gateways, this guide is going to take you through a quick introduction on how to use Kong and perform basic operations such as:

- [Running your own Kong instance][quickstart].
- [Adding and consuming APIs][adding-your-api].
- [Installing plugins on Kong][enabling-plugins].

### What is Kong, technically?

You’ve probably heard that Kong is built on Nginx, leveraging its stability and efficiency. But how is this possible exactly?

To be more precise, Kong is a Lua application running in Nginx and made possible by the [lua-nginx-module](https://github.com/openresty/lua-nginx-module). Instead of compiling Nginx with this module, Kong is distributed along with [OpenResty](https://openresty.org/), which already includes lua-nginx-module. OpenResty is *not* a fork of Nginx, but a bundle of modules extending its capabilities.

This sets the foundations for a pluggable architecture, where Lua scripts (referred to as *”plugins”*) can be enabled and executed at runtime. Because of this, we like to think of Kong as **a paragon of microservice architecture**: at its core, it implements database abstraction, routing and plugin management. Plugins can live in separate code bases and be injected anywhere into the request lifecycle, all in a few lines of code.

### What are the advantages of using Kong?

- One of the core principals of Kong is its extensibility through plugins. Plugins allow to easily add new features and tackle complex code, these plugins are written in LUA language. Kong also comes with a lot of useful plugins which can be used directly or you can even make your own plugins!

- Kong supports very flexible gateway routing which can be fully configured by using Routes. These define if traffic should be by Host-header, Method, URI path or a combination of those.

- Besides traditional DNS-based balancing, Kong provides a Ring-based balancer where you can either use round-robin or a customized hash-based balancer following the Ketama principle.

- Kong also provides analytics for all your APIs which in turn help you make your website even more powerful by diagnosing issues and optimizing it.

- Kong has a huge community of fans, users and contributors - so whether you have a doubt, problem or you need any kind of assistance, we have got you covered!
  
## Next Steps

Now, lets get familiar with learning how to "start" and "stop" Kong.

Go to [5-minute quickstart with Kong &rsaquo;][quickstart]

[quickstart]: /{{page.kong_version}}/getting-started/quickstart
[adding-your-api]: /{{page.kong_version}}/getting-started/adding-your-api
[enabling-plugins]: /{{page.kong_version}}/getting-started/enabling-plugins
