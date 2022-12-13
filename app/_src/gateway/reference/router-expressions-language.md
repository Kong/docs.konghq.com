---
title: Router Expressions Language Reference for Kong Gateway
content-type: reference
---

With the release of version 3.0, {{site.base_gateway}} now ships with a new router. The new router can describe routes using a domain-specific language called Expressions. Expressions can describe routes or paths as
combinations of logical operations called "predicates". This document serves as a reference for all of the available operators and fields.
If you want to learn how to configure routes using Expressions read [How to configure routes using Expressions](/gateway/{{ page.kong_version }}/key-concepts/routes/expressions).


## General design

Kong router Expressions are designed as combinations of simple comparisons called "predicates". All predicates have one of the following form:

```
field op value
transformation(field) op value
```

Example:

```
http.path ^= "/prefix/"
lower(http.path) ^= "/prefix/"
```

Note: transformations only works on fields, it will not work on the value side of the predicate. This means you can **not** write:

```
http.path ^= lower("/preFIX/")
```

Predicates can be grouped with parenthesis `()` or logical operators `||`, `&&`:

Example:

```
(http.path ^= "/prefix/" && net.port == 80) || http.method == "POST"
```

## Types

Router expressions are strongly typed. The operators available to each field depends on the type of that field.
For example, you can not perform string comparisons on a integer type field.

## Available fields

| Field | Description | Type |
| --- | ----------- | -------|
| `net.protocol` | The protocol used to communicate with the upstream application. | String |
| `net.port` | Server end port number. | Int |
| `tls.sni`  | Server name indication. | String |
| `http.method` | HTTP methods that match a route. | String |
| `http.host`  | Lists of domains that match a route. | String |
| `http.path` | Normalized request path (without query parameters). | String |
| `http.headers.header_name` | Value of header `Header-Name`. Header names are converted to lower case, and `-` are replaced to `_`. | String |

## String

| Operator | Meaning |
| --- | ----------- |
| == | Equals |
| != | Not equals |
| ~ | Regex matching |
| ^= | Prefix matching |
| =^ | Suffix matching |
| in | Contains |
| not in | Does not contain |

## String transformations

| Transformation | Meaning |
| -------------- | ------- |
| lower()        | turn the uppercase letters into lowercase |

## Integer

| Operator | Meaning |
| --- | ----------- |
| == | Equals |
| != | Not equals|
| > | Greater than |
| >= | Greater than or equal |
| < | Less than |
| <= | Less than or equal |

## IP

| Operator | Meaning |
| --- | ----------- |
| == | Equals |
| != | Not equals |
| in | Contains |

## Boolean

| Operator | Meaning |
| --- | ----------- |
| && | Logical And |
| `||` | Logical Or |



## More information

* [Expressions repository](https://github.com/Kong/atc-router#table-of-contents)
* [How to configure routes using Expressions](/gateway/{{ page.kong_version }}/key-concepts/routes/expressions)
