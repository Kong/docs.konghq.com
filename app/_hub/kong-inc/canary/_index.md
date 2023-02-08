---
name: Canary Release
publisher: Kong Inc.
desc: Slowly roll out software changes to a subset of users
description: |
  Reduce the risk of introducing a new software version in production by slowly
  rolling out the change to a small subset of users. This plugin also enables rolling
  back to your original upstream service, or shifting all traffic to the new version.
enterprise: true
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  enterprise_edition:
    compatible: true
---
