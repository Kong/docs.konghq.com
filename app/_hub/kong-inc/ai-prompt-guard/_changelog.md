## Changelog

### {{site.base_gateway}} 3.8.0.0
* Added the `match_all_roles` option to allow matching all roles in addition to `user`.
[#13183](https://github.com/Kong/kong/issues/13183)
* Fixed an issue which occurred when `allow_all_conversation_history` was set to false, and caused the first 
  user request to be selected instead of the last one.
[#13183](https://github.com/Kong/kong/issues/13183)

### {{site.base_gateway}} 3.7.0.0

* Increased the maximum length of regex expressions to 500 for the `allow` and `deny` parameters.

### {{site.base_gateway}} 3.6.0.0

* Introduced the new **AI Prompt Guard** plugin.