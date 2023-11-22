---
title: Expressions Performance Optimizations
content-type: reference
---

Performance is critical when it comes to proxying API traffic. This guide explains how to optimize the
expressions you write to get the most performance out of the routing engine.

## Number of routes

### Route matching priority order

Expressions routes are always evaluated in the descending `priority` order they were defined.
Therefore, it is helpful to put more likely matched routes before (as in, higher priority)
less frequently matched routes.

The following examples show how you would prioritize two routes based on if they were likely to be matched or not.

Example route 1:
```
expression: http.path == "/likely/matched/request/path"
priority: 100
```

Example route 2:
```
expression: http.path == "/unlikely/matched/request/path"
priority: 50
```

It's also best to reduce the number of `Route` entities created by leveraging the
logical combination capability of the expressions language.

### Combining routes

If multiple routes result in the same `Service` and `Plugin` config being used,
they should be combined into a single expression `Route` with the `||` logical or operator. By combining routes into a single expression, this results in fewer `Route` objects created and better performance.

Example route 1:
```
service: example-service
expression: http.path == "/hello"
```

Example route 2:
```
service: example-service
expression: http.path == "/world"
```

These two routes can instead be combined as:

```
service: example-service
expression: http.path == "/hello" || http.path == "/world"
```

## Regular expressions usage

Regular expressions (regexes) are powerful tool that can be used to match strings based on
very complex criteria. Unfortunately, this has also made them more expensive to
evaluate at runtime and hard to optimize. Therefore, there are some common
scenarios where regex usages can be eliminated, resulting in significantly
better matching performance.

When performing exact matches (non-prefix matching) of a request path, use the `==` operator
instead of regex.

**Faster performance example:**
```
http.path == "/foo/bar"
```

**Slower performance example:**
```
http.path ~ r#"^/foo/bar$"#
```

When performing exact matches with the `/` optional slash at the end, it is tempting to write
regexes. However, this is completely unnecessary with the expressions language.

**Faster performance example:**
```
http.path == "/foo/bar" || http.path == "/foo/bar/"
```

**Slower performance example:**
```
http.path ~ r#"^/foo/?$"#
```
