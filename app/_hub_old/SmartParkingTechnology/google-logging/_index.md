---
name: Kong Google Cloud Logging
publisher: SmartParkingTechnology

categories:
  - logging

type: plugin

desc: Logs Kong requests with Google Cloud Logging

description: |
  Plugin for exporting Kong request data such as Service name, Route name, Consumer name or request latency to Google Cloud Logging.

support_url: https://github.com/SmartParkingTechnology/kong-google-logging-plugin/issues

source_url: https://github.com/SmartParkingTechnology/kong-google-logging-plugin

license_type: Apache-2.0

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.2.x
      - 2.1.x

params:
  name: google-logging
  api_id: false
  service_id: false
  consumer_id: false
  route_id: false
  protocols: ["http", "https"]
  dbless_compatible: yes

  config:
    - name: log_id
      required: false
      default: "cloudresourcemanager.googleapis.com%2Factivity"
      value_in_examples:
      description: |
        The log id in: `projects/[PROJECT_ID]/logs/[LOG_ID]`. Also see [LogEntry](https://cloud.google.com/logging/docs/reference/v2/rest/v2/LogEntry){:target="_blank"}{:rel="noopener noreferrer"}.
    - name: google_key
      required: false
      default:
      value_in_examples:
      description: The private key parameters of the Google service account. Either `google_key` or `google_key_file` must be specified.
    - name: google_key_file
      required: false
      default:
      value_in_examples:
      description: |
        Path to the service account json file. The associated service account needs the scope: `https://www.googleapis.com/auth/logging.write`. Either `google_key` or `google_key_file` must be specified.
    - name: resource
      required: false
      default:
      value_in_examples:
      description: The Google monitor resource. Also see [MonitoredResource](https://cloud.google.com/logging/docs/reference/v2/rest/v2/MonitoredResource){:target="_blank"}{:rel="noopener noreferrer"}.
    - name: retry_count
      required: false
      default: 0
      value_in_examples:
      description: Kong batch queue `retry_count`.
    - name: flush_timeout
      required: false
      default: 2
      value_in_examples:
      description: Kong batch queue `flush_timeout` in seconds.
    - name: batch_max_size
      required: false
      default: 200
      value_in_examples:
      description: Kong batch queue `batch_max_size`.
---

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
