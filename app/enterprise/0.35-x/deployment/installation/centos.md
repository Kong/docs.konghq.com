---
title: How to Install Kong Enterprise on CentOS
---

### Introduction

This guide walks through downloading, installing, and starting Kong Enterprise
using CentOS 7 and PostgreSQL 9.5. The configuration shown in this guide is
intended only as an example -- you will want to modify and take additional
measures to secure your Kong Enterprise system before moving to a production
environment.


### Prerequisites

To complete this guide you will need:

- A CentOS 7 system with root equivalent access.
- The ability to SSH to the system.


## Step 1. Download Kong Enterprise

1. Option 1. Download via **Packages**

    - Log in to [Bintray](http://bintray.com) to download the latest Kong 
    Enterprise PRM for CentOS 7. Your **Sales** or **Support** contact will
    email this credential to you.
    
    - Copy the file to your home directory:

    ```
    $ scp kong-enterprise-edition-0.35-1.el7.noarch.rpm <centos user>@192.168.91.109:~
    ```

2. Option 2. Download via **YUM**

    - Edit the `baseurl` field in the yum repository file `/etc/yum.repos.d` :

    ```
    baseurl=https://<USERNAME>:<API_KEY>@kong.bintray.com/kong-enterprise-edition-rpm/centos/$releasever
    ```
    - Replace `<USERNAME>` with your Bintray account information
    - Set `$releasever` to the correct CentOS version (e.g. `6` or `7`)

3. Download your Kong license


## Step 2. Install Kong Enterprise

3. Securely copy the license file to the CentOS system

4. Install Kong Enterprise

5. Copy the license file to the Kong directory


## Step 3. Setup PostgreSQL

1. Install PostgreSQL

2. Initialize the PostgreSQL database

3. State PostgreSQL and enable automatic start


## Step 4. Create a Kong database and user

1. Switch to PostgreSQL user

2. Launch PostgreSQL

3. Run the following command to create a Kong user and database, make Kong the 
owner of the database, and set the password of the Kong user to 'kong'

4. Exit from PostgreSQL

5. Return to the terminal

6. Run the following command to access the PostgreSQL configuration file.

7. Under IPv4 local connections replace `ident` with `md5`


## Step 5. Modify Kong's configuration file

To use the newly provisioned PostgreSQL database, Kong's configuration file
must be modified to accept the correct PostgreSQL user and password.

1. Make a copy of the default configuration file

2. Edit the configuration file


## Step 6. Seed the **Super Admin**


## Step 7. Start Kong


### Next Steps

