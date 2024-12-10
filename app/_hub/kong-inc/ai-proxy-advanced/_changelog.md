## Changelog

### {{site.base_gateway}} 3.9.x
* Added support for streaming responses to the AI Proxy Advanced plugin.
* Made the `embeddings.model.name` config field a free text entry, enabling use of a self-hosted (or otherwise compatible) model.
* Fixed an issue where lowest-usage and lowest-latency strategies did not update data points correctly.
* Fixed an issue where stale plugin config was not updated in DB-less and hybrid modes.

### {{site.base_gateway}} 3.8.x

* Introduced the AI Proxy Advanced plugin, which mediates request and response formats, as well as authentication between users and multiple AI providers. This plugin supports load balancing, semantic routing, and multi-provider transformations and provides enhanced request mediation, usage tracking, and self-hosted model support over the regular AI Proxy plugin
