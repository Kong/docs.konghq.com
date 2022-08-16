---
title: Router Operator Reference for Kong Gateway
content-type: reference
---

With the release of version 3.0, {{site.base_gateway}} now ships with a new router. The new router can describe routes using a domain-specific language called Expressions. Expressions can describe routes or paths as patterns using regular expressions. This document serves as a reference for all of the available operators. If you want to learn how to configure routes using Expressions read [How to configure routes using Expressions](gateway/latest/understanding-kong/how-to/router-atc/).


## Available fields

| Field | Description |
| --- | ----------- | 
| `net.protocol` | The protocol used to communicate with the upstream application.  |
| `tls.sni`  | Server name indication. | 
| `http.method` | HTTP methods that match a route. |
| `http.host`  | Lists of domains that match a route. | 
| `http.path` | Returns or sets the path. | 
| `http.raw_path` | Returns or sets the escaped path. | 
| `http.headers.*` |  Lists of values that are expected in the header of a request. | 

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

| Operator | Name | Return Type | 
| --- | ----------- | --- | 
| == | Equals | Boolean|
| != | Not equals| Boolean|
| > | Greater than | Boolean|
| >= | Greater than or equal | Boolean|
| < | Less than | Boolean|
| <= | Less than or equal | Boolean|

## IP 

| Operator | Name | Return Type | 
| --- | ----------- | --- | 
| == | Equals | Boolean|
| != | Not equals | Boolean|
| in | Contains | Boolean|

## Boolean

| Operator | Name | Return Type | 
| --- | ----------- | --- | 
| && | And | Boolean|
| `||` | Or | Boolean|
| ! | Not | Boolean|



## More information

* [Expressions repository](https://github.com/Kong/atc-router#table-of-contents)
* [How to configure routes using Expressions](gateway/latest/understanding-kong/how-to/router-atc/)