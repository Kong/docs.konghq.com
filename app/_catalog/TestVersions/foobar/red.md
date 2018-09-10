---
name: Foo Bar

version: Red

categories:
  - analytics-monitoring
type: integration
desc: Complex Versioning Examples
description: |
  Test the versions
kong_version_compatibility:
  community_edition:
    compatible:
      - 0.13.x
      - 0.14.x
    incompatible:
      - 0.12.x
  enterprise_edition:
    compatible:
      - 0.33-x
      - 0.34-x
    incompatible:
      - 0.32-x
---

### This is the Red version

In this example, the versions are colors, and they have no dates.

The versions are ordered by the order of their appearance in the `app/_data/extensions/TestVersions.yml` file - that file includes:

```
foobar:
  versions:
    - release: black
    - release: blue
    - release: green
    - release: red
```

Which results in the version order you see in this page's sidebar and version picker dropdown.
