---
title: Consumers
concept_type: explanation
---

## What is a consumer?

A consumer typically refers to an entity that consumes or uses the APIs managed by Kong. 
Consumers can be applications, services, or users who interact with your APIs. 
Since they are not always human, Kong calls them consumers, as they "consume" the service.
Kong allows you to define and manage consumers, apply access control policies, and monitor their usage of APIs.

Consumers in Kong are often associated with key authentication, OAuth, or other authentication and authorization mechanisms. 
They are essential for controlling access to your APIs, tracking usage, and ensuring security.

You can either rely on Kong Gateway as the primary datastore, or you can map the consumer list 
to your database to keep consistency between Kong Gateway and your existing primary datastore

Consumers are identified by authentication plug-ins. 
For example, adding a basic auth to a service or route allows it to identify a consumer, or block access if credentials are bad.

By attaching a plugin to a consumer, you can control things on a consumer level - for example, rate limits.

{% mermaid %}
flowchart LR
A(Consumer)
B(Auth plugin)
C(Upstream service)
A--Credentials-->B
subgraph Kong Gateway
direction LR
B
end
B-->C
{% endmermaid %}

## Use cases for consumers

* **Authentication:** Authentication plugins require credentials. To create credentials, you need a consumer object.
* **Consumer groups:** Group consumers by sets of criteria and apply certain rules to them.
* **Rate limiting:** Rate limit specific consumers based on tiers.

## Manage consumers

{% navtabs %}
{% navtab Kong Admin API %}

To create a consumer, call the Admin API and the consumer’s endpoint.
The following creates a new consumer called **consumer**:

```sh
curl -i -X POST http://localhost:8001/consumers/ \
  --data username=consumer \
  --data custom_id=consumer
```

Once provisioned, call the Admin API to provision a key for the consumer
created above. For this example, set the key to `apikey`.

```sh
curl -i -X POST http://localhost:8001/consumers/consumer/key-auth \
  --data key=apikey
```

If no key is entered, Kong automatically generates the key.

Result:

```json
HTTP/1.1 201 Created
...
{
    "consumer": {
        "id": "2c43c08b-ba6d-444a-8687-3394bb215350"
    },
    "created_at": 1568255693,
    "id": "86d283dd-27ee-473c-9a1d-a567c6a76d8e",
    "key": "apikey"
}
```

You now have a consumer with an API key provisioned to access the route.

{% endnavtab %}
{% navtab Konnect API %}
```sh
curl -X POST https://{us|eu}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/consumers \
  --data username=alex
```
{% endnavtab %}
{% navtab decK (YAML) %}
``` yaml
_format_version: "3.0""
consumers:
- custom_id: consumer
    username: consumer
    keyauth_credentials:
    - key: apikey
```
{% endnavtab %}
{% navtab KIC (YAML) %}
```yaml
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
 name: alex
 annotations:
   kubernetes.io/ingress.class: kong
username: alex
credentials:
- alex-key-auth
```
{% endnavtab %}
{% navtab Kong Manager %}

1. In Kong Manager, go to **API Gateway** > **Consumers**.
2. Click **New Consumer**.
3. Enter the **Username** and **Custom ID**. For this example, use `consumer` for each field.
4. Click **Create**.
5. On the Consumers page, find your new consumer and click **View**.
6. Scroll down the page and click the **Credentials** tab.
7. Click **New Key Auth Credential**.
8. Set the key to `apikey` and click **Create**.

  The new Key Authentication ID displays on the **Consumers** page under the **Credentials** tab.
{% endnavtab %}
{% navtab Konnect - Gateway Manager %}

1. In Gateway Manager, go to **API Gateway** > **Consumers**.
2. Click **New Consumer**.
3. Enter the **Username** and **Custom ID**. For this example, use `consumer` for each field.
4. Click **Create**.
5. On the Consumers page, find your new consumer and click **View**.
6. Scroll down the page and click the **Credentials** tab.
7. Click **New Key Auth Credential**.
8. Set the key to `apikey` and click **Create**.

  The new Key Authentication ID displays on the **Consumers** page under the **Credentials** tab.
{% endnavtab %}
{% endnavtabs %}

## FAQs

<details><summary>What is the difference between consumers and applications?</summary>

Applications provide developers the ability to, in a self-service way, get access to APIs managed by Kong with no interaction from the Kong team to generate credentials required.

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

Certain plugins can be scoped to consumers (as opposed to services, routes, or globally). 
You can see the full list in the <a href="/hub/plugins/compatibility/#scopes">plugin scopes compatibility reference</a>.
</details>

<details><summary>Are consumers used in Kuma/Mesh?</summary>

No.
</details>

## Related links

* [Authentication reference](/gateway/latest/kong-plugins/authentication/reference/)
* [Consumers API reference](/gateway/api/admin-ee/latest/#/Consumers)
* [Consumer groups API reference](/gateway/api/admin-ee/latest/#/consumer_groups)
* [Plugins that can be enabled on consumers](/hub/plugins/compatibility/#scopes)