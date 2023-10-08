---
layout: overlay
target: '$.paths["/{runtimeGroupId}/expected-config-hash"].get'
---

Retrieve the expected config hash for this runtime group. The expected config hash can be used to verify if the config hash of a runtime instance is up to date with the runtime group. The config hash will be the same if they are in sync.