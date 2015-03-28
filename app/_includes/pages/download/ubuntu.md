### Ubuntu 12.04/14.04

1. Installation:

    Add the right source to APT for Ubuntu 12.04:

    ```bash
    echo "deb [arch=amd64] http://mashape-kong-apt-repo.s3-website-us-east-1.amazonaws.com/ubuntu/12_04/ kong main" >> /etc/apt/sources.list
    ```

    Add the right source to APT for Ubuntu 14.04:

    ```bash
    echo "deb [arch=amd64] http://mashape-kong-apt-repo.s3-website-us-east-1.amazonaws.com/ubuntu/14_04/ kong main" >> /etc/apt/sources.list
    ```

    Then execute:

    ```bash
    apt-get update
    apt-get install kong
    ```

2. Start Kong:

    Before starting Kong, make sure [Cassandra v2.1.3](http://cassandra.apache.org/) is running and [`kong.yml`](/docs/getting-started/configuration/) points to the right Cassandra server. Then execute:

    ```bash
    kong start
    ```

3. Kong is running:

    ```bash
    curl http://127.0.0.1:8001
    ```
