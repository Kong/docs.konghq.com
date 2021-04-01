<!---shared with ldap-auth-adv, ldap-auth, kong manager ldap, changelog and release notes sections --->

When using only RBAC Token authorization, Service Directory Mapping to Kong Roles does not take effect. If you need to use CLI access with your Service Directory mapping, you can use the same authentication mechanism that Kong Manager uses to secure browser sessions.

#### Authenticate User Session

Retrieve a secure cookie session with the authorized LDAP user credentials:

```sh
$ curl -c /tmp/cookie http://localhost:8001/auth \
-H 'Kong-Admin-User: <LDAP_USERNAME>' \
--user <LDAP_USERNAME>:<LDAP_PASSWORD>
```

Now the cookie is stored at `/tmp/cookie` and can be read for future requests:

```sh
$ curl -c /tmp/cookie -b /tmp/cookie http://localhost:8001/consumers \
-H 'Kong-Admin-User: <LDAP_USERNAME>'
```

Because Kong Manager is a browser application, if any HTTP responses see the `Set-Cookie` header, then it will automatically attach it to future requests. This is why it is helpful to utilize [cURL's cookie engine](https://ec.haxx.se/http/http-cookies) or [HTTPie sessions](https://httpie.org/docs/0.9.7#sessions). If storing the session is not desired, then the `Set-Cookie` header value can be copied directly from the `/auth` response and used with subsequent requests.
