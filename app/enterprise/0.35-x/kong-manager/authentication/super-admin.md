---
title: How to Create a Super Admin
book: admin_gui
---

If you seeded a **Super Admin** at the time of running 
migrations by passing `KONG_PASSWORD`, you may log in to Kong Manager
with the `kong_admin` username. 

Otherwise, if `enforce_rbac=off`, you may create your first 
**Super Admin** within Kong Manager itself.

You may also use this guide to create additional **Super Admins** once
you have an account and `enforce_rbac=on`.

<video width="100%" autoplay loop controls>
  <source src="https://konghq.com/wp-content/uploads/2019/02/org-super-admin-ent-34.mov" type="video/mp4">
  Your browser does not support the video tag.
</video>

1. Go to the "Organization" tab in Kong Manager.

2. Click "+ Invite User" and fill out the form. 

3. Give the user the `super-admin` role in the `default` workspace.

4. Return to the "Organization" page, and in the "Invited" section, 
click the email address of the user in order to view them.

5. Click "Generate Registration Link". 

6. Copy the link for later use after completing the account setup.

## How to Create Your First Super Admin Account Post Installation

In the event that the default kong_admin Super Admin was not seeded during the initial database preparation step as defined in [Step 1 in How To Start Kong Enterprise Securely](../../getting-started/start-kong/#step-1), the following steps outline how to create and enable a new Super Admin post installation. 

1. Follow the instructions outlined above to create a new ***Super Admin** user account and generate a registration link.

2. Before the link generated above can be used, RBAC and GUI Authentication must be enabled. Follow the instructions on [how to enable Basic Auth on Kong Manager](../basic).

3. Paste the URL in your browser and you will be asked to create a password for the newly defined ***Super Admin*** user on the Kong Manager.

4. Go to the Kong Manager homepage and you will be prompted to login with the new ***Super Admin*** credentials
