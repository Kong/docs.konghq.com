---
title: Create Consumer Groups in Konnect
content_type: tutorial
badge: enterprise
---

With [consumer groups](/gateway/latest/key-concepts/consumer-groups/), you can scope plugins to specifically defined groups and a new plugin instance will be created for each individual consumer group, making configurations and customizations more flexible and convenient. 
For all plugins available on the consumer groups scope, see the [Plugin Scopes Reference](/hub/plugins/compatibility/#scopes).

## Create a consumer group in {{site.konnect_short_name}}

The following creates a new consumer group:

1. In Gateway Manager, go to a {{site.base_gateway}} control plane > **Consumers**.
2. Open the **Consumer Groups** tab.
3. Click **New Consumer Group**.
4. Enter a group name and select consumers to add to the group.
5. Click **Save**.

On the consumer group's overview page, you can now add any supported plugin. 
This plugin will apply to all consumers in the group.

## decK example

Let's look at a more complex example where you define three consumer groups for rate limiting consumers. In this example, each consumer group represents a different tier of support, such as Free, Basic, and Premium. Each tier will have different rate limits. For example, the Free tier has lower rate limits than the Premium tier.

We'll be using [decK](/deck/) to reduce the configuration complexity, but you can achieve all of this using the {{site.konnect_short_name}} admin interface or API as well.

In the following decK file, you have:
1. Consumer authentication via the Key Authentication plugin
2. Three consumer groups (Free, Basic, Premium)
3. Three consumers, each belonging to a different group
4. The Rate Limiting Advanced plugin configured with a different rate limit on each consumer group 

Save the following content to a file named `konnect.yaml`:
```yaml
_format_version: '3.0'
services:
  - name: example-service
    url: http://httpbin.konghq.com/anything
routes:
  - name: example-route
    paths:
    - "/anything"
    service:
      name: example-service
consumer_groups:
  - name: Free
  - name: Basic
  - name: Premium
consumers:
  - username: Amal
    groups:
    - name: Free
    keyauth_credentials:
    - key: amal
  - username: Dana
    groups:
    - name: Basic
    keyauth_credentials:
    - key: dana
  - username: Mahan
    groups:
    - name: Premium
    keyauth_credentials:
    - key: mahan
plugins:
  - name: key-auth
    config:
      key_names:
      - apikey
  - name: rate-limiting-advanced
    consumer_group: Free
    config:
      limit:
      - 3
      window_size:
      - 30
      window_type: fixed
      retry_after_jitter_max: 0
      namespace: free
  - name: rate-limiting-advanced
    consumer_group: Basic
    config:
      limit:
      - 5
      window_size:
      - 30
      window_type: sliding
      retry_after_jitter_max: 0
      namespace: basic
  - name: rate-limiting-advanced
    consumer_group: Premium
    config:
      limit:
      - 500
      window_size:
      - 30
      window_type: sliding
      retry_after_jitter_max: 0
      namespace: premium
```

Check your configuration with `deck gateway diff`, adding in your [{{site.konnect_short_name}} token](/konnect/org-management/access-tokens/) and control plane name:

```sh
deck gateway diff konnect.yaml \
 --konnect-token $KONNECT_TOKEN \
 --konnect-control-plane-name $KONNECT_CP_NAME
```

If everything looks right, synchronize the file to {{site.konnect_short_name}} to update your Gateway configuration:

```sh
deck gateway sync konnect.yaml \
  --konnect-token $KONNECT_TOKEN \
  --konnect-control-plane-name $KONNECT_CP_NAME
```

### Validate

Now we can test that each rate limiting tier is working as expected by sending a series of HTTP requests (for example, six for Free Tier and seven for Basic Tier) to the endpoint with the appropriate API key with the goal of exceeding the configured rate limit for that tier. The tests wait for one second between requests to avoid overwhelming the server and test rate limits more clearly.

Test the rate limiting of the Free tier:

```sh
echo "Testing Free Tier Rate Limit..."

for i in {1..6}; do
  curl -I http://localhost:8000/anything -H 'apikey:amal'
  echo
  sleep 1
done
```

For the first few requests (up to the configured limit, which is 3 requests in 30 seconds), you should receive a `200 OK` status code. Once the limit is exceeded, you should receive a `429 Too Many Requests` status code with a message indicating the rate limit has been exceeded.

You can do the same for the Basic tier:
```sh
echo "Testing Basic Tier Rate Limit..."

for i in {1..7}; do
  curl -I http://localhost:8000/anything -H 'apikey:dana'
  echo
  sleep 1
done
```

And for the Premium tier:

```sh
echo "Testing Premium Tier Rate Limit..."

for i in {1..11}; do
  curl -I http://localhost:8000/anything -H 'apikey:mahan'
  echo
  sleep 1
done
```