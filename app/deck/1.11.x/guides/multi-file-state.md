---
title: Using Multiple Files to Store Configuration
---

decK can construct a state by combining multiple JSON or YAML files inside a
directory instead of a single file.

In most use cases, a single file will suffice, but you might want to use
multiple files if:
- You want to organize the files for each service. In this case, you
  can have one file per service, and keep the service, its associated routes,
  plugins, and other entities in that file.
- You have a large configuration file and want to break it down into smaller
  digestible chunks.

You can specify an entire directory for decK to consume using the `--state`
flag.

You can also specify multiple files using comma-separated syntax (`--state file.yml,file2.yml,directory`),
or by using the flag many times (`-s file.yml -s file2.yml -s directory`)

Under the hood, decK combines the YAML/JSON files in a very dumb fashion,
meaning it just concatenates the various arrays in the file together, before
starting to process the state.

There is no automated way of generating multiple files using decK. You will
have to export the entire configuration using the `deck dump` command and then
split the configuration into different files as you see fit for your use case.


Please note that having the state split across different files is not same
as [distributed configuration](/deck/{{page.kong_version}}/guides/distributed-configuration).

## Multiple files and `--select-tag`

You must be careful when mixing distributed configuration in multiple files and
the `--select-tag` flag, as this may result in undesired outcomes.
For example, imagine you have a couple of services deployed with some tags
and that you dump their configuration as follows:

```sh
deck dump --select-tag team-svc1 -o svc1.yaml
```

```sh
$ cat svc1.yaml
_format_version: "1.1"
_info:
  defaults: {}
  select_tags:
  - team-svc1
services:
- connect_timeout: 60000
  host: foo.org
  name: svc1
  port: 80
  protocol: http
  read_timeout: 60000
  retries: 5
  tags:
  - team-svc1
  write_timeout: 60000
```

```sh
deck dump --select-tag team-svc2 -o svc2.yaml
```

```sh
$ cat svc2.yaml
_format_version: "1.1"
_info:
  defaults: {}
  select_tags:
  - team-svc2
services:
- connect_timeout: 60000
  host: bar.org
  name: svc2
  port: 80
  protocol: http
  read_timeout: 60000
  retries: 5
  tags:
  - team-svc2
  write_timeout: 60000
```

At this point you have 2 files, each pointing to resources marked with a different tag.

For syncing back (or diffing) the configurations, you must sync each of these files separately,
otherwise decK merges the content of `select_tags` together and applies both tags
to both services.

```sh
deck sync -s svc1.yaml
Summary:
  Created: 0
  Updated: 0
  Deleted: 0
```

```sh
deck sync -s svc2.yaml
Summary:
  Created: 0
  Updated: 0
  Deleted: 0
```

{:.important}
> As a best practice, the way you `sync` configurations should be consistent with the way you
initially `dump`ed them.