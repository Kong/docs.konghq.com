---
title: Using Multiple Files to Store Configuration
toc: false
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
