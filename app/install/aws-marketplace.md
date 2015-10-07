---
id: page-install-method aws-marketplace
title: Install - AWS Marketplace
header_title: AWS Marketplace
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
links:
  market: "https://aws.amazon.com/marketplace/pp/B014GHERVU"
---

Kong 64-bit Amazon Machine Image (AMI) is available on the AWS Marketplace, with 1-Click Launch, or manually With EC2 Console, APIs or CLI

- [Install Kong with from AWS Marketplace]({{ page.links.market }})

----

### Notes:

1. **Cassandra**:

    The Kong AWS Marketplace AMI image is designed for simplicity and fast deployment, this means it comes bundled with [Cassandra](/about/faq/#how-does-it-work) on the same image.

    For optimal performance, we recommend deploying a Cassandra cluster separately from the Kong Cluster.

    Please refer to the [AWS Cloud Formation Template](/install/aws-cloudformation) for custom deployment of Cassandra and Kong Clusters on AWS.

2. **Scaling**:

    Each EC2 Node is self-contained, running both Kong & Cassandra. In order to add more nodes and start a cluster, you'll have have to turn on [Clustering in Cassandra](/about/faq/#apache-cassandra), and modify each node's [`kong.yml`](https://getkong.org/docs/0.5.x/configuration/#databases_available) with the updated Cassandra information.

3. **Using Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).
