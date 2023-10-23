## Deploy the {{site.kic_product_name}} {#deploy-kic}

1. Add the Kong Helm repo

    ```bash
    helm repo add kong https://charts.konghq.com
    helm repo update
    ```

1. Deploy the {{site.kic_product_name}} using `Helm`:

    ```bash
    helm install kong kong/ingress -n kong --create-namespace
    ```

    The results should look like this:
    
    ```bash
    NAME: kong
    LAST DEPLOYED: Tue Oct  3 15:12:38 2023
    NAMESPACE: kong
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    ```
    
    *Note:* this process could take up to five minutes the first time.

