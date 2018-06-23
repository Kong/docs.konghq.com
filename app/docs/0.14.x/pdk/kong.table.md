---
title: kong.table
---

# kong.table

Utilities for Lua tables

## Table of Contents

* [kong.table.clear(tab)](#kong_table_clear)
* [kong.table.new([narr[, nrec]])](#kong_table_new)




### <a name="kong_table_clear"></a>kong.table.clear(tab)

Clears a table from all of its array and hash parts entries.

**Parameters**

* **tab** (table):  the table which will be cleared

**Returns**

*  Nothing


**Usage**

``` lua
local tab = {
  "hello",
  foo = "bar"
}

kong.table.clear(tab)

kong.log(tab[1]) -- nil
kong.log(tab.foo) -- nil
```

[Back to TOC](#table-of-contents)


### <a name="kong_table_new"></a>kong.table.new([narr[, nrec]])

Returns a table with pre-allocated number of slots in its array and hash
 parts.

**Parameters**

* **narr** (number, _optional_):  specifies the number of slots to pre-allocate
 in the array part.
* **nrec** (number, _optional_):  specifies the number of slots to pre-allocate in
 the hash part.

**Returns**

* `table` the newly created table


**Usage**

``` lua
local tab = kong.table.new(4, 4)
```

[Back to TOC](#table-of-contents)

