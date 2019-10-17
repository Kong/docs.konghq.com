---
title: CentOS
toc: false
---

## Installing Kong Enterprise on CentOS

A quick guide on how to install Kong Enterprise on CentOS.

1. Head over to https://bintray.com/kong/kong-enterprise-edition-rpm
2. Click **Set Me Up** and follow the instructions on the **Download > Resolving RPM packages**
3. Edit the repo file you placed under `/etc/yum.repos.d` to correctly set up your CentOS version (`$releasever` e.g. `6`, `7` etc.), by editing the baseurl field; for instance:

        baseurl=https://<USERNAME>:<API_KEY>@kong.bintray.com/kong-enterprise-edition-rpm/centos/$releasever

**Note**: `<USERNAME>` is obtained from your access key, by appending a `%40kong`
to it (encoded form of `@kong`). For example, if your access key is `bob-company`,
your username will be `bob-company%40kong`.

4. Update YUM's database `yum update`
5. Install Kong and proceed normally from here
