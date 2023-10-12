### {{site.ee_product_name}} License secret

Enterprise version requires a valid license to run.
As part of sign up for {{site.ee_product_name}}, you should have received a license file.
If you do not have one, please contact your sales representative.
Save the license file temporarily to disk with filename `license`
and execute the following:

```bash
$ kubectl create secret generic kong-enterprise-license --from-file=license=./license.json -n kong
secret/kong-enterprise-license created
```

Please note that `-n kong` specifies the namespace in which you are deploying
  the {{site.kic_product_name}}. If you are deploying in a different namespace,
  please change this value.
