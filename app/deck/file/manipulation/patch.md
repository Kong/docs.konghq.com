---
title: deck file patch
---

The `deck file patch` command allows you to add, update, or remove values from a declarative configuration file. A patch is a combination of a `selector` that selects which objects to patch in the file, and a `value` that contains the new value to use.

The data type of the property identified by `selector` defines the merge behavior. For scalar values (strings, integers, booleans) the existing value is overwritten. For arrays, the provided values are appended to the existing array if the selector is an array.

Changes can be specified as command line arguments, or provided in a patch file that is passed to the `deck file patch` command.

The `deck file patch` command outputs the patched file to `stdout` by default. You can provide `-o /path/to/config.yaml` to write the updated configuration to a file on disk.

## Command line arguments

To patch values using the command line, pass the `--selector` and `--value` arguments.

You can run the following examples as `deck file patch -s /path/to/kong.yaml --selector <S> --value <V>`.

```bash
# set field "read_timeout" to a numeric value of 10000
--selector="$..services[*]" --value="read_timeout:10000"

# set field "_comment" to a string value
--selector="$..services[*]" --value='_comment:"comment injected by patching"'

# set field "_ignore" to an array of strings
--selector="$..services[*]" --value='_ignore:["ignore1","ignore2"]'

# remove fields "_ignore" and "_comment" from the object
--selector="$..services[*]" --value='_ignore:' --value='_comment:'

# append entries to the methods array of all route objects
--selector="$..routes[*].methods" --value='["OPTIONS"]'
```

## Patch file

If you have more complex patching needs, you can store the patches in a YAML file. The YAML file contains `selectors` and `values`, plus an explicit `remove` key for deleting values.

```yaml
patches:
  - selectors:
      - $..services[*]
    values:
      read_timeout: 10000
      _comment: comment injected by patching
    remove:
      - _ignore
      - _comment
```

To apply the above file, run `deck file patch -s /path/to/config.yaml patch1.yaml patch2.yaml`. Multiple patch files can be provided at once.