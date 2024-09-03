---
nav_title: AWS ALB Integration
title: AWS ALB Integration
---

AWS has support for mutually authenticating clients that present X509 certificates to Application Load Balancer (ALB). More information: https://aws.amazon.com/blogs/networking-and-content-delivery/introducing-mtls-for-application-load-balancer/

To make sure AWS/ALB works with the header-cert-auth plugin with mTLS enabled we first need to generate the required certificates. For development certificates, you can use OpenSSL to generate certificates or tools such as `mkcert`.

## Add HTTPS listener to the ALB

Configure the ALB by adding an HTTPS listener.

1. In the Listener configuration, configure the following settings:
  * Protocol: HTTPS
  * Port: 443
  * Routing actions: Forward to target groups

2. In the Secure listener settings, configure the certificate from AWS Certificate Manager (ACM). 
Make sure to upload your certificates to ACM and use them in the ALB. 
  * Certificate source: From ACM
  * Certificate (from ACM): Select the certificate that you want to use
  * Client certificate handling: Select Mutual authentication (mTLS) with Passthrough

## Configure Kong Gateway with certs and plugin

Next, configure {{site.base_gateway}}.

1. Add the root CA to the CA certificates:

    ```bash
    curl -sX POST https://localhost:8001/ca_certificates -F cert=@cert.pem
    {
      "tags": null,
      "created_at": 1566597621,
      "cert": "-----BEGIN CERTIFICATE-----\FullPEMOmittedForBrevity==\n-----END CERTIFICATE-----\n",
      "id": "322dce96-d434-4e0d-9038-311b3520f0a3"
    }
    ```

2. Add the Header Cert Auth plugin to the service (or route). 

    * We need to update the `certificate_header_name` to `X-Amzn-Mtls-Clientcert`. 
    * The `certificate_header_format` should be `url_encoded` for AWS/ALB.

    ```bash
    curl -X POST http://localhost:8001/services/{serviceName|Id}/plugins \
      --header "accept: application/json" \
      --header "Content-Type: application/json" \
      --data '
      {
        "name": "header-cert-auth",
        "config": {
          "ca_certificates": [
            "0D769DE8-7CC0-4541-989B-F9C23E20054C"
          ],
          "certificate_header_name": "X-Amzn-Mtls-Clientcert",
          "certificate_header_format": "url_encoded",
          "secure_source": false
        }
      }
    ```

## Validate 

Use the certificate and key to proxy the traffic:

```bash
curl -k --cert <client_certificate> --key <client_key> https://test-alb-<id>.us-east-2.elb.amazonaws.com/test
```

You should then be able to see the certificate in the response headers:

```bash
"X-Amzn-Mtls-Clientcert": "-----BEGIN%20CERTIFICATE-----%0AMIIDbDCCAdSgAwIBAgIUa...-----END%20CERTIFICATE-----"
```
