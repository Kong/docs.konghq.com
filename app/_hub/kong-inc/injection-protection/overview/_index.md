---
nav_title: Overview
title: Overview
---

You can use the Injection Protection plugin to detect well known patterns that might be the result of a cross site scripting or other injection type attacks.

The Injection Protection plugin makes it easier to protect your APIs from cross site scription or other injection attacks by providing out-of-the box regex matching for common injection attacks. In addition, you can configure custom regex matching as well. 

The Injection Protection plugin does the following: 
* Extracts information from request headers, path/query parameters, or the payload body and evaluate that content against pre-defined regular expression
* Rejects the requests that match the regular expressions with a 400 bad request
* Captures metrics about rejected requests for analytics and reporting

## How does the Injection Protection plugin work?

Depending on what you have configured in the plugin's config, the Injection Protection plugin does the following:

1. The plugin extracts the specified content (headers, path/query parameters, payload body, etc.) from a client request.
1. The plugin checks the extracted content for matches against the specified pre-defined or custom regex expressions. The regex expressions define patterns that would match well-known cross site scripting or other injection attacks.
1. Depending on if the content matches, the plugin does one of the following:
    * **Regex doesn't match:** The plugin allows the request and sends a `200` status code to the client.
    * **Regex match:** The plugin prevents the request by sending a `400` status code to the client and sends {{site.base_gateway}} an error log that contains the name of the injection type, what content matched the pattern, and what regex matched the content. You can also configure the plugin to only log matches and allow requests that match to still by proxied.

The following diagram shows how the Injection Protection plugin detects injections and is configured to block and log matches:

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

## What pre-defined regex patterns does the plugin provide for injection attacks?

The Injection Protection plugin comes with several pre-built regex patterns that match common injection attacks. You can specify these patterns when you configure the plugin to easily block common attacks.

| Injection type | Regex | Description |
|----------------|-------|-------------|
| SQL | `[\s]*((delete)|(exec)|(drop\s*table)|(insert)|(shutdown)|(update)|(\bor\b))` | Detects injection of a SQL query using the input data from the client to the application. |
| Server-side include | `<!--#(include|exec|echo|config|printenv)\s+.*` | Detects scripts injected in HTML pages. |
| XPath abbreviated | `(/(@?[\w_?\w:\*]+(\[[^]]+\])*)?)+` | Detects intentionally malformed information that is sent to a website with the intention of constructing an XPath query for XML data, specifically in abbreviated syntax. |
| XPath extended | `/?(ancestor(-or-self)?|descendant(-or-self)?|following(-sibling))` | Detects intentionally malformed information that is sent to a website with the intention of constructing an XPath query for XML data, specifically in the full syntax. |
| JavaScript | `<\s*script\b[^>]*>[^<]+<\s*/\s*script\s*>` | Detects abritrarily injected JavaScript that is part of a cross site scripting attack and will execute in the browser. 
| Java exception | `.*?Exception in thread.*` | Detects denial-of-service (DoS) attacks that match Java exception messages. |

## How do I create a custom regex for matching?

You can specify a custom regex for matching by using the `custom_regex_record` parameter in the Injection Protection plugin config. To create a custom regex, you must define the following:

* The name of the regex (used in {{site.base_gateway}} logs)
* The regex string you want to check for a match
* The content you want to check for a regex match (such as headers, path and query, and body)

## How do I collect and read the logs?

<!--unsure-->

## More information

<!-- Bulleted list of links to more info about your plugin -->