---
title: Manage Applications
badge: enterprise
---

Developers can create applications from the Kong Dev Portal. An application can apply to any number of Services. This is called a Service Contract. To use an application with a Service, the Service Contract must have an Approved status. To enable automatic approval for all new Service Contracts, enable Auto-approve for the Portal Application Registration plugin.

## Create an Application

1. Log in to the Kong Dev Portal.
2. Click **My Apps** in the top navigation bar.
3. Click **New Application**.
4. Complete the **Create Application** dialog:
    1. Enter a unique `Application Name`.
    2. Enter a `Redirect URI`.
    3. Enter a `Description`.
5. Click **Create**. The Application Dashboard is displayed. From the
dashboard, you can view details about your application, view your credentials,
generate more credentials, and view your application status against a list of
Services.
6. Before you can use your application, you must activate it to create a Service
Contract for the Service. In the Services section of the Application Dashboard,
click **Activate** on the Service you want to use. If [Auto-approve](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/enable-application-registration##aa) is not
enabled, your application will remain pending until an admin approves your
request.

## View all Service Contracts for an Application

A list of all applications in a Workspace can be accessed from the left navigation pane.

1. Click **Applications** to view the list of applications.
2. From the Applications list, click an application to view all Service Contracts for the application; including contracts in Approved, Revoked, and Rejected status.
3. In the Service Contracts section, click the **Requested Access** tab to view Service Contracts requests for the application. Approve, revoke, or reject
requests.

## View all Application Contracts for a Service

View all Application Contracts and their status for a Service from the
**Service** page.

1. Click **Services** in the left navigation pane.
2. Select the Service for which you have Application Registration enabled.
3. From the Service Contracts tab, view all Approved, Revoked, Rejected, and Requested Access for the Service.

## Add a Document to your Service
When using Application Registration, it is recommended to link documentation
(OAS/Swagger spec) to your Service. Doing so allows Dev Portal users to easily
register Application Contracts for their applications from the documentation
page, and view a list of all documentation from the Catalog page.

Add a document from the Service **View** page:
1. From your Workspace, in the left navigation pane, go to **API Gateway > Services**.
2. On the Services page, select the Service for which you want to add a document and click **View**.
3. In the Documents section, click **Add a Document**.
4. Choose a method to add the document to the Service:
  - Use **Document Spec Path** to select an existing spec in the Portal.
  - Use **Upload Document** to upload a new spec to the Portal.
5. Click **Add Document**.
