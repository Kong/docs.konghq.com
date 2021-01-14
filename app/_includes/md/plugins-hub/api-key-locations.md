<!---will be shared in future with key-auth-enc plugin, also shared with on-prem app reg key-auth --->

Use cases for key locations:

* Recommended: Use `key_in_header` (enabled by default) as the most common and
  secure way to do service-to-service calls.
* If you need to share links to browser clients, use `key_in_query` (enabled by default).
  Note that query parameter requests can appear within application logs and URL browser bars,
  which expose the API key.
* If you are sending a form with a browser, such as a login form, use `key_in_body`. This option is
  set to `false` by default because it's a less common use case, and is a
  more expensive and less performant HTTP request.

For better security, only enable the key locations that you need to use.
