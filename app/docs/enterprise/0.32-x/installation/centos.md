---
title: CentOS
class: page-install-method
---

# Installing Kong Enterprise on CentOS

A quick guide on how to install Kong Enterprise on CentOS.

1. Head over to https://bintray.com/kong/kong-enterprise-edition-rpm
2. Click **Set Me Up** and follow the instructions on the **Download > Resolving RPM packages**
3. Edit the repo file you placed under `/etc/yum.repos.d` to correctly set up your CentOS version (`$releasever` e.g. `6`, `7` etc.), by editing the baseurl field; for instance:

        baseurl=https://<USERNAME>:<API_KEY>@kong.bintray.com/kong-enterprise-edition-rpm/centos/$releasever

4. Update YUM's database `yum update`
5. Install Kong and proceed normally from here
