---
title: Event Hooks Examples
badge: enterprise
---

{% include_cached /md/enterprise/event-hooks-intro.md %}

## Webhook

Webhook event hooks make JSON POST requests to a provided URL with the event data as a payload.
For this example, we will use a site that is helpful for testing webhooks: [https://webhook.site](https://webhook.site).

To create a webhook event hook:

1. Generate a URL by navigating to [https://webhook.site](https://webhook.site) in your web browser.
2. Select **Copy to clipboard** next to **Your unique URL**.
3. Create a webhook event hook on the `consumers` event (Kong entity the event hook will listen to for events),
   on the `crud` source (action that triggers logging), and the URL you copied from step 2 using the following HTTP request:
{% capture the_code %}
{% navtabs codeblock %}
{% navtab cURL %}

<div class="copy-code-snippet"><pre><code>curl -i -X POST http://<div contenteditable="true">{HOSTNAME}</div>:8001/event-hooks \
-d source=crud \
-d event=consumers \
-d handler=webhook \
-d config.url=<div contenteditable="true">{WEBHOOK_URL}</div></code></pre></div>

{% endnavtab %}
{% navtab HTTPie %}

<div class="copy-code-snippet"><pre><code>http -f :8001/event-hooks \
source=crud \
event=consumers \
handler=webhook \
config.url=<div contenteditable="true">{WEBHOOK_URL}</div></code></pre></div>

{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

4. Navigate to the URL from step 2. You should see a POST request, of type `ping`, notifying our webhook endpoint
   about the creation of this webhook.
5. In Kong Manager or Kong Admin API, add a consumer from any workspace.

{% capture the_code2 %}
{% navtabs %}
{% navtab Kong Manager %}

1. Select the workspace.
2. Select **Consumers** in the left navigation.
3. Select the **New Consumer** button.
4. Enter a **Username**.
5. (Optional) Enter a **Custom ID** and any **Tags**.
6. Select the **Create** button.

{% endnavtab %}
{% navtab Admin API %}

Create a consumer, Ada Lovelace, by making the following HTTP request to your instance of the Kong Admin API:

{% navtabs codeblock %}
{% navtab cURL %}

<div class="copy-code-snippet"><pre><code>curl -i -X POST http://<div contenteditable="true">{HOSTNAME}</div>:8001/consumers \
-d username="Ada Lovelace"</code></pre></div>

{% endnavtab %}
{% navtab HTTPie %}

<div class="copy-code-snippet"><pre><code>http -f :8001/consumers \
username="Ada Lovelace"</code></pre><div>

{% endnavtab %}
{% endnavtabs %}

{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code2 | indent }}

6. Check the URL from the [https://webhook.site](https://webhook.site) page.
   You should see an entry with data for the new consumer in its payload.

    ```json
    {
    "source": "crud",
    "entity": {
      "created_at": 1627581878,
      "type": 0,
      "username": "Ada Lovelace",
      "id": "0fd2319f-13ea-4582-a448-8d11893026a8"
    },
    "event": "consumers",
    "operation": "create",
    "schema": "consumers"
    }
    ```

## Custom webhook

Custom webhook event hooks are fully customizable requests. Custom webhooks are useful for building direct
integration with a service. Because custom webhooks are fully configurable, they have more complex configurations.
Custom webhooks support Lua templating on a configurable body, form payload, and headers. For a list of
possible fields for templating, see the [sources](/gateway/{{ page.kong_version }}/admin-api/event-hooks/reference/#list-all-sources) endpoint.

The following example sends a message to Slack any time a new administrator is invited to Kong Gateway.
Slack allows for [incoming webhooks](https://slack.com/help/articles/115005265063-Incoming-webhooks-for-Slack#set-up-incoming-webhooks)
and we can use these to build an integration with Kong's event hooks features.

To create a custom webhook event hook:

1. [Create an app in Slack.](https://api.slack.com/apps?new_app=1)
2. Activate incoming webhooks in the settings for your new app.
3. Select to **Add New Webhook to Workspace**, select the channel where you wish to receive notices, and select **Allow**.
4. Copy the **Webhook URL**, for example `https://hooks.slack.com/services/foo/bar/baz`.
5. Create a webhook event hook on the `admins` event (Kong entity the event hook will listen to for events),
   and the `crud` source (action that triggers logging), and format the payload as, {% raw %}"Admin account \`{{ entity.username }}\` {{ operation }}d; e-mail address set to \`{{ entity.email }}\`"{% endraw %}, using the following HTTP request:

{% capture the_code3 %}
{% navtabs codeblock %}
{% navtab cURL %}

<div class="copy-code-snippet"><pre><code>curl -i -X POST http://<div contenteditable="true">{HOSTNAME}</div>:8001/event-hooks \
-d source=crud \
-d event=admins \
-d handler=webhook-custom \
-d config.method=POST \
-d config.url=<div contenteditable="true">{WEBHOOK_URL}</div> \
-d config.headers.content-type="application/json" \
-d config.payload.text={% raw %}"Admin account \`{{ entity.username }}\` {{ operation}}d; email address set to \`{{ entity.email }}\`"{% endraw %}</code></pre></div>

{% endnavtab %}
{% navtab HTTPie %}

<div class="copy-code-snippet"><pre><code>http -f :8001/event-hooks \
source=crud \
event=admins \
handler=webhook-custom \
config.method=POST \
config.url=<div contenteditable="true">{WEBHOOK_URL}</div> \
config.headers.content-type="application/json" \
config.payload.text={% raw %}"Admin account \`{{ entity.username }}\` {{ operation}}d; email address set to \`{{ entity.email }}\`"{% endraw %}</code></pre></div>

{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code3 | indent }}

6. Turn on RBAC.

{% capture anInclude %}
{% include_cached /md/enterprise/turn-on-rbac.md %}
{% endcapture %}
{{ anInclude | indent }}

7. Invite an Admin using Kong Manager or the Kong Admin API.

{% capture the_code2 %}
{% navtabs %}
{% navtab Kong Manager %}

1. Go to Kong Manager, or reload the page if you already have it open and you will see a login screen.
2. Log in to Kong Manager with the built-in Super Admin account, `kong_admin`, and its password.
   This is the initial `KONG_PASSWORD` you used when you ran migrations during installation.
3. From the **Teams > Admins** tab, click **Invite Admin**.
4. Enter the new administrator's **Email** address and **Username**.
5. Click **Invite Admin** to send the invite.
  At this point in the getting started guide, you likely haven’t set up SMTP yet, so no email will be sent.

{% endnavtab %}
{% navtab Admin API %}

Create an admin, Arya Stark, by making the following HTTP request to your instance of the Kong Admin API:

{:.note}
> **Note:** Replace `{KONG_ADMIN_PASSWORD`} with your `kong_admin` password. This is the initial
  `KONG_PASSWORD` you used when you ran migrations during installation.

{% navtabs codeblock %}
{% navtab cURL %}

<div class="copy-code-snippet"><pre><code>curl -i -X POST http://<div contenteditable="true">{HOSTNAME}</div>:8001/admins \
-d username="Arya Stark" \
-d email=arya@gameofthrones.com \
-H Kong-Admin-Token:{KONG_ADMIN_PASSWORD}</code></pre></div>

{% endnavtab %}
{% navtab HTTPie %}

<div class="copy-code-snippet"><pre><code>http -f :8001/admins \
username="Arya Stark" \
email=arya@gameofthrones.com \
Kong-Admin-Token={KONG_ADMIN_PASSWORD}</code></pre><div>

{% endnavtab %}
{% endnavtabs %}

{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code2 | indent }}

Afterwards, you should receive a message in the Slack channel you selected with the message you included as the
`config.payload.text`.

## Log

Log event hooks log the specified event and content of the payload into the Kong Gateway logs.

To create a log event hook:

1. Create a log event hook on the `consumers` event (Kong entity the event hook will listen to for events)
  and on the `crud` source (action that triggers logging) using the following HTTP request:

{% capture the_code5 %}
{% navtabs codeblock %}
{% navtab cURL %}

<div class="copy-code-snippet"><pre><code>curl -i -X POST http://<div contenteditable="true">{HOSTNAME}</div>:8001/event-hooks \
-d source=crud \
-d event=consumers \
-d handler=log</code></pre></div>

{% endnavtab %}
{% navtab HTTPie %}

<div class="copy-code-snippet"><pre><code>http -f :8001/event-hooks \
source=crud \
event=consumers \
handler=log</code></pre></div>

{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code5 | indent }}

2. In Kong Manager or Kong Admin API, add a consumer from any workspace.

{% capture the_code6 %}
{% navtabs %}
{% navtab Kong Manager %}

1. Select the workspace.
2. Select **Consumers** in the left navigation.
3. Select the **New Consumer** button.
4. Enter a **Username**.
5. (Optional) Enter a **Custom ID** and any **Tags**.
6. Select the **Create** button.

{% endnavtab %}
{% navtab Admin API %}

Create a consumer, Elizabeth Bennet, by making the following HTTP request to your instance of the Kong Admin API:

{% navtabs codeblock %}
{% navtab cURL %}

<div class="copy-code-snippet"><pre><code>curl -i -X POST http://<div contenteditable="true">{HOSTNAME}</div>:8001/consumers \
-d username="Elizabeth Bennet"</code></pre></div>

{% endnavtab %}
{% navtab HTTPie %}

<div class="copy-code-snippet"><pre><code>http -f :8001/consumers \
username="Elizabeth Bennet"</code></pre><div>

{% endnavtab %}
{% endnavtabs %}

{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code6 | indent }}

3. You should see an entry with data for the new consumer in the payload in Kong's error log,
   which is typically accessible at `/usr/local/kong/logs/error.log`.

    ```log
    172.19.0.1 - - [29/Jul/2021:15:57:15 +0000] "POST /consumers HTTP/1.1" 409 147 "-" "HTTPie/2.4.0"
    2021/07/29 15:57:26 [notice] 68854#0: *819021 +--------------------------------------------------+, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001
    2021/07/29 15:57:26 [notice] 68854#0: *819021 |[kong] event_hooks.lua:?:452 "log callback: " { "consumers", "crud", {|, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001
    2021/07/29 15:57:26 [notice] 68854#0: *819021 |    entity = {                                    |, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001
    2021/07/29 15:57:26 [notice] 68854#0: *819021 |      created_at = 1627574246,                    |, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001
    2021/07/29 15:57:26 [notice] 68854#0: *819021 |      id = "4757bd6b-8d54-4b08-bf24-01e346a9323e",|, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001
    2021/07/29 15:57:26 [notice] 68854#0: *819021 |      type = 0,                                   |, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001
    2021/07/29 15:57:26 [notice] 68854#0: *819021 |      username = "Elizabeth Bennet"               |, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001
    2021/07/29 15:57:26 [notice] 68854#0: *819021 |    },                                            |, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001
    2021/07/29 15:57:26 [notice] 68854#0: *819021 |    operation = "create",                         |, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001
    2021/07/29 15:57:26 [notice] 68854#0: *819021 |    schema = "consumers"                          |, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001
    2021/07/29 15:57:26 [notice] 68854#0: *819021 |  }, 68854 }                                      |, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001
    2021/07/29 15:57:26 [notice] 68854#0: *819021 +--------------------------------------------------+, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001

    ```

## Lambda

The lambda event hook allows you to write completely custom logic in Lua code and
hook it into a variety of Kong events. The following example writes a log entry
any time a consumer changes, but conditionally and with custom formatting.

{:.important}
> The lambda event hook type is extremely powerful: you can write completely custom logic to handle any use case you want.
However, it’s [restricted by default through the sandbox.](/gateway/{{ page.kong_version }}/reference/configuration/#untrusted_lua).  This
sandbox is put in place to keep users safe: it’s easy to inadvertently add unsafe libraries/objects into the sandbox
and leave the Kong Gateway exposed to security vulnerabilities. Use caution before modifying these sandbox settings.

To create a lambda event hook:

1. Create a Lua script to load into the lambda event hook and save it to a file named `lambda.lua` on your home directory.

    ```lua
    return function (data, event, source, pid)
      local user = data.entity.username
      error("Event hook on consumer " .. user .. "")
    end
    ```
2. Create a lambda event hook on the `consumers` event (Kong entity the event hook will listen to for events)
  and on the `crud` source (action that triggers logging) using the following HTTP request:

{% capture the_code7 %}
{% navtabs codeblock %}
{% navtab cURL %}

<div class="copy-code-snippet"><pre><code>curl -i -X POST http://<div contenteditable="true">{HOSTNAME}</div>:8001/event-hooks \
-d source=crud \
-d event=consumers \
-d handler=lambda \
-F config.functions='return function (data, event, source, pid) local user = data.entity.username error("Event hook on consumer " .. user .. "")end'</code></pre></div>

{% endnavtab %}
{% navtab HTTPie %}

<div class="copy-code-snippet"><pre><code>http -f :8001/event-hooks \
source=crud \
event=consumers \
handler=lambda \
config.functions[]=@~/lambda.lua</code></pre></div>

{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code7 | indent }}

3. In Kong Manager or Kong Admin API, add a consumer to any workspace.

{% capture the_code8 %}
{% navtabs %}
{% navtab Kong Manager %}

1. Select the workspace.
2. Select **Consumers** in the left navigation.
3. Select the **New Consumer** button.
4. Enter a **Username**.
5. (Optional) Enter a **Custom ID** and any **Tags**.
6. Select the **Create** button.

{% endnavtab %}
{% navtab Admin API %}

Create a consumer, Lois Lane, by making the following HTTP request to your instance of the Kong Admin API:

{% navtabs codeblock %}
{% navtab cURL %}

<div class="copy-code-snippet"><pre><code>curl -i -X POST http://<div contenteditable="true">{HOSTNAME}</div>:8001/consumers \
-d username="Lois Lane"</code></pre></div>

{% endnavtab %}
{% navtab HTTPie %}

<div class="copy-code-snippet"><pre><code>http -f :8001/consumers \
username="Lois Lane"</code></pre></div>

{% endnavtab %}
{% endnavtabs %}

{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code8 | indent }}

3. You should see an entry "Event hook on consumer Lois Lane" in Kong's error log,
   which is typically accessible at `/usr/local/kong/logs/error.log`.

    ```log
    2021/07/29 21:52:54 [error] 114#0: *153047 [kong] event_hooks.lua:190 [string "return function (data, event, source, pid)..."]:3: Event hook on consumer Lois Lane, context: ngx.timer, client: 172.19.0.1, server: 0.0.0.0:8001
    ```
