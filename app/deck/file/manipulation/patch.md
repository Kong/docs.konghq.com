---
title: deck file patch
---

The `deck file patch` command allows you to add, update or remove values from a declarative configuration file. A patch is a combination of a `selector` that selects which objects to patch in the file, and a `value` that contains the new value to use.

The data type of the property identified by `selector` defines the merge behavior. For scalar values (strings, integers, booleans) the existing value is overwritten. For arrays, the provided values are appended to the existing array.

Changes can be specified as command line arguments, or provided in a patch file that is passed to the `deck file patch` command.

## Command line arguments

...

## Patch file

...

---

WIP:

Changes can be specified using a `--selector` and one or more `--value` tags, or via patch files.

When using `--selector` and `--values`, the items are selected by the `selector`, which is a JSONpath query. The 'field values' (in `<key:value>` format) are applied on each of the JSONObjects returned by the 'selector'. The 'array values' (in `[val1, val2]` format) are appended to each of the JSONArrays returned by the `selector`.

The field values must be a valid JSON snippet, so use single/double quotes
appropriately. If the value is empty, the field is removed from the object.

Examples of valid values:

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

Patch files have the following format (JSON or YAML) and can contain multiple
patches that are applied in order:

```json
{ "_format_version": "1.0",
  "patches": [
    { "selectors": [
        "$..services[*]"
      ],
      "values": {
        "read_timeout": 10000,
        "_comment": "comment injected by patching"
      },
      "remove": [ "_ignore" ]
    }
  ]
}
```

If the 'values' object instead is an array, then any arrays returned by the selectors
will get the 'values' appended to them.