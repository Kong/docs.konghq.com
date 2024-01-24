---
nav_title: Consumer authorization
---

To use the plugin, you first need to create a consumer and associate one or more
[JWT credentials](/hub/kong-inc/jwt/how-to/credentials/) (holding the public and private keys used to verify the token) to it.
The Consumer represents a developer using the final service.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object.
A Consumer can have many credentials.

{% navtabs %}
{% navtab Kong Admin API %}
To create a Consumer, you can execute the following request:

```bash
curl -d "username=<user123>&custom_id=<SOME_CUSTOM_ID>" http://localhost:8001/consumers/
```
{% endnavtab %}
{% navtab Declarative (YAML) %}
Your declarative configuration file will need to have one or more Consumers. You can create them
on the `consumers:` yaml section:

``` yaml
consumers:
- username: <user123>
  custom_id: <SOME_CUSTOM_ID>
```
{% endnavtab %}
{% endnavtabs %}

In both cases, the parameters are as described below:

parameter                       | description
---                             | ---
`username`<br>*semi-optional*   | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.