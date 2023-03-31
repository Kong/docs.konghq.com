---
name: AWS Lambda
publisher: Kong Inc.
desc: Invoke and manage AWS Lambda functions from Kong
description: |
  Invoke an [AWS Lambda](https://aws.amazon.com/lambda/) function from Kong. The
  AWS Lambda plugin can be used in combination with other request plugins to secure, manage, or
  extend the function.
type: plugin
categories:
  - serverless
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
params:
  name: aws-lambda
  service_id: true
  route_id: true
  consumer_id: true
  protocols:
    - name: http
    - name: https
    - name: grpc
    - name: grpcs
  dbless_compatible: 'yes'
  config:
    - name: aws_key
      required: semi
      value_in_examples: <AWS_KEY>
      urlencode_in_examples: true
      default: null
      datatype: string
      encrypted: true
      referenceable: true
      description: |
        The AWS key credential to be used when invoking the function. The `aws_key` value is required
        if `aws_secret` is defined. If `aws_key` and `aws_secret` are not set, the plugin uses an
        IAM role inherited from the instance running Kong to authenticate. Can be symmetrically encrypted
        if using Kong Gateway and [data encryption](/gateway/latest/kong-production/db-encryption/)
        is configured.
    - name: aws_secret
      required: semi
      value_in_examples: <AWS_SECRET>
      urlencode_in_examples: true
      default: null
      datatype: string
      encrypted: true
      referenceable: true
      description: |
        The AWS secret credential to be used when invoking the function. The `aws_secret` value is required
        if `aws_key` is defined. If `aws_key` and `aws_secret` are not set, the plugin uses an
        IAM role inherited from the instance running Kong to authenticate. Can be symmetrically encrypted
        if using Kong Gateway and [data encryption](/gateway/latest/kong-production/db-encryption/)
        is configured.
    - name: aws_region  # old version, do not update
      maximum_version: "2.5.x"
      required: true
      default:
      value_in_examples: <AWS_REGION>
      datatype: string
      description: |
        The AWS region where the Lambda function is located. The plugin does not
        attempt to validate the supplied region name. If an invalid region name
        is provided, the plugin responds with an HTTP `500 Internal Server Error`
        at runtime and logs a DNS resolution failure. Either `aws_region` or `host`
        must be provided.

    - name: aws_region  # old version, do not update
      minimum_version: "2.6.x"  
      maximum_version: "2.8.x"
      required: false
      default: null
      value_in_examples: <AWS_REGION>
      datatype: string
      description: |
        The AWS region where the Lambda function is located. The plugin does not
        attempt to validate the supplied region name. If an invalid region name
        is provided, the plugin responds with an HTTP `500 Internal Server Error`
        at runtime and logs a DNS resolution failure.

        The plugin will automatically
        detect the AWS region on runtime via `AWS_REGION` or `AWS_DEFAULT_REGION` environment
        variables when neither `aws_region` nor `host` is specified in plugin configuration.
        Using environment variables enables regionally distributed Kong cluster nodes
        to connect to the closest AWS region. If `aws_region`, `host` and environment
        variables have not been specified, the plugin responds with an HTTP
        `500 Internal Server Error` at run-time.

    - name: aws_region  # current version of parameter
      minimum_version: "3.0.x"
      required: semi
      default: null
      value_in_examples: <AWS_REGION>
      datatype: string
      description: |
        The AWS region where the Lambda function is located. The plugin does not
        attempt to validate the supplied region name.

        The plugin has two methods of detecting the AWS region: the `aws_region`
        parameter, or one of the `AWS_REGION` or `AWS_DEFAULT_REGION` environment
        variables. One of these must be set.

        If `region` is not specified in plugin configuration, the plugin
        automatically detects the AWS region on runtime via one of the environment
        variables.
        Using environment variables enables regionally distributed Kong cluster nodes
        to connect to the closest AWS region.

        The AWS region is required for AWS SigV4.
        If `aws_region` or the `AWS_REGION` or `AWS_DEFAULT_REGION` environment
        variables have not been specified, or an invalid region name has been provided,
        the plugin responds with an HTTP `500 Internal Server Error` at runtime.

    - name: aws_assume_role_arn
      minimum_version: "2.8.x"
      required: false
      default: null
      value_in_examples: <AWS_ASSUME_ROLE_ARN>
      datatype: string
      referenceable: true
      description: |
        The target AWS IAM role ARN used to invoke the Lambda function. Typically this is
        used for a cross-account Lambda function invocation.
    - name: aws_role_session_name
      minimum_version: "2.8.x"
      required: false
      default: '`kong`'
      value_in_examples: <AWS_ROLE_SESSION_NAME>
      datatype: string
      description: |
        The identifier of the assumed role session. It is used for uniquely identifying
        a session when the same target role is assumed by different principals or
        for different reasons. The role session name is also used in the ARN of the assumed role principle.

    - name: host
      minimum_version: "2.1.x"
      maximum_version: "2.5.x"
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        The host where the Lambda function is located. This value can point to a
        local Lambda server, allowing for easier debugging.

        Either `aws_region` or `host` must be provided.

    - name: host
      minimum_version: "3.0.x"
      required: false
      default: null
      value_in_examples: null
      datatype: string
      description: |
        The host where the Lambda function is located. This value can point to a
        local Lambda server, allowing for easier debugging.

        To set a region, use the `aws_region` parameter.

    - name: function_name
      required: true
      default: null
      value_in_examples: <LAMBDA_FUNCTION_NAME>
      datatype: string
      description: |
        The AWS Lambda function name to invoke. This may contain
        the function name only (`my-function`), the full ARN
        (arn:aws:lambda:us-west-2:123456789012:function:my-function) or a
        partial ARN (123456789012:function:my-function). You can also append a version
        number or alias to any of the formats.
    - name: qualifier
      required: false
      default: null
      datatype: string
      description: |
        The [`Qualifier`](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#API_Invoke_RequestSyntax) to use when invoking the function.
    - name: invocation_type
      required: true
      default: '`RequestResponse`'
      datatype: string
      description: |
        The [`InvocationType`](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#API_Invoke_RequestSyntax) to use when invoking the function. Available types are `RequestResponse`, `Event`, `DryRun`.
    - name: log_type
      required: true
      default: '`Tail`'
      datatype: string
      description: |
        The [`LogType`](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#API_Invoke_RequestSyntax) to use when invoking the function. By default, `None` and `Tail` are supported.
    - name: timeout
      required: true
      default: '`60000`'
      datatype: number
      description: An optional timeout in milliseconds when invoking the function.
    - name: port
      required: false
      default: '`443`'
      datatype: integer
      description: |
        The TCP port that the plugin uses to connect to the server.
    - name: keepalive
      required: true
      default: '`60000`'
      datatype: number
      description: |
        An optional value in milliseconds that defines how long an idle connection lives before being closed.
    - name: unhandled_status
      required: false
      default: '`200`, `202`, or `204`'
      datatype: integer
      description: |
        The response status code to use (instead of the default `200`, `202`, or `204`) in the case of an
        [`Unhandled` Function Error](https://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#API_Invoke_ResponseSyntax).
    - name: forward_request_body
      required: false
      default: '`false`'
      datatype: boolean
      description: |
        An optional value that defines whether the request body is sent in the `request_body` field of the JSON-encoded request.
        If the body arguments can be parsed, they are sent in the separate `request_body_args` field of the request.
        The body arguments can be parsed for `application/json`, `application/x-www-form-urlencoded`, and `multipart/form-data` content types.
    - name: forward_request_headers
      required: false
      default: '`false`'
      datatype: boolean
      description: |
        An optional value that defines whether the original HTTP request headers are
        sent as a map in the `request_headers` field of the JSON-encoded request.
    - name: forward_request_method
      required: false
      default: '`false`'
      datatype: boolean
      description: |
        An optional value that defines whether the original HTTP request method verb is
        sent in the `request_method` field of the JSON-encoded request.
    - name: forward_request_uri
      required: false
      default: '`false`'
      datatype: boolean
      description: |
        An optional value that defines whether the original HTTP request URI is sent in
        the `request_uri` field of the JSON-encoded request. Request URI arguments (if any) are sent in
        the separate `request_uri_args` field of the JSON body.
    - name: is_proxy_integration
      required: false
      default: '`false`'
      datatype: boolean
      description: |
        An optional value that defines whether the response format to receive from the Lambda to
        [this format](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-output-format).
    - name: awsgateway_compatible
      required: false
      default: '`false`'
      datatype: boolean
      description: |
        An optional value that defines whether the plugin should wrap requests into the Amazon API gateway.
    - name: proxy_url
      required: semi
      default: null
      datatype: string
      value_in_examples: http://my-proxy-server:3128
      description: |
        An optional value that defines whether the plugin should connect through
        the given proxy server URL. Include the request scheme in the URL, which
        must be `http`. For example: `http://my-proxy-server:3128`.

        Kong Gateway uses HTTP tunneling via the [CONNECT HTTP](https://httpwg.org/specs/rfc7231.html#CONNECT)
        method so that no details of the AWS Lambda request are leaked to the proxy server.

    - name: proxy_scheme # deprecated and removed
      maximum_version: "2.8.x"
      required: semi
      default: null
      datatype: string
      description: |

        {:.important}
        > As of Kong Gateway 2.8.0.0, this parameter is deprecated.
        > <br><br>
        > If running Kong Gateway 2.7.x or earlier, the
        `proxy_scheme` value is required if `proxy_url` is defined. In 2.8.x or
        later versions, `proxy_scheme` is not required.

        An optional value that defines which HTTP scheme to use for connecting through the proxy server. The
        supported schemes are `http` and `https`.

    - name: skip_large_bodies
      required: false
      default: '`true`'
      datatype: boolean
      description: |
        An optional value that defines whether Kong should send large
        bodies that are buffered to disk. Note that enabling this option will have an impact
        on system memory depending on the number of requests simultaneously in flight at any given point in time
        and on the maximum size of each request. Also this option blocks all requests being handled by the
        nginx workers. That could be tens of thousands of other transactions that are not being processed. For small I/O
        operations, such a delay would generally not be problematic. In cases where the body size is in the order of MB,
        such a delay would cause notable interruptions in request processing. Given all of the potential
        downsides resulting from enabling this option, consider increasing the
        [client_body_buffer_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size)
        value instead.
    - name: base64_encode_body
      minimum_version: "2.2.x"
      required: false
      default: '`true`'
      datatype: boolean
      description: |
        An optional value that Base64-encodes the request body.
    - name: aws_imds_protocol_version
      minimum_version: "2.8.x"
      required: true
      default: '`v1`'
      datatype: string
      description: |
        Identifier to select the IMDS protocol version to use, either
        `v1` or `v2`. If `v2` is selected, an additional session
        token is requested from the EC2 metadata service by the plugin
        to secure the retrieval of the EC2 instance role. Note that
        if Kong Gateway is running inside a container on an
        EC2 instance, the EC2 instance metadata must be configured
        accordingly. 
        
        Refer to the Considerations section in the
        [Retrieve Instance Metadata section of the EC2 manual](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html)
        for details.
  extra: |
    **Reminder**: By default, cURL sends payloads with an
    `application/x-www-form-urlencoded` MIME type, which will naturally be URL-
    decoded by Kong. To ensure special characters that are likely to appear in
    your AWS key or secret (like `+`) are correctly decoded, you must
    URL-encode them with `--data-urlencode`.
    Alternatives to this approach would be to send your payload with a
    different MIME type (like `application/json`), or to use a different HTTP client.
---

## Sending parameters

Any form parameter sent along with the request is also sent as an
argument to the AWS Lambda function.

---
## Notes

If you provide `aws_key` and `aws_secret`, they will be used in the highest priority to
invoke the Lambda function.

If you do not provide an `aws_key` and `aws_secret`, the plugin uses an IAM role inherited
from the instance running Kong.

{% if_plugin_version lte:2.7.x %}

First, the plugin tries ECS metadata to get the role. If no ECS metadata is available,
the plugin falls back on EC2 metadata.

{% endif_plugin_version %}

{% if_plugin_version gte:2.8.x %}

For example, if you're running Kong on an EC2 instance, the IAM role that attached
to the EC2 will be used, and Kong will fetch the credential from the
[EC2 Instance Metadata service(IMDSv1)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html).
If you're running Kong in an ECS container, the task IAM role will be used, and Kong will fetch the credentials from
the [container credential provider](https://docs.aws.amazon.com/sdkref/latest/guide/feature-container-credentials.html).
Note that the plugin will first try to fetch from ECS metadata to get the role, and if no ECS metadata related environment
variables are available, the plugin falls back on EC2 metadata.

If you also provide the `aws_assume_role_arn` option, the plugin will try to perform
an additional [AssumeRole](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html)
action, which requires the Kong process to make HTTPS request to AWS STS service API, after
configuring AWS access key/secret or fetching credentials automatically from EC2/ECS IAM roles.
If it succeeds, the plugin will fetch a temporary security credentials that represents
that the plugin now has the access permission configured in the target assumed role.

{% endif_plugin_version %}

{% if_plugin_version gte:2.6.x %}
## AWS region as environment variable

If the plugin configuration `aws_region` is unset, the plugin attempts to obtain the
AWS region through environment variables `AWS_REGION` and `AWS_DEFAULT_REGION`,
with the former taking higher precedence. For example, if both `AWS_REGION` and
`AWS_DEFAULT_REGION` are set, the `AWS_REGION` value is used; otherwise, if only
`AWS_DEFAULT_REGION` is set, its value is used. If neither configuration `aws_region`
nor environment variables are set, a run-time error "no region or host specified"
will be thrown.

{% endif_plugin_version %}

{% if_plugin_version lte:2.1.x %}

### Known issues

#### Use a fake upstream service

When using the AWS Lambda plugin, the response will be returned by the plugin
itself without proxying the request to any upstream service. The service
configured for a route is ignored when using this plugin.

Versions of {{site.ce_product_name}} prior to 2.x require a service on all
routes. Even though the service will not be used, you must configure a
placeholder service for routes using this plugin. Versions after 2.x allow you
to omit service configuration.

When using {{site.kic_product_name}}, Kubernetes Ingresses require a service.
Even on {{site.ce_product_name}} versions that support empty services, you must still configure a placeholder service for the Ingress. An [ExternalName
service](https://kubernetes.io/docs/concepts/services-networking/service/#externalname)
for an unresolvable domain (for example, `fake.example`) satisfies this
requirement without requiring a Deployment associated with the service.

#### Response plugins

There is a known limitation in the system that prevents some response plugins
from being executed. We are planning to remove this limitation in the future.

{% endif_plugin_version %}

---
## Usage

Prerequisite: You must have access to the AWS Console as a user who is
allowed to operate with lambda functions, and create users and roles.

1. First, create an execution role called `LambdaExecutor` for your
lambda function.

    In the IAM Console, create a new Role choosing the AWS Lambda service. There
    will be no policies because the function in this example will simply execute
    itself, returning a hardcoded JSON response without accessing other
    AWS resources.

2. Create a user named `KongInvoker`, used by the Kong API gateway
to invoke the function.

    In the IAM Console, create a new user. Programmatic access must be provided to the user via Access and Secret keys. Then, attach existing policies directly, particularly the predefined `AWSLambdaRole`. After the user creation is confirmed, store the Access Key and Secret Key in a safe place.

3. Next, create the lambda function itself in the N. Virginia Region
(code `us-east-1`).

    In Lambda Management, create a new function `MyLambda`. There will be no blueprint because you are going to paste the code below (which is an example code snippet). For the execution role, choose the `LambdaExecutor` created previously.

    **Note**: The following code snippet is only an example. The Kong AWS Lambda plugin supports all runtimes provided by AWS. See the list of runtimes in the **AWS Lambda** > **Functions** > **Create function** dialog.

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

4. Set up a route in Kong and link it to the `MyLambda` function you just created.

{% navtabs %}
{% navtab With a database %}

Create the route:

```bash
curl -i -X POST http://<kong_hostname>:8001/routes \
--data 'name=lambda1' \
--data 'paths[1]=/lambda1'
```

Add the plugin:

```bash
curl -i -X POST http://<kong_hostname>:8001/routes/lambda1/plugins \
--data 'name=aws-lambda' \
--data-urlencode 'config.aws_key={KongInvoker user key}' \
--data-urlencode 'config.aws_secret={KongInvoker user secret}' \
--data 'config.aws_region=us-east-1' \
--data 'config.function_name=MyLambda'
```

{% endnavtab %}
{% navtab Without a database %}

Add a route and plugin to the declarative config file:

``` yaml
routes:
- name: lambda1
  paths: [ "/lambda1" ]

plugins:
- route: lambda1
  name: aws-lambda
  config:
    aws_key: {KongInvoker user key}
    aws_secret: {KongInvoker user secret}
    aws_region: us-east-1
    function_name: MyLambda
```

{% endnavtab %}
{% endnavtabs %}

### Test your Lambda with Kong

After everything is created, make the http request and verify the correct
invocation, execution, and response:

```bash
curl http://<kong_hostname>:8000/lambda1
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

---

## Changelog


**{{site.base_gateway}} 3.2.x**
* Added the configuration parameter `aws_imds_protocol_version`, which
lets you select the IMDS protocol version.
This option defaults to `v1` and can be set to `v2` to enable IMDSv2.
[#9962](https://github.com/Kong/kong/pull/9962)

**{{site.base_gateway}} 3.1.x**
* Added a `requestContext` field into `awsgateway_compatible` input data.
  [#9380](https://github.com/Kong/kong/pull/9380)

**{{site.base_gateway}} 3.0.x**
* The `proxy_scheme` configuration parameter has been removed from the plugin.
* The plugin now allows both `aws_region` and `host` to be set at the same time.

**{{site.base_gateway}} 2.8.x**
* The `proxy_scheme` configuration parameter is deprecated and planned to be
removed in 3.x.x.
* {{site.base_gateway}} 2.8.1.3: Added support for cross account invocation
through configuration properties `aws_assume_role_arn` and `aws_role_session_name`.
* {{site.base_gateway}} 2.8.4.0: Backported the parameter
`aws_imds_protocol_version` into 2.8.x.

**{{site.base_gateway}} 2.7.x**
* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.aws_key` and `config.aws_secret` parameter values will be encrypted.

**{{site.base_gateway}} 2.6.x**
* The AWS region can now be set with the environment variables: `AWS_REGION` or `AWS_DEFAULT_REGION`.

**{{site.base_gateway}} 2.2.x**
* Added support for `isBase64Encoded` flag in Lambda function responses.

**{{site.base_gateway}} 2.1.x**
* Added `host` configuration to allow for custom Lambda endpoints.
