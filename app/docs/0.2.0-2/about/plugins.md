---
title: What are plugins?
alias: /docs/latest/about/plugins
---

# What are plugins?

Plugins are one of the most important features of Kong. All the functionalities provided by Kong are done so by easy to use **plugins**. Authentication, rate-limiting, logging and many more. Plugins can be installed and configured through Kong's REStful Admin API.

Feel free to explore available plugins by browsing the [Plugin Gallery](/plugins).

From a technical perspective, a plugin is some [Lua](http://www.lua.org/) code that's being executed during the life-cycle of an API request and response. Through plugins, Kong can be extended to fit any custom need or integration challenge. For example, if you need to integrate the API user authentication with a third-party enterprise security system, that would be implemented in a dedicated plugin that is run on every API request.
