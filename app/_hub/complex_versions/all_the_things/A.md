---
name: All The Things
publisher: Complex Versions

version: A

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

### This is the A version

In this example, the versions are letters, and they have dates.

The versions are ordered by the order of their appearance in the `app/_data/extensions/TestVersions.yml` file - that file includes:

```
all_the_things:
  versions:
    - release: D
      date: 2018-08-25
    - release: C
      date: 2018-08-03
    - release: B
      date: 2018-07-29
    - release: A
      date: 2017-07-29
```

Which results in the version order you see in this page's sidebar and version picker dropdown.
