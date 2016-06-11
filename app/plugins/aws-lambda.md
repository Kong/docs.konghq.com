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
  - label: Documentation
    items:
      - label: Authentication
  - label: Status
    items:
      - label: Working
      - label: ToDo
---

Easily expose AWS Lambda functions as REST-ful API endpoints, without requiring AWS SDK or request signing of any sort on the client.

----

## Configuration
> NOTE: This plugin is designed only for APIs that have an `aws-lambda` `upstream_url` scheme `aws-lambda://\<aws_region\>/\<function_name\>`. This is intended to better reflect the dependency of this API on the aws-lambda plugin. In other words, without adding the plugin, this API will be non-functional, as the request will not be properly signed or otherwise formatted for AWS Lambda function invocation.

Add your API with a compatible `upstream_url`:

```bash
$ curl -X POST http://kong:8001/apis \
    --data "name=aws-lambda-test" \
    --data "request_path=/aws-lambda-test" \
    --data "upstream_url=aws-lambda://us-east-1/kongLambdaTest"
```

You can configure and enable the plugin for your [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/aws-lambda-test/plugins \
    --data "name=aws-lambda" \
    --data "config.aws_access_key=AKIAIDPNYYGMJOXN26SQ" \
    --data "config.aws_secret_key=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" \
    --data 'config.body={"key1":"foo","key2":"bar","key3":"baz"}'
```

The parameters follow those outlined by AWS for Lamba's invoke-function as outlined in http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                        | description
---:                                  | ---
`name`                                | Name of the plugin to use, in this case: `aws-lambda`
`config.aws_access_key`<br>*optional* | AWS Access Key authorized to call the Lambda function, expects a string (e.g. `AKIAIDPNYYGMJOXN26SQ`).
`config.aws_secret_key`<br>*optional* | AWS Secret Key authorized to call the Lambda function, expects a string (e.g. `toq1QWn7b5aystpA/Ly48OkvX3N4pODRLEC9wINw`).
`config.body`<br>*optional*           | Payload as JSON string to be passed to the Lambda function. Defaults to `{}`. Any querystring and body parameters will be merged into this body.

----

## Authentication
AWS IAM Credentials must be provided to this plugin one of the following three ways:
1. *HTTP Basic Authentication* An AWS IAM Access Key and Secret Key can be used as the Basic base64(username:password) value in the Authorization header of the HTTP request to the API. This will be decoded by the plugin and used for invoking the Lambda.
1. *Configuration* An AWS IAM Access Key and Secret Key can be provided in the plugin via config.aws_access_key and config.aws_secret_key. Eventually this should be possible to include in the api''s upstream_url, but this is a future enhancement.
1. *IAM Role on EC2* If the Kong node processing this request is a member of an IAM role, the plugin will use this role for invoking the Lambda.
These will be attempted in the priority order listed above and the first wins. E.g. if an api has IAM credentials in the aws-lambda plugin config, and the Kong node processing the request is a member of an IAM role, and the request headers contain an Authorization header, the Authorization header will be decoded for the IAM credential and the other two credentials will be ignored.

----

## Status
### Working
- Add plugin to api
- Specify IAM credentials in Authorization Basic header of api to lambda
- Specify region, function name, in aws-lambda://\<region>/\<function_name> api upstream_url
- Specify body in config
- Return response value
- Return appropriate error response on request if api.upstream_url is *not* aws-lambda://region/func
- Merging of query parameters from api to lambda payload
- Merging of body from api to lambda
- Error handling
- Supports for IAM Instance Role authentication

### ToDo
- Allow sepecifying qualifier, invocation type, log type and client context declaratively in aws-lambda schemed upstream_url of parent api
- Add support for logging?
- Add support for client context?
- Add support for qualifier
- Rewrite as *pure* nginx request to aws-lambda (i.e. without capturing and/or making origin request via resty) -- is this possible?
- Add support for other invocation types? (does this even make sense?)
