When a client has been authenticated, the plugin appends some headers to
the request before proxying it to the upstream service, so that you
can identify the consumer in your code:

* `X-Consumer-ID`: The ID of the consumer in Kong.
* `X-Consumer-Custom-ID`: The `custom_id` of the consumer (if set).
* `X-Consumer-Username`: The `username` of the consumer (if set).
* `X-Credential-Identifier`: The identifier of the credential (only if the consumer is not the `anonymous` consumer).
* `X-Anonymous-Consumer`: Is set to `true` if authentication fails, and the `anonymous` consumer is set instead.

You can use this information on your side to implement additional logic.
You can use the `X-Consumer-ID` value to query the Kong Admin API and retrieve
more information about the consumer.

{% if_version lte:2.8.x %}

{:.important}
> **Important**: `X-Credential-Username` was deprecated in favor of `X-Credential-Identifier` in Kong 2.1.

{% endif_version %}
