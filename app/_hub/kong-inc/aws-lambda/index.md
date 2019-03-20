---
name: AWS Lambda
publisher: Kong Inc.
version: 1.0.0

desc: Invoke and manage AWS Lambda functions from Kong
description: |
  Invoke an [AWS Lambda](https://aws.amazon.com/lambda/) function from Kong. It
  can be used in combination with other request plugins to secure, manage or extend
  the function.

  <div class="alert alert-warning">
    <strong>Note:</strong> The functionality of this plugin as bundled
    with versions of Kong prior to 0.14.0 and Kong Enterprise prior to 0.34
    differs from what is documented herein. Refer to the
    <a href="https://github.com/Kong/kong/blob/master/CHANGELOG.md">CHANGELOG</a>
    for details.
  </div>

type: plugin
categories:
  - serverless

kong_version_compatibility:
    community_edition:
      compatible:
        - 1.0.x
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
    enterprise_edition:
      compatible:
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

params:

  name: aws-lambda
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
    - name: is_proxy_integration
      required: false
      default: "`false`"
      description: |
        An optional value that defines whether the response format to receive from the Lambda to [this format](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-output-format). Note that the parameter `isBase64Encoded` is not implemented.


  extra: |
    **Reminder**: curl by default sends payloads with an
    `application/x-www-form-urlencoded` MIME type, which will naturally be URL-
    decoded by Kong. To ensure special characters that are likely to appear in your
    AWS key or secret (like `+`) are correctly decoded, you must URL-encode them,
    hence use `--data-urlencode` if you are using curl. Alternatives to this
    approach would be to send your payload with a different MIME type (like
    `application/json`), or to use a different HTTP client.

---

### Sending parameters

Any form parameter sent along with the request, will be also sent as an
argument to the AWS Lambda function.

### Known Issues

#### Use a fake upstream service

When using the AWS Lambda plugin, the response will be returned by the plugin
itself without proxying the request to any upstream service. This means that
a Service's `host`, `port`, `path` properties will be ignored, but must still
be specified for the entity to be validated by Kong. The `host` property in
particular must either be an IP address, or a hostname that gets resolved by
your nameserver.

#### Response plugins

There is a known limitation in the system that prevents some response plugins
from being executed. We are planning to remove this limitation in the future.

[configuration]: /latest/configuration
[consumer-object]: /latest/admin-api/#consumer-object
[acl-associating]: /plugins/acl/#associating-consumers
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?

---
### Step By Step Guide

#### The Steps
1. Access to AWS Console as user allowed to operate with lambda functions and create user and roles.
2. Create an Execution role in AWS
3. Create an user which will be invoke the function via Kong, test it.
4. Create a Service & Route in Kong, add the aws-lambda plugin linked to our aws function and execute it.

#### Configure

1. First, let's create an execution role called `LambdaExecutor` for our lambda function.

    In IAM Console create a new Role choosing the AWS Lambda service, there will be no policies as our function in this example will simply execute itself giving us back an hardcoded JSON as response without accessing other AWS resources.

2. Now let's create a user named KongInvoker, used by our Kong API gateway to invoke the function.

    In IAM Console create a new user, must be provided to it programmatic access via Access and Secret keys; then will attach existing policies directly particularly the AWSLambdaRole predefined. Once the user creation is confirmed, store Access Key and Secret Key in a safe place.

3. Now we need to create the lambda function itself, will do so in N.Virginia Region (code us-east-1).

    In Lambda Management, create a new function Mylambda, there will be no blueprint as we are going to paste the code below; for the execution role let's choose an existing role specifically LambdaExecutor created previously

    Use the inline code below to have a simple JSON response in return, note this is code for Python 3.6 interpreter.

    ```python
    import json
    def lambda_handler(event, context):
        """
          If is_proxy_integration is set to true :
          jsonbody='''{"statusCode": 200, "body": {"response": "yes"}}'''
        """
        jsonbody='''{"response": "yes"}'''
        return json.loads(jsonbody)
    ```

    Test the lambda function from the AWS console and make sure the execution succeeds.

4. Finally we setup a Service & Route in Kong and link it to the function just created.

    ```bash
    curl -i -X POST http://{kong_hostname}:8001/services \
    --data 'name=lambda1' \
    --data 'url=http://localhost:8000' \
    ```

    The Service doesn't really need a real `url` since we are not going to have an HTTP call to upstream but rather a response generated by our function.

    Also create a Route for the Service:

    ```
    curl -i -X POST http://{kong_hostname}:8001/services/lambda1/routes \
    --data 'paths[1]=/lambda1'
    ```

    Add the plugin:

    ```bash
    curl -i -X POST http://{kong_hostname}:8001/services/lambda1/plugins \
    --data 'name=aws-lambda' \
    --data-urlencode 'config.aws_key={KongInvoker user key}' \
    --data-urlencode 'config.aws_secret={KongInvoker user secret}' \
    --data 'config.aws_region=us-east-1' \
    --data 'config.function_name=MyLambda'
    ```

    Call the Service and verify the correct invocation, execution and response:

    ```bash
    curl http://{kong_hostname}:8000/lambda1
    ```

    Additional headers:

    ```
    x-amzn-Remapped-Content-Length, X-Amzn-Trace-Id, x-amzn-RequestId
    ```

    JSON response:

    ```json
    {"response": "yes"}
    ```

Have fun leveraging the power of AWS Lambda in Kong!
