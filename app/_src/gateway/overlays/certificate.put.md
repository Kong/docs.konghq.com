---
layout: overlay
target: '$.paths["/{runtimeGroupId}/core-entities/certificates/{certificate_id}"].put'
---

Update details about the specified certificate using the provided path parameter `certificate_id`.

Inserts (or replaces) the certificate under the requested `certificate_id`with the definition specified in the request body. When the `id` attribute has the structure of a UUID, the certificate being inserted/replaced will be identified by its `id`. Otherwise it will be identified by the `name`.

When creating a new Certificate without specifying `id` (neither in the path or the request body), then it will be auto-generated.