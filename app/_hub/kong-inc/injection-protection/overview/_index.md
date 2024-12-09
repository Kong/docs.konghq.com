---
nav_title: Overview
title: Injection Protection
---

You can use the Injection Protection plugin to detect and block known injection patterns consistent with SQL injection, server-side include injection, and more.

The Injection Protection plugin makes it easier to protect your APIs from SQL injection or other injection attacks by providing out-of-the box regex matching for common injection attacks. 
You can also configure custom regex matching.

The Injection Protection plugin does the following: 
* Extracts information from request headers, path/query parameters, or the payload body and evaluates that content against predefined regular expressions
* Rejects the requests that match the regular expressions with a configurable HTTP status code and error message
* Logs information about rejected requests for analytics and reporting

## How does the Injection Protection plugin work?

Depending on what you have configured in the plugin's config, the Injection Protection plugin does the following:

1. The plugin extracts the specified content (headers, path/query parameters, payload body) from a client request.
1. The plugin checks the extracted content for matches against the specified predefined or custom regex expressions. 
The regex expressions define patterns that would match well-known injection attacks.
1. Depending on if the content matches, the plugin does one of the following:
    * **Regex doesn't match:** The plugin allows the request and sends a `200` status code to the client.
    * **Regex match:** The plugin blocks the request by sending a `400` status code to the client and sends 
    {{site.base_gateway}} an error log that contains the name of the injection type, the content that matched the pattern, and the regex that matched the content. 
    You can also configure the plugin to only log matches and allow requests that match to still be proxied.

The following diagram shows how the Injection Protection plugin detects injections and is configured to block and log matches:

<!--vale off-->
{% mermaid %}
sequenceDiagram
    actor Consumer
    participant Injection Protection plugin
    participant {{site.base_gateway}}
    Consumer->>Injection Protection plugin: Sends a request

    alt No regex match
        Injection Protection plugin->>Consumer: 200 OK
    else Regex match
        Injection Protection plugin->>Consumer: 400 Bad Request
        Injection Protection plugin->>{{site.base_gateway}}: Logs injection 
    end
{% endmermaid %}
<!--vale on-->

## Predefined regex patterns

The Injection Protection plugin comes with several pre-built regex patterns that match common injection attacks. 
You can enable or disable these patterns when you configure the plugin to easily block common attacks.

| Injection type | Regex | Description |
|----------------|-------|-------------|
| SQL | `[\s]*((delete)|(exec)|(drop\s*table)|(insert)|(shutdown)|(update)|(\bor\b))` | Detects injection of a SQL query using the input data from the client to the application. |
| Server-side include | `<!--#(include|exec|echo|config|printenv)\s+.*` | Detects scripts injected in HTML pages. |
| XPath abbreviated | `(/(@?[\w_?\w:\*]+(\[[^]]+\])*)?)+` | Detects intentionally malformed information that is sent to a website with the intention of constructing an XPath query for XML data, specifically in abbreviated syntax. |
| XPath extended | `/?(ancestor(-or-self)?|descendant(-or-self)?|following(-sibling))` | Detects intentionally malformed information that is sent to a website with the intention of constructing an XPath query for XML data, specifically in the full syntax. |
| JavaScript | `<\s*script\b[^>]*>[^<]+<\s*/\s*script\s*>` | Detects abritrarily injected JavaScript that is part of a cross site scripting attack and will execute in the browser. 
| Java exception | `.*?Exception in thread.*` | Detects denial-of-service (DoS) attacks that match Java exception messages. |

## How do I create a custom regex for matching?

You can specify a custom regex for matching by using the [`custom_injections`](/hub/kong-inc/injection-protection/configuration/#config-custom_injections) parameter in the Injection Protection plugin config. 
To create a custom regex, you must define the following:

* The name of the regex (used in {{site.base_gateway}} logs)
* The regex string you want to check for a match
* The content you want to check for a regex match (such as headers, path and query, and body)

## How do I collect and read the logs?

Logs are automatically collected when you enable the Injection Protection plugin. You can view the logs with the following options:

* [{{site.base_gateway}} error log](/gateway/latest/production/logging/)
* Log serializer. You can view these log with the following plugins:
    * [File Log](/hub/kong-inc/file-log/)
    * [HTTP Log](/hub/kong-inc/http-log/)
    * [Kafka Log](/hub/kong-inc/kafka-log/)
    * [TCP Log](/hub/kong-inc/tcp-log/)
    * [UDP Log](/hub/kong-inc/udp-log/)
* [{{site.konnect_short_name}} Advanced Analytics](/konnect/analytics/) <!--though i'm not sure if they will do anything with them yet--> 