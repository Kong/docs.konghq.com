---
nav_title: Overview
---

The AI Sanitizer plugin for {{site.base_gateway}} helps protect sensitive information in client request bodies before they reach upstream services.
By integrating with an external PII service, the plugin ensures compliance with data privacy regulations while preserving the usability of request data.
It supports multiple sanitization modes, including replacing sensitive information with fixed placeholders or generating synthetic replacements that retain category-specific characteristics.

Additionally, it offers an optional restoration feature, allowing the original data to be reinstated in responses when needed.

{:.note}
> This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/) or the [AI Proxy Advanced](/hub/kong-inc/ai-proxy-advanced/) plugin, and requires an AI proxy to be configured first. 
Check out the [AI Gateway quickstart](/gateway/latest/get-started/ai-gateway/) to get an AI proxy up and running within minutes!

The AI Sanitizer plugin relies on the AI PII Anonymizer Service for identifying and sanitizing sensitive information, which can be deployed as a Docker container. See the [tutorial on configuring the AI Sanitizer plugin](/hub/kong-inc/ai-sanitizer/how-to/) for more information on how to configure the plugin with the AI PII Anonymizer Service.

## How it works

1. When a request reaches {{site.base_gateway}}, the plugin intercepts the request body and forwards it to the external PII service.
2. The PII service analyzes the content, identifies sensitive information, and applies the selected sanitization method (fixed placeholders or category-based synthetic replacements).
3. The sanitized request body is then forwarded to the upstream service through the AI Proxy or AI Proxy Advanced plugin.
4. If the restoration feature is enabled, the plugin can restore the original data in responses before returning them to the client, ensuring a seamless user experience.

## AI PII Anonymizer service

Kong provides an [AI PII Anonymizer service](https://hub.docker.com/r/kong/ai-pii-service) Docker image. 

### Image configuration options

This service takes the following optional environment variables at startup:
* `GUNICORN_WORKERS`: Specifies the number of Gunicorn processes to run
* `PII_SERVICE_ENGINE_CONF`: Specifies the natural language processing (NLP) engine configuration file
* `GUNICORN_LOG_LEVEL`: Specifies log level

### Sanitization endpoints

* `POST /llm/v1/sanitize`: Sanitize specified types of PII information, including credentials, and custom patterns
* `POST /llm/v1/sanitize_credentials`: Only for sanitizing credentials

### Available anonymization modes

You can anonymize data in requests using the following redact modes:

* `placeholder`: Redact the sensitive data with a fixed placeholder pattern, `PLACEHOLDER{i}`, where `i` is a sequence number and the same original text share the same number. 
   
   For example, the location `New York City` might be replaced with `LOCATION`.
   
* `synthetic`: Redact the sensitive data with a word in the same type. 
   
   For example, the name `John` might be replaced with `Amir`.

  * Custom patterns will be replaced with `CUSTOM{i}`.
  * For credentials, the string `#` with the same length as the original string will be used as a replacement.

### Custom patterns

You can introduce an array of custom patterns on a per-request basis. 
Today we support regex patterns, and all fields are required (`name`, `regex`, and `score`).

The `name` must be unique for each pattern.

### Fields that can be anonymized

You can use the following fields in the `anonymize` array:

* `general`: Anonymizes general PII entities such as person names, locations, and organizations.
* `phone`: Anonymizes phone numbers (for example, `mobile`, `landline`).
* `email`: Anonymizes email addresses.
* `creditcard`: Anonymizes credit card numbers.
* `crypto`: Anonymizes cryptocurrency addresses.
* `date`: Anonymizes dates and timestamps.
* `ip`: Anonymizes IP addresses (both IPv4 and IPv6).
* `nrp`: Anonymizes a person’s nationality, religious, or political group.
* `ssn`: Anonymizes Social Security Numbers (SSN) and other related identifiers like ITIN, NIF, ABN, and more.
* `domain`: Anonymizes domain names.
* `url`: Anonymizes web URLs.
* `medical`: Anonymizes medical identifiers (for example, medical license numbers, NHS numbers, medicare numbers).
* `driverlicense`: Anonymizes driver's license numbers.
* `passport`: Anonymizes passport numbers.
* `bank`: Anonymizes bank account numbers and related banking identifiers (for example, VAT codes, IBAN).
* `nationalid`: Anonymizes various national identification numbers (for example, Aadhaar, PESEL, NRIC, social security, or voter IDs).
* `custom`: Anonymizes user-defined custom PII patterns using regular expressions only when custom patterns are provided.
* `credentials`: Anonymizes the credentials, similar to `/sanitize_credentials`.
* `all`: Includes all the fields above, including custom ones.