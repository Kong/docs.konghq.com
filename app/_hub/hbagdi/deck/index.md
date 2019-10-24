---
name: decK
publisher: hbagdi

categories:
- deployment

type: integration

desc: Backup, restore, diff and sync configuration to Kong
description: |
  decK helps manage Kong's configuration in a declarative fashion.
  It can sync configuration to a running Kong cluster, diff configuration
  to detect any drift or manual changes and backup your Kong's configuration.
  It also can manage Kong's configuration in a distributed way using tags,
  helping you split Kong's configuration across various teams.

support_url: https://github.com/hbagdi/deck/issues

source_url: https://github.com/hbagdi/deck

license_type: (Apache-2.0)

# COMPATIBILITY

kong_version_compatibility:
    community_edition:
      compatible:
        - 1.2.x
        - 1.1.x
        - 1.0.x
      incompatible:
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
    enterprise_edition:
      compatible:
        - 0.35-x
      incompatible:
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# If you include headers, your headers MUST start at Level 2 (parsing to
# h2 tag in HTML). Heading Level 2 is represented by ## notation
# preceding the header text. Subsequent headings,
# if you choose to use them, must be properly nested (eg. heading level 2 may
# be followed by another heading level 2, or by heading level 3, but must NOT be
# followed by heading level 4)
###############################################################################
# BEGIN MARKDOWN CONTENT
---

## decK: Declarative configuration for Kong

decK is a CLI tool to configure Kong declaratively using a single config file.

[![asciicast](https://asciinema.org/a/238318.svg)](https://asciinema.org/a/238318)

### Features

- **Export**  
  Exisitng Kong configuration to a YAML configuration file
  This can be used to backup Kong's configuration.
- **Import**  
  Kong's database can be populated using the exported or a hand written config
  file.
- **Diff and sync capabilities**  
  decK can diff the configuration in the config file and
  the configuration in Kong's DB and then sync it as well.
  This can be used to detect config drifts or manual interventions.
- **Reverse sync**:  
  decK supports a sync the other way as well, meaning if an
  entity is created in Kong and doesn't add it to the config file,
  decK will detect the change.
- **Reset**  
  This can be used to drops all entities in Kong's DB.
- **Parallel operations**  
  All Admin API calls to Kong are executed in parallel using threads to
  speed up the sync.
- **Supported entities**
  - Routes and services
  - Upstreams and targets
  - Certificates and SNIs
  - Consumers
  - Plugins (Global, per route, per service and per consumer)
- **Authentication with Kong**
  Custom HTTP headers can be injected in requests to Kong's Admin API
  for authentication/authorization purposes.
- **Manage Kong's config with multiple config file**
  Split your Kong's configuration into multiple logical files based on a shared
  set of tags amongst entities.

### Compatibility

decK is compatible with Kong 1.x. 

### Installation

If you are on macOS, install decK using brew:

```shell
$ brew tap hbagdi/deck
$ brew install deck
```

If you are Linux, you can either use the Debian or RPM archive from
the Github [release page](https://github.com/hbagdi/deck/releases)
or install by downloading the binary:

```shel
$ curl -sL https://github.com/hbagdi/deck/releases/download/v0.4.0/deck_0.4.0_linux_amd64.tar.gz -o deck.tar.gz
$ tar -xf deck.tar.gz -C /tmp
$ cp /tmp/deck /usr/local/bin/
```

Once installed, please use the following command to get help:

```shell
$ deck --help
```
