---
title: Introduction 
book: plugin_dev_getstarted
chapter: 1
---

This tutorial will walk you through all the steps to build a new custom plugin for {{site.base_gateway}}.
The plugin you build will transform HTTP traffic as it passes through the API gateway, and give you
a solid starting point for building custom plugins to solve your specific business needs.

The guide starts by setting up a new plugin project, showing how folders are structured and which
files contain the custom plugin code. The second chapter describes testing tools and how to build automated tests 
for your custom plugins. In the third chapter we explain how to add configuration to your plugin 
allowing for customization at runtime. 

Later chapters of the guide go further and provide guideance on more advanced topics including 
plugin deployments. 

Use the links on the bottom of these pages to navigate the guide. If you experience any issues
with this guide, please reach out by 
[reporting an issue on GitHub](https://github.com/Kong/docs.konghq.com/issues).

{:.note}
> **Note**: While not required, an understanding of the [Lua](https://www.lua.org/about.html) language
> is helpful for this guide.

{:.note}
> **Note**: This guide is written to help you quickly build a custom plugin 
> from the beginning. For advanced topics on plugin development with {{site.base_gateway}},
> be sure to see the remaining areas of documentation in the 
> [Plugin Development Section](/gateway/{{page.release_version}}/plugin-development/).
