---
nav_title: AWS ALB Integration
title: AWS ALB Integration
---

AWS has support for mutually authenticating clients that present X509 certificates to Application Load Balancer (ALB). More information: https://aws.amazon.com/blogs/networking-and-content-delivery/introducing-mtls-for-application-load-balancer/

To make sure AWS/ALB works with the header-cert-auth plugin with mTLS enabled we first need to generate the required certificates. For development certificates, you can use OpenSSL to generate certificates or tools such as `mkcert`.

First, add an HTTPS listener to the ALB.

1) In the Listener configuration, use HTTPS as the protocol and 443 as the port.

![AWS setup 1](/assets/images/products/plugins/header-cert-auth/header-cert-auth-aws-1.png)

2) In the Secure listener settings, we will configure the certificate from AWS Certificate Manager (ACM). Make sure to upload your certificates to ACM and use them in the ALB. For the Client certificate handling, select Mutual authentication (mTLS).

![AWS setup 2](/assets/images/products/plugins/header-cert-auth/header-cert-auth-aws-2.png)

3) Add the root CA to the CA certificates.

```bash
curl -sX POST https://localhost:8001/ca_certificates -F cert=@cert.pem
{
  "tags": null,
  "created_at": 1566597621,
  "cert": "-----BEGIN CERTIFICATE-----\FullPEMOmittedForBrevity==\n-----END CERTIFICATE-----\n",
  "id": "322dce96-d434-4e0d-9038-311b3520f0a3"
}
```

4) Add the header-cert-auth plugin to the service (or route). We need to update the `certificate_header_name` to `X-Amzn-Mtls-Clientcert`. The `certificate_header_format` should be `url_encoded` for AWS/ALB.

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

5) Then we can use the certificate and key to proxy the traffic.

```bash
curl -k --cert <client_certificate> --key <client_key> https://test-alb-<id>.us-east-2.elb.amazonaws.com/test
```

6) You should then be able to see the certificate in the response headers:

```bash
"X-Amzn-Mtls-Clientcert": "-----BEGIN%20CERTIFICATE-----%0AMIIDbDCCAdSgAwIBAgIUa...-----END%20CERTIFICATE-----"
```
