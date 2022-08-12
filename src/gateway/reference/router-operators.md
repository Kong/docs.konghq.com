---
title: Configuration Reference for Kong Gateway
content-type: reference
---

With the release of version 3.0, {{site.base_gateway}} now ships with a new router. The new router can describe routes using a domain-specific languaged called ATC. ATC can describe routes or paths as patterns using regular expressions. This document serves as a reference for all of the available operators: 


## String
| Operator | Name | Return Type | 
| --- | ----------- | --- | 
| == | Equals | Boolean|
| != | Not equals | Boolean|
| ~ | Regex matching | Boolean|
| ^= | Prefix matching | Boolean|
| =^ | Suffix matching | Boolean|
| in | Contains | Boolean|
| not in | Does not contain | Boolean|
| lower() | Lowercase | String|

## Integer

| == | Equals | Boolean|
| != | Not equals| Boolean|
| > | Greater than | Boolean|
| >= | Greater than or equal | Boolean|
| < | Less than | Boolean|
| <= | Less than or equal | Boolean|

## IP 

| == | Equals | Boolean|
| != | Not equals | Boolean|
| in | Contains | Boolean|

## Boolean

| && | And | Boolean|
| `||` | Or | Boolean|
| ! | Not | Boolean|

"protocols": ["http", "https"],
"methods": ["GET", "POST"],
"hosts": ["example.com", "foo.test"],
"paths": ["/foo", "/bar"],
"headers": {"x-another-header":["bla"], "x-my-header":["foo", "bar"]},

