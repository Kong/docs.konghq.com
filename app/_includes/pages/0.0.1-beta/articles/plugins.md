# Plugins

One of the most important concept to understand are Kong Plugins. All the functionalities provided by Kong are served by easy to use **plugins**: authentication, rate-limiting, logging features are provided through an authentication plugin, a rate-limiting plugin, and a logging plugin among the others. You can decide which plugin to install and how to configure them through the Kong's RESTful internal API.

Feel free to explore the available plugins by looking at the [Plugins Gallery](/plugins/).

From a technical perspective, a Plugin is [Lua](http://www.lua.org/) code that's being executed into the life-cycle of an API request and response. By having Plugins, Kong can be extended to fit any custom need or integration challenge. For example, if you need to integrate the API user authentication with a third-party enterprise security system, that would be implemented in a dedicated Plugin that will run on every API request. More advanced users can build their own plugins, to extend the functionalities of Kong. If you would like to build your own plugin, please [contact us](/enterprise/).