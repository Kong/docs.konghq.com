## Changelog

### {{site.base_gateway}} 3.10.0.0

* Introduced the new **AI Sanitizer** plugin, which replaces PII information in request bodies before forwarding to upstream services. This plugin supports fixed placeholders, category-based synthetic replacements, and optional restoration of original data in responses, ensuring data privacy while maintaining contextual integrity.
