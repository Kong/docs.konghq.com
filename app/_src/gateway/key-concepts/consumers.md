---
title: Consumers
concept_type: reference
---

## What is a consumer?

A consumer typically refers to an entity that consumes or uses the APIs managed by {{site.base_gateway}}. 
Consumers can be applications, services, or users who interact with your APIs. 
Since they are not always human, {{site.base_gateway}} calls them consumers, because they "consume" the service.
{{site.base_gateway}} allows you to define and manage consumers, apply access control policies, and monitor their API usage.

Consumers are essential for controlling access to your APIs, tracking usage, and ensuring security.
They are identified by key authentication, OAuth, or other authentication and authorization mechanisms. 
For example, adding a Basic Auth plugin to a service or route allows it to identify a consumer, or block access if credentials are invalid.

You can choose to use {{site.base_gateway}} as the primary datastore for consumers, or you can map the consumer list 
to an existing database to keep consistency between {{site.base_gateway}} and your existing primary datastore.

By attaching a plugin directly to a consumer, you can manage specific controls at the consumer level, such as rate limits.

{% mermaid %}
flowchart LR

A(Consumer entity)
B(Auth plugin)
C[Upstream service]

Client --> A
subgraph id1[{{site.base_gateway}}]
direction LR
A--Credentials-->B
end

B-->C
{% endmermaid %}

## Use cases for consumers

The following are examples of common use cases for consumers:

Use case | Description
---------|------------
Authentication | Client authentication is the most common reason for setting up a consumer. If you're using an authentication plugin, you'll need a consumer with credentials.
Consumer groups | Group consumers by sets of criteria and apply certain rules to them.
Rate limiting | Rate limit specific consumers based on tiers.

## Manage consumers

{% navtabs %}
{% navtab Kong Admin API %}

To create a consumer, call the [Admin API's `/consumers` endpoint](/gateway/api/admin-ee/latest/#/Consumers).
The following creates a consumer called **example-consumer**:

```sh
curl -i -X POST http://localhost:8001/consumers/ \
  --data username=example-consumer \
  --data custom_id=example-consumer-id \
  --data tags[]=silver-tier
```

{% endnavtab %}
{% navtab Konnect API %}

To create a consumer, call the {{site.konnect_short_name}} [control plane config API's `/consumers` endpoint](/konnect/api/control-plane-configuration/latest/#/Consumers).
The following creates a consumer called **example-consumer**:

```sh
curl -X POST https://{us|eu}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/consumers \
  --data '{
    "custom_id":"example-consumer-id",
    "tags":["silver-tier"],
    "username":"example-consumer"
    }'
```
{% endnavtab %}
{% navtab decK (YAML) %}

The following creates a consumer called **example-consumer**:

``` yaml
_format_version: "3.0"
consumers:
- custom_id: example-consumer-id
  username: example-consumer
  tags:
    - silver-tier
```
{% endnavtab %}
{% navtab KIC (YAML) %}

The following creates a consumer called **example-consumer**:

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
 name: example-consumer
 annotations:
   kubernetes.io/ingress.class: kong
username: example-consumer
```
{% endnavtab %}
{% navtab Kong Manager or Gateway Manager %}

The following creates a new consumer called **example-consumer**:

1. In Kong Manager or Gateway Manager, go to **API Gateway** > **Consumers**.
2. Click **New Consumer**.
3. Enter the **Username** and **Custom ID**.
4. Click **Create**.

{% endnavtab %}
{% endnavtabs %}

### Next steps

You will need a credential for each consumer.
Find your [authentication plugin](/hub/?category=authentication) 
for the specific instructions for each authentication method. Open the plugin, go to **Using this plugin** > **Basic examples**, 
then choose your preferred tool and follow the instructions.

## FAQs

<details><summary>What are credentials, and why do I need them?</summary>
Credentials are necessary to authenticate consumers via various authentication mechanisms. 
The credential type depends on which authentication plugin you want to use.
<br><br>
For example, a Key Authentication plugin requires an API key, and a Basic Auth plugin requires a username and password pair.
</details>

<details><summary>What is the difference between consumers and applications?</summary>

Applications provide developers the ability to get access to APIs managed by {{site.base_gateway}} or {{site.konnect_short_name}} 
with no interaction from the Kong admin team to generate credentials required.
<br><br>
With consumers, the Kong team creates consumers, generates credentials and needs to share them with the developers that need access to the APIs.
You can think as applications as a type of consumer in Kong that allows developers to automatically obtain credentials for and subscribe to the required APIs.

</details>

<details><summary>What is the difference between consumers and developers?</summary>

Developers are real users of the Dev Portal, whereas consumers are abstractions.

</details>

<details><summary>What is the difference between consumers and RBAC users?</summary>

RBAC users are users of Kong Manager, whereas consumers are users (real or abstract) of the Gateway itself.

</details>

<details><summary>Which plugins can be scoped to consumers?</summary>

Certain plugins can be scoped to consumers (as opposed to services, routes, or globally). For example, you might want to 
configure the Rate Limiting plugin to rate limit a specific consumer, or use the Request Transformer plugin to edit requests for that consumer.
You can see the full list in the <a href="/hub/plugins/compatibility/#scopes">plugin scopes compatibility reference</a>.
</details>

<details><summary>Can you scope authentication plugins to consumers?</summary>

No. You can associate consumers with an auth plugin by configuring credentials - a consumer with basic 
auth credentials will use the Basic Auth plugin, for example. 
But that plugin must be scoped to either a route, service, or globally, so that the consumer can access it.

</details>

<details><summary>Are consumers used in Kuma/Mesh?</summary>

No.
</details>

<details><summary>Can you manage consumers with decK?</summary>

Yes, you can manage consumers using decK, but take caution if you have a large number of consumers.
<br><br>
If you have many consumers in your database, don't export or manage them using decK. 
decK is built for managing entity configuration. It is not meant for end user data, 
which can easily grow into hundreds of thousands or millions of records.
</details>

## Related links

* [Authentication reference](/gateway/latest/kong-plugins/authentication/reference/)
* [Consumers API reference - {{site.base_gateway}}](/gateway/api/admin-ee/latest/#/Consumers)
* [Consumers API reference - {{site.konnect_short_name}}](/konnect/api/control-plane-configuration/latest/#/Consumers)
* [Consumer groups API reference](/gateway/api/admin-ee/latest/#/consumer_groups)
* [Plugins that can be enabled on consumers](/hub/plugins/compatibility/#scopes)