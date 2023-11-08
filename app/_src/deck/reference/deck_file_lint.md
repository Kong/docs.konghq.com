---
title: deck file lint
source_url: https://github.com/Kong/deck/tree/main/cmd/file_lint.go
content_type: reference
---

Validate a decK state file against a linting ruleset, reporting any violations or failures.
Report output can be returned in JSON, YAML, or human readable format (see --format).
[Ruleset Docs](https://quobix.com/vacuum/rulesets/)

## Syntax

```
deck file lint [command-specific flags] [global flags]
```

## Flags

`-D`, `--display-only-failures`
:  only output results equal to or greater than --fail-severity (Default: `false`)

`-F`, `--fail-severity`
:  results of this level or above will trigger a failure exit code
[choices: "error", "warn", "info", "hint"] (Default: `"error"`)

`--format`
:  output format [choices: "plain", "json", "yaml"] (Default: `"plain"`)

`-h`, `--help`
:  help for lint 

`-o`, `--output-file`
:  Output file to write to. Use - to write to stdout. (Default: `"-"`)

`-s`, `--state`
:  decK file to process. Use - to read from stdin. (Default: `"-"`)



## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}

