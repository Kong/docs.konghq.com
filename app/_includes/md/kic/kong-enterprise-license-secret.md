
### {{site.ee_product_name}} License secret

Enterprise version requires a valid license to run.
As part of sign up for {{site.ee_product_name}}, you should have received a license file.
If you do not have one, please contact your sales representative.
1. Save the license file temporarily to disk with filename `license.json`.
1. Deploy {{site.ee_product_name}} in the `kong` namespace.
   Ensure that you provide the file path where you have stored `license.json` file when you run the command. To deploy {{site.kic_product_name}} in a different namespace, change the value of `-n kong`.

    ```bash
    $ kubectl create secret generic kong-enterprise-license --from-file=license=./license.json -n kong
    ```
    The results should look like this:
    
    ```text
    secret/kong-enterprise-license created
    ```
