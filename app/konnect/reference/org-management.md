---
title: Managing Users and Roles
no_search: true
no_version: true
beta: true
---

## Overview
Managing your organization includes inviting users and assigning roles. Use the steps in this topic to invite new users, view and manage users, and view and manage roles. 

**Note**: Teams and Identity Management are not available in the CAB Beta version.

## Invite a New User
1. Go to the **Organization > Users** page.
2. Click **Invite New User**.
3. Enter the user’s information, including first name, last name, and email address to send an email invitation. 
4. Click **Next**.
5. Assign a role or roles for the new user by checking the box next to the role. Note:
   * A user can have more than one role. 
   * For role descriptions, click the information (i) icon next to the role or see the Role Definitions section below. 
6. Click **Invite User**. An email invitation is sent to the user.

## View and Manage Users
1. Go to the **Organization > Users** page.
2. From the Users page, actions you can perform include:
   * View user names, email address, and assigned role(s). 
   * For pending users, a **pending** indicator displays by their name.
   * To edit assigned roles, click the user's name to drill down to their assigned role(s) and description of the role. Click **Actions > Add/Remove Roles** to add or remove role(s) from the selected user. 

## View and Manage Roles
1. Go to the **Organization > Roles** page.
2. From the Roles page, actions you can perform include:
   * View role titles and a description of each role.
   * For each role, the number of users in your Konnect instance assigned to the role are listed in the Users column.
   * Hover over the number in the Users column to display the users assigned to the role. 
   * Click a **Role** title to display the users assigned to the role and their email address. 
   * Click **Actions > Add/Remove Users** to add or remove user(s) from the selected role. 
   
## Role Definitions
When assigning a role or roles to a user, the following default roles are available. Default roles are included in every organization, and users can have more than one role.  

| Role | Permission | Entities |
|-------------|-------------|-------------|
| Organization Admin | Full CRUD (create, read, update, and delete) on all objects within an organization including users and organization configuration. | Users, Roles, Service Packages, Service Versions, Implementations, Portal and Service Detail pages, and Runtime Config. | 
| Service Admin | Full CRUD on Service Packages, and publish/unpublish Services to the Portal. | Service Packages, Service Versions, Service Detail pages, Implementations, and Portal documents (Service Docs and Version Specs). | 
| Service Developer | CRUD on Service Versions. | Service Versions, Implementations, and Service Detail pages. | 
| Portal Admin | Read and update on the Portal landing page, as well as Service Detail pages. | All Portal documents, and Publish Services to the Portal. | 
| Service Page Editor | Read and update individual Service pages, and create/register Applications. | Service Detail pages and Applications. | 

## Role Permissions
Individual permissions can be granted for custom roles, as defined in the table.

| Permission name | Description | Entities |
|-------------|-------------|-------------|
| Service Editor | Permissions to fully manage a specific Services, including Versions, Implementations, Routes, and Portal docs, and can also delete the Service. | Specific Service Package, Service Versions within the Service, Implementations within the Service, Portal and Service docs for the Service. | 
| Service Viewer | Read permissions on a specific Service including Versions, Implementations, Routes, and Portal docs. | Specific Service Package, Service Versions within the Service, Implementations within the Service, Portal and Service docs for the Service. | 
| Version Editor | Permissions to fully manage all Versions for a specific Service, including creating and updating Implementations and Specs, and can also create or delete Versions. | Service Versions of a Service, Version Specs, and Implementations for a given Service. | 
| Portal Editor | Includes permissions to fully manage all Portal content for a specific Service and its Versions. | Portal documents for a Service. | 


