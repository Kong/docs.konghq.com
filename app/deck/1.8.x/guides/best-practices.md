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
- If you have a very large installation, you can consider splitting
  your configuration into smaller subsets. You can find more info for it
  in the guide to practicing
  [distributed configuration](/deck/{{page.kong_version}}/guides/distributed-configuration).
- Always use a pinned version of decK and Kong.
  Achieving declarative configuration is
  not easy because details matter a lot. Use a specific version of decK in
  production. If you're going to start using a new version of decK or Kong,
  please safely test the changes in a staging environment first.
- decK does not manage encryption of sensitive information, meaning plaintext
  will store the private keys of your certificates and credentials of consumers
  in the state file. Please be careful in how and where you store
  this file, as it can compromise your security.
  You must store these in an encrypted form and provide a plaintext version
  of it on a need-only basis.
- If you have many consumers in your database, do not export
  or manage them using decK. Declarative configuration is for configuration,
  not end-user data, which can easily grow into hundreds of thousands
  or millions.
- Always run a `deck diff` command before running a `deck sync`
  to ensure that the change occurs correctly.
- Adopt a [CI-driven configuration](/deck/{{page.kong_version}}/guides/ci-driven-configuration) practice.
- Always secure Kong's Admin API with any authentication method.
- Do not write the state file by hand, to avoid any error.
  Instead, you can use Kong's Admin API to
  configure Kong first and then export the configuration. You
  must make any subsequent changes by manually editing the file and pushing
  the change via CI. If you're making a large change with several small changes, 
  make the changes in Kong, export the new file, and then differentiate the 
  two state files to review the made changes.
- Configure a `cronjob` to run `deck diff` periodically to ensure that Kong's
  database is the same as the state file checking into your Git repositories.
  Trigger an alert if decK detects a drift in the configuration.
