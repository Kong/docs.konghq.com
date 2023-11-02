---
title: Language References
content-type: reference
---

# Predicates

Predicate is the basic unit of expressions code which takes in the following form:

field *operator* constant

# Type system

Expressions language is strongly typed, operations are only allowed to be performed
if such operation makes sense with in regard to the actual type of field and constant.

Type conversion at runtime is not supported, either explicitly or implicitly. Types
are always known at the time an route is parsed and an error will be returned
if the operator can not be performed on the provided field and constant.

The Expressions language currently supports the following types:

| Type     | Description                                                                                          | Field type | Constant type |
|----------|------------------------------------------------------------------------------------------------------|------------|---------------|
| `String` | A string value, always in valid UTF-8.                                                               | ✅          | ✅             |
| `IpCidr` | Range of IP addresses in CIDR format. Can be either IPv4 and IPv6.                                   | ❌          | ✅             |
| `IpAddr` | A single IP address. Can be either IPv4 and IPv6.                                                    | ✅          | ✅             |
| `Int`    | A 64-bit signed integer.                                                                             | ✅          | ✅             |
| `Regex`  | A regex in [syntax](https://docs.rs/regex/latest/regex/#syntax) specified by the Rust `regex` crate. | ❌          | ✅             |

In addition, Expressions also supports one composite type - `Array`. Array types are written as `Type[]`.
For example: `String[]`, `Int[]`. Currently arrays can only be present in field values. They are used in
case one field could contain multiple values. e.g. `http.headers.x` or `http.queries.x`.

## `String`

Strings are valid UTF-8 sequences. They can be defined with string literal that looks like:
`"content"`. `\n`, `\r`, `\t`,`\\` as well as `\"` escape sequences are supported:

| Escape sequence | Description               |
|-----------------|---------------------------|
| `\n`            | Newline character         |
| `\r`            | Carriage return character |
| `\t`            | Horizontal tab character  |
| `\\`            | The `\` character         |
| `\"`            | The `"` character         |

In addition, Expressions supports raw string literals which takes form in `r#"content"`.
This feature is useful in case you want to write a regex and repeated escape quickly become
tedious to deal with:

For example, if you want to match `http.path` against `/\d+\-\d+` using the regex `~` operator:

With string literals, the predicate will be written as:

```
http.path ~ "/\\d+\\-\\d+"
```

With raw string literals, you can simply write:

```
http.path ~ r"/\d+\-\d+"
```

## `IpCidr`

`IpCidr` represents a range of IP addresses in [Classless Inter-Domain Routing (CIDR)](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) format.
Here are some examples:

IPv4:

```
net.src.ip in 192.168.1.0/24
```

IPv6:
```
net.src.ip in fd00::/8
```

> **Note:** Expressions parser rejects any CIDR literal where the host portion contains
  any non-zero bits. This means that `192.168.0.1/24` won't pass the parser check because
  the intention of the author is unclear.

## `IpAddr`

`IpCidr` represents a single IP addresses in [IPv4 Dot-decimal notation](https://en.wikipedia.org/wiki/Dot-decimal_notation),
or the standard [IPv6 Address Format](https://en.wikipedia.org/wiki/IPv6_address#Address_formats).

Here are some examples:

IPv4:

```
net.src.ip == 192.168.1.1
```

IPv6:
```
net.src.ip == fd00::1
```

## `Int`

There is only one integer type in Expressions, all integers are signed 64-bit integer. Integer
literals can be written as: `12345`, `-12345`, or in hexadecimal format such as `0xab12ff`
or in octet format as `0751`.

## `Regex`

Regex are written as `String` literals, but they are parsed when the regex operator `~` is present
and checked for validity according to the [Rust `regex` crate syntax](https://docs.rs/regex/latest/regex/#syntax).
For example, in the following predicate, the constant is parsed as a `Regex`:

```
http.path ~ r#"/foo/bar/.+"#
```

# Operators

Expressions language support rich set of operators that can be performed on various data types.
Here is an overview:

| Operator   | Name                  | Description                                      |
|------------|-----------------------|--------------------------------------------------|
| `==`       | Equals                | Field value equals to constant value             |
| `!=`       | Not equals            | Field value does not equals to constant value    |
| `~`        | Regex match           | Field value matches regex                        |
| `^=`       | Prefix match          | Field value starts with constant value           |
| `=^`       | Postfix match         | Field value ends with constant value             |
| `>=`       | Greater than or equal | Field value greater than or equal constant value |
| `>`        | Greater than          | Field value greater than constant value          |
| `<=`       | Less than or equal    | Field value less than or equal constant value    |
| `<`        | Less than             | Field value less than constant value             |
| `in`       | In                    | Field value is inside constant value             |
| `not in`   | Not in                | Field value is not inside constant value         |
| `contains` | Contains              | Field value contains constant value              |

Here are the allowed combination of field types and constant types with each operator:

> **Note:** Rows represents field types where columns represents constant value types.

| LHS/RHS  | `String`                                | `IpCidr`       | `IpAddr` | `Int`                      | `Regex` |
|----------|-----------------------------------------|----------------|----------|----------------------------|---------|
| `String` | `==`, `!=`, `~`, `^=`, `=^`, `contains` | ❌              | ❌        | ❌                          | `~`     |
| `IpAddr` | ❌                                       | `in`, `not in` | `==`     | ❌                          | ❌       |
| `Int`    | ❌                                       | ❌              | ❌        | `==`, `>=`, `>`, `<=`, `<` | ❌       |

> **Note:** The `~` operator is described as supports both `String ~ String` and `String ~ Regex`.
  In reality, `Regex` constant values can only be written as `String` on the right hand side.
  The presence of `~` operators makes the string literal to be treated as an regex constant value.

> **Note:** The `~` operator does not automatically anchor the regex to the beginning of the input.
  Meaning `http.path ~ r#"/foo/\d"#` could match a path like `/foo/1` or `/some/thing/foo/1`.
  If you with to match from the beginning of the string (anchoring the regex), then you must
  manually specify it with the `^` meta-character. For example: `http.path ~ r#"^/foo/\d"#`.

> **Note:** When performing IP addresses related comparisons with `==`, `in` or `not in`, different family of
  address types for the field and constant value will always cause the predicate to return `false` at
  runtime.
