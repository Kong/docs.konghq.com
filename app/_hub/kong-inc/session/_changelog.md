## Changelog

**{{site.base_gateway}} 3.1.x**
*  Added the new configuration parameter `cookie_persistent`, which allows the
browser to persist cookies even if the browser is closed. This defaults to `false`,
which means cookies are not persisted across browser restarts.

**{{site.base_gateway}} 2.7.x**

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.secret` parameter value will be encrypted.

[plugin]: https://docs.konghq.com/hub/
[lua-resty-session]: https://github.com/bungle/lua-resty-session
[multiple authentication]: https://docs.konghq.com/0.14.x/auth/#multiple-authentication
[key auth]: https://docs.konghq.com/hub/kong-inc/key-auth/
[request termination]: https://docs.konghq.com/hub/kong-inc/request-termination/
