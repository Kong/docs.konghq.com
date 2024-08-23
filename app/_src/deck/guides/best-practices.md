---
title: Best Practices when using decK
content_type: explanation
---

- Always ensure that you have one decK process running at any time. Multiple
  processes step on each other and can corrupt Kong's configuration.
- Do not mix up decK's declarative configuration with cURL or any other
  script. Either manage the configuration with decK or manage it with your
  homegrown script. Mixing the two on the same dataset is cumbersome and error-prone.
- If you have a very large installation, you can split out
  your configuration into smaller subsets. You can find more info for it
  in the guide to practicing
  [distributed configuration](/deck/{{page.release}}/guides/distributed-configuration/).
- Always use a pinned version of decK and {{site.base_gateway}}.
  Use a specific version of decK in production to achieve declarative
  configuration. If you upgrade to a new version of decK or {{site.base_gateway}},
  please safely test the changes in a staging environment first.
- decK does not manage encryption of sensitive information. The state file
  stores the private keys of your certificates and credentials of consumers in
  plaintext. Be careful in how and where you store
  this file to avoid any security breaches.
  Always store the sensitive information in an encrypted form and provide a plaintext
  version of it on a need-only basis.
- If you have many consumers in your database, do not export
  or manage them using decK. Declarative configuration is only meant for entity
  configuration. It is not meant for end-user data, which can easily grow into
  hundreds of thousands or millions of records.
- Always run a `diff` command before running a `sync`
  to ensure that the change is correct.
- Adopt a [CI-driven configuration](/deck/{{page.release}}/guides/ci-driven-configuration/) practice.
- Always secure Kong's Admin API with a reliable authentication method.
- Do not write the state file by hand to avoid errors.
  Use Kong's Admin API to configure {{site.base_gateway}} for the first time, then
  export the configuration to a declarative configuration file. Any
  subsequent changes should be made by manually editing the file and pushing
  the change via CI. If you're making a larger change, make the change in {{site.base_gateway}} first, then
  export the new file. Then you can `diff` the two state files to review the changes
  being made.
- Configure a `cronjob` to run `diff` periodically to ensure that {{site.base_gateway}}'s
  database is in sync with the state file checking into your Git repositories.
  Trigger an alert if decK detects a drift in the configuration.
