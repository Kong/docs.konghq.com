## Manage keys and Key Sets

For more information, see [Key and Key Set Management in Kong Gateway](/gateway/latest/reference/key-management/).


## Supported Content Encryption Algorithms

Currently, A256GCM is supported. More encryption algorithms will be supported in future releases.


## Failure modes

The following table describes the behavior of this plugin in the event of an error.

| Request message                | Proxied to upstream service? | Response status code |
| --------                       | ---------------------------- |--------------------- |
| Has no JWE with strict=true    | No                           | 403                  |
| Has no JWE with strict=false   | Yes                          | x                    |
| Failed to decode JWE           | No                           | 400                  |
| Failed to decode JWE           | No                           | 400                  |
| Missing mandatory header values| No                           | 400                  |
| References key-set not found   | No                           | 403                  |
| Failed to decrypt              | No                           | 403                  |
