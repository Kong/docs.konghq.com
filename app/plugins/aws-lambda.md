---
id: page-plugin
title: Plugins - AWS Lambda
header_title: AWS Lambda
header_icon: /assets/images/icons/plugins/aws-lambda.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Sending parameters
      - label: Known Issues

description: |
  Invoke an [AWS Lambda](https://aws.amazon.com/lambda/) function from Kong. It
  can be used in combination with other request plugins to secure, manage or extend
  the function.

params:

  name: aws-lambda
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: aws_key
      required: true
      value_in_examples: AWS_KEY
      urlencode_in_examples: true
      default:
      description: The AWS key credential to be used when invoking the function
    - name: aws_secret
      required: true
      value_in_examples: AWS_SECRET
      urlencode_in_examples: true
      default:
      description: The AWS secret credential to be used when invoking the function
    - name: aws_region
      required: true
      default:
      value_in_examples: AWS_REGION
      description: |
        The AWS region where the Lambda function is located. Regions supported are: `us-east-1`, `us-east-2`, `ap-northeast-1`, `ap-northeast-2`, `ap-southeast-1`, `ap-southeast-2`, `eu-central-1`, `eu-west-1`
    - name: function_name
      required: true
      default:
      value_in_examples: LAMBDA_FUNCTION_NAME
      description: The AWS Lambda function name to invoke
    - name: qualifier
      required: false
      default:
      description: |
        The [`Qualifier`](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#API_Invoke_RequestSyntax) to use when invoking the function.
    - name: invocation_type
      required: false
      default: "`RequestResponse`"
      description: |
        The [`InvocationType`](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#API_Invoke_RequestSyntax) to use when invoking the function. Available types are `RequestResponse`, `Event`, `DryRun`
    - name: log_type
      required: false
      default: "`Tail`"
      description: |
        The [`LogType`](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#API_Invoke_RequestSyntax) to use when invoking the function. By default `None` and `Tail` are supported
    - name: timeout
      required: false
      default: "`60000`"
      description: An optional timeout in milliseconds when invoking the function
    - name: keepalive
      required: false
      default: "`60000`"
      description: |
        An optional value in milliseconds that defines how long an idle connection will live before being closed
    - name: unhandled_status
      required: false
      default: "`200`, `202` or `204`"
      description: |
        The response status code to use (instead of the default `200`, `202`, or `204`) in the case of an [`Unhandled` Function Error](https://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#API_Invoke_ResponseSyntax)
    - name: forward_request_body
      required: false
      default: "`false`"
      description: |
        An optional value that defines whether the request body is to be sent in the `request_body` field of the JSON-encoded request. If the body arguments can be parsed, they will be sent in the separate `request_body_args` field of the request. The body arguments can be parsed for `application/json`, `application/x-www-form-urlencoded`, and `multipart/form-data` content types.
    - name: forward_request_headers
      required: false
      default: "`false`"
      description: |
        An optional value that defines whether the original HTTP request headers are to be sent as a map in the `request_headers` field of the JSON-encoded request.
    - name: forward_request_method
      required: false
      default: "`false`"
      description: |
        An optional value that defines whether the original HTTP request method verb is to be sent in the `request_method` field of the JSON-encoded request.
    - name: forward_request_uri
      required: false
      default: "`false`"
      description: |
        An optional value that defines whether the original HTTP request URI is to be sent in the `request_uri` field of the JSON-encoded request. Request URI arguments (if any) will be sent in the separate `request_uri_args` field of the JSON body.

  extra: |
    **Reminder**: curl by default sends payloads with an
    `application/x-www-form-urlencoded` MIME type, which will naturally be URL-
    decoded by Kong. To ensure special characters that are likely to appear in your
    AWS key or secret (like `+`) are correctly decoded, you must URL-encode them,
    hence use `--date-urlencode` if you are using curl. Alternatives to this
    approach would be to send your payload with a different MIME type (like
    `application/json`), or to use a different HTTP client.

---

### Sending parameters

Any form parameter sent along with the request, will be also sent as an
argument to the AWS Lambda function.

### Known Issues

#### Use a fake upstream_url

When using the AWS Lambda plugin, the response will be returned by the plugin
itself without proxying the request to any upstream service. This means that
whatever `upstream_url` has been set on the [API][api-object] it will
never be used.

Although `upstream_url` will never be used, it's currently a mandatory field
in Kong's data model and its hostname must be resolvable. So set it to a
fake value (ie, `http://127.0.0.1:20000`) if you are planning to use this
plugin. Failing to do so will result in 500 errors regarding a resolution
failure.

In the future we will provide a more intuitive way to deal with similar
use cases.

#### Response plugins

There is a known limitation in the system that prevents some response plugins
from being executed. We are planning to remove this limitation in the future.

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[acl-associating]: /plugins/acl/#associating-consumers
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
