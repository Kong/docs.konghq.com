## Changelog

### {{site.base_gateway}} 3.10.x

* Added two boolean configuration fields, `hash_subject` (default `false`) and `store_metadata` (default `false`), to store the session's metadata in the database.
  
### {{site.base_gateway}} 3.5.x

* Introduced the new configuration field `read_body_for_logout` with a default value of `false`. 
This change alters the behavior of `logout_post_arg` in such a way that it is no longer considered, 
unless `read_body_for_logout` is explicitly set to `true`. 

  This adjustment prevents the Session plugin from automatically reading request bodies for 
  logout detection, particularly on POST requests.

### {{site.base_gateway}} 3.2.x
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

### {{site.base_gateway}} 3.1.x
*  Added the new configuration parameter `cookie_persistent`, which allows the
browser to persist cookies even if the browser is closed. This defaults to `false`,
which means cookies are not persisted across browser restarts.

### {{site.base_gateway}} 2.7.x

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.secret` parameter value will be encrypted.
