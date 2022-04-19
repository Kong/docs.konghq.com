---
name: KongMap
publisher: Yes Interactive

categories:
  - deployment

type: integration

desc: Visually Map and Manage your Kong Clusters

description: |
  Kongmap is a free visualization tool that allows you to view and edit configurations of your Kong API Gateway Clusters, including Routes, Services, and Plugins/Policies. The tool is being offered for installation using Docker and Kubernetes at this time. 
 
support_url: https://github.com/yesinteractive/kong-map/issues

source_url: https://github.com/yesinteractive/kong-map

license_type: AGPL-3.0

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.1.x
        - 2.0.x
        - 1.5.x
        - 1.4.x
        - 1.3.x

    enterprise_edition:
      compatible:
        - 2.1.x
        - 1.5.x
        - 1.3-x


###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# Your headers must be Level 3 or 4 (parsing to h3 or h4 tags in HTML).
# This is represented by ### or #### notation preceding the header text.
###############################################################################
# BEGIN MARKDOWN CONTENT
---

## Features

#### Cluster View
Allows an admin to view a dynamic map of their Kong API Gateway clusters and visually see relationships between
Workspaces (for Kong Gateway), Services, Routes (Endpoints), and Plugins (Policies). Clicking on any entity displays
details of the entity and related links. Plugins can be toggled from view. 


![alt text](https://github.com/yesinteractive/kong-map/blob/main/screenshots/kongmap-home.png?raw=true "kongmap")

#### Endpoint Analyzer
View details of an API Endpoint (Route). The analyzer shows the Service attached to the endpoint/route as well as 
a breakdown of all plugins/policies in order of execution attached to the route/endpoint. For Kong Gateway users,
all entities can be viewed directly via a link to Kong Manager.

![alt text](https://github.com/yesinteractive/kong-map/blob/main/screenshots/kongmap-endpoint.png?raw=true "kongmap")


#### Declarative Configuration Viewer/Editor
KongMap is deployed with a browser-based version of Kong's CLI tool, decK. Here you can view, edit, and export Kong declarative configurations for your open source 
and Enterprise clusters via YAML. Declarative
configuration editing can be disabled by KongMap configuration, or managed with RBAC permissions if using Kong Gateway. 

![alt text](https://github.com/yesinteractive/kong-map/blob/main/screenshots/kongmap-deck.png?raw=true "kongmap")


Full documentation is available here: [https://github.com/yesinteractive/kong-map/](https://github.com/yesinteractive/kong-map/){:target="_blank"}{:rel="noopener noreferrer"}. 

## Compatibility ## 
KongMap supports Kong Gateway (OSS) and Kong Gateway clusters version 1.5 and later, in both DB-backed and DB-less configurations. KongMap also supports Kong for Kubernetes Ingress Controller versions 0.6 and later. In Kong for Kubernetes, the Ingress Controller's proxy container must have its Admin API exposed in some fashion.

## Installation Instructions ##

Installation instructions are available here: [https://github.com/yesinteractive/kong-map/](https://github.com/yesinteractive/kong-map/){:target="_blank"}{:rel="noopener noreferrer"}.

## Feedback and Issues

If you have questions, feedback, or want to submit issues, please do so here: [https://github.com/yesinteractive/kong-map/issues](https://github.com/yesinteractive/kong-map/issues){:target="_blank"}{:rel="noopener noreferrer"}.
