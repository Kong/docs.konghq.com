---
title: decK
subtitle: Manage Konnect and Kong Gateway configuration declaratively
---

decK helps manage Kong’s configuration in a declarative fashion. This means that
a developer can define the desired state of 
{{site.base_gateway}} or {{site.konnect_short_name}} &ndash;
services, routes, plugins, and more &ndash; and let decK handle implementation
without needing to execute each step manually, as you would with the Kong Admin
API.

Features include:
* Sync configuration to a running Kong cluster
* diff configuration to detect any drift or manual changes
* Back up your instance's configuration
* Manage Kong’s configuration in a distributed way using tags, helping you split
the configuration across various teams

Here is an introductory screencast explaining decK:
<a href="https://asciinema.org/a/238318">
  <img class="no-image-expand" src="https://asciinema.org/a/238318.svg" alt="deck screencast" />
</a>

## Features
* **Export**: Export Kong configuration to a YAML configuration file.
This feature is especially useful for backing up Kong's configuration.

* **Import**: Populate Kong's database using a previously exported or
manually written configuration file.

* **Diff and sync capabilities**: decK can diff the configuration between the
provided configuration file and Kong's database, then sync the configs based on
the diff. This feature is particularly useful for detecting config drifts or
manual interventions.

* **Reverse sync**: decK also supports sync in the opposite direction, meaning
that if an entity is created in Kong and isn't added to the config file,
decK will detect the change.

* **Validation**: decK can validate YAML files that you backup or modify to
catch errors early on.

* **Reset**: decK can completely reset Kong's database by deleting all entities.

* **Parallel operations**: All Admin API calls to Kong are executed in parallel
using multiple threads to speed up the sync process.

* **Authentication with Kong**: Custom HTTP headers can be injected in requests
to Kong's Admin API for authentication or authorization purposes.

* **Manage Kong's config with multiple config files**: Split your configuration
into multiple logical files based on a shared set of tags amongst entities.

* **Designed to automate configuration management**: decK is designed to be part
of your CI pipeline, where it can push configuration to Kong and detect drifts
in configuration.

## Compatibility
decK is compatible with {{site.ce_product_name}} >= 1.x and
{{site.ee_product_name}} >= 0.35.

## References

The command line `--help` flag on the main command or a subcommand (like diff,
sync, reset, etc.) shows the help text along with supported flags for those
commands.

A list of all commands that are available in decK can be found
[here](/deck/{{page.release}}/commands).

## Frequently Asked Questions (FAQs)

You can find answers to FAQs [here](/deck/{{page.release}}/faqs/).

## Explainer video

Harry Bagdi gave a talk on motivation behind decK and demonstrated a few key
features of decK at Kong Summit 2019. The following is a recording of that session:

<a href="https://www.youtube.com/watch?v=fzpNC5vWE3g">
  <img class="no-image-expand" src="https://img.youtube.com/vi/fzpNC5vWE3g/0.jpg" alt="decK talk by Harry Bagdi" />
</a>

## Changelog

The changelog can be found in the
[CHANGELOG.md](https://github.com/kong/deck/blob/main/CHANGELOG.md) file.

## Licensing

decK is licensed with Apache License Version 2.0.
Please read the
[LICENSE](https://github.com/kong/deck/blob/main/LICENSE) file for more details.

## Security

decK does not offer to secure your Kong deployment but only configures it.
It encourages you to protect your Kong's Admin API with authentication but
doesn't offer such a service itself.

decK's state file can contain sensitive data such as private keys of
certificates, credentials, etc. It is left up to the user to manage
and store the state file in a secure fashion.

If you believe that you have found a security vulnerability in decK,
submit a detailed report, along with reproducible steps
to [security@konghq.com](mailto:security@konghq.com).

## Getting help

One of the design goals of decK is deliver a good developer experience to you.
Part of it is getting the required help when you need it.
To seek help, use the following resources:
- `--help` flag gives you the necessary help in the terminal itself and should
  solve most of your problems.
- If you still need help, please open a
  [Github issue](https://github.com/kong/deck/issues/new) to ask your
  question.
- decK has very wide adoption by Kong's community and you can seek help
  from the larger community at [Kong Nation](https://discuss.konghq.com).

## Reporting a bug

If you believe you have run into a bug with decK, please open
a [Github issue](https://github.com/kong/deck/issues/new).

If you think you've found a security issue with decK, please read the
[Security](#security) section.
