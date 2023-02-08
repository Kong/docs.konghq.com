---
name: AppDynamics
publisher: Kong Inc.
desc: Integrate Kong with the AppDynamics APM Platform
description: |
  This plugin integrates Kong with the AppDynamics APM platform so that
  proxy requests handled by Kong can be identified and analyzed in
  AppDynamics. The plugin reports request and response timestamps and error information to the AppDynamics platform to
  be analyzed in the AppDynamics flow map and correlated with other
  systems participating in handling application API requests.
  
  ## Prerequisites

  Before using the plugin, download and install the [AppDynamics C/C++ Application Agent and SDK](https://docs.appdynamics.com/pages/viewpage.action?pageId=42583435) on the machine or within the container running Kong Gateway. 

  ### Platform support
  
  The AppDynamics C SDK supports Linux distributions based on glibc 2.5+. MUSL-based distributions like the Alpine distribution, which is popular for container usage, are not supported. Kong Gateway must be running on a glibc-based distribution like RHEL, CentOS, Debian, or Ubuntu to support this plugin. 
  
  See the [AppDynamics C/C++ SDK Supported Environments](https://docs.appdynamics.com/appd/21.x/21.12/en/application-monitoring/install-app-server-agents/c-c++-sdk/c-c++-sdk-supported-environments) document for more information.

enterprise: true
type: plugin
categories:
  - analytics-monitoring
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
---
