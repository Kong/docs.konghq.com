## Changelog

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

**{{site.base_gateway}} 2.7.x**
* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.aws_key` and `config.aws_secret` parameter values will be encrypted.

**{{site.base_gateway}} 2.6.x**
* The AWS region can now be set with the environment variables: `AWS_REGION` or `AWS_DEFAULT_REGION`.

**{{site.base_gateway}} 2.2.x**
* Added support for `isBase64Encoded` flag in Lambda function responses.

**{{site.base_gateway}} 2.1.x**
* Added `host` configuration to allow for custom Lambda endpoints.
