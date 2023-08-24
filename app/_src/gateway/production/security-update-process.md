---
title: Kong Vulnerability Patching Process
---

Kong Enterprise Gateway is primarily delivered as [DEB, RPM & APK](/gateway/{{page.kong_version}}/support-policy/#supported-versions) installable artifacts. Strictly as a convenience to customers, Kong also offers Docker images with the artifacts preinstalled.  At the time of release, all artifacts and images are patched, scanned and are free of known vulnerabilities. 

## Types of Vulnerabilities

Generally, there are three types of vulnerabilities:
* In Kong code
* In third-party code that Kong directly links (such as openssl, glibc, libxml2)
* In third-pary code that is part of the convenience Docker image. This code is not part of Kong.

Vulnerabilities reported in Kong code will be assessed by Kong and assigned a CVSS3.0 score. Based on the CVSS score, Kong will produce patches for all applicable Gateway versions currently under support within SLA reproduced below. The SLA clock starts from the day the CVSS score is assigned.

|  CVSS 3.0 Criticality | CVSS 3.0 Score | Resolution SLA |
|---|---|---|
| Critical  | 9.0 - 10.0  |  15 days |
| High  |  7.0 - 8.9 |  30 days |
|  Medium |  4.0 - 6.9 |  90 days |
|  Low |  0.1 - 3.9 | 180 days  |


Vulnerabilities reported in third party code that Kong links directly must have confirmed CVE numbers assigned. Kong will produce patches for all applicable Gateway versions currently under support within SLA reproduced below. The SLA clock for these vulnerabilities starts from the day the upstream (third party) announces availability of patches.  

|  CVSS 3.0 Criticality | CVSS 3.0 Score | Resolution SLA |
|---|---|---|
| Critical  | 9.0 - 10.0  |  15 days |
| High  |  7.0 - 8.9 |  30 days |
|  Medium |  4.0 - 6.9 |  90 days |
|  Low |  0.1 - 3.9 | 180 days  |


Vulnerabilities reported in third party code that is part of the convenience Docker images are only addressed by Kong as part of the regularly scheduled release process. These vulnerabilities are not exploitable during normal Kong operations. Kong always applies all available patches when releasing a docker image, but by definition images accrue vulnerabilities over time. All customers using containers are strongly urged to generate their own images using their secure corporate approved base images. Customers wishing to use the convenience images from Kong should always apply the latest patches for their Gateway version to receive the latest patched container images. Kong does not explicitly address 3rd party vulnerabilities in convenience images outside of the scheduled release mechanism.

## Reporting Vulnerabilities in Kong code

If you are reporting a vulnerability in Kong code, we request you to kindly follow the instructions in the [Kong Vulnerability Disclosure Program](https://konghq.com/compliance/bug-bounty). 

