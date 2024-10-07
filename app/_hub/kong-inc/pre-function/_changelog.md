## Changelog

**{{site.base_gateway}} 3.0**

* The deprecated `config.functions` parameter has been removed from the plugin.
Use `config.access` instead.
* The pre-function plugin changed priority from `+inf` to `1000000`.

**{{site.base_gateway}} 2.3**

* Introduced sandboxing, which is enabled by default.
Only the Kong PDK, OpenResty `ngx` APIs, and Lua standard libraries are allowed.
To change the default setting, see the Kong [configuration property reference](/gateway/latest/reference/configuration/#untrusted_lua).

  This change was also introduced into previous releases through patch versions: 1.5.0.9, 2.1.4.3, and 2.2.1.0.
