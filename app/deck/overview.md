---
title: Overview
---

decK helps manage Kong’s configuration in a declarative fashion. It can sync
configuration to a running Kong cluster, diff configuration to detect any drift
or manual changes and backup your Kong’s configuration. It also can manage Kong’s
configuration in a distributed way using tags, helping you split Kong’s
configuration across various teams.

Here is an introductory screencast explaining decK: [asciicast](https://asciinema.org/a/238318)

## References

The command line `--help` flag on the main command or a subcommand (like diff,
sync, reset, etc.) shows the help text along with supported flags for those
commands.

A gist of all commands that are available in decK can be found
[here](/deck/commands).

## Frequently Asked Questions (FAQs)

You can find answers to FAQs [here](/deck/faqs).

## Explainer video

Harry Bagdi gave a talk on motivation behind decK and demonstrated a few key
features of decK at Kong Summit 2019. The following is a recording of that session:

[![decK talk by Harry Bagdi](https://img.youtube.com/vi/fzpNC5vWE3g/0.jpg)](https://www.youtube.com/watch?v=fzpNC5vWE3g)

## Changelog

The changelog can be found in the
[CHANGELOG.md](https://github.com/hbagdi/deck/blob/master/CHANGELOG.md) file.

## Licensing

decK is licensed with Apache License Version 2.0.
Please read the
[LICENSE](https://github.com/hbagdi/deck/blob/master/LICENSE) file for more details.

## Security

decK does not offer to secure your Kong deployment but only configures it.
It encourages you to protect your Kong's Admin API with authentication but
doesn't offer such a service itself.

decK's state file can contain sensitive data such as private keys of
certificates, credentials, etc. It is left up to the user to manage
and store the state file in a secure fashion.

If you believe that you have found a security vulnerability in decK, please
submit a detailed report, along with reproducible steps
to Harry Bagdi (email address is first name last name At gmail Dot com).
I will try to respond in a timely manner and will really appreciate it you
report the issue privately first.

## Getting help

One of the design goals of decK is deliver a good developer experience to you.
And part of it is getting the required help when you need it.
To seek help, use the following resources:
- `--help` flag gives you the necessary help in the terminal itself and should
  solve most of your problems.
- If you still need help, please open a
  [Github issue](https://github.com/hbagdi/deck/issues/new) to ask your
  question.
- decK has very wide adoption by Kong's community and you can seek help
  from the larger community at [Kong Nation](https://discuss.konghq.com).

## Reporting a bug

If you believe you have run into a bug with decK, please open
a [Github issue](https://github.com/hbagdi/deck/issues/new).

If you think you've found a security issue with decK, please read the
[Security](#security) section.
