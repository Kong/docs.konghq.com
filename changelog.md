# Changelog

## Week 38

### [fix: Rename runtime group id to control plane id](https://github.com/Kong/docs.konghq.com/pull/6157) (2023-09-22)

Missed renaming group ID in Konnect API examples in plugins, eg: https://docs.konghq.com/hub/kong-inc/basic-auth/how-to/basic-example/ (switch to konnect api tab).

#### Modified

- https://docs.konghq.com/hub/kong-inc/jq/overview/


### [update insomnia link](https://github.com/Kong/docs.konghq.com/pull/6150) (2023-09-20)

Update Insomnia link on API index site.

#### Modified

- https://docs.konghq.com/konnect/api/


### [chore: Remove link to KIC guide that doesn't exist](https://github.com/Kong/docs.konghq.com/pull/6149) (2023-09-20)

Guide was removed in https://github.com/Kong/docs.konghq.com/pull/6068 but the link to it from the guides overview still remained.

Caught by the broken link checker: https://github.com/Kong/docs.konghq.com/actions/runs/6251198466/job/16971798110#step:12:399

#### Modified

- https://docs.konghq.com/gateway/3.0.x/kong-enterprise/analytics/influx-strategy
- https://docs.konghq.com/gateway/3.1.x/kong-enterprise/analytics/influx-strategy
- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/analytics/influx-strategy
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/analytics/influx-strategy
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/analytics/influx-strategy
- https://docs.konghq.com/kubernetes-ingress-controller/1.0.x/guides/overview
- https://docs.konghq.com/kubernetes-ingress-controller/1.1.x/guides/overview
- https://docs.konghq.com/kubernetes-ingress-controller/1.2.x/guides/overview
- https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/guides/overview
- https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/guides/overview
- https://docs.konghq.com/kubernetes-ingress-controller/2.1.x/guides/overview
- https://docs.konghq.com/kubernetes-ingress-controller/2.2.x/guides/overview


### [Fix: broken links in Konnect docs](https://github.com/Kong/docs.konghq.com/pull/6148) (2023-09-20)

Fixes broken links in the konnect docs found by link checker

#### Modified

- https://docs.konghq.com/konnect/dev-portal/troubleshoot/
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/how-to
- https://docs.konghq.com/konnect/updates


### [chore: Remove composite runtime groups screenshots](https://github.com/Kong/docs.konghq.com/pull/6146) (2023-09-20)

Removing composite runtime groups screenshots. No longer necessary.

#### Modified

- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/conflicts


### [Update: Konnect audit log webhooks only allow HTTPS](https://github.com/Kong/docs.konghq.com/pull/6142) (2023-09-20)

Konnect Audit Webhook Configurations only allow HTTPS endpoints - HTTP endpoint traffic will blocked at network level. Hence, updated docs to reflect same.

#### Modified

- https://docs.konghq.com/konnect/org-management/audit-logging/webhook


### [fix: Configuring a fallback service](https://github.com/Kong/docs.konghq.com/pull/6140) (2023-09-20)

rewrite, tested, validated, and formatting changes.

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/configuring-fallback-service
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/configuring-fallback-service
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/configuring-fallback-service
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/configuring-fallback-service
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/configuring-fallback-service
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/configuring-fallback-service
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/configuring-fallback-service
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/configuring-fallback-service
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/configuring-fallback-service


### [fix(dcr): Note about Azure DCR v1 endpoints](https://github.com/Kong/docs.konghq.com/pull/6126) (2023-09-20)

We wanted to add [a small note](https://kongstrong.slack.com/archives/C05HHGAPYJU/p1695033542245779) about Azure DCR only supporting v1 endpoints.

#### Modified

- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/azure


### [Feat: Konnect Great Rename](https://github.com/Kong/docs.konghq.com/pull/6121) (2023-09-20)

The “runtime” terminology has become overloaded and not meaningful to users. Since the conception of Konnect, users have struggled with understanding the “runtime group” and “runtime instances” terms and how they match up with the gateway topology.

With this rename, kong-ified terms such as “runtime” are replaced with more standardized terminology such as control plane and data plane. As a result, new users to Konnect should have an easier time understanding and navigating the Konnect UI and APIs.

https://konghq.atlassian.net/browse/DOCU-3151

#### Summary of changes

UI:
* Runtime Manager to Gateway Manager
* Runtime group to control plane
* Composite runtime group to control plane group
* Runtime instance to data plane node

API:
* `/v2/systems-accounts` to `/v3/system-accounts`
* `/v2/teams` to `/v3/teams`
* `/v2/users` to `/v3/users`
* `/v2/roles` to `/v3/roles`
* `/v2/runtime-groups` to `/v2/control-planes`
* `/v2/runtime-groups/{runtimeGroupId}/` to `/v2/control-planes/{controlPlaneId}/`
* `/v2/runtime-groups/{runtimeGroupId}/composite-status` to `/v2/control-planes/{controlPlaneId}/group-status`

decK:
* decK command flag: `--konnect-runtime-group-name` to `--konnect-control-plane-name`
* decK state file attribute: `_konnect.runtime_group_name`  to` _konnect.control_plane_name`

#### Added

- https://docs.konghq.com/assets/images/docs/konnect/konnect-control-plane-dashboard.png
- https://docs.konghq.com/assets/images/docs/konnect/konnect-control-plane-group.svg
- https://docs.konghq.com/assets/images/docs/konnect/konnect-control-plane.svg
- https://docs.konghq.com/assets/images/docs/konnect/konnect-control-planes-example.png
- https://docs.konghq.com/assets/images/docs/konnect/konnect-install-options.png
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/conflicts
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/
- https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/migrate
- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/
- https://docs.konghq.com/konnect/gateway-manager/data-plane-nodes/upgrade
- https://docs.konghq.com/konnect/gateway-manager/
- https://docs.konghq.com/konnect/gateway-manager/troubleshoot
- https://docs.konghq.com/konnect/getting-started/configure-data-plane-node

#### Modified

- https://docs.konghq.com/hub/kong-inc/mtls-auth/overview/
- https://docs.konghq.com/deck/1.15.x/3.0-upgrade
- https://docs.konghq.com/deck/1.16.x/3.0-upgrade
- https://docs.konghq.com/deck/1.17.x/3.0-upgrade
- https://docs.konghq.com/deck/1.18.x/3.0-upgrade
- https://docs.konghq.com/deck/1.19.x/3.0-upgrade
- https://docs.konghq.com/deck/1.20.x/3.0-upgrade
- https://docs.konghq.com/deck/1.21.x/3.0-upgrade
- https://docs.konghq.com/deck/1.22.x/3.0-upgrade
- https://docs.konghq.com/deck/1.23.x/3.0-upgrade
- https://docs.konghq.com/deck/1.24.x/3.0-upgrade/
- https://docs.konghq.com/deck/1.25.x/3.0-upgrade/
- https://docs.konghq.com/deck/1.26.x/3.0-upgrade/
- https://docs.konghq.com/deck/1.27.x/3.0-upgrade/
- https://docs.konghq.com/deck/1.12.x/guides/konnect
- https://docs.konghq.com/deck/1.13.x/guides/konnect
- https://docs.konghq.com/deck/1.14.x/guides/konnect
- https://docs.konghq.com/deck/1.15.x/guides/konnect
- https://docs.konghq.com/deck/1.16.x/guides/konnect
- https://docs.konghq.com/deck/1.17.x/guides/konnect
- https://docs.konghq.com/deck/1.18.x/guides/konnect
- https://docs.konghq.com/deck/1.19.x/guides/konnect
- https://docs.konghq.com/deck/1.20.x/guides/konnect
- https://docs.konghq.com/deck/1.21.x/guides/konnect
- https://docs.konghq.com/deck/1.22.x/guides/konnect
- https://docs.konghq.com/deck/1.23.x/guides/konnect
- https://docs.konghq.com/deck/1.24.x/guides/konnect/
- https://docs.konghq.com/deck/1.25.x/guides/konnect/
- https://docs.konghq.com/deck/1.26.x/guides/konnect/
- https://docs.konghq.com/deck/1.27.x/guides/konnect/
- https://docs.konghq.com/deck/1.24.x/reference/deck/
- https://docs.konghq.com/deck/1.25.x/reference/deck/
- https://docs.konghq.com/deck/1.26.x/reference/deck/
- https://docs.konghq.com/deck/1.27.x/reference/deck/
- https://docs.konghq.com/deck/1.10.x/reference/deck_completion
- https://docs.konghq.com/deck/1.11.x/reference/deck_completion
- https://docs.konghq.com/deck/1.12.x/reference/deck_completion
- https://docs.konghq.com/deck/1.13.x/reference/deck_completion
- https://docs.konghq.com/deck/1.14.x/reference/deck_completion
- https://docs.konghq.com/deck/1.15.x/reference/deck_completion
- https://docs.konghq.com/deck/1.16.x/reference/deck_completion
- https://docs.konghq.com/deck/1.17.x/reference/deck_completion
- https://docs.konghq.com/deck/1.18.x/reference/deck_completion
- https://docs.konghq.com/deck/1.19.x/reference/deck_completion
- https://docs.konghq.com/deck/1.20.x/reference/deck_completion
- https://docs.konghq.com/deck/1.21.x/reference/deck_completion
- https://docs.konghq.com/deck/1.22.x/reference/deck_completion
- https://docs.konghq.com/deck/1.23.x/reference/deck_completion
- https://docs.konghq.com/deck/1.24.x/reference/deck_completion/
- https://docs.konghq.com/deck/1.25.x/reference/deck_completion/
- https://docs.konghq.com/deck/1.26.x/reference/deck_completion/
- https://docs.konghq.com/deck/1.27.x/reference/deck_completion/
- https://docs.konghq.com/deck/1.8.x/reference/deck_completion
- https://docs.konghq.com/deck/1.9.x/reference/deck_completion
- https://docs.konghq.com/deck/1.10.x/reference/deck_convert
- https://docs.konghq.com/deck/1.11.x/reference/deck_convert
- https://docs.konghq.com/deck/1.12.x/reference/deck_convert
- https://docs.konghq.com/deck/1.13.x/reference/deck_convert
- https://docs.konghq.com/deck/1.14.x/reference/deck_convert
- https://docs.konghq.com/deck/1.15.x/reference/deck_convert
- https://docs.konghq.com/deck/1.16.x/reference/deck_convert
- https://docs.konghq.com/deck/1.17.x/reference/deck_convert
- https://docs.konghq.com/deck/1.18.x/reference/deck_convert
- https://docs.konghq.com/deck/1.19.x/reference/deck_convert
- https://docs.konghq.com/deck/1.20.x/reference/deck_convert
- https://docs.konghq.com/deck/1.21.x/reference/deck_convert
- https://docs.konghq.com/deck/1.22.x/reference/deck_convert
- https://docs.konghq.com/deck/1.23.x/reference/deck_convert
- https://docs.konghq.com/deck/1.24.x/reference/deck_convert/
- https://docs.konghq.com/deck/1.25.x/reference/deck_convert/
- https://docs.konghq.com/deck/1.26.x/reference/deck_convert/
- https://docs.konghq.com/deck/1.27.x/reference/deck_convert/
- https://docs.konghq.com/deck/1.7.x/reference/deck_convert
- https://docs.konghq.com/deck/1.8.x/reference/deck_convert
- https://docs.konghq.com/deck/1.9.x/reference/deck_convert
- https://docs.konghq.com/deck/1.10.x/reference/deck_diff
- https://docs.konghq.com/deck/1.11.x/reference/deck_diff
- https://docs.konghq.com/deck/1.12.x/reference/deck_diff
- https://docs.konghq.com/deck/1.13.x/reference/deck_diff
- https://docs.konghq.com/deck/1.14.x/reference/deck_diff
- https://docs.konghq.com/deck/1.15.x/reference/deck_diff
- https://docs.konghq.com/deck/1.16.x/reference/deck_diff
- https://docs.konghq.com/deck/1.17.x/reference/deck_diff
- https://docs.konghq.com/deck/1.18.x/reference/deck_diff
- https://docs.konghq.com/deck/1.19.x/reference/deck_diff
- https://docs.konghq.com/deck/1.20.x/reference/deck_diff
- https://docs.konghq.com/deck/1.21.x/reference/deck_diff
- https://docs.konghq.com/deck/1.22.x/reference/deck_diff
- https://docs.konghq.com/deck/1.23.x/reference/deck_diff
- https://docs.konghq.com/deck/1.24.x/reference/deck_diff/
- https://docs.konghq.com/deck/1.25.x/reference/deck_diff/
- https://docs.konghq.com/deck/1.26.x/reference/deck_diff/
- https://docs.konghq.com/deck/1.27.x/reference/deck_diff/
- https://docs.konghq.com/deck/1.7.x/reference/deck_diff
- https://docs.konghq.com/deck/1.8.x/reference/deck_diff
- https://docs.konghq.com/deck/1.9.x/reference/deck_diff
- https://docs.konghq.com/deck/1.10.x/reference/deck_dump
- https://docs.konghq.com/deck/1.11.x/reference/deck_dump
- https://docs.konghq.com/deck/1.12.x/reference/deck_dump
- https://docs.konghq.com/deck/1.13.x/reference/deck_dump
- https://docs.konghq.com/deck/1.14.x/reference/deck_dump
- https://docs.konghq.com/deck/1.15.x/reference/deck_dump
- https://docs.konghq.com/deck/1.16.x/reference/deck_dump
- https://docs.konghq.com/deck/1.17.x/reference/deck_dump
- https://docs.konghq.com/deck/1.18.x/reference/deck_dump
- https://docs.konghq.com/deck/1.19.x/reference/deck_dump
- https://docs.konghq.com/deck/1.20.x/reference/deck_dump
- https://docs.konghq.com/deck/1.21.x/reference/deck_dump
- https://docs.konghq.com/deck/1.22.x/reference/deck_dump
- https://docs.konghq.com/deck/1.23.x/reference/deck_dump
- https://docs.konghq.com/deck/1.24.x/reference/deck_dump/
- https://docs.konghq.com/deck/1.25.x/reference/deck_dump/
- https://docs.konghq.com/deck/1.26.x/reference/deck_dump/
- https://docs.konghq.com/deck/1.27.x/reference/deck_dump/
- https://docs.konghq.com/deck/1.7.x/reference/deck_dump
- https://docs.konghq.com/deck/1.8.x/reference/deck_dump
- https://docs.konghq.com/deck/1.9.x/reference/deck_dump
- https://docs.konghq.com/deck/1.24.x/reference/deck_file/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_add-plugins/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_add-plugins/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_add-plugins/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_add-plugins/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_add-tags/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_add-tags/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_add-tags/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_add-tags/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_list-tags/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_list-tags/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_list-tags/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_list-tags/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_merge/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_merge/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_merge/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_merge/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_openapi2kong/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_openapi2kong/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_openapi2kong/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_openapi2kong/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_patch/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_patch/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_patch/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_patch/
- https://docs.konghq.com/deck/1.24.x/reference/deck_file_remove-tags/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_remove-tags/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_remove-tags/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_remove-tags/
- https://docs.konghq.com/deck/1.25.x/reference/deck_file_render/
- https://docs.konghq.com/deck/1.26.x/reference/deck_file_render/
- https://docs.konghq.com/deck/1.27.x/reference/deck_file_render/
- https://docs.konghq.com/deck/1.10.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.11.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.12.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.13.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.7.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.8.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.9.x/reference/deck_konnect
- https://docs.konghq.com/deck/1.10.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.11.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.12.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.13.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.7.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.8.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.9.x/reference/deck_konnect_diff
- https://docs.konghq.com/deck/1.10.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.11.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.12.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.13.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.7.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.8.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.9.x/reference/deck_konnect_dump
- https://docs.konghq.com/deck/1.10.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.11.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.12.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.13.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.7.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.8.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.9.x/reference/deck_konnect_ping
- https://docs.konghq.com/deck/1.10.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.11.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.12.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.13.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.7.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.8.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.9.x/reference/deck_konnect_sync
- https://docs.konghq.com/deck/1.10.x/reference/deck_ping
- https://docs.konghq.com/deck/1.11.x/reference/deck_ping
- https://docs.konghq.com/deck/1.12.x/reference/deck_ping
- https://docs.konghq.com/deck/1.13.x/reference/deck_ping
- https://docs.konghq.com/deck/1.14.x/reference/deck_ping
- https://docs.konghq.com/deck/1.15.x/reference/deck_ping
- https://docs.konghq.com/deck/1.16.x/reference/deck_ping
- https://docs.konghq.com/deck/1.17.x/reference/deck_ping
- https://docs.konghq.com/deck/1.18.x/reference/deck_ping
- https://docs.konghq.com/deck/1.19.x/reference/deck_ping
- https://docs.konghq.com/deck/1.20.x/reference/deck_ping
- https://docs.konghq.com/deck/1.21.x/reference/deck_ping
- https://docs.konghq.com/deck/1.22.x/reference/deck_ping
- https://docs.konghq.com/deck/1.23.x/reference/deck_ping
- https://docs.konghq.com/deck/1.24.x/reference/deck_ping/
- https://docs.konghq.com/deck/1.25.x/reference/deck_ping/
- https://docs.konghq.com/deck/1.26.x/reference/deck_ping/
- https://docs.konghq.com/deck/1.27.x/reference/deck_ping/
- https://docs.konghq.com/deck/1.7.x/reference/deck_ping
- https://docs.konghq.com/deck/1.8.x/reference/deck_ping
- https://docs.konghq.com/deck/1.9.x/reference/deck_ping
- https://docs.konghq.com/deck/1.10.x/reference/deck_reset
- https://docs.konghq.com/deck/1.11.x/reference/deck_reset
- https://docs.konghq.com/deck/1.12.x/reference/deck_reset
- https://docs.konghq.com/deck/1.13.x/reference/deck_reset
- https://docs.konghq.com/deck/1.14.x/reference/deck_reset
- https://docs.konghq.com/deck/1.15.x/reference/deck_reset
- https://docs.konghq.com/deck/1.16.x/reference/deck_reset
- https://docs.konghq.com/deck/1.17.x/reference/deck_reset
- https://docs.konghq.com/deck/1.18.x/reference/deck_reset
- https://docs.konghq.com/deck/1.19.x/reference/deck_reset
- https://docs.konghq.com/deck/1.20.x/reference/deck_reset
- https://docs.konghq.com/deck/1.21.x/reference/deck_reset
- https://docs.konghq.com/deck/1.22.x/reference/deck_reset
- https://docs.konghq.com/deck/1.23.x/reference/deck_reset
- https://docs.konghq.com/deck/1.24.x/reference/deck_reset/
- https://docs.konghq.com/deck/1.25.x/reference/deck_reset/
- https://docs.konghq.com/deck/1.26.x/reference/deck_reset/
- https://docs.konghq.com/deck/1.27.x/reference/deck_reset/
- https://docs.konghq.com/deck/1.7.x/reference/deck_reset
- https://docs.konghq.com/deck/1.8.x/reference/deck_reset
- https://docs.konghq.com/deck/1.9.x/reference/deck_reset
- https://docs.konghq.com/deck/1.10.x/reference/deck_sync
- https://docs.konghq.com/deck/1.11.x/reference/deck_sync
- https://docs.konghq.com/deck/1.12.x/reference/deck_sync
- https://docs.konghq.com/deck/1.13.x/reference/deck_sync
- https://docs.konghq.com/deck/1.14.x/reference/deck_sync
- https://docs.konghq.com/deck/1.15.x/reference/deck_sync
- https://docs.konghq.com/deck/1.16.x/reference/deck_sync
- https://docs.konghq.com/deck/1.17.x/reference/deck_sync
- https://docs.konghq.com/deck/1.18.x/reference/deck_sync
- https://docs.konghq.com/deck/1.19.x/reference/deck_sync
- https://docs.konghq.com/deck/1.20.x/reference/deck_sync
- https://docs.konghq.com/deck/1.21.x/reference/deck_sync
- https://docs.konghq.com/deck/1.22.x/reference/deck_sync
- https://docs.konghq.com/deck/1.23.x/reference/deck_sync
- https://docs.konghq.com/deck/1.24.x/reference/deck_sync/
- https://docs.konghq.com/deck/1.25.x/reference/deck_sync/
- https://docs.konghq.com/deck/1.26.x/reference/deck_sync/
- https://docs.konghq.com/deck/1.27.x/reference/deck_sync/
- https://docs.konghq.com/deck/1.7.x/reference/deck_sync
- https://docs.konghq.com/deck/1.8.x/reference/deck_sync
- https://docs.konghq.com/deck/1.9.x/reference/deck_sync
- https://docs.konghq.com/deck/1.10.x/reference/deck_validate
- https://docs.konghq.com/deck/1.11.x/reference/deck_validate
- https://docs.konghq.com/deck/1.12.x/reference/deck_validate
- https://docs.konghq.com/deck/1.13.x/reference/deck_validate
- https://docs.konghq.com/deck/1.14.x/reference/deck_validate
- https://docs.konghq.com/deck/1.15.x/reference/deck_validate
- https://docs.konghq.com/deck/1.16.x/reference/deck_validate
- https://docs.konghq.com/deck/1.17.x/reference/deck_validate
- https://docs.konghq.com/deck/1.18.x/reference/deck_validate
- https://docs.konghq.com/deck/1.19.x/reference/deck_validate
- https://docs.konghq.com/deck/1.20.x/reference/deck_validate
- https://docs.konghq.com/deck/1.21.x/reference/deck_validate
- https://docs.konghq.com/deck/1.22.x/reference/deck_validate
- https://docs.konghq.com/deck/1.23.x/reference/deck_validate
- https://docs.konghq.com/deck/1.24.x/reference/deck_validate/
- https://docs.konghq.com/deck/1.25.x/reference/deck_validate/
- https://docs.konghq.com/deck/1.26.x/reference/deck_validate/
- https://docs.konghq.com/deck/1.27.x/reference/deck_validate/
- https://docs.konghq.com/deck/1.7.x/reference/deck_validate
- https://docs.konghq.com/deck/1.8.x/reference/deck_validate
- https://docs.konghq.com/deck/1.9.x/reference/deck_validate
- https://docs.konghq.com/deck/1.10.x/reference/deck_version
- https://docs.konghq.com/deck/1.11.x/reference/deck_version
- https://docs.konghq.com/deck/1.12.x/reference/deck_version
- https://docs.konghq.com/deck/1.13.x/reference/deck_version
- https://docs.konghq.com/deck/1.14.x/reference/deck_version
- https://docs.konghq.com/deck/1.15.x/reference/deck_version
- https://docs.konghq.com/deck/1.16.x/reference/deck_version
- https://docs.konghq.com/deck/1.17.x/reference/deck_version
- https://docs.konghq.com/deck/1.18.x/reference/deck_version
- https://docs.konghq.com/deck/1.19.x/reference/deck_version
- https://docs.konghq.com/deck/1.20.x/reference/deck_version
- https://docs.konghq.com/deck/1.21.x/reference/deck_version
- https://docs.konghq.com/deck/1.22.x/reference/deck_version
- https://docs.konghq.com/deck/1.23.x/reference/deck_version
- https://docs.konghq.com/deck/1.24.x/reference/deck_version/
- https://docs.konghq.com/deck/1.25.x/reference/deck_version/
- https://docs.konghq.com/deck/1.26.x/reference/deck_version/
- https://docs.konghq.com/deck/1.27.x/reference/deck_version/
- https://docs.konghq.com/deck/1.7.x/reference/deck_version
- https://docs.konghq.com/deck/1.8.x/reference/deck_version
- https://docs.konghq.com/deck/1.9.x/reference/deck_version
- https://docs.konghq.com/gateway/3.0.x/install-support
- https://docs.konghq.com/gateway/3.1.x/install-support
- https://docs.konghq.com/gateway/3.1.x/reference/key-management
- https://docs.konghq.com/gateway/3.2.x/reference/key-management
- https://docs.konghq.com/gateway/3.3.x/reference/key-management
- https://docs.konghq.com/gateway/3.4.x/reference/key-management
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/concepts/deployment
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/concepts/deployment
- https://docs.konghq.com/assets/images/docs/konnect/api-products/api-products-overview.png
- https://docs.konghq.com/assets/images/docs/konnect/custom-reports/latency/kong-latency.png
- https://docs.konghq.com/assets/images/docs/konnect/custom-reports/latency/upstream-latency.png
- https://docs.konghq.com/assets/images/docs/konnect/dashboard/konnect-dashboard.png
- https://docs.konghq.com/assets/images/docs/konnect/konnect-intro.png
- https://docs.konghq.com/assets/images/docs/konnect/konnect-runtime-instance-kic.png
- https://docs.konghq.com/assets/images/docs/konnect/konnect-vaults.png
- https://docs.konghq.com/contributing/word-choice
- https://docs.konghq.com/konnect/account-management/
- https://docs.konghq.com/konnect/analytics/
- https://docs.konghq.com/konnect/analytics/reference
- https://docs.konghq.com/konnect/analytics/troubleshoot
- https://docs.konghq.com/konnect/analytics/use-cases/latency
- https://docs.konghq.com/konnect/api-products/
- https://docs.konghq.com/konnect/api/identity-management/identity-integration
- https://docs.konghq.com/konnect/api/
- https://docs.konghq.com/konnect/api/portal-auth/portal-rbac-guide
- https://docs.konghq.com/konnect/api/runtime-groups-config/overview
- https://docs.konghq.com/konnect/architecture
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/azure
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-app-connections
- https://docs.konghq.com/konnect/dev-portal/access-and-approval/manage-teams
- https://docs.konghq.com/konnect/dev-portal/applications/application-overview
- https://docs.konghq.com/konnect/dev-portal/applications/dev-reg-app-service
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/auth0
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/azure
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/curity
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/
- https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/okta
- https://docs.konghq.com/konnect/dev-portal/applications/enable-app-reg
- https://docs.konghq.com/konnect/dev-portal/customization/
- https://docs.konghq.com/konnect/dev-portal/customization/self-hosted-portal
- https://docs.konghq.com/konnect/dev-portal/
- https://docs.konghq.com/konnect/dev-portal/troubleshoot/
- https://docs.konghq.com/konnect/getting-started/access-account
- https://docs.konghq.com/konnect/getting-started/app-registration
- https://docs.konghq.com/konnect/getting-started/deploy-service
- https://docs.konghq.com/konnect/getting-started/import
- https://docs.konghq.com/konnect/getting-started/
- https://docs.konghq.com/konnect/getting-started/productize-service
- https://docs.konghq.com/konnect/
- https://docs.konghq.com/konnect/network-resiliency
- https://docs.konghq.com/konnect/network
- https://docs.konghq.com/konnect/org-management/audit-logging/reference
- https://docs.konghq.com/konnect/org-management/deactivation
- https://docs.konghq.com/konnect/org-management/system-accounts
- https://docs.konghq.com/konnect/org-management/teams-and-roles/
- https://docs.konghq.com/konnect/org-management/teams-and-roles/manage
- https://docs.konghq.com/konnect/org-management/teams-and-roles/roles-reference
- https://docs.konghq.com/konnect/org-management/teams-and-roles/teams-reference
- https://docs.konghq.com/konnect/org-management/users
- https://docs.konghq.com/konnect/reference/labels
- https://docs.konghq.com/konnect/reference/plugins
- https://docs.konghq.com/konnect/servicehub/
- https://docs.konghq.com/konnect/updates
- https://docs.konghq.com/konnect/upgrade-faq


### [Update: Add note about group filtering to Konnect SSO](https://github.com/Kong/docs.konghq.com/pull/6119) (2023-09-20)

Just adding a note to the Konnect SSO doc page about group filtering as it's needed in the rare case where a user in the IdP has over ~150 groups assigned which some IdPs will then not send the groups_claim in a standard manner and prevents successful authentication as a result. Customers need to use group filtering capabilities from the IdP to work effectively in that situation.

Stems from an issue discussed in Kong Support case #00037499.

### Checklist 

- [x] Review label added <!-- (see below) -->
- [x] PR pointed to correct branch (`main` for immediate publishing, or a release branch: e.g. `release/gateway-3.2`, `release/deck-1.17`)

#### Modified

- https://docs.konghq.com/konnect/org-management/oidc-idp


### [[fix] Exposing a TCP Service](https://github.com/Kong/docs.konghq.com/pull/6118) (2023-09-19)

Tested, validated, and formatted.
 
<!-- Include any supporting resources, e.g. link to a Jira ticket, GH issue, FTI, Slack, Aha, etc. -->

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/using-tcpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/using-udpingress
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/using-udpingress
- https://docs.konghq.com/assets/kubernetes-ingress-controller/examples/echo-service.yaml


### [fix(docs): correct the influxdb - gateway startup order](https://github.com/Kong/docs.konghq.com/pull/6103) (2023-09-19)

- Update the startup order and startup InfluxDB before starting up kong-gateway.

- From 3.4.0.0 Kong doesn't release the alpine docker image anymore thus correct the doc.


<!-- What did you change and why? -->
 
<!-- Include any supporting resources, e.g. link to a Jira ticket, GH issue, FTI, Slack, Aha, etc. -->

#### Modified

- https://docs.konghq.com/gateway/3.3.x/breaking-changes/28x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/28x/


### [chore: Add the 2.8.4.3 Gateway changelog](https://github.com/Kong/docs.konghq.com/pull/6029) (2023-09-18)

What did you change and why?

- Added the 2.8.4.3 Gateway changelog and the 2.8.4.3 breaking changes in preparation for the upcoming release.
- Updating AWS Lambda plugin with info related to refactor.
 
Include any supporting resources, e.g. link to a Jira ticket, GH issue, FTI, Slack, Aha, etc.
DOCU-3350

#### Modified

- https://docs.konghq.com/hub/kong-inc/aws-lambda/
- https://docs.konghq.com/hub/kong-inc/aws-lambda/overview/
- https://docs.konghq.com/gateway/3.3.x/breaking-changes/28x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/28x/
- https://docs.konghq.com/gateway/changelog

