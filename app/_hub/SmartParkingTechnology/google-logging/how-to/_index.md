## Exported Data

For every request, the following data is exported:

- service name (if known)
- route name (if known)
- consumer name (if known)
- upstream_uri
- uri
- latency_request
- latency_gateway
- latency_proxy
- [httpRequest](https://cloud.google.com/logging/docs/reference/v2/rest/v2/LogEntry#HttpRequest){:target="_blank"}{:rel="noopener noreferrer"}

The logs are labeled with: `"source": "kong-google-logging"`.

## Usage

The plugin requires some Google service account credentials to write log entries to Google Cloud Logging.
The service account requires the scope as described in the [API docs](https://cloud.google.com/logging/docs/reference/v2/rest/v2/entries/write){:target="_blank"}{:rel="noopener noreferrer"}.
The credential details can be configured using the `google_key` parameter OR by providing a path to the key file using the `google_key_file` parameter.

The plugin uses Kong's batch queue to send out log entries to Google in batches.
For more information about the batch queue parameters, see [batch_queue.lua](https://github.com/Kong/kong/blob/master/kong/tools/batch_queue.lua){:target="_blank"}{:rel="noopener noreferrer"}.

Sample configuration via declarative (YAML):

```yaml
plugins:
  - name: google-logging
    config:
      google_key:
        private_key: "***"
        client_email: "***"
        project_id: "***"
        token_uri: "***"
      google_key_file: /path/to/service-account-keyfile.json
      resource:
        type: k8s_cluster
        labels:
          project_id: "my project"
          location: "my location"
          cluster_name: "my cluster name"
      retry_count: 0
      flush_timeout: 2
      batch_max_size: 200
```

## Install
### Luarocks
```
luarocks install kong-plugin-google-logging
```

### Source Code
```
> git clone https://github.com/SmartParkingTechnology/kong-google-logging-plugin.git
> cd /path/to/kong/plugins/kong-google-logging-plugin
> luarocks make *.rockspec
```
