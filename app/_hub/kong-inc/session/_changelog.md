## Changelog

**{{site.base_gateway}} 3.2.x**
* The plugin has been updated to use version 4.0.0 of the `lua-resty-session` library. This introduced several new features, such as the possibility to specify an `audience` for the session.
The following configuration parameters were affected:

  Added:
    * `audience`
    * `remember`
    * `remember_cookie_name`
    * `remember_rolling_timeout`
    * `remember_absolute_timeout`
    * `absolute_timeout`
    * `request_headers`
    * `response_headers`
  
  Renamed:
    * `cookie_lifetime` to `rolling_timeout`
    * `cookie_idletime` to `idling_timeout`
    * `cookie_samesite` to `cookie_same_site`
    * `cookie_httponly` to `cookie_http_only`
    * `cookie_discard` to `stale_ttl`
  
  Removed:
    * `cookie_renew`

**{{site.base_gateway}} 3.1.x**
*  Added the new configuration parameter `cookie_persistent`, which allows the
browser to persist cookies even if the browser is closed. This defaults to `false`,
which means cookies are not persisted across browser restarts.

**{{site.base_gateway}} 2.7.x**

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.secret` parameter value will be encrypted.

[plugin]: https://docs.konghq.com/hub/
[lua-resty-session]: https://github.com/bungle/lua-resty-session
[multiple authentication]: https://docs.konghq.com/gateway/latest/kong-plugins/authentication/reference/#multiple-authentication
[key auth]: https://docs.konghq.com/hub/kong-inc/key-auth/
[request termination]: https://docs.konghq.com/hub/kong-inc/request-termination/
