### Installation

Recommended:

```bash
$ luarocks install kong-upstream-jwt
```

Other:

```bash
$ git clone https://github.com/Optum/kong-upstream-jwt.git /path/to/kong/plugins/kong-upstream-jwt
$ cd /path/to/kong/plugins/kong-upstream-jwt
$ luarocks make *.rockspec
```

### Configuration

The plugin requires that Kong's private key be accessible in order to sign the JWT. [We also include the x509 cert in the `x5c` JWT Header for use by API providers to validate the JWT](https://tools.ietf.org/html/rfc7515#section-4.1.6){:target="_blank"}{:rel="noopener noreferrer"}. We access these via Kong's overriding environment variables `KONG_SSL_CERT_KEY` for the private key as well as `KONG_SSL_CERT_DER` for the public key. The first contains the path to your .key file, the second specifies the path to your public key in DER format .cer file.

If not already set, these can be done so as follows:

```bash
$ export KONG_SSL_CERT_KEY="/path/to/kong/ssl/privatekey.key"
$ export KONG_SSL_CERT_DER="/path/to/kong/ssl/kongpublickey.cer"
```

**One last step** is to make the environment variables accessible by a nginx worker. To do this, simply add these line to your _nginx.conf_

```
env KONG_SSL_CERT_KEY;
env KONG_SSL_CERT_DER;
```

### Maintainers

[jeremyjpj0916](https://github.com/jeremyjpj0916){:target="_blank"}{:rel="noopener noreferrer"}  
[rsbrisci](https://github.com/rsbrisci){:target="_blank"}{:rel="noopener noreferrer"}  

Feel free to [open issues](https://github.com/Optum/kong-upstream-jwt/issues){:target="_blank"}{:rel="noopener noreferrer"}, or refer to our [Contribution Guidelines](https://github.com/Optum/kong-upstream-jwt/blob/master/CONTRIBUTING.md){:target="_blank"}{:rel="noopener noreferrer"} if you have any questions.
