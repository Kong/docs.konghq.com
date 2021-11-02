---
title: Kong Security Update Process
---

## Reporting a Vulnerability

If you have found a vulnerability or a potential vulnerability in the Kong gateway or other Kong software, or know of a publicly disclosed security vulnerability, please immediately let us know by emailing [security@konghq.com](mailto:security@konghq.com). We'll send a confirmation email to acknowledge your report, and we'll send an additional email when we've identified the issue positively or negatively.

Once a report is received, we will investigate the vulnerability and assign it a [CVSS](https://www.first.org/cvss/) score which will determine the timeline for the development of an appropriate fix.

While the fix development is underway, we ask that you do not share or publicize an unresolved vulnerability with third parties. If you responsibly submitted a vulnerability report, we will do our best to acknowledge your report in a timely fashion and notify you of the estimated timeline for a fix.

## Fix Development Process

If a discovered vulnerability with a CVSS score above 4.0 (medium severity or higher) affects the latest major release of the Kong gateway or other Kong software, then we will work to develop a fix in the most timely fashion. The work and communication around the fix will happen in private channels, and a delivery estimate will be given to the vulnerability reporter. Once the fix is developed and verified, a new patch version will be released by Kong for each supported Kong Enterprise release and for the current release of the open source gateway. We will disclose the vulnerability as appropriate.

Discovered vulnerabilities with a CVSS score below 4.0 (low severity) will follow the same fix development and release process but with a less urgent timeline.

Vulnerabilities affecting upstream projects (e.g. NGINX, OpenResty, OpenSSL...) will receive fixes as per the upstream project's disclosure timeline.
