---

name: EE Canary Release
publisher: Kong HQ

desc: Slowly roll out software changes to a subset of users
description: |
  Reduce the risk of introducing a new software version in production by slowly rolling out the change to a small subset of users. This plugin also enables roll back to your original upstream service, or shift all traffic to the new version.

  * [Detailed documentation for the EE Canary Release Plugin](/enterprise/latest/plugins/canary-release/)

enterprise: true
type: plugin
categories:
  - traffic-control

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

---
