local data = {}

data.header = [[
---
title: CLI Reference
---

## Introduction

The provided CLI (*Command Line Interface*) allows you to start, stop, and
manage your Kong instances. The CLI manages your local node (as in, on the
current machine).

If you haven't yet, we recommend you read the [configuration reference][configuration-reference].

## Global flags

All commands take a set of special, optional flags as arguments:

* `--help`: print the command's help message
* `--v`: enable verbose mode
* `--vv`: enable debug mode (noisy)

[Back to TOC](#table-of-contents)

## Available commands

]]

data.command_intro = {
  ["prepare"] = [[
    This command prepares the Kong prefix folder, with its sub-folders and files.
  ]],
}

data.footer = [[

[configuration-reference]: /{{page.kong_version}}/configuration
]]

return data
