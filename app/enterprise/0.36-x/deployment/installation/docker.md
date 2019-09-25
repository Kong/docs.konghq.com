---
title: How to Install Kong Enterprise with Docker
---

## Introduction

This guide walks through downloading, installing, and start Kong Enterprise
using Docker and either Cassandra or PostgreSQL. The configuration shown in this
guide is intended only as an example -- you will want to modify and take
additional measures to secure your Kong Enterprise system before moving to a 
production environment.


## Prerequisites

To complete this guide you will need:

- Docker
- Bintray credentials
- A valid Kong Enterprise license file


## Step 1. Download Kong Enterprise

1. Obtain your Kong Enterprise License file

    If you do not already have your license file, you can download it from your
    account files in Bintray
    `https://bintray.com/kong/<YOUR_REPO_NAME>/license#files`

    Your **Sales** or **Support** contact will email your Bintray credentials
    to you.

    Ensure your local license file is in proper `JSON`"
    ```json
      {"license":{"signature":"91e6dd9716d12ffsn4a5ckkb16a556dbebdbc4d0a66d9b2c53f8c8d717eb93dd2bdbe2cb3ef51c20806f14345128907da35","payload":{"customer":"Kong Inc","license_creation_date":"2019-05-07","product_subscription":"Kong Enterprise Edition","admin_seats":"5","support_plan":"None","license_expiration_date":"2021-04-01","license_key":"00Q1K00000zuUAwUAM_a1V1K000005kRhuUAE"},"version":1}}
   ```

2. Copy your Bintray API Key

    While logged in to [Bintray](https://bintray.com), copy your Bintray API
    Key. You will need this to pull the docker image in the next step.

    To find your Bintray API key:

    - Navigate to your Bintray profile page by clicking "Edit Profile" in the
    upper right corner.

    - Select "API Key" from the profile sidebar

    - Submit your Bintray password and copy your API key.


3. Pull the Kong Enterprise Docker Image

   To pull the latest Kong Enterprise Docker image, first log in:

   ```
   $ docker login -u <bintray_username> -p <bintray_api_key>
   kong-docker-kong-enterprise-edition-docker.bintray.io
   ```

   Then pull the latest image:

   ```
   $ docker pull kong-docker-kong-enterprise-edition-docker.bintray.io/kong-enterprise-edition
   ``` 


## Step 2. Pull the Docker Image


