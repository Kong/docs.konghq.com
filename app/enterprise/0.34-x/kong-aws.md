---
title: Kong Installation - AWS Guide and Best Practices
---

<img src="https://konghq.com/wp-content/uploads/2019/04/image001.jpg">

## Introduction

This document serves as a reference guide for installing Kong and Kong Enterprise on Amazon Web Services (AWS). This guide covers AWS-specific preparation and installation steps for setting up a typical installation of a Kong cluster on AWS with the following functionality and constraints:

- Kong is deployed in a single geographic region
- Multi-AZ AWS services are used wherever possibly to provide redundancy and scalability
- Auto-scaling groups and AWS load balancers are used to simply horizontal scaling of Kong compute resources

We recommend new users familiarize themselves with the [Kong Introduction Documentation](https://docs.konghq.com/1.0.x/getting-started/introduction/) and [5-minute Quickstart Guide](https://docs.konghq.com/1.0.x/getting-started/quickstart/) to understand how Kong operates.

## Installation Prerequisites

Before proceeding with installation, users should be familiar with the following AWS concepts

- [ELB](https://aws.amazon.com/elasticloadbalancing/)
- [Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)
- [PostgreSQL RDS](https://aws.amazon.com/rds/postgresql/)
- [ASG](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html)
- [VPC](https://aws.amazon.com/vpc/)

Users should also be familiar with the following concepts related to installing and running Kong

- [CLI](https://docs.konghq.com/1.0.x/cli/)
- [Configuration file](https://docs.konghq.com/1.0.x/configuration/)
- [Clustering guide](https://docs.konghq.com/1.0.x/clustering/)

Kong Enterprise users should also be familiar with the following concepts and have access to the following data:

- [Kong Enterprise licensing](https://docs.konghq.com/enterprise/0.34-x/getting-started/licensing/)
- [Kong Enterprise configuration](https://docs.konghq.com/enterprise/0.34-x/property-reference/)

## AWS Resource Setup

<img src="https://konghq.com/wp-content/uploads/2019/04/diagram_057_VCP.png">

## Instance Sizing

For Kong, prefer CPU optimized instances. We recommend at least 4 CPU cores, 16GB of RAM and 24GB of disk space. Kong performs better on a system with multiple cores. In an AWS environment, we recommend running `c5.2xlarge` instances in production that guarantee enough cores (8) and memory (16GB).

For PostgreSQL RDS, we recommend modern `db.m5.large` instances to provide ample resources for the backing database.

Kong nodes aggressively cache database configuration to reduce load on the database and minimze latency when processing requests. We recommend monitoring the useage of both Kong nodes and the RDS instance accordingly once exposed to production-level traffic, and adjusting the instance sizes accordingly. We do not recommend using burstable instance types for production traffic.

See the generic [deployment guide](https://docs.konghq.com/enterprise/0.34-x/deployment-guide/) and [architecture overview](https://docs.konghq.com/enterprise/0.34-x/kong-architecture-overview/) for further discussion on Kong resource requirements.

### Load Balancers

Classic elastic load balancers (ELB) should be configured to set the Proxy Protocol header in upstream requests, allowing Kong to properly recognize the client address instead of assuming all requests are sent via the ELB. Note that network load balancers (NLB) use version 2 of the Proxy protocol, which is not yet supported by Kong.

Application load balancers (ALB) can also be used as a load balancer in front of a Kong cluster, but doing so prevents operators from leveraging Kong's ability to handle arbitrary TCP traffic (such as gRPC, Thrift, etc).

### ASG

For fault tolerance, we recommend that auto-scaling groups are configured to launch in multiple availability zones. By registering ASG instances with an ELB, Kong can be scaled horizontally simply by adjusting the size of the scaling group.

### Security Groups

#### Kong Security Group

Following the general steps to create a Security Group, as outlined in the AWS Documentation, perform these steps to create the necessary security groups for Kong instances:

1. Open the Amazon VPC console at https://console.aws.amazon.com/vpc/.

2. In the navigation pane, choose Security Groups.

3. Choose Create Security Group.

4. Enter a name of the security group, such as 'Kong Nodes' and provide a description of your choice.

5. Select the ID of your VPC from the VPC menu.

6. Use the Add Rule button to add the following Inbound rules:

Type - Protocol - Port Range - Source - Description
Custom TCP Rule - TCP - 8000-8003 - <VPC CIDR> - Kong proxy, Admin API, Manager, and Dev Portal (HTTP)
Custom TCP Rule - TCP - 8443-8446 - <VPC CIDR> - Kong proxy, Admin API, Manager, and Dev Portal (HTTPS)

#### RDS Security Group

Following the general steps to create a Security Group, as outlined in the AWS Documentation, perform these steps to create the necessary security groups for the RDS instance:

1. Open the Amazon VPC console at https://console.aws.amazon.com/vpc/.

2. In the navigation pane, choose Security Groups.

3. Choose Create Security Group.

4. Enter a name of the security group, such as 'Kong Nodes' and provide a description of your choice.

5. Select the ID of your VPC from the VPC menu.

6. Use the Add Rule button to add the following Inbound rules:

Type - Protocol - Port Range - Source - Description
Custom TCP - TCP - 5432 - <VPC CIDR> - Postgres access for Kong nodes

### RDS

For fault tolerance, we recommend that PostgreSQL RDS instances are created with multi-AZ availability. Disk encryption for RDS instances is encouraged for sensitive environments, but is not a requirement for running Kong.

## Kong Configuration

## Installation

Refer to the existing generic documentation on [installing Kong](https://konghq.com/install/).

Additional directions on installing Kong Enterprise on AWS Linux can be found [here](https://docs.konghq.com/enterprise/0.34-x/installation/amazon-linux/).

### Proxy protocol

When running Kong behind a load balancer forwarding requests via the Proxy protocol, we recommend configuring Kong to listen for Proxy protocol requests in order to correctly identify the downstream client address. This can be set by defining the `proxy_protocol` stanza of the `proxy_listen` and `admin_listen` directives as outlined in the [configuration reference](https://docs.konghq.com/1.0.x/configuration/#proxy_listen):

```
proxy_listen = 0.0.0.0:8000 proxy_protocol
```

## Automated Deployments

As a template, Kong provides the following resources to automatically deploy Kong resources in AWS:

* Kong + AWS Cloudformation: https://github.com/Kong/kong-dist-cloudformation

## Operations/Maintenance

### Health checks

The health and status of Kong nodes can be checked in multiple ways, including

- The [kong health](https://docs.konghq.com/1.0.x/cli/#kong-health) CLI command
- The [/status](https://docs.konghq.com/1.0.x/admin-api/#retrieve-node-status) Admin API endpoint

The latter can be used in conjunction with [ELB health checks](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-healthchecks.html) to provide seamless integration of health checking Kong with AWS load balancers.

### Data Backups

Kong nodes are stateless compute instances that rely on configuration data present within the database to handle and route request traffic. As such, apart from the configuration file, no data on Kong node disks needs to be backed up.

We recommend that [RDS snapshots](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CreateSnapshot.html) be taken regularly as a database backup mechanism. Additional data duplication techniques, such as PostgreSQL's `pgdump` tool, are useful tools that can be used in conjunction with RDS snapshots to provide a robust data backup strategy.

For additional data assurance, we recommend store the RDS snapshots via S3 or some other data service located outside the geographic region in which the Kong cluster is deployed.

### Service Outage

In the event of a multi-AZ or region-wide failure, the following steps outline a process to recover a Kong cluster:

1. Decide which alternative region to deploy the cluster in

2. Create the re-create VPC, ELB, ASG, and Security Groups.

3. Create a new RDS instance from an existing RDS snapshot.

4. Configure Kong nodes to communicate with the new RDS instance.

5. Update the cluster DNS to point to the ELB CNAME.

This should keep the RPO of the state data to what is offered by the AWS database replication service, and the RTO to mere minutes.

### Recovery Testing

We recommend performing recovery testing on a regular basis. The above guide can be used as a reference to stand up a new Kong cluster (either in a separate AWS region, or the existing production region in a separate VPC) to ensure the efficacy of the database backups.

### Horizontal scaling

We recommend using auto-scaling groups in AWS as the de facto solution for scaling Kong. For further reading, see the section on [scaling Kong](https://docs.konghq.com/enterprise/0.34-x/deployment-guide/#scaling-kong) in the deployment guide.

## Additional Notes

### Billable Services

The following table list the AWS resources used by Kong and states if they are required and billable:

| Service | Required | Billable | Notes |
|------------|----------|----------|-------------------------------------------------------------------------------------------------------------------------------------------|
| EC2 | Yes | Yes | Free tier instance types are not recommended |
| ELB | No | Yes | Load balancers are not strictly required to operate Kong, but are strongly recommended for highly-available and scalable deployments |
| RDS/Aurora | Yes | Yes | Free tier instance types are not recommended |
| ASG | No | No | Auto scaling groups are not strictly required to operate Kong, but are strongly recommended for highly-available and scalable deployments |
| VPC | Yes | No | Only additional services for VPCs, like a NAT Gateway, are billable |

### Cost Model

The open source version of Kong is free to use, fork, develop, and contribute back to the community. We welcome our community members to participate in our [discussion forums](https://discuss.konghq.com/) to keep abreast of developments in Kong.

Kong Enterprise is priced variably based on the size of the enterprise deployment. To learn more, [schedule a Kong Enterprise demo](https://konghq.com/request-demo/).

### Contacting Support

Kong Enterprise users can receive support via the [Enterprise Support Portal](https://support.konghq.com/support/s/).
