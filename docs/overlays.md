# Generating OAS Overlays

1. Add all the entries to the gateway nav file in the `unlisted` section
2. Create entries in `app/_src/gateway/overlays` with the following format:

```yaml
---
layout: overlay
target: '$.paths["/{runtimeGroupId}/core-entities/certificates/{certificate_id}"].put'
---

This is a description.

It can be as long as you like.

{% if_version gte:3.3.x %}
And even use conditionals
{% endif_version %}
```

Build the site with `make run`:

```bash
export VERSION=3.4.x;
for i in dist/gateway/$VERSION/overlays/*/index.html; do cat $i >> $VERSION.yaml; echo "" >> $VERSION.yamldone;
```

`$VERSION.yaml` now contains all overlay items.

It's missing the header:

```
info:
  title: Add descriptions
  version: 1.0.0
overlay: 1.0.0
actions:
```

## Next Steps

1. Build tooling to combine overlays into a single file, including the header
1. Make sure that the overlays folder isn't published to production