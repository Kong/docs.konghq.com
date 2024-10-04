
{% if_version lte: 3.1.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.0.x, and then upgrade to 3.1.1.3 or later 3.1.x patches. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, then upgrade to 3.0.x, and then upgrade to 3.1.1.3 or later 3.1.x patches. |
| 2.x–2.7.x | DB-less | No | Upgrade to 2.8.x, and then upgrade to 3.1.1.3 or later 3.1.x patches. |
| 2.8.x | Traditional | Yes | Upgrade to 3.1.1.3 or later 3.1.x patches.|
| 2.8.x | Hybrid | Yes | Upgrade to 3.1.1.3 or later 3.1.x patches. |
| 2.8.x | DB-less | Yes | Upgrade to 3.1.1.3 or later 3.1.x patches. |
| 3.0.x | Traditional | Yes | Upgrade to 3.1.1.3 or later 3.1.x patches.|
| 3.0.x | Hybrid | Yes | Upgrade to 3.1.1.3 or later 3.1.x patches. |
| 3.0.x | DB-less | Yes | Upgrade to 3.1.1.3 or later 3.1.x patches. |

{% endif_version %}

{% if_version eq: 3.2.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.0.x, upgrade to 3.1.x, and then upgrade to 3.2.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, upgrade to 3.0.x, upgrade to 3.1.x, and then upgrade to 3.2.x. |
| 2.x–2.7.x | DB-less | No | Upgrade to 3.0.x, upgrade to 3.1.x, and then upgrade to 3.2.x. |
| 2.8.x | Traditional | No | Upgrade to 3.1.1.3, and then upgrade to 3.2.x. |
| 2.8.x | Hybrid | No | Upgrade to 3.1.1.3, and then upgrade to 3.2.x. |
| 2.8.x | DB-less | No | Upgrade to 3.1.1.3, and then upgrade to 3.2.x. |
| 3.0.x | Traditional | No | Upgrade to 3.1.x, and then upgrade to 3.2.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.1.x, and then upgrade to 3.2.x. |
| 3.0.x | DB-less | No | Upgrade to 3.1.x, and then upgrade to 3.2.x. |
| 3.1.x | Traditional | Yes | Upgrade to 3.2.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | Upgrade to 3.1.1.3, and then upgrade to 3.2.x. |
| 3.1.1.3 | Hybrid | Yes | Upgrade to 3.2.x. |
| 3.1.x | DB-less | Yes | Upgrade to 3.2.x. |

{% endif_version %}

{% if_version eq: 3.3.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 2.x–2.7.x | DB-less | No | Upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 2.8.x | Traditional | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 2.8.x | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 2.8.x | DB-less | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.0.x | Traditional | No | Upgrade to 3.1.x, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.1.x, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.0.x | DB-less | No | Upgrade to 3.1.x, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.1.x | Traditional | No | Upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.1.1.3 | Hybrid | No | Upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.1.x | DB-less | No | Upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.2.x | Traditional | Yes | Upgrade to 3.3.x. |
| 3.2.x | Hybrid | Yes | Upgrade to 3.3.x. |
| 3.2.x | DB-less | Yes | Upgrade to 3.3.x. |

{% endif_version %}

{% if_version eq: 3.4.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 2.x–2.7.x | DB-less | No | Upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 2.8.x | Traditional | Yes | [Directly upgrade to 3.4.x (LTS to LTS upgrade)](/gateway/{{page.release}}/upgrade/lts-upgrade/). |
| 2.8.x | Hybrid | Yes | [Directly upgrade to 3.4.x (LTS to LTS upgrade)](/gateway/{{page.release}}/upgrade/lts-upgrade/) |
| 2.8.x | DB-less | Yes | [Directly upgrade to 3.4.x (LTS to LTS upgrade)](/gateway/{{page.release}}/upgrade/lts-upgrade/) |
| 3.0.x | Traditional | No | Upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 3.0.x | DB-less | No | Upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 3.1.x | Traditional | No | Upgrade to 3.2.x, upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 3.1.1.3 | Hybrid | No | Upgrade to 3.2.x, upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 3.1.x | DB-less | No | Upgrade to 3.2.x, upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 3.2.x | Traditional | No | Upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 3.2.x | Hybrid | No | Upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 3.2.x | DB-less | No | Upgrade to 3.3.x, and then upgrade to 3.4.x. |
| 3.3.x | Traditional | Yes | Upgrade to 3.4.x. |
| 3.3.x | Hybrid | Yes | Upgrade to 3.4.x. |
| 3.3.x | DB-less | Yes | Upgrade to 3.4.x. |

{% endif_version %}

{% if_version eq: 3.5.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 2.x–2.7.x | DB-less | No | Upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 2.8.x | Traditional | No | Upgrade to 3.4.x via [LTS upgrade](/gateway/{{page.release}}/upgrade/lts-upgrade/), and then upgrade to 3.5.x. |
| 2.8.x | Hybrid | No | Upgrade to 3.4.x via [LTS upgrade](/gateway/{{page.release}}/upgrade/lts-upgrade/), and then upgrade to 3.5.x. |
| 2.8.x | DB-less | No | Upgrade to 3.4.x via [LTS upgrade](/gateway/{{page.release}}/upgrade/lts-upgrade/), and then upgrade to 3.5.x. |
| 3.0.x | Traditional | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.0.x | DB-less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.1.x | Traditional | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, upgrade to 3.3.x, upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.1.1.3 | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.1.x | DB-less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.2.x | Traditional | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.2.x | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.2.x | DB-less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.3.x | Traditional | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.3.x | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.3.x | DB-less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.4.x | Traditional | Yes | Upgrade to 3.5.x. |
| 3.4.x | Hybrid | Yes | Upgrade to 3.5.x. |
| 3.4.x | DB-less | Yes | Upgrade to 3.5.x. |

{% endif_version %}

{% if_version eq: 3.6.x %}
| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 2.x–2.7.x | DB-less | No | Upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 2.8.x | Traditional | No | Upgrade to 3.4.x via [LTS upgrade](/gateway/{{page.release}}/upgrade/lts-upgrade/), upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 2.8.x | Hybrid | No | Upgrade to 3.4.x via [LTS upgrade](/gateway/{{page.release}}/upgrade/lts-upgrade/), upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 2.8.x | DB-less | No | Upgrade to 3.4.x via [LTS upgrade](/gateway/{{page.release}}/upgrade/lts-upgrade/), upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.0.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.0.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.1.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, upgrade to 3.3.x, upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.1.1.3 | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.1.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.2.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.2.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.2.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.3.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.3.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.3.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.4.x | Traditional | No | Upgrade to 3.5.x and then upgrade to 3.6.x. |
| 3.4.x | Hybrid | No | Upgrade to 3.5.x and then upgrade to 3.6.x. |
| 3.4.x | DB-less | No | Upgrade to 3.5.x and then upgrade to 3.6.x. |
| 3.5.x | Traditional | Yes | Upgrade to 3.6.x. |
| 3.5.x | Hybrid | Yes | Upgrade to 3.6.x. |
| 3.5.x | DB-less | Yes | Upgrade to 3.6.x. |

{% endif_version %}

{% if_version eq: 3.7.x %}
| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 2.x–2.7.x | DB-less | No | Upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x.|
| 2.8.x | Traditional | No | Upgrade to 3.4.x via [LTS upgrade](/gateway/{{page.release}}/upgrade/lts-upgrade/), upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 2.8.x | Hybrid | No | Upgrade to 3.4.x via [LTS upgrade](/gateway/{{page.release}}/upgrade/lts-upgrade/), upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x.. |
| 2.8.x | DB-less | No | Upgrade to 3.4.x via [LTS upgrade](/gateway/{{page.release}}/upgrade/lts-upgrade/), upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.0.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.0.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.1.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, upgrade to 3.3.x, upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.1.1.3 | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.1.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.2.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.2.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.2.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.3.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.3.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.3.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.4.x | Traditional | No | Upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.4.x | Hybrid | No | Upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.4.x | DB-less | No | Upgrade to 3.5.x, upgrade to 3.6.x, and then upgrade to 3.7.x. |
| 3.5.x | Traditional | No | Upgrade to 3.6.x, then upgrade to 3.7.x. |
| 3.5.x | Hybrid | No | Upgrade to 3.6.x, then upgrade to 3.7.x. |
| 3.5.x | DB-less | No | Upgrade to 3.6.x, then upgrade to 3.7.x. |
| 3.6.x | Traditional | Yes | Upgrade to 3.7.x. |
| 3.6.x | Hybrid | Yes | Upgrade to 3.7.x. |
| 3.6.x | DB-less | Yes | Upgrade to 3.7.x. |

{% endif_version %}

{% if_version eq: 3.8.x %}
| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x,  upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 2.x–2.7.x | DB-less | No | Upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x.|
| 2.8.x | Traditional | No | Upgrade to 3.4.x via [LTS upgrade](/gateway/{{page.release}}/upgrade/lts-upgrade/), upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 2.8.x | Hybrid | No | Upgrade to 3.4.x via [LTS upgrade](/gateway/{{page.release}}/upgrade/lts-upgrade/), upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 2.8.x | DB-less | No | Upgrade to 3.4.x via [LTS upgrade](/gateway/{{page.release}}/upgrade/lts-upgrade/), upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.0.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x,  upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.0.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.1.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, upgrade to 3.3.x, upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.1.1.3 | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.1.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.2.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.2.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.2.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.3.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.3.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.3.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.4.x | Traditional | No | Upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.4.x | Hybrid | No | Upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.4.x | DB-less | No | Upgrade to 3.5.x, upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.5.x | Traditional | No | Upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.5.x | Hybrid | No | Upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.5.x | DB-less | No | Upgrade to 3.6.x, upgrade to 3.7.x, and then upgrade to 3.8.x. |
| 3.6.x | Traditional | Yes | Upgrade to 3.7.x, then upgrade to 3.8.x. |
| 3.6.x | Hybrid | Yes | Upgrade to 3.7.x, then upgrade to 3.8.x.|
| 3.6.x | DB-less | Yes | Upgrade to 3.7.x, then upgrade to 3.8.x. |
| 3.7.x | Traditional | Yes | Upgrade to 3.8.x. |
| 3.7.x | Hybrid | Yes | Upgrade to 3.8.x. |
| 3.7.x | DB-less | Yes | Upgrade to 3.8.x. |

{% endif_version %}