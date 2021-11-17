---
title: Application Registration
---

<div class="alert alert-red">WARNING: This functionality is released as a <a href="/enterprise/latest/introduction/key-concepts/#beta">BETA</a> feature. Please proceed with caution.</div>


## Introduction
Applications allow registered developers on Kong Developer Portal to authenticate with OAuth against a Service on Kong. Admins can selectively admit access to Services using Kong Manager.

## Prerequisites
* Kong Enterprise, version 1.5.0.0 or newer
* Developer Portal enabled on the same Workspace as the Service
* Service with HTTPS
* Authentication enabled on the Developer Portal
* Logged in as an Admin with read and write roles on applications, services, and developers

## Enable Application Registration on a Service using Kong Manager
To use Application Registration on a Service, the Portal Application Registration Plugin must be enabled on the Service.

In Kong Manager, access the Service for which you want to enable Application Registration:
1. From your Workspace, in the left navigation pane go to **API Gateway > Services**.
2. On the Services page, select the Service for which you want to enable Application Registration and click **View**.
3. In the Plugins section on the Services page, click **Add Plugin**.
4. On the Add New Plugin page, in the Authentication section, find the **Portal Application Registration** Plugin and click **Enable**.
5. Enter the configuration settings. Use the parameters in the next section, [Application Registration Configuration Parameters](#application-registration-configuration-parameters), to complete these fields.
6. Click **Create**.  

## Application Registration Configuration Parameters

#### Auth Header Name

Default: `authorization`

Description: The name of the header that contains the access token.

#### Auto Approve

Default: `false`

Description: If enabled, all new Service Contracts requests are automatically approved.

#### Description

Default: none

Description: Description displayed in info about Service in portal.

#### Display Name

**Required**

Description: Display name used for Service in portal.

#### Auth flows

At least one of the following OAuth2 auth flows **must be enabled**. For more information, see [the OAuth2 plugin documentation](/../hub/kong-inc/oauth2/).

* Enable Authorization Code
* Enable Client Credentials
* Enable Implicit Grant
* Enable Password Grant

#### Mandatory Scope

Default: `false`

Description: An optional boolean value telling the plugin to require at least one scope to be authorized by the end user.

#### Provision Key

Default: Key automatically generated on creation. No input required.

Description: Used by Resource Owner Password Credentials Grant (Password Grant) flow.

#### Refresh Token TTL

Default: `1209600`

Description: An optional integer value telling the plugin how many seconds a token/refresh token pair is valid for, and can be used to generate a new access token. Default value is two weeks. Set to `0` to keep the token/refresh token pair indefinitely valid.

#### Scopes

Description: Describes an array of scope names that will be available to the end-user.

#### Token Expiration

Default: `7200`

Description: An optional integer value telling the plugin how many seconds a token should last, after which the client will need to refresh the token. Set to `0` to disable the expiration.

## Add a Document to your Service
When using Application Registration, it is recommended to link documentation (OAS/Swagger spec) to your Service. Doing so allows Portal users to easily register Application Contracts for their applications from the documentation page, and view a list of all documentation from the catalog page.

Adding a document is done from the Service **View** page, as follows:
1. From your Workspace, in the left navigation pane go to **API Gateway > Services**.
2. On the Services page, select the Service for which you want to enable Application Registration and click **View**.
3. In the Documents section on the Services page, click click **Add a Document**.
4. Add a document to Service. You can add a document using **Document Spec Path** (selecting an existing spec in the portal) or click **Upload Document** to upload a new Spec to the Portal and add the document to the Service.
5. Click **Add Document**.

## How to use Applications as a Portal Developer
To use Applications as a Portal Developer:
1. Log into the Kong Developer Portal.
2. Click **My Apps** in the top navigation bar.
3. Click **New Application**.
4. Complete the **Create Application** dialog. Enter an Application Name, Redirect URI, and optional description.
5. Click **Create**. After you have created an application, the Application Dashboard displays. From the dashboard, you can view details about your application, view your credentials, generate more credentials, and view your application status against a list of Services.
6. Before using your application, you must activate it to create a Service Contract for the Service. In the Services section on the Application Dashboard, click **Activate** on the Service you want to use.
7. If Auto-approve is not enabled, your application will remain pending until an Admin approves your request.

## How to manage Developer Applications from Kong Manager
Developers can create applications from Kong Developer Portal. An application can apply to any number of Services. This is called a Service Contract. In order for the application to be used against a service, the Service Contract must have a status of Approved. To enable auto-approval for all new Service Contracts, enable Auto-approve on the Portal Application Registration Plugin.

### View all Application Contracts for an Application
To view Application Contracts:
1. A list of all applications in a Workspace can be accessed from the left navigation pane. Click **Applications** to view the list of applications.
2. From the Applications list, click an application to view all Service Contracts for the application, including Approved, Revoked, and Rejected.
3. In the Service Contracts section, click the **Requested Access** tab to view Service Contracts requests for the application. From here the Application’s Service Contracts can be approved.

### View all Application Contracts for a Service
All Application Contracts and their status for a Service can be viewed from the **Service** page.
1. Click **Services** in the left navigation pane.
2. Select the Service for which you have Application Registration enabled.
3. From the Service Contracts tab, view all Approved, Revoked, Rejected, and Requested Access Service for the Service.
