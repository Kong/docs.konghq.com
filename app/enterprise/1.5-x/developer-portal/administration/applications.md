---
title: Developer Roles and Content Permissions
---

## Introduction

Applications allow registered developers on Kong Portal to authenticate with OAuth against a Service on Kong. Admins can selectively admit access to Services through Kong Manager.


## <span class="x x-first x-last">Enable </span>Application Registration on a Service <span class="x x-first x-last">using</span> Kong Manager

To use Application Registration on a <span class="x x-first x-last">Service</span>, the `application_registration` plugin must be enabled on that <span class="x x-first x-last">Service</span>.

1. Navigate to the Service.
2. Click **Services** in the sidebar and click **View** on the Service.
<span class="x x-first x-last">3</span>. Click <span class="x x-first x-last">**</span>Add Plugin<span class="x x-first x-last">**</span> in the plugins widget.
<span class="x x-first x-last">4</span>. Click <span class="x x-first x-last">**</span>Enable<span class="x x-first x-last">**</span> on Portal Application Registration<span class="x x-first x-last">.</span>
5. Enter **config**.
<span class="x x-first x-last">6. Click **</span>Create<span class="x x-first x-last">**.</span>

## Application Registration <span class="x x-first x-last">Configuration</span>

### Auth Header Name

Default: `authorization`
Description: The name of the header that contains the access token.

### Auto Approve

Default: `false`
Description: If enabled<span class="x x-first x-last">,</span> all new Service Contracts requests are automatically approved.

### Description

Default: none
Description: Description displayed in info about Service in portal.

### Display Name

**Required**
Description: Display name used for Service in portal.

### Auth flows

At least one of the following OAuth 2 auth flows **must be enabled**. For more information, see https://docs.konghq.com/hub/kong-inc/openid-connect/

* Enable Authorization Code
* Enable Client Credentials
* Enable Implicit Grant
* Enable Password Grant

### Mandatory Scope

Default: `false`
Description: An optional boolean value telling the plugin to require at least one scope to be authorized by the end user

### Provision Key

Default: Key automatically generated on creation, no input required.
Description: Used by Resource Owner Password Credentials Grant (Password Grant) flow.

### Refresh Token Ttl

Default: `1209600`
Description: An optional integer value telling the plugin how many seconds a token/refresh token pair is valid for, and can be used to generate a new access token. Default value is 2 weeks. Set to `0` to keep the token/refresh token pair indefinitely valid.

### Scopes

Description:  Describes an array of scope names that will be available to the end user

### Token Expiration

Default: `7200`
Description: An optional integer value telling the plugin how many seconds a token should last, after which the client will need to refresh the token. Set to `0` to disable the expiration.


## Add a Document Object to your Service
It is recommended when using Application Registration to link documentation to your Service. Doing so will allow portal users to easily register Application Contracts for their Applications from the spec page.

This can be done from the Service view page.
1. **Navigate to the service** - Click on “services” on the sidebar, click “View” on the service.
2. Click on "Add documentation" inside the Documents Card.
3. Add Documentation:
 * Select a Document to add either by path (selecting an existing spec in the portal) or
 * Click Upload Document to upload a new Spec to portal, and establish document link to service.



## How to manage Developer Applications from Kong Manager

Developers can create applications from Kong Portal. An application can apply to any number of Services. This is called a Service Contract.
In order for application to be used against a service, the Service Contract must have a status of “Approved.” To enable auto approval for all new Service Contracts on ,


### View all Application Contracts for an Application

1. A list of all applications in a workspace can be accessed from the sidebar. Clicking on the “Applications” to see list.
2. Click into a application to view all the Service Contracts for that application.
3. Click on Requested access to view Service Contracts requests for that application.
4.  From here the Application’s service contracts can be Approved.

### View all Application Contracts for a Service

All application contracts and their status for a service can be viewed from the “Service” page.

1. Click “Services” on the sidebar.
2. Select the Service you have Application Registration enabled for.
3. From here you can view all Approved, Revoked, Rejected, and Requested Access Service for Service
