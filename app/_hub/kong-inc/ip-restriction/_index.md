## Usage

{% if_plugin_version gte:2.1.x %}

{% if_plugin_version lte:2.8.x %}

{:.note}
> **Note**: We have deprecated the usage of `whitelist` and `blacklist` in favor of `allow` and `deny`. This change may require Admin API requests to be updated.

{% endif_plugin_version %}

An `allow` list provides a positive security model, in which the configured CIDR ranges are allowed access to the resource, and all others are inherently rejected. By contrast, a `deny` list configuration provides a negative security model, in which certain CIDRS are explicitly denied access to the resource (and all others are inherently allowed).

You can configure the plugin with both `allow` and `deny` configurations. An interesting use case of this flexibility is to allow a CIDR range, but deny an IP address on that CIDR range:

```bash
curl -X POST http://kong:8001/services/{service}/plugins \
  --data "name=ip-restriction" \
  --data "config.allow=127.0.0.0/24" \
  --data "config.deny=127.0.0.1"
```
{% endif_plugin_version %}

{% if_plugin_version eq:2.0.x %}

Note that the `whitelist` and `blacklist` models are mutually exclusive in their usage, as they provide complimentary approaches. That is, you cannot configure the plugin with both `whitelist` and `blacklist` configurations. A `whitelist` provides a positive security model, in which the configured CIDR ranges are allowed access to the resource, and all others are inherently rejected. In contrast, a `blacklist` configuration provides a negative security model, in which certain CIDRS are explicitly denied access to the resource (and all others are inherently allowed).

{% endif_plugin_version %}

---
