# Changelog



<!--vale off-->
## Week 38


### [Update: Konnect audit log webhooks only allow HTTPS](https://github.com/Kong/docs.konghq.com/pull/6142) (2023-09-20)

Konnect Audit Webhook Configurations only allow HTTPS endpoints - HTTP endpoint traffic will blocked at network level. Hence, updated docs to reflect same.

#### Modified

- https://docs.konghq.com/konnect/org-management/audit-logging/webhook


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

#### Modified

- https://docs.konghq.com/konnect/org-management/oidc-idp



### [fix(docs): correct the influxdb - gateway startup order](https://github.com/Kong/docs.konghq.com/pull/6103) (2023-09-19)

- Update the startup order and startup InfluxDB before starting up kong-gateway.

- From 3.4.0.0 Kong doesn't release the alpine docker image anymore thus correct the doc.


#### Modified

- https://docs.konghq.com/gateway/3.3.x/breaking-changes/28x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/28x/


### [chore: Add the 2.8.4.3 Gateway changelog](https://github.com/Kong/docs.konghq.com/pull/6029) (2023-09-18)

What did you change and why?

- Added the 2.8.4.3 Gateway changelog and the 2.8.4.3 breaking changes in preparation for the upcoming release.
- Updating AWS Lambda plugin with info related to refactor.
 


#### Modified

- https://docs.konghq.com/hub/kong-inc/aws-lambda/
- https://docs.konghq.com/hub/kong-inc/aws-lambda/overview/
- https://docs.konghq.com/gateway/3.3.x/breaking-changes/28x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/28x/
- https://docs.konghq.com/gateway/changelog



## Week 37

### [Update(plugins): GraphQL Introspection endpoint related note](https://github.com/Kong/docs.konghq.com/pull/6090) (2023-09-12)

GraphQL Introspection endpoint will only be read from the Kong service (`service = ngx.ctx.service`) instead of reading from a specific variable or ingress - local.

Documenting this behavior so consumers are aware of how to configure correctly and know about the limitation.

#### Modified

- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/overview/


### [[Fix]- KIC: Setting up Active and Passive health checks guide](https://github.com/Kong/docs.konghq.com/pull/6081) (2023-09-11)
 
Revised and rewrote the guide after validating.

#### Modified

- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/cp-outage-handling
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/cp-outage-handling
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/cp-outage-handling


### [fix missing keyword config in curl data](https://github.com/Kong/docs.konghq.com/pull/6075) (2023-09-12)

To enable grpc-web plugin via Admin API, the keywork `config` in curl data is missing.

#### Modified

- https://docs.konghq.com/hub/kong-inc/grpc-web/how-to/


### [fix: remove unsupported KIC feature](https://github.com/Kong/docs.konghq.com/pull/6068) (2023-09-11)

Remove the custom entities guide from KIC 2.x pages.

This feature was never actually supported in 2.x, and we removed the leftover flag [in 2.9](https://github.com/Kong/kubernetes-ingress-controller/pull/3262). In earlier 2.x versions, the flag was available but did not work.


## Week 36

### [chore: Split the gateway changelogs to archive changelogs for sunset versions](https://github.com/Kong/docs.konghq.com/pull/6073) (2023-09-08)

Our Gateway changelog page is massive. This is a problem for everyone involved:
* Bad page load times/performance
* Difficult to edit
* Lots of unnecessary info
* Documenting versions that we don't support
* And the most recent discovery, a not-insignificant chunk of our Algolia records

From now on, we will be archiving old changelogs at the same time we archive old versions of our docs. You can find the changelogs at https://legacy-gateway--kongdocs.netlify.app/enterprise/changelog/.

#### Modified

- https://docs.konghq.com/gateway/changelog


### [Post-launch tidy of Konnect API overview page + nav](https://github.com/Kong/docs.konghq.com/pull/6067) (2023-09-07)
 
Update links to api specs in overview page to reference evergreen links, repeat spec description from devportal description field, update nav links to consistently refer to API spec and use evergreen links.

#### Modified

- https://docs.konghq.com/konnect/api/


### [update urls to latest and remove mention of dev portal](https://github.com/Kong/docs.konghq.com/pull/6066) (2023-09-06)

Update urls to latest for gateway APIs.

Remove mention of dev portal from API announcement banner.

#### Modified

- https://docs.konghq.com/konnect/api/


### [Fix(plugin scopes): Consumer groups scope and application registration plugin](https://github.com/Kong/docs.konghq.com/pull/6059) (2023-09-05)

The [scopes compatibility table](https://docs.konghq.com/hub/plugins/compatibility/#scopes) was missing a column for consumer groups. This update enables generating the column and all entries from the plugins' schemas.

Additionally, the Application Registration plugin was listed as incompatible with all scopes, which is wrong - it's compatible with services only. Turns out we were selecting for the wrong key. Fixing this also fixes the display of the plugin's [config](https://docs.konghq.com/hub/kong-inc/application-registration/configuration/) and [basic examples](https://docs.konghq.com/hub/kong-inc/application-registration/how-to/basic-example/), which were both missing services.

#### Modified

- https://docs.konghq.com/hub/plugins/compatibility/


### [(fix) remove note about cloud launcher support ](https://github.com/Kong/docs.konghq.com/pull/6057) (2023-09-06)

Existing note was incorrect and causing confusion. 
https://kongstrong.slack.com/archives/CQK8J4VN3/p1693903551408579

#### Modified

- https://docs.konghq.com/konnect/runtime-manager/runtime-instances/upgrade


### [Fix "supported-router-flavors" typos](https://github.com/Kong/docs.konghq.com/pull/6056) (2023-09-05)

This change fixes small typos in the documentation.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.1.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.2.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.3.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.4.x/install/linux/ubuntu


### [Salt plugin: add konnect and update version compatibility](https://github.com/Kong/docs.konghq.com/pull/6050) (2023-09-05)

Updating for Konnect compatibility & Kong version support
taking colleagues work and putting into PR on main for Kong's docs repo

#### Modified

- https://docs.konghq.com/hub/salt/salt/_metadata.yml


### [feat: Split serverless plugins into their own pages](https://github.com/Kong/docs.konghq.com/pull/6047) (2023-09-08)

We currently document one entry for [Serverless Functions](https://docs.konghq.com/hub/kong-inc/serverless-functions/), but it’s actually two plugins: `pre-function` and `post-function`. When searching for docs, users look for one of those names, not for Serverless Function. The UI also has them as two separate plugins, so one docs entry doesn't make sense.

This PR aims to solve that by splitting Serverless Functions into Post-function and Pre-function plugins. 
* For the titles of the plugins, used the names from the Konnect and Kong Manager UIs: Kong Functions (Pre-Plugins) and Kong Functions (Post-Plugins).
* You can still search for these plugins by the term "serverless" and by their real names (post- and pre-function)
* Split out the how-to guide for the pre-function plugin into its own topic
* For the post-function plugin, wrote a how-to guide based on a KB: https://support.konghq.com/support/s/article/How-can-the-latency-and-rate-limit-plugin-header-names-be-changed
* For both plugins, also added short guide on running the plugins in multiple phases based on yet another KB: https://support.konghq.com/support/s/article/Is-it-possible-to-run-serverless-plugins-in-phases-other-than-the-access-phase

https://konghq.atlassian.net/browse/DOCU-3434

#### Added

- https://docs.konghq.com/hub/kong-inc/post-function/
- https://docs.konghq.com/hub/kong-inc/post-function/how-to/
- https://docs.konghq.com/hub/kong-inc/post-function/how-to/
- https://docs.konghq.com/hub/kong-inc/post-function/overview/
- https://docs.konghq.com/hub/kong-inc/pre-function/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/pre-function/how-to/
- https://docs.konghq.com/hub/kong-inc/pre-function/how-to/
- https://docs.konghq.com/hub/kong-inc/pre-function/overview/
- https://docs.konghq.com/hub/kong-inc/pre-function/versions.yml
- https://docs.konghq.com/assets/images/icons/hub/kong-inc_pre-function.png

#### Modified

- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/overview/
- https://docs.konghq.com/hub/kong-inc/request-transformer/overview/
- https://docs.konghq.com/gateway/3.3.x/breaking-changes/30x
- https://docs.konghq.com/gateway/3.4.x/breaking-changes/30x/
- https://docs.konghq.com/gateway/3.0.x/upgrade/
- https://docs.konghq.com/gateway/changelog
- https://docs.konghq.com/konnect/updates


### [[Fix] KIC guides](https://github.com/Kong/docs.konghq.com/pull/6043) (2023-09-06)

Update existing Kong Ingress Controller guides for consistency and readability. Audit that all guides work as intended by copy/pasting the instructions.

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/deployment/minikube
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/faq
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/configure-acl-plugin
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/getting-started
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/using-consumer-credential-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.3.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.4.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/guides/using-kongplugin-resource
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/guides/using-kongplugin-resource
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
- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/support-policy
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/support-policy


### [fix: change go-apiops to deck file in deck_file_remove-tags.md](https://github.com/Kong/docs.konghq.com/pull/6037) (2023-09-06)

go-apiops cli is built for testing purposes. End users are encumbered to use this utility through deck file command

I changed `go-apiops` cli example to `deck file`. As mentioned in [go-apiops repository](https://github.com/Kong/go-apiops)
> Currently, the functionality is released as a library and as part of the [decK](https://github.com/Kong/deck) CLI tool. The 
> repository also contains a CLI named go-apiops **for local testing**. For general CLI usage, prefer the decK tool [docs](https://docs.konghq.com/deck/latest/) tool.

 `go-apiops` is used for testing and deck is encouraged for general usage.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.1.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.2.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.3.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.4.x/install/linux/ubuntu


### [Feat: Plugin hub nested overviews](https://github.com/Kong/docs.konghq.com/pull/6027) (2023-09-05)
 
Add the ability to nest overview pages to plugins, they work in the same way as the `how-tos`.
Add redirects, so that existing URLs redirect to `/overview/`.
Add `nav_title: Introduction` to existing pages.

#### Modified

- https://docs.konghq.com/hub/kong-inc/acl/how-to/
- https://docs.konghq.com/hub/kong-inc/acme/how-to/
- https://docs.konghq.com/hub/kong-inc/acme/how-to/
- https://docs.konghq.com/hub/kong-inc/acme/how-to/
- https://docs.konghq.com/hub/kong-inc/application-registration/how-to/
- https://docs.konghq.com/hub/kong-inc/graphql-proxy-cache-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/graphql-rate-limiting-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/grpc-gateway/how-to/
- https://docs.konghq.com/hub/kong-inc/grpc-web/how-to/
- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer/how-to/
- https://docs.konghq.com/hub/kong-inc/request-transformer/how-to/


### [Adds documentation for the Filter Chain entity available in Kong Gateway 3.4 ](https://github.com/Kong/docs.konghq.com/pull/6011) (2023-09-05)

Adds documentation for the Filter Chain entity available in Kong Gateway 3.4 when WebAssembly support is enabled.

#### Modified

- https://docs.konghq.com/gateway/3.4.x/kong-manager-oss/troubleshoot/
- https://docs.konghq.com/mesh/1.7.x/features/windows
- https://docs.konghq.com/mesh/1.8.x/features/windows
- https://docs.konghq.com/mesh/1.9.x/features/windows
- https://docs.konghq.com/mesh/2.0.x/features/windows
- https://docs.konghq.com/mesh/2.1.x/features/windows


## Week 35

### [Add info about how IP address is determined for IP Restriction plugin](https://github.com/Kong/docs.konghq.com/pull/6046) (2023-08-31)

Added a blurb about how the IP Address is determined when using the IP Restriction plugin, as this was confusing customers who were unaware of the appropriate settings that needed to be tweaked for their environment so the IP could be determined accurately.

#### Modified

- https://docs.konghq.com/hub/kong-inc/ip-restriction/


### [Added info about limiting by IP address](https://github.com/Kong/docs.konghq.com/pull/6045) (2023-08-31)

We were missing details about how the IP address was determined when customers want to limit by IP address. Added these details to clarify how this works and linked to other sources for the appropriate properties that need to be set.

#### Modified

- https://docs.konghq.com/hub/kong-inc/rate-limiting/


### [Updated RLA index page to share some details from RL plugin](https://github.com/Kong/docs.konghq.com/pull/6044) (2023-08-31)

There were some missing details from the RL (Rate Limiting) plugin which I pasted into the RLA (Rate Limiting Advanced) plugin index page, including extra details about the strategies that can be used and the use-cases for each.

Also added a section for how the IP address is determined as this was missing from the details and was not obvious to customers how this worked when limiting by IP address.

#### Modified

- https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/


### [Update index.md](https://github.com/Kong/docs.konghq.com/pull/6042) (2023-08-31)

Fixed spelling mistake and commas

- Fixed spelling error: changed confict to conflict.
- Added commas

#### Modified

- https://docs.konghq.com/konnect/runtime-manager/composite-runtime-groups/


### [fix: Update OSS install instructions for Kong Manager](https://github.com/Kong/docs.konghq.com/pull/6040) (2023-08-31)

Our OSS install instructions (specifically Docker and I found some Linux ones as well) that still said that KM wasn't for OSS even though it is. I fixed those spots.

DOCU-3445

#### Modified

- https://docs.konghq.com/gateway/3.4.x/kong-manager-oss/troubleshoot/


### [chore(deps): update docs from repo source](https://github.com/Kong/docs.konghq.com/pull/6036) (2023-08-31)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/6034676360)

#### Modified

- https://docs.konghq.com/mesh/2.4.x/kuma-cp.yaml
- https://docs.konghq.com/mesh/dev/kuma-cp.yaml
- https://docs.konghq.com/mesh/raw/CHANGELOG


### [Update: Add link to changelog entry for Kong Manager OSS](https://github.com/Kong/docs.konghq.com/pull/6034) (2023-08-29)

Add link to https://docs.konghq.com/gateway/latest/kong-manager-oss/ in the feature annoucement

#### Modified

- https://docs.konghq.com/gateway/changelog


### [(Fix) Cross-ref CP-DP communication through forward proxy in Konnect docs](https://github.com/Kong/docs.konghq.com/pull/6028) (2023-08-29)

You can now find cross-reference to the "Control Plane and Data Plane Communication through a Forward Proxy" page in the "Konnect Ports and Networking Requirements" page.

Updated based on Slack feedback [here](https://kongstrong.slack.com/archives/C02CWN8C7DK/p1693260752247129). 

#### Modified

- https://docs.konghq.com/konnect/network


### [kic: update `CombinedServices` feature gate default for 2.11](https://github.com/Kong/docs.konghq.com/pull/6026) (2023-08-30)

Update `CombinedServices` feature gate default for 2.11 as it was made in https://github.com/Kong/kubernetes-ingress-controller/pull/4138

#### Modified

- https://docs.konghq.com/gateway/3.4.x/reference/wasm


### [chore(deps): bump kumahq/kuma-website from c530a7a4 to 045ff986](https://github.com/Kong/docs.konghq.com/pull/6024) (2023-08-30)

Auto upgrade PR log:

045ff9868acdb4b322759dde3f8053f41948100f feat: extend kubernetes perf tuning section (kumahq/kuma-website#1444)
cac5fd764b722ee64e1be31f26d9d006d9cf1574 fix(annotations): remove reference to injection annotation (kumahq/kuma-website#1450)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/6018914319).

#### Modified

- https://docs.konghq.com/gateway/3.4.x/kong-manager-oss/troubleshoot/


### [Edited the CP outage handling doc to add emphasis to environment variables](https://github.com/Kong/docs.konghq.com/pull/6022) (2023-08-28)

Corrected some wording and bolded the "import" and "export" portions in the environment variables as customers are often seeing these are the same variables without realizing they're different between export and import.

Reverted the bolding after I realized it didn't load correctly in the preview. Overall the final change is just a mild correction to a wrongly formatted sentence from earlier.

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.1.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.2.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.3.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.4.x/install/linux/ubuntu


### [Add if_versions tags so windows support does not show up in KM v2.4](https://github.com/Kong/docs.konghq.com/pull/6021) (2023-08-29)

Remove Windows support from KM 2.4 onwards

#### Modified

- https://docs.konghq.com/gateway/3.4.x/reference/wasm
- https://docs.konghq.com/mesh/1.7.x/features/windows
- https://docs.konghq.com/mesh/1.8.x/features/windows
- https://docs.konghq.com/mesh/1.9.x/features/windows
- https://docs.konghq.com/mesh/2.0.x/features/windows
- https://docs.konghq.com/mesh/2.1.x/features/windows
- https://docs.konghq.com/mesh/1.7.x/gettingstarted
- https://docs.konghq.com/mesh/1.8.x/gettingstarted
- https://docs.konghq.com/mesh/1.9.x/gettingstarted
- https://docs.konghq.com/mesh/2.0.x/gettingstarted
- https://docs.konghq.com/mesh/2.1.x/gettingstarted
- https://docs.konghq.com/mesh/2.0.x/install/
- https://docs.konghq.com/mesh/2.1.x/install/
- https://docs.konghq.com/mesh/1.7.x/installation/windows
- https://docs.konghq.com/mesh/1.8.x/installation/windows
- https://docs.konghq.com/mesh/1.9.x/installation/windows
- https://docs.konghq.com/mesh/2.0.x/installation/windows
- https://docs.konghq.com/mesh/2.1.x/installation/windows


### [chore(deps): bump kumahq/kuma-website from 2064c900 to 707fb928](https://github.com/Kong/docs.konghq.com/pull/6012) (2023-08-28)

Auto upgrade PR log:

707fb928c63b3d4cc57628ecfb8f53845b4ab314 fix(MeshGateway): fix typo on example tags table (kumahq/kuma-website#1442)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/5994030906).

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/debian
- https://docs.konghq.com/gateway/3.1.x/install/linux/debian
- https://docs.konghq.com/gateway/3.2.x/install/linux/debian
- https://docs.konghq.com/gateway/3.3.x/install/linux/debian
- https://docs.konghq.com/gateway/3.4.x/install/linux/debian


### [feat(pre-built-reports): added changelog entry and an intro sentence](https://github.com/Kong/docs.konghq.com/pull/6009) (2023-08-28)

Added a changelog item to release our pre-built reports feature ([Aha ticket](https://konghq.aha.io/features/KP-204)) and an intro sentence into the Analytics section inside the Konnect intro chapter. This feature is rather small and is only for new organization. Therefore, I think we don't need a lot of docs changes.

[Here](https://docs.google.com/spreadsheets/d/1QnwrHOjR-K-H5w9FQAWltNvq_H0OF8vv-y19o-5CtD0/edit#gid=0) is a list of the pre-built reports we deploy for all new organizations.

#### Modified

- https://docs.konghq.com/konnect/
- https://docs.konghq.com/konnect/updates


### [chore(deps): update docs from repo source](https://github.com/Kong/docs.konghq.com/pull/6003) (2023-08-29)

Syncing docs from source code.

Generated by [action](https://github.com/Kong/kong-mesh/actions/runs/6009565670)

#### Added

- https://docs.konghq.com/mesh/2.4.x/crds/access-audit.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/access-role-binding.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/access-role.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_circuitbreakers.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_containerpatches.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_dataplaneinsights.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_dataplanes.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_externalservices.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_faultinjections.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_healthchecks.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshaccesslogs.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshcircuitbreakers.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshes.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshfaultinjections.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshgatewayconfigs.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshgatewayinstances.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshgatewayroutes.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshgateways.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshglobalratelimits.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshhealthchecks.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshhttproutes.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshinsights.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshloadbalancingstrategies.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshopas.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshproxypatches.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshretries.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshtcproutes.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshtimeouts.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshtraces.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_meshtrafficpermissions.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_proxytemplates.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_ratelimits.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_retries.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_serviceinsights.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_timeouts.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_trafficlogs.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_trafficpermissions.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_trafficroutes.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_traffictraces.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_virtualoutbounds.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_zoneegresses.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_zoneegressinsights.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_zoneingresses.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_zoneingressinsights.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_zoneinsights.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/kuma.io_zones.yaml
- https://docs.konghq.com/mesh/2.4.x/crds/opa-policy.yaml
- https://docs.konghq.com/mesh/2.4.x/helm-values.yaml
- https://docs.konghq.com/mesh/2.4.x/kuma-cp.yaml
- https://docs.konghq.com/mesh/2.4.x/protos/OPAPolicy.json

#### Modified

- https://docs.konghq.com/mesh/1.7.x/features/windows
- https://docs.konghq.com/mesh/1.8.x/features/windows
- https://docs.konghq.com/mesh/1.9.x/features/windows
- https://docs.konghq.com/mesh/2.0.x/features/windows
- https://docs.konghq.com/mesh/2.1.x/features/windows
- https://docs.konghq.com/mesh/dev/crds/kuma.io_circuitbreakers.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_containerpatches.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_dataplaneinsights.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_dataplanes.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_externalservices.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_faultinjections.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_healthchecks.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshaccesslogs.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshcircuitbreakers.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshes.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshfaultinjections.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshgatewayconfigs.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshgatewayinstances.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshgatewayroutes.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshgateways.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshglobalratelimits.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshhealthchecks.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshhttproutes.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshinsights.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshloadbalancingstrategies.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshopas.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshproxypatches.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshratelimits.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshretries.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshtcproutes.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshtimeouts.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshtraces.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_meshtrafficpermissions.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_proxytemplates.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_ratelimits.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_retries.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_serviceinsights.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_timeouts.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_trafficlogs.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_trafficpermissions.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_trafficroutes.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_traffictraces.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_virtualoutbounds.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_zoneegresses.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_zoneegressinsights.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_zoneingresses.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_zoneingressinsights.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_zoneinsights.yaml
- https://docs.konghq.com/mesh/dev/crds/kuma.io_zones.yaml


### [fix: Docker installation for Kong Gateway OSS missing port for Kong Manager OSS](https://github.com/Kong/docs.konghq.com/pull/5998) (2023-08-29)

The installation instructions for Kong Gateway OSS on Docker were missing the Kong Manager OSS port mapping.
Adding it for 3.4, along with a troubleshooting entry, in case anyone else runs into it.

#### Added

- https://docs.konghq.com/mesh/1.7.x/features/windows
- https://docs.konghq.com/mesh/1.8.x/features/windows
- https://docs.konghq.com/mesh/1.9.x/features/windows
- https://docs.konghq.com/mesh/2.0.x/features/windows
- https://docs.konghq.com/mesh/2.1.x/features/windows

#### Modified

- https://docs.konghq.com/kubernetes-ingress-controller/2.10.x/references/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/references/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/2.5.x/references/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/2.6.x/references/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/2.7.x/references/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/2.8.x/references/feature-gates
- https://docs.konghq.com/kubernetes-ingress-controller/2.9.x/references/feature-gates


### [Add blog post note to gateway install pages](https://github.com/Kong/docs.konghq.com/pull/5997) (2023-08-31)

This addition was requested by the marketing folks just to further cement usage of the new site.

#### Modified

- https://docs.konghq.com/gateway/3.4.x/reference/wasm


### [chore: Sunset Kong Gateway versions 2.1.x-2.5.x](https://github.com/Kong/docs.konghq.com/pull/5992) (2023-08-29)

As of August 24th, 2023, Kong Gateway OSS and Enterprise versions 2.1.x-2.5.x [end their sunset support](https://docs.konghq.com/gateway/latest/support-policy/#older-versions).

This PR removes all of the old versions from the docs site, as well as the `/archive` folder maintained on the `main` branch.
We no longer need that folder, since we have a legacy-gateway site.

You can find all of the archived versions at the following links:
https://legacy-gateway--kongdocs.netlify.app/enterprise/2.5.x/
https://legacy-gateway--kongdocs.netlify.app/gateway-oss/2.5.x/
https://legacy-gateway--kongdocs.netlify.app/getting-started-guide/2.5.x/overview/

For the additions to the archive, see https://github.com/Kong/docs.konghq.com/pull/5993.

https://konghq.atlassian.net/browse/DOCU-3347

---

Some specifics:
* Deleting everything to do with `enterprise`, `gateway-oss`, and `getting-started-guide` editions and URLs. All three of those editions were replaced with one `gateway` edition in 2.6.x. Since we're archiving everything before 2.6.x, we no longer need to maintain all of the exceptions for the old editions.
* Plugins: We will no longer build versions 2.5.x or earlier. There wasn't a lot of 2.5.x or earlier content that was unique, so I think that should be fine.
  * If we want to move the old plugin docs to the archive site, we will need to port the whole new plugin hub over there. I'm not sure that it's worth it yet.

#### Modified

- https://docs.konghq.com/hub/kong-inc/acme/
- https://docs.konghq.com/hub/kong-inc/aws-lambda/
- https://docs.konghq.com/hub/kong-inc/bot-detection/
- https://docs.konghq.com/hub/kong-inc/datadog/
- https://docs.konghq.com/hub/kong-inc/file-log/
- https://docs.konghq.com/hub/kong-inc/grpc-gateway/how-to/
- https://docs.konghq.com/hub/kong-inc/hmac-auth/
- https://docs.konghq.com/hub/kong-inc/http-log/
- https://docs.konghq.com/hub/kong-inc/ip-restriction/
- https://docs.konghq.com/hub/kong-inc/jwt-signer/versions.yml
- https://docs.konghq.com/hub/kong-inc/kafka-log/
- https://docs.konghq.com/hub/kong-inc/kafka-upstream/
- https://docs.konghq.com/hub/kong-inc/key-auth/
- https://docs.konghq.com/hub/kong-inc/ldap-auth-advanced/
- https://docs.konghq.com/hub/kong-inc/ldap-auth/
- https://docs.konghq.com/hub/kong-inc/loggly/
- https://docs.konghq.com/hub/kong-inc/prometheus/
- https://docs.konghq.com/hub/kong-inc/statsd-advanced/versions.yml
- https://docs.konghq.com/hub/kong-inc/syslog/
- https://docs.konghq.com/hub/kong-inc/tcp-log/
- https://docs.konghq.com/hub/kong-inc/udp-log/
- https://docs.konghq.com/hub/kong-inc/zipkin/
- https://docs.konghq.com/gateway/2.6.x/configure/auth/kong-manager/ldap
- https://docs.konghq.com/gateway/2.7.x/configure/auth/kong-manager/ldap
- https://docs.konghq.com/gateway/2.8.x/configure/auth/kong-manager/ldap

## Week 34

### [Fix missing icon](https://github.com/Kong/docs.konghq.com/pull/6007) (2023-08-25)
 
The OSS/Enterprise icon was missing. We changed it to a white version when we added it to the blue navigation, and forgot to change it back when we put it back in the TOC. 

Add missing `alt` text to konnect's dashboard image.

#### Modified

- https://docs.konghq.com/konnect/


### [Chore: Bump GW to version 3.1.1.5](https://github.com/Kong/docs.konghq.com/pull/6006) (2023-08-25)

https://konghq.atlassian.net/browse/DOCU-3410

* changelog

* updated `app/_data/kong_versions.yml`

#### Modified

- https://docs.konghq.com/gateway/changelog


### [chore(deps): bump kumahq/kuma-website from 643f230a to 2064c900](https://github.com/Kong/docs.konghq.com/pull/6001) (2023-08-25)

Auto upgrade PR log:

2064c9000e7605c6b057ac3e668708a45046c8aa chore(deps): update docs from repo source (kumahq/kuma-website#1443)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/5970254269).

#### Modified

- https://docs.konghq.com/gateway/3.2.x/kong-enterprise/cp-outage-handling
- https://docs.konghq.com/gateway/3.3.x/kong-enterprise/cp-outage-handling
- https://docs.konghq.com/gateway/3.4.x/kong-enterprise/cp-outage-handling


### [fix: Add missing metadata to appdynamics and serverless functions plugins](https://github.com/Kong/docs.konghq.com/pull/5999) (2023-08-24)

The AppDynamics and Serverless functions plugins were incorrectly listed as being incompatible with all Kong Gateway deployment modes: https://docs.konghq.com/hub/plugins/compatibility/#serverless

Fixing that by adding `network_config_opts` to the metadata files for both plugins. Both plugins can be run in DB-less, traditional, and hybrid modes.

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/serverless-functions/_metadata.yml


### [chore(deps): bump kumahq/kuma-website from b49b8059 to 643f230a](https://github.com/Kong/docs.konghq.com/pull/5994) (2023-08-23)

Auto upgrade PR log:

643f230ab275957febf4c5195e83939dd8bdf16e fix(retry): correct baseDuration to baseInterval (kumahq/kuma-website#1441)

Triggered by [action](https://github.com/Kong/docs.konghq.com/actions/runs/5945388060).

#### Modified

- https://docs.konghq.com/gateway/3.0.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.1.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.2.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.3.x/install/linux/ubuntu
- https://docs.konghq.com/gateway/3.4.x/install/linux/ubuntu


### [feat: Konnect API examples for plugins](https://github.com/Kong/docs.konghq.com/pull/5970) (2023-08-23)

For any plugin that is supported in Konnect, it’s now possible to configure it using the Konnect runtime groups API, via `core-entities`. This PR adds support for generated Konnect API examples in the plugin docs, which makes the Konnect API more visible and positions it as a parallel option to the Kong Admin API.

A simple service example for the Basic auth plugin:
![Screenshot 2023-08-17 at 1 54 20 PM](https://github.com/Kong/docs.konghq.com/assets/54370747/2168aff3-0bad-4d46-82f9-ed5964a083c2)

A global example for the Rate Limiting Advanced plugin:
![Screenshot 2023-08-17 at 2 57 19 PM](https://github.com/Kong/docs.konghq.com/assets/54370747/d71f434e-7689-4a7a-bad4-9298621e49eb)

Along with that, there were several fixes/improvements that I had to make:
* Placeholders in curl examples: after team discussion, settled on `{ }` as the placeholder characters for URLs. This format is heavily used in our API specs, and is the OpenAPI standard: https://swagger.io/docs/specification/describing-parameters/. Going forward, we should be using `{ }` to enclose variables **in specs and API examples**. 
  * Placeholders in other situations still need revisiting. Out of scope here.
 
* The global example now explains what "global" means in the context of Konnect, Kong Enterprise, and Kong OSS. This is a long-running painpoint, and it seems timely to add this as we add Konnect examples.

* Removed the duplicate `konnect_examples` and `manager_examples` metadata keys from plugin docs. We don't have Kong Manager examples, and we don't need a separate `konnect_examples` key. `konnect: false/true` already performs the same function.

https://konghq.atlassian.net/browse/DOCU-2949

#### Modified

- https://docs.konghq.com/hub/kong-inc/app-dynamics/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/application-registration/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/datadog/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/exit-transformer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/jq/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/key-auth-enc/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/oauth2-introspection/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/oauth2/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/opentelemetry/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/openwhisk/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-size-limiting/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-transformer-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/request-transformer/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/response-transformer-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/route-by-header/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/route-transformer-advanced/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/serverless-functions/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/vault-auth/_0.3.0/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/vault-auth/_metadata.yml
- https://docs.konghq.com/hub/kong-inc/zipkin/_metadata.yml
- https://docs.konghq.com/contributing/conditional-rendering
- https://docs.konghq.com/contributing/markdown-rules
- https://docs.konghq.com/contributing/style-guide
