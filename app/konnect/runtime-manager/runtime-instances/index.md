---
title: About Runtime Instances
content_type: explanation
---


A runtime instance is a single self-managed instance of {{site.base_gateway}} that functions as a data plane. In {{site.konnect_saas}}, runtime instances are part of [runtime groups](/konnect/runtime-manager/runtime-groups) and can be used to serve traffic to the runtime group. Runtime groups manage and store configuration in {{site.konnect_saas}}, and runtime instances are configured according to the configuration distributed by the runtime group. 


{{site.konnect_short_name}} provides runtime instance installation scripts for various platforms. These runtime instances are configured to run in your {{site.konnect_short_name}} environment.
You can access these scripts from the {{site.konnect_short_name}} **Runtime Manager**. 

{% include install.html config=site.data.tables.install_options_konnect header='no-header' %}



## More Information

- [Upgrade a Runtime Instance](/konnect/runtime-manager/runtime-instances/upgrade)
- [Renew Certificates](/konnect/runtime-manager/runtime-instances/renew-certificates)
- [Backup and Restore](/konnect/runtime-manager/runtime-groups/manage/#delete-a-runtime-group)
- [Runtime parameter reference](/konnect/runtime-manager/runtime-instances/runtime-parameter-reference)
