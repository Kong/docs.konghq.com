---
title: Performance Optimizations
content-type: reference
---

Performance is critical when it comes to proxying API traffic. Learn how to optimize the
Expressions you write to get the most performance out of the routing engine.

## Number of routes

Expressions routes are always evaluated in the descending `priority` order they were defined.
Therefore, it is helpful to put more likely matched routes before (i.e. higher priority)
less frequently matched routes.

### Examples

Route 1:
```
expression: http.path == "/very/hot/request/path"
priority: 100
```

Route 2:
```
expression: http.path == "/not/so/hot/request/path"
priority: 50
```

It is also desirable to reduce the number of `Route` entity created by leveraging the
logical combination capability of the Expressions language.

### Examples

If multiple routes results in the same `Service` and `Plugin` config being used,
they should be combined into a single Expression `Route` with logical or operator `||`:

Route 1:
```
service: example-service
expression: http.path == "/hello"
```

Route 2:
```
service: example-service
expression: http.path == "/world"
```

Could instead be combined as:

```
service: example-service
expression: http.path == "/hello" || http.path == "/world"
```

which results in less `Route` object created, and better performance.

## Regular expressions usage

Regular expressions (regexes) are powerful tool that can be used to match strings based on
very complex criteria. Unfortunately, this has also made them more expensive to
evaluate at runtime and hard to optimize. Therefore, there are some common
scenarios where regex usages can be eliminated, resulting in significantly
better matching performance.

### Examples

When performing exact matches (non-prefix patches) of request path, use the `==` operator,
instead of regex:

<span style="color:green">**Fast:**</span>.
```
http.path == "/foo/bar"
```

<span style="color:red">**Slow:**</span>.
```
http.path ~ r#"^/foo/bar$"#
```

When performing exact matches with optional slash `/` at the end, it is tempting to write
regexes. However, this is completely unnecessary with the Expressions language:

<span style="color:green">**Fast:**</span>.
```
http.path == "/foo/bar" || http.path == "/foo/bar/"
```

<span style="color:red">**Slow:**</span>.
```
http.path ~ r#"^/foo/?$"#
```
