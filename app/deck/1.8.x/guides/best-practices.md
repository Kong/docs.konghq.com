---
title: Best Practices when using decK
toc: false
---

- Always ensure that you have one decK process running at any time. Multiple
  processes will step on each other and can corrupt Kong's configuration.
- Do not mix up decK's declarative configuration with `cURL` or any other
  script. Either manage the configuration with decK or manage it with your
  homegrown script. Mixing the two on the same dataset will get cumbersome
  and will be error-prone.
- If you have a very large installation, then it is recommended to split out
  your configuration into smaller subsets. You can find more info for it
  in the guide to practicing
  [distributed configuration](/deck/{{page.kong_version}}/guides/distributed-configuration).
- Always use a pinned version of decK and Kong.
  Utilize a specific version of decK in
  production to achieve declarative configuration. If you're going to opt for a new version of decK or Kong,
  please safely test the changes in a staging environment first.
- decK does not manage encryption of sensitive information which means private
  keys of your certificates and credentials of consumers will be stored in
  plaintext in the state file. Please be careful in how and where you store
  this file to avoid any security breaches.
  You should always store these in an encrypted form and provide a plaintext version
  of it on a need-only basis.
- If you have a very large number of consumers in your database, do not export
  or manage them using decK. Declarative configuration is for- Configuration,
  it is not meant for end-user data that can easily grow into hundreds or
  thousands or millions.
- Always run a `deck diff` command before running a `deck sync`
  to ensure that the change is behaving as expected.
- Adopt a [CI-driven configuration](/deck/{{page.kong_version}}/guides/ci-driven-configuration) practice.
- Always secure Kong's Admin API with a reliable authentication method.
- Don't write the state file by hand to avoid errors.
  Always use Kong's Admin API to
  configure Kong for the first time and then export the configuration. Any
  subsequent changes should be made by manually editing the file and pushing
  the change via CI. If you're making a larger change, make the changes in Kong and
  export the new file. Then you can differentiate the two state files to review the changes
  being made.
- Configure a `cronjob` to run `deck diff` periodically to ensure that Kong's
  database is same as the state file checking into your Git repositories.
  Trigger an alert if decK detects a drift in the configuration.
