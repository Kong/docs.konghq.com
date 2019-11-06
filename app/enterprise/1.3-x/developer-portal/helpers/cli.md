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

Then edit `workspaces/default/cli.conf.yaml` to set workspace `name` and `rbac_token` to match your setup.

Make sure Kong is running and portal is on:

Now from root folder of the templates repo you can run:

```portal [-h,--help] [--config PATH] [-v,--verbose] <command>```

Where `<command>` is one of:

* `config`   Output or change configuration of the portal on the given
* `workspace`, locally.
* `deploy`   Deploy changes made locally under the given workspace upstream.
* `disable`  Enable the portal on the given workspace.
* `enable`   Enable the portal on the given workspace.
* `fetch`    Fetches content and themes from the given workspace.
* `serve`    Run the portal of a given workspace locally.
* `wipe`     Deletes all content and themes from upstream workspace

Add `--watch` to make changes reactive


[clipanion]: https://github.com/arcanis/clipanion
[sync-script]: https://github.com/Kong/kong-portal-templates/blob/81382f2c7887cf57bb040a6af5ca716b83cc74f3/bin/sync.js
[cli-support]: https://github.com/Kong/kong-portal-cli/issues/new
[cli-license]: https://github.com/Kong/kong-portal-cli/blob/master/LICENSE
[cli-contributors]: (https://github.com/Kong/kong-portal-cli/contributors)
[kong-support]: https://support.konghq.com/support/s/
[templates]: https://github.com/Kong/kong-portal-templates
