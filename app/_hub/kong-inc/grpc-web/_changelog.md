## Changelog

### {{site.base_gateway}} 3.10.x
* Fixed a bug where the `TE` (transfer-encoding) header would not be sent to the upstream gRPC servers when `grpc-web` or `grpc-gateway` were in use.

### {{site.base_gateway}} 2.5.x
* Added support for setting the `Access-Control-Allow-Origin` header.

### {{site.base_gateway}} 2.2.x
* Added the `pass_stripped_path` configuration parameter, which, if set to true, causes the plugin to pass the stripped request path to the upstream gRPC service.
