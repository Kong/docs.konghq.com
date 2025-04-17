---
nav_title: Overview
---

The AI Sanitizer plugin for {{site.base_gateway}} helps protect sensitive information in client request bodies before they reach upstream services.
By integrating with an external PII service, the plugin ensures compliance with data privacy regulations while preserving the usability of request data.
It supports multiple sanitization modes, including replacing sensitive information with fixed placeholders or generating synthetic replacements that retain category-specific characteristics.

Additionally, AI Sanitizer offers an optional restoration feature, allowing the original data to be reinstated in responses when needed.

{:.note}
> This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/) or the [AI Proxy Advanced](/hub/kong-inc/ai-proxy-advanced/) plugin, and requires an AI proxy to be configured first. 
Check out the [AI Gateway quickstart](/gateway/latest/get-started/ai-gateway/) to get an AI proxy up and running within minutes.

The AI Sanitizer plugin uses the AI PII Anonymizer Service, which can run in a Docker container, to detect and sanitize sensitive data.  See the [tutorial on configuring the AI Sanitizer plugin](/hub/kong-inc/ai-sanitizer/how-to/) for more information on how to configure the plugin with the AI PII Anonymizer Service.

## How it works

1. The plugin intercepts the request body and sends it to the external PII service.
1. The PII service detects sensitive data and applies the chosen sanitization method (placeholders or synthetic replacements).
1. The sanitized request is forwarded upstream with the AI Proxy or AI Proxy Advanced plugin.
1. If restoration is enabled, the plugin restores original data in responses before returning them to the client.

## AI PII Anonymizer service

Kong provides several [AI PII Anonymizer service](https://hub.docker.com/r/kong/ai-pii-service) Docker images, each of which has its own built-in NLP model and is tagged with the `version-lang_code` pattern. For example:
* `ai-pii-service:v0.1.2-en` means the version of the image is 0.1.2 and its built-in NLP model is English
* `ai-pii-service:v0.1.2-it` is for Italian and `ai-pii-service:v0.1.2-fr` is French
and so on.

The image tagged with `all` contains English, French, German, Italian, Japanese, Portuguese, and Spanish models. If you need to use other NLP models, customize `ai_pii_service/nlp_engine_conf.yml` with any of the available images.

{:.note}
> This Docker image is private, contact [Kong Support](https://support.konghq.com/support/s/) to get access to it.
>
> The PII Anonymizer service loads NLP models, with one model loaded by default. Ensure that you have at least 600MB of free memory to run the image.

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

* `placeholder`: Replaces sensitive data with a fixed placeholder pattern, `PLACEHOLDER{i}`, where `i` is a sequence number. Identical original values receive the same placeholder.
   
   For example, the location `New York City` might be replaced with `LOCATION`.
   
* `synthetic`: Redact the sensitive data with a word in the same type. 
   
   For example, the name `John` might be replaced with `Amir`.

  * Custom patterns are replaced with `CUSTOM{i}`.
   * Credentials are replaced with a string of `#` characters matching the original length.

### Custom patterns

You can define an array of custom patterns on a per-request basis.  
Currently, only regex patterns are supported, and all fields are required: `name`, `regex`, and `score`.

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