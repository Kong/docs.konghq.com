---
title: Developer Portal CLI
---


### Introduction

The Kong Developer Portal CLI is used to manage your Developer Portals from the
command line. It is built using [clipanion][clipanion].


### Overview

This is the next generation TypeScript based Developer Portal CLI. The goal of
this project is to make a higher quality CLI tool over the initial sync script.

This project is built for Kong Enterprise `>= 1.3`.

For Kong Enterprise `<= 0.36`, or for `legacy mode` on Kong Enterprise `>= 1.3` [use the legacy sync script][sync-script].


### Install

```
> npm install -g kong-portal-cli
```



### Usage

The easiest way to start is by cloning the [portal-templates repo][templates] master branch locally.

Then edit `workspaces/default/cli.conf.yaml` to set `kong_admin_uri` and `kong_admin_token` to match your setup.

Make sure Kong is running and portal is on.

Now, from the root folder of the templates repo, you can run:

```portal [-h,--help] [--config PATH] [-v,--verbose] <command> <workspace>```

Where `<command>` is one of:

* `config`   Output or change configuration of the portal on the given
`workspace`, locally.
* `deploy`   Deploy changes made locally under the given workspace upstream.
* `disable`  Enable the portal on the given workspace.
* `enable`   Enable the portal on the given workspace.
* `fetch`    Fetches content and themes from the given workspace.
* `wipe`     Deletes all content and themes from upstream workspace

Where <workspace> indicates the directory/workspace pairing you would like to operate on.

#### For `deploy`
- Add `-W` or `--watch` to make changes reactive.
- Add `-P` or `--preserve` to avoid deleting files upstream that you do not have locally.
- Add `-D` or `--disable-ssl-verification` to disable SSL verification and use self-signed certs.
- Add `-I` or `--ignore-specs` to ignore the `/specs` directory.

#### For `fetch`
- Add `-K` or `--keep-encode` to keep binary assets as base64-encoded strings locally.
- Add `-D` or `--disable-ssl-verification` to disable SSL verification and use self-signed certs.
- Add `-I` or `--ignore-specs` to ignore the `/specs` directory.

#### For `wipe`
- Add `-D` or `--disable-ssl-verification` to disable SSL verification and use self-signed certs.
- Add `-I` or `--ignore-specs` to ignore the `/specs` directory.

#### For `enable` and `disable`
- Add `-D` or `--disable-ssl-verification` to disable SSL verification and use self-signed certs.


### Using Environment Variables
You can override config values set in `cli.conf.yaml` via environment variables.  If you wanted to override the kong admin url for example, you can run:

```
KONG_ADMIN_URL=http://new-admin-url.com portal deploy default
```

Environment variables are useful for scripting as well as temporarily overriding particular settings.

Available environment variables include:
  - `KONG_ADMIN_URL` Kong Admin URL the CLI should target for uploading files.
  - `KONG_ADMIN_TOKEN` Kong Admin Token token used to authenticate with the Kong Admin API.

[clipanion]: https://github.com/arcanis/clipanion
[sync-script]: https://github.com/Kong/kong-portal-templates/blob/81382f2c7887cf57bb040a6af5ca716b83cc74f3/bin/sync.js
[cli-support]: https://github.com/Kong/kong-portal-cli/issues/new
[cli-license]: https://github.com/Kong/kong-portal-cli/blob/master/LICENSE
[cli-contributors]: (https://github.com/Kong/kong-portal-cli/contributors)
[kong-support]: https://support.konghq.com/support/s/
[templates]: https://github.com/Kong/kong-portal-templates
