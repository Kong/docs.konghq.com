---
id: page-plugin
title: Plugins - AWS Lambda
header_title: AWS Lambda
header_icon: /assets/images/icons/plugins/aws-lambda.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
  - label: Usage
    items:
      - label: Sending parameters
      - label: Known Issues
---

Invoke an [AWS Lambda](https://aws.amazon.com/lambda/) function from Kong. It can be used in combination with other request plugins to
secure, manage or extend the function.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=aws-lambda" \
    --data "config.aws_key=AWS_KEY" \
    --data "config.aws_secret=AWS_SECRET" \
    --data "config.aws_region=AWS_REGION" \
    --data "config.function_name=LAMBDA_FUNCTION_NAME"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

form parameter                             | default | description
---                                        | ---     | ---
`name`                                     |         | The name of the plugin to use, in this case: `aws-lambda`
`config.aws_key`                           |         | The AWS key credential to be used when invoking the function
`config.aws_secret`                        |         | The AWS secret credential to be used when invoking the function
`config.aws_region`                        |         | The AWS region where the Lambda function is located. Regions supported are: `us-east-1`, `us-east-2`, `ap-northeast-1`, `ap-northeast-2`, `ap-southeast-1`, `ap-southeast-2`, `eu-central-1`, `eu-west-1`
`config.function_name`                     |         | The AWS Lambda function name to invoke
`config.qualifier`<br>*optional*           | ``      | The [`Qualifier`](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#API_Invoke_RequestSyntax) to use when invoking the function.
`config.invocation_type`<br>*optional*     | `RequestResponse` | The [`InvocationType`](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#API_Invoke_RequestSyntax) to use when invoking the function. Available types are `RequestResponse`, `Event`, `DryRun`
`config.log_type`<br>*optional*            | `Tail`  | The [`LogType`](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#API_Invoke_RequestSyntax) to use when invoking the function. By default `None` and `Tail` are supported
`config.timeout`<br>*optional*          | `60000` | An optional timeout in milliseconds when invoking the function
`config.keepalive`<br>*optional*        | `60000` | An optional value in milliseconds that defines for how long an idle connection will live before being closed
----

### Sending parameters

Any form parameter sent along with the request, will be also sent as an argument to the AWS Lambda function.

### Known Issues

#### Use a fake upstream_url

When using the AWS Lambda plugin, the response will be returned by the plugin itself without proxying the request to any upstream service. This means that whatever `upstream_url` has been set on the [API][api-object] it will ultimately never be used.

Although `upstream_url` will never be used, it's currently a mandatory field in Kong's data model, so feel free to set a fake value (ie, `http://nowhere.com`) if you are planning to use this plugin.

In the future we will provide a more intuitive way to deal with similar use-cases.

#### Response plugins

There is a known limitation in the system that prevents some response plugins from being executed. We are planning to remove this limitation
in the future.

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[acl-associating]: /plugins/acl/#associating-consumers
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
