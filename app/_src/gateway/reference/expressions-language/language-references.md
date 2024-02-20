---
title: Language References
content-type: reference
---

This reference explains the parts of the expressions language structure used for the expression router.

## Predicates

A predicate is the basic unit of expressions code which takes the following form:

```
http.path ^= "/foo/bar"
```

This predicate example has the following structure:
* `http.path`: Field
* `^=`: Operator
* `"/foo/bar"`: Constant value

## Type system

Expressions language is strongly typed. Operations are only performed
if such an operation makes sense in regard to the actual type of field and constant.

Type conversion at runtime is not supported, either explicitly or implicitly. Types
are always known at the time a route is parsed and an error is returned
if the operator cannot be performed on the provided field and constant.

The expressions language currently supports the following types:

| Type     | Description                                                                                          | Field type | Constant type |
|----------|------------------------------------------------------------------------------------------------------|------------|---------------|
| `String` | A string value, always in valid UTF-8.                                                               | ✅          | ✅             |
| `IpCidr` | Range of IP addresses in CIDR format. Can be either IPv4 or IPv6.                                   | ❌          | ✅             |
| `IpAddr` | A single IP address. Can be either IPv4 or IPv6.                                                    | ✅          | ✅             |
| `Int`    | A 64-bit signed integer.                                                                             | ✅          | ✅             |
| `Regex`  | A regex in [syntax](https://docs.rs/regex/latest/regex/#syntax) specified by the Rust `regex` crate. | ❌          | ✅             |

In addition, expressions also supports one composite type, `Array`. Array types are written as `Type[]`.
For example: `String[]`, `Int[]`. Currently, arrays can only be present in field values. They are used in
case one field could contain multiple values. For example, `http.headers.x` or `http.queries.x`.

### String

Strings are valid UTF-8 sequences. They can be defined with string literal that looks like
`"content"`. The following escape sequences are supported:

| Escape sequence | Description               |
|-----------------|---------------------------|
| `\n`            | Newline character         |
| `\r`            | Carriage return character |
| `\t`            | Horizontal tab character  |
| `\\`            | The `\` character         |
| `\"`            | The `"` character         |

In addition, expressions support raw string literals, like `r#"content"#`.
This feature is useful if you want to write a regex and repeated escape becomes
tedious to deal with.

For example, if you want to match `http.path` against `/\d+\-\d+` using the regex `~` operator, the predicate will be written as the following with string literals:

```
http.path ~ "/\\d+\\-\\d+"
```

With raw string literals, you can write:

```
http.path ~ r#"/\d+\-\d+"#
```

### IpCidr

`IpCidr` represents a range of IP addresses in Classless Inter-Domain Routing (CIDR) format.

The following is an IPv4 example:

```
net.src.ip in 192.168.1.0/24
```

The following is an IPv6 example:
```
net.src.ip in fd00::/8
```

Expressions parser rejects any CIDR literal where the host portion contains any non-zero bits. This means that `192.168.0.1/24` won't pass the parser check because the intention of the author is unclear.

### IpAddr

`IpAddr` represents a single IP addresses in IPv4 Dot-decimal notation,
or the standard IPv6 Address Format.

The following is an IPv4 example:

```
net.src.ip == 192.168.1.1
```

The following is an IPv6 example:
```
net.src.ip == fd00::1
```

### Int

There is only one integer type in expressions. All integers are signed 64-bit integers. Integer
literals can be written as `12345`, `-12345`, or in hexadecimal format, such as `0xab12ff`,
or in octet format like `0751`.

### Regex

Regex are written as `String` literals, but they are parsed when the `~` regex operator is present
and checked for validity according to the [Rust `regex` crate syntax](https://docs.rs/regex/latest/regex/#syntax).
For example, in the following predicate, the constant is parsed as a `Regex`:

```
http.path ~ r#"/foo/bar/.+"#
```

## Operators

Expressions language support a rich set of operators that can be performed on various data types.

| Operator       | Name                  | Description                  |
|----------------|-----------------------|--------------------------------------------------------------------------------------|
| `==`           | Equals                | Field value is equal to the constant value                                                                                                                                                                   |
| `!=`           | Not equals            | Field value does not equal the constant value                                                                                                                                                                |
| `~`            | Regex match           | Field value matches regex                                                                                                                                                                                    |
| `^=`           | Prefix match          | Field value starts with the constant value                                                                                                                                                                   |
| `=^`           | Postfix match         | Field value ends with the constant value                                                                                                                                                                     |
| `>=`           | Greater than or equal | Field value is greater than or equal to the constant value                                                                                                                                                   |
| `>`            | Greater than          | Field value is greater than the constant value                                                                                                                                                               |
| `<=`           | Less than or equal    | Field value is less than or equal to the constant value                                                                                                                                                      |
| `<`            | Less than             | Field value is less than the constant value                                                                                                                                                                  |
| `in`           | In                    | Field value is inside the constant value                                                                                                                                                                     |
| `not in`       | Not in                | Field value is not inside the constant value                                                                                                                                                                 |
| `contains`     | Contains              | Field value contains the constant value                                                                                                                                                                      |
| `&&`           | And                   | Returns `true` if **both** expressions on the left and right side evaluates to `true`                                                                                                                        |
| `||` | Or | Returns `true` if **any** expressions on the left and right side evaluates to `true` |                                                                                                                    |
| `(Expression)` | Parenthesis           | Groups expressions together to be evaluated first                                                                                                                                                            |

{% if_version gte:3.6.x inline:true %}
| `!`            | Not                   | Negates the result of a parenthesized expression. **Note:** The `!` operator can only be used with parenthesized expression like `!(foo == 1)`, it **cannot** be used with a bare predicate like `! foo == 1` |
{% endif_version %}

### Extended descriptions

### In and not in

These operators are used with `IpAddr` and `IpCidr` types to perform an efficient IP list check.
For example, `net.src.ip in 192.168.0.0/24` will only return `true` if the value of `net.src.ip` is within
`192.168.0.0/24`.

### Contains

This operator is used to check the existence of a string inside another string.
For example, `http.path contains "foo"` will return `true` if `foo` can be found anywhere inside `http.path`.
This will match a `http.path` that looks like `/foo`, `/abc/foo`, or `/xfooy`, for example.

### Type and operator semantics

Here are the allowed combination of field types and constant types with each operator.
In the following table, rows represent field types that display on the left-hand side (LHS) of the predicate, 
whereas columns represent constant value types that display on the right-hand side (RHS) of the predicate.

| Field (LHS)/Constant (RHS) types | `String`                                | `IpCidr`       | `IpAddr` | `Int`                            | `Regex` | `Expression` |
|----------------------------------|-----------------------------------------|----------------|----------|----------------------------------|---------|--------------|
| `String`                         | `==`, `!=`, `~`, `^=`, `=^`, `contains` | ❌              | ❌        | ❌                                | `~`     | ❌            |
| `IpAddr`                         | ❌                                       | `in`, `not in` | `==`     | ❌                                | ❌       | ❌            |
| `Int`                            | ❌                                       | ❌              | ❌        | `==`, `!=`, `>=`, `>`, `<=`, `<` | ❌       | ❌           |
| `Expression`                     | ❌                                       | ❌              | ❌        | ❌                                | ❌       | `&&`, `||`|


{:.note}
> **Notes:** 
  * The `~` operator is described as supporting both `String ~ String` and `String ~ Regex`.
  In reality, `Regex` constant values can only be written as `String` on the right hand side.
  The presence of `~` operators treats the string value as a regex.
  Even with the `~` operator, [`String` escape rules described above](#string) still apply and it
  is almost always easier to use raw string literals for the `~` operator as described in the [`Regex` section](#regex).
  * The `~` operator does not automatically anchor the regex to the beginning of the input.
  Meaning `http.path ~ r#"/foo/\d"#` could match a path like `/foo/1` or `/some/thing/foo/1`.
  If you want to match from the beginning of the string (anchoring the regex), then you must
  manually specify it with the `^` meta-character. For example, `http.path ~ r#"^/foo/\d"#`.
  * When performing IP address-related comparisons with `==`, `in`, or `not in`, different families of
  address types for the field and constant value will always cause the predicate to return `false` at
  runtime.
