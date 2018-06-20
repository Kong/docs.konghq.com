---
title: FAQ Kong Developer Portal
---

# FAQ

I am going to [:8003](http://127.0.0.1:8003/) but I only see `{"message":"not found"}`

    * Check your kong.conf configuration file (/etc/kong/kong.conf by default) to ensure the Dev Portal is set to `on`

When I browse to the Dev Portal, it is blank.

* Check a few things:
   * Are there files populated? Browse to [:8004/files](http://127.0.0.1:8004/files) to check. If you don't have any files in your Kong database, then the portal will not render anything.
   * Difference between 127.0.0.1 vs localhost can affect authentication responses. Look into CORS plugin configuration, Kong configuration, and request url to ensure consistency.
   * Which requests, if any, are failing? If you are getting 401 responses, double check proxy + plugin configuration, and make sure unauthenticated files can be requested without credentials
   * Double check spelling of proxy URI with Kong configuration.
   * Check your browser's console and networking output for errors and additional helpful information.
