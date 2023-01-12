---
title: Migrating to the Vitals API
badge: enterprise
content_type: reference
---

Support for the `/vitals/reports/:entity_type` endpoint is deprecated. You can achieve similar functionality using the [Vitals API](/api/vitals.yaml). The chart below contains information to help transition from the deprecated endpoint to the Vitals API. 

| Deprecated endpoint | Vitals API endpoint |
| --- | ----------- |
| `/vitals/reports/consumer` | `/{workspace_name}/vitals/status_codes/by_consumer` |
| `/vitals/reports/service` | `/{workspace_name}/vitals/status_codes/by_service` |
|`/vitals/reports/hostname` |`/{workspace_name}/vitals/nodes`|


With the Vitals API, to retrieve the number of requests for a service in a workspace, issue the following `GET` request: 

```bash
curl -i -X GET http://localhost:8001/WORKSPACE_NAME/vitals/status_codes/by_service \
    -d "service_id=030f4ade-69ed-48b0-b3e1-cd088a1f2a09" \
    -d "interval=minutes"
```


If the request was successful, the response body will contain data in this format: 

```bash
{
"stats": {
		"cluster": {
			"1673366520": {
				"200": 44
			},
			"1673366580": {
				"200": 49
			},
			"1673366460": {
				"200": 13
			}
		}
	},
	"meta": {
		"earliest_ts": 1673343331,
		"latest_ts": 1673366580,
		"stat_labels": [
			"status_codes_per_service_total"
		],
		"level": "cluster",
		"entity_type": "service",
		"interval": "minutes",
		"workspace_id": "af622cf4-f636-4ae4-9aa5-2726d6713edf"
	}
}
```

For a detailed look at these endpoints review the [Vitals API Spec](/api/vitals.yaml).